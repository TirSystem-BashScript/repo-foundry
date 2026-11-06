# MIL-029 List the licenses of the Gitea server

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-029 |
| CrossReference | [BC-001], [US-001], [MIL-022], [MIL-028] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-06 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [b7406aa] |

---

## Purpose

The license of a project is already optional: the key `PROJECT_LICENSE` of `config.env` names a Gitea license key, or `none` for no license, and the script stops before it creates anything if the Gitea server does not offer the key. The Maintainer cannot see which keys the server offers without calling the Gitea API by hand. This phase lets the user find the keys: a read-only option `--list-licenses` that prints them, and a comment in `config.env.example` that lists the keys of the Maintainer's Gitea server next to `PROJECT_LICENSE`.

## Deliverable

A mode of `create-project.sh`, `--list-licenses`, that reads the license list of the Gitea server named in `config.env` (`GET /licenses`, the request that the license check of a run already makes) and prints one license key per line. It is read-only, so it needs no `--apply`. Like `--protect OWNER/NAME` ([MIL-022]) it does nothing else: it asks for no GitHub credential and creates no repository, mirror, directory or submodule. It cannot be combined with another mode.

`config.env.example` lists, as a comment next to `PROJECT_LICENSE`, the keys that the Gitea server of the Maintainer offers (30 at the time of writing, from `0BSD` to `WTFPL`, among them `AGPL-3.0`, `MIT`, `Apache-2.0` and the two TirSystem licenses), says that the list belongs to that server and that `--list-licenses` prints the list of any other server. The behaviour of `PROJECT_LICENSE` does not change.

No new credential and no new host.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `--list-licenses` sends one `GET /licenses` to the Gitea server and prints each license key on its own line; status 0 | Tests pass | Another request, or another output |
| 2 | The mode sends no `POST`, `PATCH`, `PUT` or `DELETE`, makes no GitHub request, creates no repository, mirror, directory or submodule, and needs neither `--apply` nor `GITHUB_PAT` | Tests pass | Any of them |
| 3 | Combined with `--protect`, `--apply` or another argument that the mode does not take, the script stops with a usage error before any request | Tests pass | A request is sent |
| 4 | An unreachable server, a status other than 200 and an empty list each stop the run with a message that names the cause and status not 0; no token is printed | Tests pass | Status 0, or a token in the output |
| 5 | The check of `PROJECT_LICENSE` in a normal run is unchanged | Tests pass | A changed result |
| 6 | `config.env.example` lists the license keys of the Gitea server as a comment next to `PROJECT_LICENSE` and names `--list-licenses`; the key is still commented out | Reviewed by S02 | No list, or a key switched on |
| 7 | The README (usage and options), `--help`, the wiki page `GettingStarted` (three languages) and `CHANGELOG.md` (`## [Unreleased]`) describe the mode | Reviewed by S02 | Not documented |
| 8 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 9 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-022] | The mode follows its pattern: a mode that needs the Gitea token only |
| [MIL-028] | Version 0.5.0 is released; this change goes into the next version |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Repeatable creation with the settings a project needs | [BC-001] |
| User story US-001, a project is created with its repositories | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-03-12 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Parse the mode | `--list-licenses` in `src/lib/cli.sh` with the refusal of every combination (criterion 3), the usage text and the help; the mode runs the Gitea checks of the credentials only. | No | US-001 |
| 2 | Read and print the licenses | One function reads `GET /licenses` and prints the keys; the license check of a normal run uses the same request (criteria 1, 2, 4 and 5). Tests in `tests/`. | No | US-001 |
| 3 | List the keys in `config.env.example` | Read the keys from the Gitea server with the new option and write them as a comment next to `PROJECT_LICENSE` (criterion 6). | No | |
| 4 | Update the use case documents | An extension of UC-001 for the mode, with its sequence diagram and DCD, and `docs/dcd.md`. | Yes, an extension of UC-001 | US-001 |
| 5 | Document the mode | README, `GettingStarted` in three languages (translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-022]: ./mil-022-protect-existing-repository.md
[MIL-028]: ./mil-028-release-0-5-0.md
[b7406aa]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/b7406aae0247f021b4489a5ce275d09c9538519d
