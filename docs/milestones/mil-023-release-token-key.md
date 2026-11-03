# MIL-023 Accept the release token key

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-023 |
| CrossReference | [BC-001], [US-001], [MIL-019] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-03 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

The release workflow of the shared workflows reads a fourth Gitea token, `TOKEN_FOR_GITEA_RELEASE`, and a `.env` that holds it is rejected by `create-project.sh` today: `error: .env line 4: unknown key 'TOKEN_FOR_GITEA_RELEASE'`. [MIL-019] made the script accept the other framework token names so that the Maintainer keeps one `.env` for the script, the framework scripts and the workflows; this key was left out, and the run stops before it does anything.

## Deliverable

`create-project.sh` accepts `TOKEN_FOR_GITEA_RELEASE` in `.env` as it accepts `TOKEN_FOR_GITEA_ISSUES` and `TOKEN_FOR_GITEA_WIKI`: the value is checked, kept secret, and never used or asked for here. No other behaviour changes.

No token value is printed, put on a command line or written anywhere new. No new host is called.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | A `.env` with `TOKEN_FOR_GITEA_RELEASE` next to the other token keys passes the check of keys and the run uses `TOKEN_FOR_GITEA_REPO` | Tests pass | `unknown key` for the release key |
| 2 | An invalid value of the key is refused without printing the value | Tests pass | The value is printed or accepted |
| 3 | The key is in the secret list so no message, log or error shows its value | Tests pass | The value appears in output |
| 4 | The key is never asked for and is not written into the `.env` of a new project | Tests pass | A prompt for it, or it is written |
| 5 | `.env.example`, the README, `AccessTokens` and `SshAndTokens` (three languages) name the key as accepted and unused | Reviewed by S02 | The documents are silent |
| 6 | `CHANGELOG.md` states the change under `## [Unreleased]` | Reviewed by S02 | No entry |
| 7 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 8 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-019] | It introduced the accepted-but-unused token keys that this milestone extends |

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

2027-02-18 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Accept the release token key | In `src/lib/constants.sh` add `TOKEN_FOR_GITEA_RELEASE` to the credential keys, and in `src/lib/config.sh` validate it and register it as a secret like `TOKEN_FOR_GITEA_ISSUES`; update the header comments. Add the tests of criteria 1 to 4. | No | US-001 |
| 2 | Document the key | `.env.example`, README, `AccessTokens` and `SshAndTokens` (English, Danish, Bahasa Melayu, with the translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-019]: ./mil-019-gitea-token-names.md
