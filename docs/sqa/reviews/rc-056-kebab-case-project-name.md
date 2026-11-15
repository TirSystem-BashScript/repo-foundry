# SQA Review Record: Kebab-case project names by default

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-056 |
| CrossReference | [MIL-031], [QC-MIL-001], [MIL-004], [MIL-029], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-14 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | pending |

---

## Artifact Under Review

- Instance reviewed: [MIL-031], and the changes it causes in [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-031]; [PP-001] and [TM-001] were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-031])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted and reviewed by the AI, so the review is not independent of the draft. S02 confirms or challenges it, and the user (S01) accepts the rows.
- Why: the framework's `create-project` skill (Intake, question 9) makes `kebab-case` the default name of a project, its folder and its git repository, with a deviation stated in the `config.env` of the creating tool. RepoFoundry accepts any valid repository name today. The phase adds the default and the key `PROJECT_NAME_STYLE`.
- Review date: 2026-11-14

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | The default rule in `create-project.sh`, the key `PROJECT_NAME_STYLE` (`kebab-case`, `any`) and its documentation; `--protect` and the other checks on existing repositories unchanged. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Ten criteria, each with an objective Go and No-Go and a test, a review or a run as evidence. Criterion 1 lists the names to test (`My_App`, `app_1`, `App`, `-app`, `app--x`, `app-`; `my-app`, `app2`). |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-004] (the pattern of an optional, validated key of `config.env`) and [MIL-029] (the latest change to the options). The framework rule is named as a dependency that is not a milestone; see finding F1. |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] (one repeatable, reviewed procedure for every new project) and [US-001]. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02; both exist in the Stakeholder Analysis. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-03-19, proposed in [PP-001]; the window 2027-03-17 to 2027-03-19 follows [MIL-030], which ends 2027-03-16. The Business Case sets no deadline. |

## Language and Domain Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | The Metadata table has a `Language` row and a `Domain` row, and neither is a placeholder | Pass | `en` and `it`. The scaffold wrote a placeholder for the domain because the registry has no `PO domain`; it was set to `it` by hand, as in the earlier milestones. |
| 2 | `Language` is a BCP 47 code and `Domain` is a value from the registry's domain list | Pass | `en` is a BCP 47 code; the registry still holds no domain list, see the action item of [RC-035]. |
| 3 | The content is written in the stated language | Pass | English throughout. |
| 4 | The register matches the one the registry gives for the artifact type | Pass | IT Executive English for MIL. |
| 5 | Domain terms are the PO terms of the domain's dictionary | Pass | The terms are those of the earlier milestones (repository, `config.env`, preset key). |
| 6 | Metadata keys, section headings, IDs and statuses are in English | Pass | |
| 7 | No translated twin exists beside the document | Pass | |
| 8 | A change of language or domain since the previous accepted version has a Version History row | N-A | First version. |
| 9 | A reviewer competent in the domain and the language has confirmed the domain terms | Pass | Drafted and checked by the AI; S02 reads English and knows the domain and confirms or challenges. |
| 10 | Abbreviations are spelled out on first use | Pass | |

## Change checks on the other artifacts

| Artifact | Change | Status | Evidence/Notes |
| --- | --- | --- | --- |
| [PP-001] | Phase [MIL-031], its window, the Gantt, the scope coverage, the dependency chain and the link | Pass | Proposed dates 2027-03-17 to 2027-03-19. The row of [MIL-030] was written by another change in the same working tree and is untouched. |
| [TM-001] | Row for [MIL-031] and this record; the downstream column of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Facts checked against the code while reviewing, so that the criteria can be met: `check_preset_choice` exists in `src/lib/config.sh` (criterion 4 of the milestone); the default local directory is `./<name>` in `src/lib/project.sh` (criterion 6); the name is asked in `collect_project_details` and validated again in `src/create-project.sh` (task 2 touches both); `--protect` uses `is_valid_repo_name` on the part after the slash (criterion 5).

Not covered by this review: the code, tests and documents of the tasks are written after the rows are accepted and are checked at the gate of [MIL-031] and in the code review against `qc-programming-shell`.

## Findings

| # | Finding | Severity | Status |
| --- | --- | --- | --- |
| F1 | The Purpose says the framework skill "now says so", but that change is in the working tree of `sqa-qc-framework` only: not committed, not released, and RepoFoundry's pin is not moved by the phase. The milestone is correct to name it as a dependency, but the sentence is true only for the Maintainer's machine. | Low | Open; the wording is fixed when the framework release is known |
| F2 | The default refuses names that were valid, so an existing `config.env` with a `PROJECT_NAME` that is not kebab-case stops the run. The milestone says so (task 5 and criterion 8) and the version number is left to a release phase. | Info | Covered |
| F3 | The key is `PROJECT_NAME_STYLE` (chosen by S01 from three options in chat on 2026-11-14), whereas the framework text names no key. The two agree only through the sentence "stated in the `config.env` of the tool". | Info | Covered |

## Overall Verdict

Go — every criterion of the checklist passes and the changed documents agree with each other. The review is not independent: the AI drafted the milestone and reviewed it. Supervised mode: the rows of [MIL-031] and the changed documents stay `Proposed` until the user (S01) accepts them in chat; nothing goes under `src/` or `tests/` before that.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Accept the rows of [MIL-031] and the changed documents, or challenge this review | S01 | before work under `src/` starts |
| Confirm or challenge this review | S02 | at the gate of [MIL-031] |
| Commit, merge and release the framework change (Intake question 9) and then reword the Purpose of [MIL-031] (F1) | S01 | before the gate of [MIL-031] |

---

[MIL-031]: ../../milestones/mil-031-kebab-case-project-name.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-004]: ../../milestones/mil-004-configurable-details.md
[MIL-029]: ../../milestones/mil-029-list-licenses.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
[RC-035]: ./rc-035-release-0-3-5.md
