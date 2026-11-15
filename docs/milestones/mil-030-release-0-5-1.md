# MIL-030 Release 0.5.1

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-030 |
| CrossReference | [BC-001], [US-001], [MIL-028], [MIL-029] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-07 | Proposed | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

Decide whether the work merged since `v0.5.0` is released as version 0.5.1. `main` now has the read-only option `--list-licenses` ([MIL-029]), which prints the license keys of the Gitea server, and a list of those keys in `config.env.example`. The Maintainer decides that this is a patch release: no existing behaviour changes, and the option is new but small. Before the release the framework pin moves from `v0.19.0` to `v0.20.0` (the AGENTS template gets rules 8 and 9), so the released version ships with the current framework. `CHANGELOG.md` holds the change under `## [Unreleased]` and `VERSION` still says 0.5.0. A release is deliberate: the Release workflow runs first as a dry run, and the run that writes the tag is S01's decision.

## Deliverable

Version 0.5.1 of `create-project.sh`, released on Gitea: `VERSION` and the `--version` check say 0.5.1; `CHANGELOG.md` has a dated `## [0.5.1]` entry and an empty `## [Unreleased]`; the tag `v0.5.1` and its release page exist, made by the Release workflow from the tip of `main`, and the moving tag `v0` points to it.

The framework submodule points to `v0.20.0` (the pointer is committed; the skills are installed again with `bash framework/scripts/install-skills.sh`). The entry keeps the Added group of `## [Unreleased]` and adds a Changed group for the new pin.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `git submodule status` shows `framework` at the commit of the tag `v0.20.0`, and `bash framework/scripts/install-skills.sh` has been run | Verified in the working tree | Another commit, or skills not installed |
| 2 | `create-project.sh --version` prints `RepoFoundry 0.5.1` | Tests pass | Another version |
| 3 | `CHANGELOG.md` has a `## [0.5.1]` entry with its date that matches the changes since `v0.5.0`, and `## [Unreleased]` holds no entry | Reviewed by S02 | An entry missing, or text left under Unreleased |
| 4 | The latest tag before this release is `v0.5.0` | Verified on Gitea | Another latest tag |
| 5 | The Quality run on the tip of `main` is green, and no test fails that passed at `v0.5.0` | Tests pass | A new failure |
| 6 | The Release workflow, run with version `0.5.1` and `dry_run` true, checks the version, the tip of `main` and the changelog entry and writes nothing | Dry run passes | The dry run reports an error |
| 7 | After the run with `dry_run` false, the tag `v0.5.1` and its release page exist on Gitea, and the page text is the changelog entry | Verified on Gitea | No tag, no page, or another text |
| 8 | The moving tag `v0` points to the same commit as `v0.5.1` | Verified on Gitea | `v0` elsewhere |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-028] | The previous release, 0.5.0, from which this one counts |
| [MIL-029] | The change this release ships |
| Framework `v0.20.0` | The pin moves to this release of `TirSystem/sqa-qc-framework` before the version is bumped; it is already tagged and merged there |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Release of the script that creates a project repeatably | [BC-001] |
| User story US-001 | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-03-16 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Move the framework pin | In the `framework/` submodule check out the tag `v0.20.0`, commit the pointer, run `bash framework/scripts/install-skills.sh`, and read `AGENTS-template.new.md` that `framework/scripts/update-framework.sh` writes when `AGENTS.md` was edited: rules 8 and 9 of the template are taken into `AGENTS.md` only if S01 agrees. The workflow copies under `.gitea/workflows/` stay as they are, because `v0.20.0` changed only the deploy templates, which this project does not use. | No | |
| 2 | Bump the version to 0.5.1 | Set `VERSION` in `src/lib/constants.sh` to 0.5.1 and the `--version` check in `tests/test-security.sh` to match. Move the entries under `## [Unreleased]` in `CHANGELOG.md` to a dated `## [0.5.1]` entry (the Added group) and leave `## [Unreleased]` empty. The entry has an Added group (`--list-licenses`) and a Changed group (the framework pin moves to `v0.20.0`). | No | |
| 3 | Release v0.5.1 | After the pull request of tasks 1 and 2 is merged, run the Release workflow on `main` with version `0.5.1` and `dry_run` true, read its output, then run it again with `dry_run` false. Check that the tag, the release page and the moving tag `v0` are as in criteria 7 and 8. Starting the second run is S01's decision. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-028]: ./mil-028-release-0-5-0.md
[MIL-029]: ./mil-029-list-licenses.md
