# MIL-022 Apply the branch protection rule to an existing Gitea repository

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-022 |
| CrossReference | [BC-001], [US-001], [MIL-021] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [1d59d45] |

---

## Purpose

[MIL-021] gives a Gitea repository that `create-project.sh` creates a branch protection rule. The repositories that exist already, made by earlier versions of the script or by hand, have no rule, and the script does not change a repository it did not create. The Maintainer needs a command that brings an existing repository to the same rule, with the same three keys and the same defaults, without creating anything else.

## Deliverable

A mode of `create-project.sh`, `--protect OWNER/NAME`, that reads the Gitea repository `OWNER/NAME` and applies the rule of [MIL-021] to it. Like every run it is a dry run until `--apply` is given: the dry run reads the repository and the rules it has and prints what would be done, and creates nothing.

- The rule is made from `PROTECTED_BRANCH_PATTERN`, `PROTECTED_FILE_PATTERNS` and `PROTECTED_STATUS_CHECKS` of `config.env`, with `enable_push` false, exactly as for a new repository. One function builds the request for both paths.
- If the repository has no rule with that name, the rule is created (`POST /repos/{owner}/{repo}/branch_protections`).
- If it has one, the script shows the differences between the existing rule and the wanted one, and changes it (`PATCH /repos/{owner}/{repo}/branch_protections/{name}`) only after a yes, as nothing is overwritten without a yes. When the rule is already as wanted, nothing is sent and the run says so.
- Rules with other names are never changed or deleted.
- The mode needs the Gitea token only (`TOKEN_FOR_GITEA_REPO`). It asks for no GitHub credential and does not create a repository, a mirror, a directory or a submodule. A repository that does not exist, or that the token cannot administer, is reported with the cause and the exit status is not 0.
- The exit status is 0 when the rule is as wanted at the end (created, changed, or already so) and not 0 otherwise. Unlike the step of a new repository ([MIL-021]), a failed request here is an error, because it is the whole job of the run.

No new credential and no new host.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | `--protect OWNER/NAME` without `--apply` reads the repository and its rules, prints the plan, and sends no `POST`, `PATCH` or `DELETE` | Tests pass | A write request in a dry run |
| 2 | With `--apply` and no rule of that name, one `POST` is sent with the same body that a created repository gets from [MIL-021] | Tests pass | No request, or another body |
| 3 | With an existing rule that differs, the script prints the differing fields and sends one `PATCH` only after a yes; on a no, nothing is sent and the status is not 0 | Tests pass | A change without a yes |
| 4 | With an existing rule that is as wanted, no write request is sent and the run says so, status 0 | Tests pass | A request is sent |
| 5 | A rule with another name is never changed or deleted | Tests pass | Any request for another rule |
| 6 | `enable_push` is false in every body; no key can turn it on | Tests pass | Direct push allowed |
| 7 | A missing repository (404), a token without the right (403) and a refused body (422) each stop the run with a message that names the cause and status not 0; no token is printed | Tests pass | Status 0, or a token in the output |
| 8 | The mode makes no GitHub request and creates no repository, mirror, directory or submodule, and needs no `GITHUB_PAT` | Tests pass | Any of them |
| 9 | An argument that is not `OWNER/NAME` (no slash, empty part, characters outside the allowed set) is refused before any request | Tests pass | A request with a bad name |
| 10 | The README (usage and options), `--help`, the wiki page `GettingStarted` (three languages) and `CHANGELOG.md` (`## [Unreleased]`) describe the mode | Reviewed by S02 | Not documented |
| 11 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 12 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-021] | The rule, its keys and the function that builds the request are made there; this phase reuses them |

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

2027-02-16 — proposed; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Parse the mode | `--protect OWNER/NAME` in `src/lib/cli.sh` with the check of the name (criterion 9), the usage text and the help; the mode runs the Gitea checks of the credentials only. | No | US-001 |
| 2 | Read and compare the rule | Read the repository and `GET .../branch_protections`; build the wanted body with the function of [MIL-021]; compare field by field (criteria 4 and 5). | No | US-001 |
| 3 | Create or change the rule | The dry run plan, the `POST` or, after a yes, the `PATCH`, and the error messages and exit status (criteria 1 to 3, 6 to 8). | No | US-001 |
| 4 | Update the use case documents | A use case for the mode, or an extension of UC-001, with its sequence diagram and DCD, and `docs/dcd.md`. | Yes, an extension of UC-001 | US-001 |
| 5 | Document the mode | README, `GettingStarted` in three languages (translation headers updated) and `CHANGELOG.md`. | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-021]: ./mil-021-protect-default-branch.md
[1d59d45]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/1d59d4552c024a43b810a2d6a25e29d5c3a27a84
