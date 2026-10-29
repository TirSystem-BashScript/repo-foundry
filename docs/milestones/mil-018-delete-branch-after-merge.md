# MIL-018 Delete the branch after merge on a new Gitea repository

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-018 |
| CrossReference | [BC-001], [US-001], [MIL-017] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

Decide whether the Gitea repository that `create-project.sh` creates has the repository setting "Delete pull request branch after merge by default" turned on. Every pull request of a project leaves a merged branch behind unless it is deleted by hand, and the framework's workflow is one pull request per milestone. A new project should start with the setting on, as this repository has it, instead of the owner finding it in the settings after the first merge. Gitea's create request has no field for the setting; the edit request of the repository (`PATCH /repos/{owner}/{repo}`) has `default_delete_branch_after_merge`, which was checked on this repository (status 200).

## Deliverable

A change to `create-project.sh` so that, right after it creates the Gitea repository, it sends one edit request that sets `default_delete_branch_after_merge` to `true`, and reports the result in the plan and in the step output. The setting is not applied to a reused repository (the script does not change settings of a repository it did not create). The GitHub repository is not changed: it only receives the push mirror. If the edit request fails, the run does not stop; it warns, says that the owner can turn the setting on in the repository settings, and the repository is left as created. Tests with a stub `curl` cover the outcomes.

The script asks for no new credential: the token that creates the repository can edit it, as the owner of the repository has admin rights on it. No new host is called.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | After a created Gitea repository, the script sends one `PATCH` to `/repos/{owner}/{name}` with `{"default_delete_branch_after_merge":true}` and no other field | Tests pass | No request, a second request, or another field |
| 2 | The plan (`--dry-run` output) names the setting for a Gitea repository that will be created, and does not name it for a reused one | Tests pass | The plan is silent, or names it for a reused repository |
| 3 | With a stub that answers the edit request with 200, the step is reported as done and the run ends as before | Tests pass | The step is missing or the exit status changes |
| 4 | With a stub that answers the edit request with 403 or 404, the run warns, still creates the mirror and the local project, and ends with status 0 | Tests pass | The run stops or the mirror is not made |
| 5 | A reused Gitea repository receives no edit request | Tests pass | An edit request is sent |
| 6 | No GitHub request carries the setting | Tests pass | A GitHub request for it |
| 7 | The README and the wiki page `GettingStarted` (three languages) say that the setting is turned on for a new repository and how to turn it off | Reviewed by S02 | The behaviour is not documented |
| 8 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 9 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-017] | Release 0.3.8 is out before a change of behaviour is merged, so the change goes into the next version |

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

2027-01-26 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Set the setting when the Gitea repository is created | In `src/lib/repositories.sh` add a function that sends the edit request after a created Gitea repository and is called from `create_repository` (not when the repository is reused); on a failure it warns and goes on. Show the setting in `src/lib/plan.sh`. Add the stub tests of criteria 1 to 6 to `tests/`. | No | US-001.02 |
| 2 | Update the use case documents | Add the step to the operation contract, the sequence diagram and the design class diagram of UC-001 (`docs/use-cases/uc-001/`) and to `docs/dcd.md`, and review them. | No | |
| 3 | Document the setting | Describe it in the README and in `GettingStarted` (English, Danish, Bahasa Melayu), and add a line to `CHANGELOG.md` under `## [Unreleased]`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-017]: ./mil-017-release-0-3-8.md
