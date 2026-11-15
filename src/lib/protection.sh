# shellcheck shell=bash
# shellcheck disable=SC2004,SC2034,SC2154  # shared state and arrays are declared in constants.sh
# protection.sh - The branch protection rule of a Gitea repository: the rule
# of a new repository (MIL-021) and --protect for an existing one (MIL-022).
#
# Part of create-project.sh: sourced by it, never run on its own.
#
# Two rules (MIL-032): the main rule never allows a direct push to the protected
# branch, so every change arrives by a pull request; the workflow rule (only when
# PROTECTED_WORKFLOW_PATTERN is set, for example release/**) adds the status checks and the block-merge settings. Gitea
# applies one rule per branch, so the two patterns must not overlap. The branch names, the protected file patterns and
# the status check names are glob patterns (https://github.com/gobwas/glob);
# they are sent as given, never expanded here.
#
# Provides: split_patterns, url_encode, protection_path, protection_pattern, protection_kinds, protection_body, protection_summary, protection_array, protection_state, protection_wanted, configure_protection, server_message_note, protect_existing_repository, protect_rule, protect_create, protect_change, protect_cleanup

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

# protection_pattern KIND: the branch pattern of a rule. KIND is "main" (no
# direct push) or "workflow" (status checks and block-merge settings, MIL-032).
protection_pattern() {
  if [[ $1 == main ]]; then
    printf '%s' "${CONFIG[PROTECTED_BRANCH_PATTERN]}"
  else
    printf '%s' "${CONFIG[PROTECTED_WORKFLOW_PATTERN]}"
  fi
}

# protection_kinds: the rules that are wanted, one KIND per line. The workflow
# rule exists only when its pattern is not empty.
protection_kinds() {
  printf 'main\n'
  if [[ -n ${CONFIG[PROTECTED_WORKFLOW_PATTERN]} ]]; then
    printf 'workflow\n'
  fi
}

# protection_body KIND create|edit: the JSON body of a rule from config.env.
# The edit request does not carry the rule name. enable_push is always false.
# Both rules carry the four block-merge settings; the main rule has no status
# check, the workflow rule has them and no signed-commits or protected-file setting. Every field is
# sent, so that an edit also clears what an older rule had.
protection_body() {
  local kind="$1" mode="$2" items=() item contexts="" enabled=false name="" blocks="" key
  local signed=false files="" block=true
  if [[ $kind == main ]]; then
    signed="${CONFIG[PROTECTED_REQUIRE_SIGNED_COMMITS]}"
    files="$(json_escape "${CONFIG[PROTECTED_FILE_PATTERNS]}")"
  else
    split_patterns "${CONFIG[PROTECTED_STATUS_CHECKS]}" items
    for item in "${items[@]}"; do
      contexts+="${contexts:+,}\"$(json_escape "$item")\""
    done
    if [[ -n $contexts ]]; then
      enabled=true
    fi
  fi
  if [[ $mode == create ]]; then
    name="\"rule_name\":\"$(json_escape "$(protection_pattern "$kind")")\","
  fi
  for key in "${PROTECTION_BLOCK_KEYS[@]}"; do
    blocks+=",\"$key\":$block"
  done
  printf '{%s"enable_push":false,"enable_status_check":%s,"status_check_contexts":[%s],"protected_file_patterns":"%s","require_signed_commits":%s%s}' \
    "$name" "$enabled" "$contexts" "$files" "$signed" "$blocks"
}

# protection_summary KIND: the wanted rule in words, for the plan.
protection_summary() {
  local kind="$1" checks files
  if [[ $kind == main ]]; then
    files="${CONFIG[PROTECTED_FILE_PATTERNS]:-none}"
    printf "rule '%s': no direct push (use a pull request); protected files: %s" \
      "$(protection_pattern main)" "$files"
    if [[ ${CONFIG[PROTECTED_REQUIRE_SIGNED_COMMITS]} == true ]]; then
      printf '; signed commits required'
    fi
  else
    checks="${CONFIG[PROTECTED_STATUS_CHECKS]:-none}"
    printf "rule '%s': no direct push; status checks: %s" "$(protection_pattern workflow)" "$checks"
    printf '; merge blocked on rejected reviews, review requests, an outdated branch and for administrators'
  fi
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
  local file="$1" checks key
  checks="$(protection_array "$file" status_check_contexts | tr '\n' ';')"
  printf 'enable_push: %s\nenable_status_check: %s\nstatus_check_contexts: %s\nprotected_file_patterns: %s\nrequire_signed_commits: %s\n' \
    "$(json_get "$file" enable_push)" "$(json_get "$file" enable_status_check)" \
    "${checks%;}" "$(json_get "$file" protected_file_patterns)" "$(json_get "$file" require_signed_commits)"
  for key in "${PROTECTION_BLOCK_KEYS[@]}"; do
    printf '%s: %s\n' "$key" "$(json_get "$file" "$key")"
  done
}

# protection_wanted KIND: the same lines for the rule in config.env.
protection_wanted() {
  local kind="$1" enabled=false key checks="" files="" signed=false block=true
  if [[ $kind == main ]]; then
    files="${CONFIG[PROTECTED_FILE_PATTERNS]}"
    signed="${CONFIG[PROTECTED_REQUIRE_SIGNED_COMMITS]}"
  else
    checks="${CONFIG[PROTECTED_STATUS_CHECKS]}"
    [[ -n $checks ]] && enabled=true
  fi
  printf 'enable_push: false\nenable_status_check: %s\nstatus_check_contexts: %s\nprotected_file_patterns: %s\nrequire_signed_commits: %s\n' \
    "$enabled" "$checks" "$files" "$signed"
  for key in "${PROTECTION_BLOCK_KEYS[@]}"; do
    printf '%s: %s\n' "$key" "$block"
  done
}

