# SQA Review Record: Release 0.3.9

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-044 |
| CrossReference | [MIL-020], [QC-MIL-001], [MIL-019], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-10-29 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | [b220a3e] |

---

## Artifact Under Review

- Instance reviewed: [MIL-020], and the changes it causes in [US-001], [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-020]; the other artifacts were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-020])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted by the AI, to be accepted by the user
- Why: the last release is `v0.3.8` (not yet tagged when this was drafted). `main` is ahead by the Gitea token names ([MIL-019]) and the framework pin `v0.19.0`. The phase bumps the version to 0.3.9 and releases `v0.3.9` with the Release workflow, whose real run stays S01's decision.
- Review date: 2026-10-29

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | Version 0.3.9: `VERSION` and the `--version` check, a dated `## [0.3.9]` changelog entry with `[Unreleased]` empty, the tag `v0.3.9` and its release page, and the moving tag `v0`. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Seven criteria, each with an objective Go and No-Go, as in the release of 0.3.8; one makes the tag `v0.3.8` a precondition. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-017], the release before it, and [MIL-019], the change it ships. |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] as the script's release, and [US-001]. No objective is added or changed. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-02-02, proposed in [PP-001]; the window 2027-02-01 to 2027-02-02 follows [MIL-019], which ends 2027-01-29. The Business Case sets no deadline. |

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
| [US-001] | [MIL-020] in the CrossReference | Pass | Link only; no story or acceptance criterion changes. |
| [PP-001] | Phase [MIL-020], its window, the Gantt, the scope coverage and the dependency chain | Pass | Proposed dates 2027-02-01 to 2027-02-02. |
| [TM-001] | Row for [MIL-020] and this record; the downstream and review columns of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Not covered by this review: the code, tests and documents of the tasks are written after the rows are accepted and are checked at the gate of [MIL-020] and in the code review against `qc-programming-shell`.

## Overall Verdict

Go â€” every criterion of the checklist passes and the changed documents agree with each other. Supervised mode: drafted by Claude Code; the rows of [MIL-020] and the changed documents were `Proposed` until the user (S01) accepted them in chat, and are now `Accepted`.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Accept the rows of [MIL-020] and the changed documents, or challenge this review | S01 | before work under `src/` starts |
| Confirm or challenge this review | S02 | at the gate of [MIL-020] |

---

[MIL-020]: ../../milestones/mil-020-release-0-3-9.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-019]: ../../milestones/mil-019-gitea-token-names.md
[MIL-017]: ../../milestones/mil-017-release-0-3-8.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
[b220a3e]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/b220a3e7b7672f1437e9dece247d6d86d5d29c2c
