# SQA Review Record: Delete Branch After Merge

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-042 |
| CrossReference | [MIL-018], [QC-MIL-001], [MIL-017], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | [4ecfb14] |

---

## Artifact Under Review

- Instance reviewed: [MIL-018], and the changes it causes in [US-001], [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-018]; the other artifacts were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-018])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted by the AI and accepted by the user on 2026-10-29
- Why: a new Gitea repository from `create-project.sh` does not have "Delete pull request branch after merge by default" on, and the owner turns it on by hand after the first merge. The phase makes the script set it.
- Review date: 2026-10-29

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | A change to `create-project.sh` that sends one edit request after a created Gitea repository; reused repositories and GitHub are named as out of scope. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Nine criteria, each with an objective Go and No-Go; criteria 1 to 6 are stub-`curl` tests. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-017]: the change of behaviour goes into the version after the release. |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001], repeatable creation with the settings a project needs, and [US-001].02. No objective is added or changed. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-01-26, proposed in [PP-001]; the window 2027-01-22 to 2027-01-26 follows [MIL-017], which ends 2027-01-21. The Business Case sets no deadline. |

## Language and Domain Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | The Metadata table has a `Language` row and a `Domain` row, and neither is a placeholder | Pass | `en` and `it`, as in the earlier release milestones. |
| 2 | `Language` is a BCP 47 code and `Domain` is a value from the registry's domain list | Pass | `en` is a BCP 47 code; the registry still holds no domain list, see the action item of [RC-035]. |
| 3 | The content is written in the stated language | Pass | English throughout. |
| 4 | The register matches the one the registry gives for the artifact type | Pass | IT Executive English for MIL. |
| 5 | Domain terms are the PO terms of the domain's dictionary | Pass | The terms are those of the earlier release milestones. |
| 6 | Metadata keys, section headings, IDs and statuses are in English | Pass | |
| 7 | No translated twin exists beside the document | Pass | |
| 8 | A change of language or domain since the previous accepted version has a Version History row | N-A | First version. |
| 9 | A reviewer competent in the domain and the language has confirmed the domain terms | Pass | Drafted by the AI; S02 reads English and knows the domain and confirms or challenges. |
| 10 | Abbreviations are spelled out on first use | Pass | |

## Change checks on the other artifacts

| Artifact | Change | Status | Evidence/Notes |
| --- | --- | --- | --- |
| [US-001] | [MIL-018] in the CrossReference | Pass | Link only; no story or acceptance criterion changes. |
| [PP-001] | Phase [MIL-018], its window, the Gantt, the scope coverage and the dependency chain | Pass | Proposed dates 2027-01-22 to 2027-01-26. |
| [TM-001] | Row for [MIL-018] and this record; the downstream and review columns of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Not covered by this review: the code, tests and documents of the tasks are written after the rows are accepted and are checked at the gate of [MIL-018] and in the code review against `qc-programming-shell`.

## Overall Verdict

Go — every criterion of the checklist passes and the changed documents agree with each other. Supervised mode: drafted by Claude Code and accepted by the user (S01) on 2026-10-29, who set the rows of [MIL-018] and the changed documents to `Accepted`.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Accept the rows of [MIL-018] and the changed documents, or challenge this review | S01 | before work under `src/` starts |
| Confirm or challenge this review | S02 | at the gate of [MIL-018] |

---

[MIL-018]: ../../milestones/mil-018-delete-branch-after-merge.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-017]: ../../milestones/mil-017-release-0-3-8.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
[4ecfb14]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/4ecfb143a9f06c007f61da7f8e98dc331b727442
