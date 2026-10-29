# MIL-019 Accept the Gitea token names of the framework

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-019 |
| CrossReference | [BC-001], [US-001], [MIL-018] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

Framework 0.18.0 named the tokens of a project `TOKEN_FOR_GITEA_ISSUES`, `TOKEN_FOR_GITEA_REPO` and `TOKEN_FOR_GITEA_WIKI`, and a `.env` that follows it is rejected by `create-project.sh` today: `error: .env line 1: unknown key 'TOKEN_FOR_GITEA_REPO'`. The script accepts only `GITEA_TOKEN`, `GITHUB_PAT`, `GITHUB_USER` and `TOKEN_FOR_GITEA_WIKI`. The Maintainer must keep one `.env` for the script, the framework scripts and the workflows, as the framework intends, and a project the script creates should start with the names the framework reads.

## Deliverable

`create-project.sh` accepts `TOKEN_FOR_GITEA_REPO` as the Gitea token it creates, pushes and mirrors with; `GITEA_TOKEN` is still read when `TOKEN_FOR_GITEA_REPO` is absent, and a `.env` that has both uses `TOKEN_FOR_GITEA_REPO` and says so. `TOKEN_FOR_GITEA_ISSUES` is accepted like `TOKEN_FOR_GITEA_WIKI` is today: checked, kept secret, never used here. The `.env` that the script writes into a new project holds `TOKEN_FOR_GITEA_REPO` (not `GITEA_TOKEN`). Messages, the prompts and the plan name the key that was read. The names `GITEA_TOKEN` and `SYNC_TOKEN` of older files keep working for one release, as in the framework; a note in the output says that the old name is deprecated.

No token value is printed, put on a command line or written anywhere new. The scope of the token is the same as before; no new host is called.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | A `.env` with `TOKEN_FOR_GITEA_REPO`, `TOKEN_FOR_GITEA_ISSUES` and `TOKEN_FOR_GITEA_WIKI` passes the check of keys and the run uses `TOKEN_FOR_GITEA_REPO` | Tests pass | `unknown key` for any of them |
| 2 | A `.env` with only `GITEA_TOKEN` still works and the output names the old key as deprecated | Tests pass | The run fails, or no note |
| 3 | A `.env` with both `TOKEN_FOR_GITEA_REPO` and `GITEA_TOKEN` uses the first and says so | Tests pass | The old key wins, or no message |
| 4 | An invalid value of any of the three new keys is refused without printing the value | Tests pass | The value is printed or accepted |
| 5 | The `.env` written for a new project holds `TOKEN_FOR_GITEA_REPO` and mode 600, and no `GITEA_TOKEN` | Tests pass | The old key is written, or the mode is wider |
| 6 | All tokens, the three new ones included, are in the secret list so no message, log or error shows them | Tests pass | A token appears in output |
| 7 | The README, `AccessTokens` and `SshAndTokens` (three languages) and UC-001 name the new keys and the fallback | Reviewed by S02 | Documents still tell the Maintainer to use `GITEA_TOKEN` only |
| 8 | `CHANGELOG.md` states the change and the one-release fallback under `## [Unreleased]` | Reviewed by S02 | No entry |
| 9 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 10 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-018] | Both change the Gitea steps in `src/lib/`; MIL-019 is done first because it unblocks running the script with a `.env` of the framework, so the pull requests are merged one after the other and the second takes the first as its base |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Credentials are kept in one `.env` and never shown | [BC-001] |
| User story US-001, a project is created with its repositories | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-01-29 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Read the new token names | In `src/lib/constants.sh` add `TOKEN_FOR_GITEA_REPO` and `TOKEN_FOR_GITEA_ISSUES` to `CREDENTIAL_KEYS`; in `src/lib/config.sh` resolve the Gitea token (new key first, `GITEA_TOKEN` as the deprecated fallback) and validate and register the new keys as secrets; update `credentials.sh`, `api.sh`, `git.sh`, `project.sh` and `create-project.sh` to use the resolved token. Add the tests of criteria 1 to 4 and 6. | No | US-001 |
| 2 | Write the new names into a new project | In `src/lib/envfile.sh` write `TOKEN_FOR_GITEA_REPO` instead of `GITEA_TOKEN`; the tests of criterion 5. | No | US-001 |
| 3 | Update the use case documents | UC-001 (`uc.md`, `sd.md`, `dcd.md`) and `docs/dcd.md` name the keys; `docs/business-case.md` and the older milestones are history and stay as they are. | No | |
| 4 | Document the names | README, `AccessTokens` and `SshAndTokens` (English, Danish, Bahasa Melayu, with the translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-018]: ./mil-018-delete-branch-after-merge.md
