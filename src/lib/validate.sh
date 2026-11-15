# shellcheck shell=bash
# shellcheck disable=SC2004,SC2034,SC2154  # shared state and arrays are declared in constants.sh
# validate.sh - Validators for names, URLs, tokens, ports and intervals.
#
# Part of create-project.sh: sourced by it, never run on its own.
#
# Provides: is_valid_repository_path, is_valid_protected_branch, patterns_overlap, is_valid_protected_list, is_valid_framework_repo, is_valid_repo_name, is_valid_kebab_name, suggest_kebab_name, is_valid_gitea_owner, is_valid_github_owner, is_valid_description, is_valid_directory, is_valid_base_url, is_valid_request_url, is_valid_token, is_valid_port, is_valid_interval, normalize_url

is_valid_repo_name() {
  local name="$1"
  [[ $name =~ ^[A-Za-z0-9._-]{1,100}$ ]] || return 1
  [[ $name != . && $name != .. && $name != *.git ]]
}

# kebab-case: lowercase letters and digits in words joined by single hyphens
# (MIL-031). A kebab-case name is always a valid repository name.
is_valid_kebab_name() {
  local LC_ALL=C
  [[ $1 =~ ^[a-z0-9]+(-[a-z0-9]+)*$ && ${#1} -le $MAX_REPO_NAME_LENGTH ]]
}

# suggest_kebab_name NAME: the kebab-case form of NAME, printed (empty when
# NAME holds no letter or digit): lowercased, every other run of characters
# one hyphen, no hyphen at either end, cut at the length limit.
suggest_kebab_name() {
  local LC_ALL=C name="${1,,}"
  name="${name//[^a-z0-9]/-}"
  while [[ $name == *--* ]]; do
    name="${name//--/-}"
  done
  name="${name:0:$MAX_REPO_NAME_LENGTH}"
  name="${name#-}"
  printf '%s' "${name%-}"
}

is_valid_gitea_owner() {
  [[ $1 =~ ^[A-Za-z0-9][A-Za-z0-9._-]{0,38}$ ]]
}

is_valid_github_owner() {
  [[ $1 =~ ^[A-Za-z0-9]([A-Za-z0-9-]{0,37}[A-Za-z0-9])?$ ]]
}

is_valid_description() {
  ((${#1} <= MAX_DESCRIPTION_LENGTH)) && ! has_control_character "$1"
}

is_valid_directory() {
  local path="$1"
  [[ -n $path && ${#path} -le 4096 && $path != -* ]] &&
    ! has_control_character "$path"
}

# https URL without user info, query or fragment, so it can never carry a
# credential.
is_valid_base_url() {
  local pattern='^https://[A-Za-z0-9.-]+(:[0-9]{1,5})?(/[A-Za-z0-9._~%+/-]*)?$'
  [[ $1 =~ $pattern ]]
}

# Like is_valid_base_url but a query string is allowed (for API requests).
is_valid_request_url() {
  local pattern='^https://[A-Za-z0-9.-]+(:[0-9]{1,5})?(/[A-Za-z0-9._~%+/-]*)?(\?[A-Za-z0-9._~%+=&,-]*)?$'
  [[ $1 =~ $pattern ]]
}

# Access tokens: no quotes, backslashes or whitespace, so a token cannot
# break out of the curl configuration it is written to.
is_valid_token() {
  [[ $1 =~ ^[A-Za-z0-9_.~+/=-]{8,255}$ ]]
}

# OWNER/NAME of the framework repository on Gitea.
is_valid_framework_repo() {
  [[ $1 =~ ^[A-Za-z0-9._-]+/[A-Za-z0-9._-]+$ && $1 != */.. && $1 != ../* && $1 != ./* && $1 != */. ]]
}

# OWNER/NAME of a Gitea repository, as --protect takes it.
is_valid_repository_path() {
  [[ $1 == */* ]] && is_valid_gitea_owner "${1%%/*}" && is_valid_repo_name "${1#*/}"
}

# A branch pattern of the protection rule: one non-empty glob pattern.
is_valid_protected_branch() {
  [[ -n $1 && $1 != *";"* ]] && ! has_control_character "$1"
}

# patterns_overlap A B: whether two branch glob patterns can match a common
# branch. A best effort: one pattern, read as a shell glob with ** as *, matches
# the other, or the two are equal. Gitea's * stops at a slash, so a few pairs
# that cannot overlap may be refused; a pair that overlaps is never accepted.
patterns_overlap() {
  local first="$1" second="$2" glob_first glob_second
  [[ $first == "$second" ]] && return 0
  glob_first="${first//\*\*/*}"
  glob_second="${second//\*\*/*}"
  # shellcheck disable=SC2053  # the right side is a glob on purpose
  [[ $first == $glob_second || $second == $glob_first ]]
}

# A semicolon separated list of glob patterns, none of them empty. An empty
# list is valid for the file patterns and the status checks.
is_valid_protected_list() {
  local items=() item
  [[ -z $1 ]] && return 0
  split_patterns "$1" items
  for item in "${items[@]}"; do
    [[ -n $item ]] && ! has_control_character "$item" || return 1
  done
}

is_valid_port() {
  [[ $1 =~ ^[0-9]{1,5}$ ]] && ((10#$1 >= 1 && 10#$1 <= 65535))
}

# A Gitea license key such as AGPL-3.0 or MIT, or the word none.
is_valid_license() {
  [[ -n $1 && ${#1} -le 64 && $1 =~ ^[A-Za-z0-9.+-]+$ ]]
}

# A Go duration such as 10m0s or 8h0m0s, the form Gitea expects.
is_valid_interval() {
  [[ -n $1 && $1 =~ ^([0-9]+h)?([0-9]+m)?([0-9]+s)?$ ]]
}

normalize_url() {
  local url="$1"
  while [[ $url == */ ]]; do
    url="${url%/}"
  done
  printf '%s' "$url"
}
