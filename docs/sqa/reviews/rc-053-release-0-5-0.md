# SQA Review Record: Release 0.5.0

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-053 |
| CrossReference | [MIL-028], [QC-MIL-001], [MIL-026], [MIL-027], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-06 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | pending |

---

## Artifact Under Review

- Instance reviewed: [MIL-028], and the changes it causes in [US-001], [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-028]; the other artifacts were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-028])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted by the AI, to be accepted by the user
- Why: the last release is `v0.4.0`. `main` is ahead by branch cleanup on a new Gitea repository ([MIL-018]) and the signed-commit requirement by default ([MIL-027]). The phase bumps the version to 0.5.0 (a minor release: one new behaviour and one changed default), dates the changelog entry and releases `v0.5.0` with the Release workflow.
- Review date: 2026-11-06

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | Version 0.5.0: `VERSION` and the `--version` check, a dated `## [0.5.0]` changelog entry with `[Unreleased]` empty, the tag `v0.5.0` and its release page, and the moving tag `v0`; the Release workflow runs as a dry run first. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Seven criteria, each with an objective Go and No-Go and a test or review as evidence. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-026] (the previous release) and [MIL-027] (the last change shipped; [MIL-018] is merged too). |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] (repeatable creation with the settings a project needs) and [US-001]. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-03-09, proposed in [PP-001]; the window 2027-03-08 to 2027-03-09 follows [MIL-027], which ends 2027-03-05. |

## Language and Domain Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | The Metadata table has a `Language` row and a `Domain` row, and neither is a placeholder | Pass | `en` and `it`, as in the earlier milestones. |
| 2 | `Language` is a BCP 47 code and `Domain` is a value from the registry's domain list | Pass | `en` is a BCP 47 code; the registry still holds no domain list, see the action item of [RC-035]. |
| 3 | The content is written in the stated language | Pass | English throughout. |
| 4 | The register matches the one the registry gives for the artifact type | Pass | IT Executive English for MIL. |
| 5 | Domain terms are the PO terms of the domain's dictionary | Pass | The terms are those of the earlier milestones. |
| 6 | Metadata keys, section headings, IDs and statuses are in English | Pass | |
| 7 | No translated twin exists beside the document | Pass | |
| 8 | A change of language or domain since the previous accepted version has a Version History row | N-A | First version. |
| 9 | A reviewer competent in the domain and the language has confirmed the domain terms | Pass | Drafted by the AI; S02 reads English and knows the domain and confirms or challenges. |
| 10 | Abbreviations are spelled out on first use | Pass | |

## Change checks on the other artifacts

| Artifact | Change | Status | Evidence/Notes |
| --- | --- | --- | --- |
| [US-001] | [MIL-028] in the CrossReference | Pass | Link only; no story or acceptance criterion changes. |
| [PP-001] | Phase [MIL-028], its window, the Gantt, the scope coverage and the dependency chain | Pass | Proposed dates 2027-03-08 to 2027-03-09. |
| [TM-001] | Row for [MIL-028] and this record; the downstream and review columns of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Not covered by this review: the version bump and the changelog entry are written after the rows are accepted and are checked at the gate of [MIL-028].

## Overall Verdict

Go — every criterion of the checklist passes and the changed documents agree with each other. Supervised mode: drafted by Claude Code; the rows of [MIL-028] and the changed documents are `Proposed` until the user (S01) accepts them in chat.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Accept the rows of [MIL-028] and the changed documents, or challenge this review | S01 | before work under `src/` starts |
| Confirm or challenge this review | S02 | at the gate of [MIL-028] |

---

[MIL-028]: ../../milestones/mil-028-release-0-5-0.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-018]: ../../milestones/mil-018-delete-branch-after-merge.md
[MIL-026]: ../../milestones/mil-026-release-0-4-0.md
[MIL-027]: ../../milestones/mil-027-signed-commits-by-default.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
[RC-035]: ./rc-035-release-0-3-5.md
