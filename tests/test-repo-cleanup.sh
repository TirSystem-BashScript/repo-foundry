#!/usr/bin/env bash
# test-repo-cleanup.sh - tests for "Delete pull request branch after merge by
# default" on a new Gitea repository (MIL-018). A stub curl answers from a
# routes file and records every call and body; no real host is contacted.
# Sourced by run-tests.sh.

# shellcheck disable=SC2016  # snippet and fixture text is literal on purpose

readonly CLEANUP_CALL="PATCH https://git.example.test/api/v1/repos/TirSystem/my-app"

cleanup_apply() {
  run_cli "$1" --apply --config "$WORK/config.env" --env "$WORK/.env"
}

cleanup_dry() {
  run_cli "$1" --config "$WORK/config.env" --env "$WORK/.env"
}

test_a_created_gitea_repository_gets_one_edit_request_with_one_field() {
  setup_hosts
  cleanup_apply "$ANSWERS_GITHUB"$'y\n'
  assert_status "apply" 0 "$STATUS"
  assert_eq "one edit request" "1" "$(calls | grep -c -x -F "$CLEANUP_CALL")"
  assert_eq "only that field" '{"default_delete_branch_after_merge":true}' \
    "$(grep -A1 "^$CLEANUP_CALL" "$WORK/curl.bodies" | tail -n 1)"
  assert_contains "step reported" "$OUT" "Branch cleanup    : on (a pull request branch is deleted after merge)"
}

test_the_edit_request_follows_the_repository_and_comes_before_the_rule() {
  setup_hosts
  cleanup_apply "$ANSWERS_GITHUB"$'y\n'
  assert_before "after the create request" "$(position "POST https://git.example.test/api/v1/orgs/TirSystem/repos")" "$(position "$CLEANUP_CALL")"
  assert_before "before the rule" "$(position "$CLEANUP_CALL")" "$(position "POST https://git.example.test/api/v1/repos/TirSystem/my-app/branch_protections")"
}

test_the_plan_names_the_setting_for_a_created_repository_only() {
  setup_hosts
  cleanup_dry "$ANSWERS_GITHUB"
  assert_status "dry run" 0 "$STATUS"
  assert_contains "plan line" "$OUT" "Branch cleanup    : turn on on Gitea: delete a pull request branch after merge, by default"
  assert_not_contains "a dry run sends no edit request" "$(calls)" "PATCH"
  setup_hosts
  prepend_route 'GET|/api/v1/repos/TirSystem/my-app|200|{"empty":true}'
  cleanup_dry "$ANSWERS_GITHUB"
  assert_contains "reused repository" "$OUT" "Branch cleanup    : not changed (the Gitea repository is reused)"
  assert_not_contains "no setting for a reused repository" "$OUT" "turn on on Gitea"
}

test_a_reused_repository_gets_no_edit_request() {
  setup_hosts
  prepend_route 'GET|/api/v1/repos/TirSystem/my-app|200|{"empty":true}'
  cleanup_apply "$ANSWERS_GITHUB_PUBLIC"$'y\ny\n'
  assert_status "reuse" 0 "$STATUS"
  assert_not_contains "no edit request" "$(calls)" "PATCH"
  assert_contains "reported" "$OUT" "Branch cleanup    : not changed (the repository is reused)"
}

test_a_refused_edit_is_a_warning_and_the_run_goes_on() {
  local code
  for code in 403 404; do
    setup_hosts
    prepend_route "PATCH|/api/v1/repos/TirSystem/my-app|$code|{\"message\":\"nope\"}"
    cleanup_apply "$ANSWERS_GITHUB"$'y\n'
    assert_status "run ends well ($code)" 0 "$STATUS"
    assert_contains "warning ($code)" "$ERR" "could not turn on branch cleanup after merge"
    assert_contains "settings hint ($code)" "$OUT" "Branch cleanup    : not set (set it in the repository settings under Pull Requests)"
    assert_contains "the mirror is made ($code)" "$OUT" "Push mirror       : created"
    assert_contains "the local project is made ($code)" "$OUT" "Local project"
    remove_workdir
    new_workdir
  done
}

test_no_github_request_carries_the_setting() {
  setup_hosts
  cleanup_apply "$ANSWERS_GITHUB"$'y\n'
  assert_not_contains "nothing for GitHub" "$(calls | grep api.github.com)" "delete_branch"
  assert_not_contains "no token in output" "$OUT$ERR" "$FAKE_GITEA_TOKEN"
}
