# shellcheck shell=bash
# shellcheck disable=SC2004,SC2034,SC2154  # shared state and arrays are declared in constants.sh
# protection.sh - The branch protection rule of a Gitea repository: the rule
# of a new repository (MIL-021) and --protect for an existing one (MIL-022).
#
# Part of create-project.sh: sourced by it, never run on its own.
#
# The rule never allows a direct push to the protected branch: every change
# arrives by a pull request. The branch name, the protected file patterns and
# the status check names are glob patterns (https://github.com/gobwas/glob);
# they are sent as given, never expanded here.
#
# Provides: split_patterns, url_encode, protection_path, protection_body, protection_summary, protection_array, protection_state, protection_wanted, configure_protection, server_message_note, protect_existing_repository, protect_create, protect_change

# split_patterns LIST ARRAY: split a semicolon separated LIST into ARRAY, each
# item trimmed. Empty items are kept, so that the validator can refuse them.
split_patterns() {
  local rest="$1" item
  local -n items_ref="$2"
  items_ref=()
  [[ -n $rest ]] || return 0
  while true; do
    item="${rest%%;*}"
    items_ref+=("$(trim "$item")")
    [[ $rest == *";"* ]] || break
    rest="${rest#*;}"
  done
}

# url_encode TEXT: percent-encode everything but letters, digits and . _ ~ -
url_encode() {
  local text="$1" char encoded="" index
  local LC_ALL=C
  for ((index = 0; index < ${#text}; index++)); do
    char="${text:index:1}"
    case "$char" in
      [A-Za-z0-9._~-]) encoded+="$char" ;;
      *) encoded+="$(printf '%%%02X' "'$char")" ;;
    esac
  done
  printf '%s' "$encoded"
}

# protection_path OWNER NAME [RULE]: the branch protection address of a repository.
protection_path() {
  local path="/repos/$1/$2/branch_protections"
  if [[ -n ${3:-} ]]; then
    path+="/$(url_encode "$3")"
  fi
  printf '%s' "$path"
}

# protection_body create|edit: the JSON body of the rule from config.env. The
# edit request does not carry the rule name. enable_push is always false.
protection_body() {
  local mode="$1" items=() item contexts="" enabled=false name=""
  split_patterns "${CONFIG[PROTECTED_STATUS_CHECKS]}" items
  for item in "${items[@]}"; do
    contexts+="${contexts:+,}\"$(json_escape "$item")\""
  done
  if [[ -n $contexts ]]; then
    enabled=true
  fi
  if [[ $mode == create ]]; then
    name="\"rule_name\":\"$(json_escape "${CONFIG[PROTECTED_BRANCH_PATTERN]}")\","
  fi
  printf '{%s"enable_push":false,"enable_status_check":%s,"status_check_contexts":[%s],"protected_file_patterns":"%s"}' \
    "$name" "$enabled" "$contexts" "$(json_escape "${CONFIG[PROTECTED_FILE_PATTERNS]}")"
}

# protection_summary: the wanted rule in words, for the plan.
protection_summary() {
  local checks="${CONFIG[PROTECTED_STATUS_CHECKS]:-none}" files="${CONFIG[PROTECTED_FILE_PATTERNS]:-none}"
  printf "rule '%s': no direct push (use a pull request); status checks: %s; protected files: %s" \
    "${CONFIG[PROTECTED_BRANCH_PATTERN]}" "${checks:-none}" "${files:-none}"
}

# protection_array FILE KEY: the strings of a JSON array, one per line.
protection_array() {
  local file="$1" key="$2"
  if ((HAS_JQ)); then
    jq -r --arg key "$key" '.[$key] // [] | .[]' "$file" | tr -d '\r'
  else
    { grep -o "\"$key\"[[:space:]]*:[[:space:]]*\[[^]]*\]" "$file" || true; } |
      sed -e 's/^[^[]*\[//' -e 's/\]$//' | tr ',' '\n' | sed -e 's/^[[:space:]]*"//' -e 's/"[[:space:]]*$//' |
      sed -e '/^$/d'
  fi
}

# protection_state FILE: the fields that matter of a rule that Gitea returned,
# one "key: value" per line, in the form protection_wanted prints.
protection_state() {
  local file="$1" checks
  checks="$(protection_array "$file" status_check_contexts | tr '\n' ';')"
  printf 'enable_push: %s\nenable_status_check: %s\nstatus_check_contexts: %s\nprotected_file_patterns: %s\n' \
    "$(json_get "$file" enable_push)" "$(json_get "$file" enable_status_check)" \
    "${checks%;}" "$(json_get "$file" protected_file_patterns)"
}

# protection_wanted: the same lines for the rule in config.env.
protection_wanted() {
  local enabled=false
  [[ -n ${CONFIG[PROTECTED_STATUS_CHECKS]} ]] && enabled=true
  printf 'enable_push: false\nenable_status_check: %s\nstatus_check_contexts: %s\nprotected_file_patterns: %s\n' \
    "$enabled" "${CONFIG[PROTECTED_STATUS_CHECKS]}" "${CONFIG[PROTECTED_FILE_PATTERNS]}"
}

# configure_protection: the step of a new Gitea repository. A refused request
# is a warning, not the end of the run: the repository is complete without it.
configure_protection() {
  local label="Branch protection" hint
  if is_reused gitea; then
    finish_step "$label" "not changed" "(the repository is reused)"
    return 0
  fi
  hint="(set it in the repository settings under Branches)"
  begin_step "$label"
  if ! try_api_call gitea POST "$(protection_path "${PROJECT[gitea_owner]}" "${PROJECT[name]}")" \
    "$(protection_body create)"; then
    warn "could not set the branch protection rule: $HTTP_ERROR"
    finish_step "$label" "not set" "$hint"
    return 0
  fi
  if [[ $HTTP_STATUS != 201 ]]; then
    warn "could not set the branch protection rule: $(describe_http_status "$HTTP_STATUS")$(server_message_note)"
    finish_step "$label" "not set" "$hint"
    return 0
  fi
  finish_step "$label" "created" "(no direct push to ${CONFIG[PROTECTED_BRANCH_PATTERN]})"
}

# server_message_note: " (the server says: ...)" or nothing.
server_message_note() {
  local message
  message="$(server_message)"
  if [[ -n $message ]]; then
    printf ' (the server says: %s)' "$message"
  fi
}

# protect_existing_repository OWNER/NAME: --protect. Read the repository and
# its rule, say what would be done, and with --apply create the rule or, after
# a yes, change it. Rules of other names are never touched.
protect_existing_repository() {
  local target="$1" owner name path rule
  owner="${target%%/*}"
  name="${target#*/}"
  rule="${CONFIG[PROTECTED_BRANCH_PATTERN]}"
  say ""
  say "Repository : $(printf '%s/%s/%s' "${CONFIG[GITEA_URL]}" "$owner" "$name")"
  say "Wanted     : $(protection_summary)"
  api_call gitea GET "/repos/$owner/$name"
  if [[ $HTTP_STATUS == 404 ]]; then
    die "the Gitea repository $owner/$name does not exist, or the token cannot see it"
  fi
  expect_status "cannot look up the Gitea repository $owner/$name" 200
  path="$(protection_path "$owner" "$name" "$rule")"
  api_call gitea GET "$path"
  case "$HTTP_STATUS" in
    404) protect_create "$owner" "$name" ;;
    200) protect_change "$owner" "$name" "$path" ;;
    *) fail_request "cannot read the branch protection rule '$rule' of $owner/$name" ;;
  esac
}