# configure_protection: the step of a new Gitea repository: the rule of the
# main branch and, when its pattern is set, the workflow rule. A refused request
# is a warning, not the end of the run: the repository is complete without it.
configure_protection() {
  local label="Branch protection" hint kind made=() patterns=""
  if is_reused gitea; then
    finish_step "$label" "not changed" "(the repository is reused)"
    return 0
  fi
  hint="(set it in the repository settings under Branches)"
  begin_step "$label"
  while read -r kind; do
    if ! try_api_call gitea POST "$(protection_path "${PROJECT[gitea_owner]}" "${PROJECT[name]}")" \
      "$(protection_body "$kind" create)"; then
      warn "could not set the $kind branch protection rule: $HTTP_ERROR"
      finish_step "$label" "not set" "$hint"
      return 0
    fi
    if [[ $HTTP_STATUS != 201 ]]; then
      warn "could not set the $kind branch protection rule: $(describe_http_status "$HTTP_STATUS")$(server_message_note)"
      finish_step "$label" "not set" "$hint"
      return 0
    fi
    made+=("$kind")
  done < <(protection_kinds)
  patterns="no direct push to ${CONFIG[PROTECTED_BRANCH_PATTERN]}"
  if [[ ${#made[@]} -gt 1 ]]; then
    patterns+="; status checks on ${CONFIG[PROTECTED_WORKFLOW_PATTERN]}"
  fi
  finish_step "$label" "created" "($patterns)"
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
# its rules, say what would be done, and with --apply create a missing rule or,
# after a yes, change one that differs, and turn branch cleanup on. Rules of
# other patterns are never touched.
protect_existing_repository() {
  local target="$1" owner name kind cleanup kinds
  owner="${target%%/*}"
  name="${target#*/}"
  mapfile -t kinds < <(protection_kinds)
  say ""
  say "Repository : $(printf '%s/%s/%s' "${CONFIG[GITEA_URL]}" "$owner" "$name")"
  for kind in "${kinds[@]}"; do
    say "Wanted     : $(protection_summary "$kind")"
  done
  say "Wanted     : branch cleanup after merge on"
  api_call gitea GET "/repos/$owner/$name"
  if [[ $HTTP_STATUS == 404 ]]; then
    die "the Gitea repository $owner/$name does not exist, or the token cannot see it"
  fi
  expect_status "cannot look up the Gitea repository $owner/$name" 200
  cleanup="$(json_get "$HTTP_BODY_FILE" default_delete_branch_after_merge)"
  for kind in "${kinds[@]}"; do
    protect_rule "$kind" "$owner" "$name"
  done
  protect_cleanup "$owner" "$name" "$cleanup"
  if ! ((IS_APPLY)); then
    say ""
    say "Dry run: nothing was changed. Run again with --apply to make the changes listed."
  fi
}

# protect_rule KIND OWNER NAME: read the rule of KIND and create or change it.
protect_rule() {
  local kind="$1" owner="$2" name="$3" path rule
  rule="$(protection_pattern "$kind")"
  path="$(protection_path "$owner" "$name" "$rule")"
  api_call gitea GET "$path"
  case "$HTTP_STATUS" in
    404) protect_create "$kind" "$owner" "$name" ;;
    200) protect_change "$kind" "$owner" "$name" "$path" ;;
    *) fail_request "cannot read the branch protection rule '$rule' of $owner/$name" ;;
  esac
}

protect_create() {
  local kind="$1" owner="$2" name="$3" rule
  rule="$(protection_pattern "$kind")"
  say "Existing   : no rule named '$rule'"
  ((IS_APPLY)) || return 0
  api_call gitea POST "$(protection_path "$owner" "$name")" "$(protection_body "$kind" create)"
  expect_status "cannot create the branch protection rule of $owner/$name" 201
  say "Done. The rule '$rule' was created."
}

protect_change() {
  local kind="$1" owner="$2" name="$3" path="$4" current wanted rule
  rule="$(protection_pattern "$kind")"
  current="$(protection_state "$HTTP_BODY_FILE")"
  wanted="$(protection_wanted "$kind")"
  if [[ $current == "$wanted" ]]; then
    say "Existing   : the rule '$rule' is already as wanted. Nothing to do."
    return 0
  fi
  say "Existing   : the rule '$rule' differs:"
  say "  now   : $(printf '%s' "$current" | tr '\n' '|')"
  say "  wanted: $(printf '%s' "$wanted" | tr '\n' '|')"
  ((IS_APPLY)) || return 0
  prompt_yes_no "Change the rule '$rule' of $owner/$name" n
  if ! ((REPLY)); then
    die "stopped: the rule '$rule' was not changed"
  fi
  api_call gitea PATCH "$path" "$(protection_body "$kind" edit)"
  expect_status "cannot change the branch protection rule of $owner/$name" 200
  say "Done. The rule '$rule' was changed."
}

# protect_cleanup OWNER NAME CURRENT: turn "Delete pull request branch after
# merge by default" on, after a yes, when CURRENT is not true.
protect_cleanup() {
  local owner="$1" name="$2" current="$3"
  if [[ $current == true ]]; then
    say "Existing   : branch cleanup after merge is already on. Nothing to do."
    return 0
  fi
  say "Existing   : branch cleanup after merge is off"
  ((IS_APPLY)) || return 0
  prompt_yes_no "Turn on branch cleanup after merge of $owner/$name" n
  if ! ((REPLY)); then
    die "stopped: branch cleanup was not turned on"
  fi
  api_call gitea PATCH "/repos/$owner/$name" '{"default_delete_branch_after_merge":true}'
  expect_status "cannot turn on branch cleanup of $owner/$name" 200
  say "Done. Branch cleanup after merge was turned on."
}
