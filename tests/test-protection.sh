#!/usr/bin/env bash
# test-protection.sh - tests for the branch protection rule of a new Gitea
# repository (MIL-021) and for --protect on an existing one (MIL-022). A stub
# curl answers from a routes file and records every call and body; no real
# host is contacted. Sourced by run-tests.sh.

# shellcheck disable=SC2016  # snippet and fixture text is literal on purpose

readonly PROTECTION_CALL="POST https://git.example.test/api/v1/repos/TirSystem/my-app/branch_protections"
readonly PROTECTION_RULE_URL="https://git.example.test/api/v1/repos/TirSystem/my-app/branch_protections/main"

prot_apply() {
  run_cli "$1" --apply --config "$WORK/config.env" --env "$WORK/.env"
}

prot_dry() {
  run_cli "$1" --config "$WORK/config.env" --env "$WORK/.env"
}

# prot_call: run --protect OWNER/NAME with the work files; STDIN is the answers.
prot_run() {
  local input="$1"
  shift
  run_cli "$input" --protect TirSystem/my-app --config "$WORK/config.env" --env "$WORK/.env" "$@"
}

# protect_fixtures: only the Gitea token (no GitHub credential) and routes for
# an existing repository whose rule answers with the given status and body.
protect_fixtures() {
  rm -f "$WORK/curl.calls" "$WORK/curl.bodies" "$WORK/curl.args" "$WORK/curl.config"
  write_fixtures
  printf 'TOKEN_FOR_GITEA_REPO=%s\n' "$FAKE_GITEA_TOKEN" >"$WORK/.env"
  write_curl_stub
  write_routes <<ROUTES
GET|/api/v1/repos/TirSystem/my-app|200|{"name":"my-app"}
GET|/api/v1/repos/TirSystem/my-app/branch_protections/main|$1|$2
POST|/api/v1/repos/TirSystem/my-app/branch_protections|201|{"rule_name":"main"}
PATCH|/api/v1/repos/TirSystem/my-app/branch_protections/main|200|{"rule_name":"main"}
ROUTES
}

readonly RULE_DIFFERENT='{"rule_name":"main","enable_push":true,"enable_status_check":false,"status_check_contexts":[],"protected_file_patterns":""}'
readonly RULE_AS_WANTED='{"rule_name":"main","enable_push":false,"enable_status_check":true,"status_check_contexts":["TirSystem/git-workflows: *"],"protected_file_patterns":""}'

# count_calls METHOD: how many requests with METHOD went to the stub.
count_calls() {
  calls | grep -c "^$1 " || true
}

# count_writes: how many requests that change something went to the stub.
count_writes() {
  calls | grep -c -E '^(POST|PATCH|PUT|DELETE) ' || true
}

# ------------------------------------------------ a new repository (MIL-021)

test_a_new_gitea_repository_gets_one_protection_rule_after_the_mirror() {
  setup_hosts
  prot_apply "$ANSWERS_GITHUB"$'y\n'
  assert_status "apply" 0 "$STATUS"
  assert_eq "one rule request" "1" "$(calls | grep -c -x -F "$PROTECTION_CALL")"
  assert_before "the rule after the mirror" "$(position "$MIRROR_CALL")" "$(position "$PROTECTION_CALL")"
  assert_before "the rule after the first sync" "$(position "$SYNC_CALL")" "$(position "$PROTECTION_CALL")"
  assert_contains "step reported" "$OUT" "Branch protection : created (no direct push to main)"
}

test_the_default_rule_body_forbids_direct_push() {
  setup_hosts
  prot_apply "$ANSWERS_GITHUB"$'y\n'
  local body
  body="$(grep -A1 "^$PROTECTION_CALL" "$WORK/curl.bodies" | tail -n 1)"
  assert_eq "the whole body" '{"rule_name":"main","enable_push":false,"enable_status_check":true,"status_check_contexts":["TirSystem/git-workflows: *"],"protected_file_patterns":""}' "$body"
}