protect_create() {
  local owner="$1" name="$2"
  say "Existing   : no rule named '${CONFIG[PROTECTED_BRANCH_PATTERN]}'"
  if ! ((IS_APPLY)); then
    say ""
    say "Dry run: nothing was changed. Run again with --apply to create the rule."
    return 0
  fi
  api_call gitea POST "$(protection_path "$owner" "$name")" "$(protection_body create)"
  expect_status "cannot create the branch protection rule of $owner/$name" 201
  say "Done. The rule '${CONFIG[PROTECTED_BRANCH_PATTERN]}' was created."
}

protect_change() {
  local owner="$1" name="$2" path="$3" current wanted
  current="$(protection_state "$HTTP_BODY_FILE")"
  wanted="$(protection_wanted)"
  if [[ $current == "$wanted" ]]; then
    say "Existing   : the rule '${CONFIG[PROTECTED_BRANCH_PATTERN]}' is already as wanted. Nothing to do."
    return 0
  fi
  say "Existing   : the rule '${CONFIG[PROTECTED_BRANCH_PATTERN]}' differs:"
  say "  now   : $(printf '%s' "$current" | tr '\n' '|')"
  say "  wanted: $(printf '%s' "$wanted" | tr '\n' '|')"
  if ! ((IS_APPLY)); then
    say ""
    say "Dry run: nothing was changed. Run again with --apply to change the rule."
    return 0
  fi
  prompt_yes_no "Change the rule '${CONFIG[PROTECTED_BRANCH_PATTERN]}' of $owner/$name" n
  if ! ((REPLY)); then
    die "stopped: the rule was not changed"
  fi
  api_call gitea PATCH "$path" "$(protection_body edit)"
  expect_status "cannot change the branch protection rule of $owner/$name" 200
  say "Done. The rule '${CONFIG[PROTECTED_BRANCH_PATTERN]}' was changed."
}
