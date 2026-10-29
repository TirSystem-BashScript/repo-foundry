# MIL-021 Protect the default branch of a new Gitea repository

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-021 |
| CrossReference | [BC-001], [US-001], [MIL-018], [MIL-020] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [b63fe29] |

---

## Purpose

Decide that the Gitea repository that `create-project.sh` creates starts with a branch protection rule, so that nothing is pushed straight to `main` and every change arrives by a pull request, as the framework's workflow already says. Today a new repository has no rule (checked on this repository: `GET /repos/{owner}/{repo}/branch_protections` answers an empty list), so the owner must find the setting after the first push. Gitea has the request for it: `POST /repos/{owner}/{repo}/branch_protections` takes `rule_name`, `enable_push`, `enable_status_check`, `status_check_contexts` and `protected_file_patterns`. Gitea reads the branch name, the file patterns and the status check names as glob patterns (https://github.com/gobwas/glob).

## Deliverable

A change to `create-project.sh` so that, as the last Gitea step on a repository the run created, it sends one create request for a protection rule with:

- the rule name (the protected branch name pattern): `PROTECTED_BRANCH_PATTERN`, default `main`;
- `enable_push` false, always: no direct push to the protected branch, use a pull request. This is not configurable;
- the protected file patterns, separated by semicolons: `PROTECTED_FILE_PATTERNS`, default empty (no file is protected);
- `enable_status_check` true with the status check patterns of `PROTECTED_STATUS_CHECKS`, separated by semicolons. The default is `TirSystem/git-workflows: *`, which matches the checks of the shared workflows that run for every repository of the organisation (OpenGrep, Quality checks, Validate). When the list is empty, the status check is turned off.

The three keys are optional keys of `config.env`, validated like the other details: an invalid value stops the run and names the key. The patterns are sent as given; the script does not expand them. The rule is made after the repository exists and holds its first content, because a rule without a push whitelist also stops the script's own and the owner's first push. A reused repository, and the GitHub repository, are not changed. If the request fails, the run does not stop: it warns and says that the owner can set the rule in the repository settings under Branches. The plan (`--dry-run`) names the rule and its values. No new credential and no new host: the token that creates the repository administers it.

Confirmed by S01 in chat: the default status check pattern. A pattern that matches no check blocks every merge, so the default must match a check that runs on a pull request of a project with no workflow of its own; only the shared workflows of the organisation do.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | After a created Gitea repository, the script sends one `POST` to `/repos/{owner}/{name}/branch_protections` with `rule_name`, `enable_push` false, `enable_status_check`, `status_check_contexts` and `protected_file_patterns` from the defaults | Tests pass | No request, a second request, or another field |
| 2 | `enable_push` is false whatever `config.env` holds; no key can turn it on | Tests pass | A key turns direct push on |
| 3 | `PROTECTED_BRANCH_PATTERN`, `PROTECTED_FILE_PATTERNS` and `PROTECTED_STATUS_CHECKS` set the rule name, the file patterns and the status check patterns (semicolon lists become arrays); an empty `PROTECTED_STATUS_CHECKS` sends `enable_status_check` false | Tests pass | A value ignored, a list not split |
| 4 | An invalid value (a control character, an empty item between semicolons) stops the run before any request and names the key | Tests pass | The run goes on, or the key is not named |
| 5 | The plan names the rule and its values for a repository that will be created, and does not name it for a reused one | Tests pass | The plan is silent, or names it for a reused repository |
| 6 | With a stub that answers 201, the step is reported as done; with 403, 404 or 422 the run warns, still ends with status 0, and the mirror and the local project are made | Tests pass | The run stops or the mirror is not made |
| 7 | A reused Gitea repository and the GitHub repository receive no protection request | Tests pass | A request is sent |
| 8 | The rule is made after the repository and its mirror, so the steps of the run that push do not meet the rule | Tests pass | A step is refused by the rule |
| 9 | The README, `config.env.example` and the wiki page `GettingStarted` (three languages) describe the rule, the three keys, the glob syntax and that work now goes by branch and pull request from the first commit | Reviewed by S02 | Not documented |
| 10 | `CHANGELOG.md` states the change under `## [Unreleased]` | Reviewed by S02 | No entry |
| 11 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 12 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-020] | Release 0.3.9 is out before a change of behaviour is merged |
| [MIL-018] | Both add a request on the created Gitea repository in `src/lib/`; they are merged one after the other and the second takes the first as its base |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Repeatable creation of the repositories with settings the project needs | [BC-001] |
| User story US-001.02, repositories and mirror | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-02-09 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Read the three keys | Add `PROTECTED_BRANCH_PATTERN`, `PROTECTED_FILE_PATTERNS` and `PROTECTED_STATUS_CHECKS` to the keys of `config.env` in `src/lib/config.sh` with their defaults and validation (criteria 3 and 4). | No | US-001 |
| 2 | Create the rule | One request after the repository and its mirror, with a plan line and a step line, a warning when it fails, and no request for a reused repository (criteria 1, 2 and 5 to 8). | No | US-001 |
| 3 | Update the use case documents | UC-001 (`uc.md`, `sd.md`, `dcd.md`) and `docs/dcd.md` name the step and the keys. | No | |
| 4 | Document the rule | README, `config.env.example`, `GettingStarted` in three languages (translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-018]: ./mil-018-delete-branch-after-merge.md
[MIL-020]: ./mil-020-release-0-3-9.md
[b63fe29]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/b63fe29d7df28b62bade9fc5b14500229dc43d80
