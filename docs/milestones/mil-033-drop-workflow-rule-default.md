# Drop the default workflow rule

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-033 |
| CrossReference | [BC-001], [US-001], [MIL-021], [MIL-032] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-15 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | pending |

---

## Purpose

[MIL-032] made a second protection rule, on `release/**` by default, to carry the status checks and the block-merge settings. The owner does not want that rule created by default: `main` has its own rule, and a rule for a branch that most repositories do not have is noise. This phase removes the default of the workflow rule, so that `--protect` and new-repository creation make only the rule of `main` unless a project asks for a second one.

## Deliverable

`PROTECTED_WORKFLOW_PATTERN` has no default: absent from `config.env`, it means no workflow rule. An explicit value still makes the second rule, with the status checks of `PROTECTED_STATUS_CHECKS` and the block-merge settings, and the overlap check still applies. The rule of `PROTECTED_BRANCH_PATTERN` (default `main`) is unchanged: no direct push, the four block-merge settings, the protected files and signed commits, and no status check. The status checks therefore apply only where a project sets a workflow pattern. `--protect` does not delete an existing `release/**` rule; it only plans nothing for it. The constants, `config.env.example`, the usage text, the README, `GettingStarted` (three languages), UC-001 and its diagrams, `CHANGELOG.md` and the tests describe it. A release is a separate phase.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | With no `PROTECTED_WORKFLOW_PATTERN`, a new repository and `--protect` make one rule (`main`) and send no status check | Tests pass | A second rule or a status check |
| 2 | With `PROTECTED_WORKFLOW_PATTERN=release/**` the body of the second rule is as before ([MIL-032] criterion 2) | Tests pass | Another body |
| 3 | The plan of a new repository and of `--protect` names one rule when no workflow pattern is set and two when it is | Tests pass | A wrong line count |
| 4 | An existing rule on another pattern is left unchanged and not deleted | Tests pass | A request on it |
| 5 | `config.env.example`, the usage text, the README, `GettingStarted` (three languages), UC-001, the diagrams and `CHANGELOG.md` (`## [Unreleased]`, Changed group) state that the workflow rule is opt-in | Reviewed by S02 | An outdated document |
| 6 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-032] | Defines the workflow rule and its key, whose default is removed |
| [MIL-021] | Defines the rule of the protected branch |

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

2027-03-24 — proposed, after [MIL-032]; the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Remove the default | `DEFAULT_PROTECTED_WORKFLOW_PATTERN` becomes empty and `validate_protection_settings` keeps an absent key as empty (criteria 1 to 4). | No | US-001 |
| 2 | Update the tests | `tests/test-protection.sh` covers one rule by default, the explicit pattern and the existing rule left alone (criteria 1 to 4 and 6). | No | |
| 3 | Update the documents | `config.env.example`, the usage text, the README, `GettingStarted` in three languages, UC-001 with its diagrams and `CHANGELOG.md` (criterion 5). | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-021]: ./mil-021-protect-default-branch.md
[MIL-032]: ./mil-032-narrow-status-checks.md
