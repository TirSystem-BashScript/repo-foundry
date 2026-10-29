# SQA Review Record: Protect the default branch

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-045 |
| CrossReference | [MIL-021], [QC-MIL-001], [MIL-018], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | pending |

---

## Artifact Under Review

- Instance reviewed: [MIL-021], and the changes it causes in [US-001], [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-021]; the other artifacts were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-021])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted by the AI, to be accepted by the user
- Why: new Gitea repositories have no branch protection; the phase adds a rule with no direct push to the default branch, a status check and file patterns, all glob patterns. It follows the release of 0.3.9 ([MIL-020]) and the setting of [MIL-018].
- Review date: 2026-10-29

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | A branch protection rule on a created Gitea repository: one request, three optional keys, `enable_push` false and not configurable, a warning when the request fails. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Twelve criteria, each with an objective Go and No-Go and a test or review as evidence. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-020], the release it follows, and [MIL-018], which changes the same step. |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] (repeatable creation with the settings a project needs) and [US-001]. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-02-09, proposed in [PP-001]; the window 2027-02-03 to 2027-02-09 follows [MIL-020], which ends 2027-02-02. |

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
| [US-001] | [MIL-021] in the CrossReference | Pass | Link only; no story or acceptance criterion changes. |
| [PP-001] | Phase [MIL-021], its window, the Gantt, the scope coverage and the dependency chain | Pass | Proposed dates 2027-02-03 to 2027-02-09. |
| [TM-001] | Row for [MIL-021] and this record; the downstream and review columns of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Not covered by this review: the code, tests and documents of the tasks are written after the rows are accepted and are checked at the gate of [MIL-021] and in the code review against `qc-programming-shell`.

## Overall Verdict

Go â€” every criterion of the checklist passes and the changed documents agree with each other. Supervised mode: drafted by Claude Code; the rows of [MIL-021] and the changed documents were `Proposed` until the user (S01) accepted them in chat, with the default status check pattern `TirSystem/git-workflows: *`, and are now `Accepted`.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Accept the rows of [MIL-021] and the changed documents, or challenge this review | S01 | before work under `src/` starts |
| Confirm or challenge this review | S02 | at the gate of [MIL-021] |

---

[MIL-021]: ../../milestones/mil-020-release-0-3-9.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-018]: ../../milestones/mil-018-delete-branch-after-merge.md
[MIL-020]: ../../milestones/mil-020-release-0-3-9.md
[MIL-017]: ../../milestones/mil-017-release-0-3-8.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
