#!/usr/bin/env bash
# test-list-licenses.sh - tests for --list-licenses (MIL-029): the mode prints
# the license keys of the Gitea server, one per line, and only reads. A stub
# curl answers from a routes file and records every call; no real host is
# contacted. Sourced by run-tests.sh.

# shellcheck disable=SC2016  # snippet and fixture text is literal on purpose

readonly LICENSES_ROUTE='GET|/api/v1/licenses|200|[{"key":"0BSD","name":"0BSD"},{"key":"AGPL-3.0","name":"AGPL-3.0"},{"key":"MIT","name":"MIT"}]'

list_licenses_run() {
  run_cli "" --list-licenses --config "$WORK/config.env" --env "$WORK/.env"
}

# -------------------------------------------------------------- the output

test_the_mode_prints_one_license_key_per_line_and_asks_once() {
  setup_hosts
  prepend_route "$LICENSES_ROUTE"
  list_licenses_run
  assert_status "list" 0 "$STATUS"
  assert_eq "one key per line" $'0BSD\nAGPL-3.0\nMIT' "$OUT"
  assert_eq "one request" "GET https://git.example.test/api/v1/licenses" \
    "$(calls | grep -F "/licenses")"
  assert_eq "one licenses request" "1" "$(calls | grep -c -F "/licenses")"
}

# --------------------------------------------------------------- read only

test_the_mode_only_reads_and_needs_neither_apply_nor_github() {
  setup_hosts
  prepend_route "$LICENSES_ROUTE"
  gitea_only_env
  list_licenses_run
  assert_status "list" 0 "$STATUS"
  assert_not_contains "no write request" "$(calls)" "POST"
  assert_not_contains "no edit request" "$(calls)" "PATCH"
  assert_not_contains "no put request" "$(calls)" "PUT"
  assert_not_contains "no delete request" "$(calls)" "DELETE"
  assert_not_contains "no GitHub call" "$(calls)" "api.github.com"
  assert_file_missing "no project directory" "$WORK/my-app"
  assert_not_contains "no plan" "$OUT" "Plan"
}

# ------------------------------------------------------------ combinations

test_the_mode_cannot_be_combined_with_apply_or_protect() {
  local args
  for args in "--apply" "--protect TirSystem/my-app" "--apply --protect TirSystem/my-app"; do
    setup_hosts
    prepend_route "$LICENSES_ROUTE"
    # shellcheck disable=SC2086  # the arguments are split on purpose
    run_cli "" --list-licenses $args --config "$WORK/config.env" --env "$WORK/.env"
    assert_status "refused: $args" 2 "$STATUS"
    assert_contains "says why: $args" "$ERR" "--list-licenses only reads and cannot be combined with --apply or --protect"
    assert_eq "no request: $args" "" "$(calls)"
  done
  setup_hosts
  run_cli "" --apply --list-licenses --config "$WORK/config.env" --env "$WORK/.env"
  assert_status "refused in the other order" 2 "$STATUS"
  assert_eq "no request in the other order" "" "$(calls)"
}

# ------------------------------------------------------------------ errors

test_a_refused_request_stops_with_the_cause_and_a_status_that_is_not_0() {
  local code
  for code in 401 403 404 500; do
    setup_hosts
    prepend_route "GET|/api/v1/licenses|$code|{\"message\":\"not allowed\"}"
    list_licenses_run
    assert_eq "status $code is not 0" "1" "$([[ $STATUS != 0 ]] && echo 1 || echo 0)"
    assert_contains "names the request: $code" "$ERR" "cannot list the licenses of the Gitea server"
    assert_not_contains "no token on stdout: $code" "$OUT" "$FAKE_GITEA_TOKEN"
    assert_not_contains "no token on stderr: $code" "$ERR" "$FAKE_GITEA_TOKEN"
  done
}

test_an_empty_list_stops_with_a_message_and_a_status_that_is_not_0() {
  setup_hosts
  prepend_route 'GET|/api/v1/licenses|200|[]'
  list_licenses_run
  assert_eq "status is not 0" "1" "$([[ $STATUS != 0 ]] && echo 1 || echo 0)"
  assert_contains "says why" "$ERR" "the Gitea server offers no licenses"
  assert_eq "nothing printed" "" "$OUT"
}

# ------------------------------------------------------ a normal run is as before

test_a_normal_run_still_stops_when_the_server_does_not_offer_the_license() {
  setup_hosts
  prepend_route "$LICENSES_ROUTE"
  printf '%s\n' "PROJECT_LICENSE=Unknown-1.0" >>"$WORK/config.env"
  run_cli "$ANSWERS_GITHUB" --config "$WORK/config.env" --env "$WORK/.env"
  assert_eq "status is not 0" "1" "$([[ $STATUS != 0 ]] && echo 1 || echo 0)"
  assert_contains "the old message" "$ERR" "the Gitea server does not offer the Unknown-1.0 license"
}