test_the_plan_names_the_rule_for_a_created_repository_only() {
  setup_hosts
  prot_dry "$ANSWERS_GITHUB"
  assert_status "dry run" 0 "$STATUS"
  assert_contains "plan line" "$OUT" "Branch protection : create on Gitea: rule 'main': no direct push (use a pull request); status checks: TirSystem/git-workflows: *; protected files: none"
  assert_not_contains "a dry run only reads" "$(calls)" "branch_protections"
  setup_hosts
  prepend_route 'GET|/api/v1/repos/TirSystem/my-app|200|{"empty":true}'
  prot_dry "$ANSWERS_GITHUB"
  assert_contains "reused repository" "$OUT" "Branch protection : not changed (the Gitea repository is reused)"
  assert_not_contains "no rule for a reused repository" "$OUT" "create on Gitea"
}

test_a_reused_repository_and_github_get_no_protection_request() {
  setup_hosts
  prepend_route 'GET|/api/v1/repos/TirSystem/my-app|200|{"empty":true}'
  prot_apply "$ANSWERS_GITHUB_PUBLIC"$'y\ny\n'
  assert_status "reuse" 0 "$STATUS"
  assert_not_contains "no rule request" "$(calls)" "branch_protections"
  assert_contains "reported" "$OUT" "Branch protection : not changed (the repository is reused)"
  setup_hosts
  prot_apply "$ANSWERS_GITHUB"$'y\n'
  assert_not_contains "nothing for GitHub" "$(calls | grep api.github.com)" "protect"
}

