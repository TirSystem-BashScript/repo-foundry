# MIL-032 Split the protection rules and narrow the status checks

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-032 |
| CrossReference | [BC-001], [US-001], [MIL-021], [MIL-022], [MIL-031] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-15 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [df7c80c] |

---

## Purpose

A Gitea branch is governed by one protection rule only: the first rule whose pattern matches it. Today one rule on `main` carries everything ([MIL-021]), including the status check pattern `TirSystem/git-workflows: *`, which also matches checks that never run on a pull request, so a merge can wait for a check that never reports. This phase splits the protection by purpose and narrows the checks to the three that run on a pull request, so that `main` is protected against a direct commit and the workflow rule applies where the checks belong.

## Deliverable

`create-project.sh` (new repository) and `--protect OWNER/NAME` (existing repository) make two rules and one repository setting:

- **Rule 1, `PROTECTED_BRANCH_PATTERN` (default `main`):** no direct push; a change arrives by a pull request. It carries the protected file patterns and the signed-commits key as today and nothing else: no status check and no block-merge option.
- **Rule 2, the workflow rule, `PROTECTED_WORKFLOW_PATTERN` (new optional key, default `release/**`):** the status checks of `PROTECTED_STATUS_CHECKS`, whose default becomes the three patterns `TirSystem/git-workflows: Validate / *`, `TirSystem/git-workflows: Release / *` and `TirSystem/git-workflows: OpenGrep / *` (separated by semicolons), and the block-merge options (rejected reviews, official review requests, outdated branch, administrators). An empty `PROTECTED_WORKFLOW_PATTERN` creates no second rule.
- **Repository setting:** "Delete pull request branch after merge by default" is turned on by `--protect` for an existing repository, as a new repository already has it.

`--protect` shows both rules and the setting in its plan, and `--apply` creates or corrects them. An explicit value in `config.env` still wins. The two patterns must not match the same branch; a pattern pair that overlaps is refused before any request, because Gitea would enforce only one of the rules. The constants, `config.env.example`, the usage text, the README, `GettingStarted` (three languages), UC-001 and its diagrams, `CHANGELOG.md` and the tests describe it. A release is a separate phase.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | The body of rule 1 has `enable_push` false, no status check and no block-merge option, and the pattern of `PROTECTED_BRANCH_PATTERN` | Tests pass | Another body |
| 2 | With no `PROTECTED_STATUS_CHECKS`, the body of rule 2 has exactly the three patterns in the order Validate, Release, OpenGrep, the block-merge options, and the pattern of `PROTECTED_WORKFLOW_PATTERN` | Tests pass | Another list or options |
| 3 | An empty `PROTECTED_WORKFLOW_PATTERN` creates no rule 2; an empty `PROTECTED_STATUS_CHECKS` switches the status check of rule 2 off; an explicit value of either key wins | Tests pass | A changed result |
| 4 | Two patterns that match a common branch (for example `main` and `**`) stop the run before any request and name both keys | Tests pass | A request is sent |
| 5 | `--protect OWNER/NAME` plans and, with `--apply`, makes both rules and the repository setting when they are missing, corrects a rule that differs, including one that carries the old default `TirSystem/git-workflows: *`, and plans no change when all match | Tests pass | A missed or repeated change |
| 6 | The plan of a new repository and of `--protect` names both rules and the repository setting | Tests pass | A missing line |
| 7 | `config.env.example`, the usage text, the README, `GettingStarted` (three languages), UC-001 and `CHANGELOG.md` (`## [Unreleased]`, Changed group) name the two rules, the new key and the new default, and no document gives the old default except the accepted records of [MIL-021] | Reviewed by S02 | An outdated document |
| 8 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 9 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |
| 10 | `--protect OWNER/NAME --apply` on one existing repository leaves rule 1 on `main`, rule 2 on `release/**` and the delete-branch setting on, and a push to `main` is refused | Verified on Gitea by S01 | Another result |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-021] | Defines the rule and the key `PROTECTED_STATUS_CHECKS` whose default changes |
| [MIL-022] | `--protect` is the way an existing repository receives the new default |
| [MIL-031] | The latest change of the options and the changelog; this one goes into the same unreleased version |
| `TirSystem/git-workflows` | The workflow names `Validate`, `Release` and `OpenGrep` are those of its shared workflows; a rename there needs this default to follow |

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

2027-03-22 to 2027-03-23 — proposed, after the kebab-case phase ([MIL-031]); the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Split the rule in two | `src/lib/protection.sh` builds the body of rule 1 (no direct push, signed commits only) and of rule 2 (status checks and block-merge options) and creates or corrects each by its pattern; `PROTECTED_WORKFLOW_PATTERN` is a new optional key in `src/lib/config.sh` and `constants.sh`, and overlapping patterns are refused (criteria 1 to 4). | Yes, an extension of UC-001 | US-001 |
| 2 | Change the default status checks | `DEFAULT_PROTECTED_STATUS_CHECKS` becomes the three patterns separated by `;` without spaces, so that the rule of Gitea and the wanted rule compare equal (criteria 2 and 3). | No | US-001 |
| 3 | Set the repository setting in `--protect` | `--protect` reads "Delete pull request branch after merge by default" and turns it on when it is off, in the plan and with `--apply` (criteria 5 and 6). | No | US-001 |
| 4 | Update the tests | `tests/test-protection.sh` covers both bodies, the empty and overlapping patterns, the correction of a rule with the old default, and the setting (criteria 1 to 6 and 8). | No | |
| 5 | Update the documents | `config.env.example`, the usage text, the README, `GettingStarted` in three languages, UC-001 with its sequence diagram and DCD, `docs/dcd.md` and `CHANGELOG.md`, with a note that `--protect --apply` corrects an existing rule (criterion 7). | No | |
| 6 | Correct the repositories of the organisation | Run `--protect` on the repositories that carry the old rule and check that a pull request merges and a push to `main` is refused (criterion 10). | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-021]: ./mil-021-protect-default-branch.md
[MIL-022]: ./mil-022-protect-existing-repository.md
[MIL-031]: ./mil-031-kebab-case-project-name.md
[df7c80c]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/df7c80c33815d9c4c900e6bedc21018e5155f850
