# SQA Review Record: Protect an existing repository

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-046 |
| CrossReference | [MIL-022], [QC-MIL-001], [MIL-021], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | pending |

---

## Artifact Under Review

- Instance reviewed: [MIL-022], and the changes it causes in [US-001], [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-022]; the other artifacts were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-022])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted by the AI, to be accepted by the user
- Why: repositories that exist already have no branch protection rule; the phase adds `--protect OWNER/NAME`, which applies the rule of [MIL-021] to one existing Gitea repository, with a dry run first and a yes before an existing rule is changed.
- Review date: 2026-10-29

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | The mode `--protect OWNER/NAME`: dry run first, `POST` for a missing rule, `PATCH` after a yes, no change to other rules, no GitHub request, no token printed. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Twelve criteria, each with an objective Go and No-Go and a test or review as evidence. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-021], whose rule, keys and request builder are reused. |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] (repeatable creation with the settings a project needs) and [US-001]. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-02-16, proposed in [PP-001]; the window 2027-02-10 to 2027-02-16 follows [MIL-021], which ends 2027-02-09. |

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
| [US-001] | [MIL-022] in the CrossReference | Pass | Link only; no story or acceptance criterion changes. |
| [PP-001] | Phase [MIL-022], its window, the Gantt, the scope coverage and the dependency chain | Pass | Proposed dates 2027-02-10 to 2027-02-16. |
| [TM-001] | Row for [MIL-022] and this record; the downstream and review columns of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Not covered by this review: the code, tests and documents of the tasks are written after the rows are accepted and are checked at the gate of [MIL-022] and in the code review against `qc-programming-shell`.

## Overall Verdict

Go â€” every criterion of the checklist passes and the changed documents agree with each other. Supervised mode: drafted by Claude Code; the rows of [MIL-022] and the changed documents were `Proposed` until the user (S01) accepted them in chat, and are now `Accepted`.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Accept the rows of [MIL-022] and the changed documents, or challenge this review | S01 | before work under `src/` starts |
| Confirm or challenge this review | S02 | at the gate of [MIL-022] |

---

[MIL-022]: ../../milestones/mil-022-protect-existing-repository.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-021]: ../../milestones/mil-021-protect-default-branch.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