test_the_keys_of_config_env_set_the_rule() {
  setup_hosts
  cat >>"$WORK/config.env" <<'EOF'
PROTECTED_BRANCH_PATTERN=release/*
PROTECTED_FILE_PATTERNS=docs/**; *.lock
PROTECTED_STATUS_CHECKS=Quality / quality (pull_request);Validate*
EOF
  prot_apply "$ANSWERS_GITHUB"$'y\n'
  assert_status "apply" 0 "$STATUS"
  local body
  body="$(grep -A1 "^$PROTECTION_CALL" "$WORK/curl.bodies" | tail -n 1)"
  assert_eq "the whole body" '{"rule_name":"release/*","enable_push":false,"enable_status_check":true,"status_check_contexts":["Quality / quality (pull_request)","Validate*"],"protected_file_patterns":"docs/**; *.lock"}' "$body"
}

test_an_empty_list_of_status_checks_switches_the_check_off() {
  setup_hosts
  printf 'PROTECTED_STATUS_CHECKS=\n' >>"$WORK/config.env"
  prot_apply "$ANSWERS_GITHUB"$'y\n'
  assert_status "apply" 0 "$STATUS"
  assert_contains "check off" "$(cat "$WORK/curl.bodies")" '"enable_status_check":false,"status_check_contexts":[]'
  assert_contains "plan says none" "$OUT" "status checks: none"
}

test_no_key_can_turn_direct_push_on() {
  setup_hosts
  printf 'PROTECTED_ENABLE_PUSH=yes\n' >>"$WORK/config.env"
  prot_dry "$ANSWERS_GITHUB"
  assert_status "unknown key" 1 "$STATUS"
  assert_contains "named" "$ERR" "unknown key 'PROTECTED_ENABLE_PUSH'"
  assert_not_contains "no request" "$(calls)" "POST"
}

test_an_invalid_protection_value_stops_before_any_request_and_names_the_key() {
  local line key
  for line in 'PROTECTED_BRANCH_PATTERN=' 'PROTECTED_BRANCH_PATTERN=a;b' \
    'PROTECTED_FILE_PATTERNS=a;;b' 'PROTECTED_FILE_PATTERNS=a;' \
    'PROTECTED_STATUS_CHECKS=;a' 'PROTECTED_STATUS_CHECKS=a; ;b'; do
    key="${line%%=*}"
    setup_hosts
    printf '%s\n' "$line" >>"$WORK/config.env"
    prot_dry "$ANSWERS_GITHUB"
    assert_status "refused: $line" 1 "$STATUS"
    assert_contains "names the key: $line" "$ERR" "$key in $WORK/config.env is not valid"
    assert_eq "no request: $line" "" "$(calls)"
    remove_workdir
    new_workdir
  done
}

test_a_refused_rule_is_a_warning_and_the_run_goes_on() {
  local code
  for code in 403 404 422; do
    setup_hosts
    prepend_route "POST|/api/v1/repos/TirSystem/my-app/branch_protections|$code|{\"message\":\"nope\"}"
    prot_apply "$ANSWERS_GITHUB"$'y\n'
    assert_status "run ends well ($code)" 0 "$STATUS"
    assert_contains "warning ($code)" "$ERR" "could not set the branch protection rule"
    assert_contains "settings hint ($code)" "$OUT" "Branch protection : not set (set it in the repository settings under Branches)"
    assert_contains "the mirror is made ($code)" "$OUT" "Push mirror       : created"
    assert_contains "the local project is made ($code)" "$OUT" "Local project"
    remove_workdir
    new_workdir
  done
}

test_the_protection_request_never_shows_a_token() {
  setup_hosts
  prot_apply "$ANSWERS_GITHUB"$'y\n'
  assert_not_contains "no token in output" "$OUT$ERR" "$FAKE_GITEA_TOKEN"
  assert_not_contains "no token in the body" "$(cat "$WORK/curl.bodies")" "$FAKE_GITEA_TOKEN"
}

# ---------------------------------------------- an existing repository (MIL-022)

test_protect_dry_run_reads_and_writes_nothing() {
  protect_fixtures 404 '{"message":"not found"}'
  prot_run ""
  assert_status "dry run" 0 "$STATUS"
  assert_contains "says no rule" "$OUT" "no rule named 'main'"
  assert_contains "says dry run" "$OUT" "Dry run: nothing was changed"
  assert_eq "no write request" "0" "$(count_writes)"
  assert_contains "reads the rule" "$(calls)" "GET $PROTECTION_RULE_URL"
}

test_protect_creates_a_missing_rule_with_the_body_of_a_new_repository() {
  protect_fixtures 404 '{"message":"not found"}'
  prot_run "" --apply
  assert_status "apply" 0 "$STATUS"
  assert_eq "one POST" "1" "$(calls | grep -c -x -F "$PROTECTION_CALL")"
  assert_eq "no PATCH" "0" "$(count_calls PATCH)"
  assert_eq "same body as for a new repository" \
    '{"rule_name":"main","enable_push":false,"enable_status_check":true,"status_check_contexts":["TirSystem/git-workflows: *"],"protected_file_patterns":""}' \
    "$(grep -A1 "^$PROTECTION_CALL" "$WORK/curl.bodies" | tail -n 1)"
  assert_contains "done" "$OUT" "The rule 'main' was created"
}

test_protect_shows_the_difference_and_changes_nothing_in_a_dry_run() {
  protect_fixtures 200 "$RULE_DIFFERENT"
  prot_run ""
  assert_status "dry run" 0 "$STATUS"
  assert_contains "differs" "$OUT" "differs"
  assert_contains "now" "$OUT" "enable_push: true"
  assert_contains "wanted" "$OUT" "enable_push: false"
  assert_eq "no write request" "0" "$(count_writes)"
}

test_protect_changes_an_existing_rule_only_after_a_yes() {
  protect_fixtures 200 "$RULE_DIFFERENT"
  prot_run $'y\n' --apply
  assert_status "yes" 0 "$STATUS"
  assert_eq "one PATCH" "1" "$(calls | grep -c -x -F "PATCH $PROTECTION_RULE_URL")"
  assert_eq "no POST" "0" "$(count_calls POST)"
  assert_not_contains "the edit body has no rule name" "$(grep -A1 "^PATCH " "$WORK/curl.bodies")" "rule_name"
  assert_contains "direct push off" "$(grep -A1 "^PATCH " "$WORK/curl.bodies")" '"enable_push":false'
  protect_fixtures 200 "$RULE_DIFFERENT"
  prot_run $'n\n' --apply
  assert_status "no" 1 "$STATUS"
  assert_contains "says so" "$ERR" "the rule was not changed"
  assert_eq "no PATCH after a no" "0" "$(count_calls PATCH)"
}

test_protect_does_nothing_when_the_rule_is_as_wanted() {
  protect_fixtures 200 "$RULE_AS_WANTED"
  prot_run "" --apply
  assert_status "as wanted" 0 "$STATUS"
  assert_contains "says so" "$OUT" "already as wanted"
  assert_eq "no write request" "0" "$(count_writes)"
}

test_protect_touches_only_the_rule_it_was_asked_for() {
  protect_fixtures 404 '{"message":"not found"}'
  printf 'PROTECTED_BRANCH_PATTERN=release/*\n' >>"$WORK/config.env"
  prot_run "" --apply
  assert_status "apply" 0 "$STATUS"
  assert_contains "encoded rule name read" "$(calls)" "GET https://git.example.test/api/v1/repos/TirSystem/my-app/branch_protections/release%2F%2A"
  assert_not_contains "no other rule" "$(calls)" "branch_protections/main"
  assert_not_contains "never deletes" "$(calls)" "DELETE"
}

test_protect_stops_with_the_cause_when_a_request_is_refused() {
  protect_fixtures 404 '{"message":"not found"}'
  prepend_route 'GET|/api/v1/repos/TirSystem/my-app|404|{"message":"not found"}'
  prot_run "" --apply
  assert_status "no repository" 1 "$STATUS"
  assert_contains "named" "$ERR" "the Gitea repository TirSystem/my-app does not exist, or the token cannot see it"
  protect_fixtures 404 '{"message":"not found"}'
  prepend_route 'POST|/api/v1/repos/TirSystem/my-app/branch_protections|403|{"message":"forbidden"}'
  prot_run "" --apply
  assert_status "forbidden" 1 "$STATUS"
  assert_contains "cause" "$ERR" "not allowed to do this"
  protect_fixtures 404 '{"message":"not found"}'
  prepend_route 'POST|/api/v1/repos/TirSystem/my-app/branch_protections|422|{"message":"bad pattern"}'
  prot_run "" --apply
  assert_status "refused body" 1 "$STATUS"
  assert_contains "server words" "$ERR" "bad pattern"
  assert_not_contains "no token" "$OUT$ERR" "$FAKE_GITEA_TOKEN"
}

test_protect_uses_the_gitea_token_only_and_creates_nothing_else() {
  protect_fixtures 404 '{"message":"not found"}'
  prot_run "" --apply
  assert_status "no GitHub credential needed" 0 "$STATUS"
  assert_not_contains "no GitHub request" "$(calls)" "api.github.com"
  assert_not_contains "no repository created" "$(calls)" "/repos\""
  assert_not_contains "no mirror" "$(calls)" "push_mirrors"
  assert_not_contains "no repository POST" "$(calls)" "POST https://git.example.test/api/v1/orgs"
  assert_not_contains "no report of a creation" "$OUT" "This is what exists now"
  assert_file_missing "no directory" "$WORK/my-app"
}

test_protect_refuses_a_name_that_is_not_owner_slash_name() {
  local bad
  for bad in my-app TirSystem/ /my-app TirSystem/my/app 'a b/c' ''; do
    protect_fixtures 404 '{"message":"not found"}'
    run_cli "" --protect "$bad" --config "$WORK/config.env" --env "$WORK/.env"
    assert_status "refused '$bad'" 2 "$STATUS"
    assert_contains "usage hint '$bad'" "$ERR" "--protect needs OWNER/NAME"
    assert_eq "no request '$bad'" "" "$(calls)"
  done
  protect_fixtures 404 '{"message":"not found"}'
  run_cli "" --protect --config "$WORK/config.env"
  assert_status "name missing" 2 "$STATUS"
}

# ------------------------------------------------------------- helper units

test_url_encode_leaves_safe_characters_and_encodes_the_rest() {
  run_lib "" 'url_encode "release/*"; echo; url_encode "a b.c_d~e-f"'
  assert_eq "encoded" $'release%2F%2A\na%20b.c_d~e-f' "$OUT"
}

test_split_patterns_keeps_empty_items_for_the_validator() {
  run_lib "" 'split_patterns "a; b ;;c" items; printf "[%s]" "${items[@]}"'
  assert_eq "items" "[a][b][][c]" "$OUT"
}
