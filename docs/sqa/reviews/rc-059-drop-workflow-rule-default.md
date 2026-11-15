# Drop the default workflow rule

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-059 |
| CrossReference | [MIL-033], [QC-MIL-001], [MIL-032], [MIL-021], [BC-001], [US-001], [PP-001], [TM-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-15 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | [9b53535] |

---

## Artifact Under Review

- Instance reviewed: [MIL-033], and the changes it causes in [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-033]; [PP-001] and [TM-001] were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-033])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted and reviewed by the AI, so the review is not independent of the draft. S02 confirms or challenges it. The user (S01) accepted the milestone in chat on 2026-11-15.
- Why: the owner does not want the second protection rule of [MIL-032] on `release/**` created by default. The phase makes it opt-in. It changes a default of [MIL-032], whose accepted record is not edited.
- Review date: 2026-11-15

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | `PROTECTED_WORKFLOW_PATTERN` without a default; one rule by default, two when a pattern is set; the plan, documents and tests describe it. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Six criteria, each with an objective Go and No-Go and a test or a review as evidence. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-032] (the rule and its key) and [MIL-021] (the rule of the protected branch). |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] and [US-001]. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-03-24, after [MIL-032] ends on 2027-03-23. The Business Case sets no deadline. |

## Language and Domain Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | The Metadata table has a `Language` row and a `Domain` row, and neither is a placeholder | Pass | `en` and `it`; the domain was set by hand, as in the earlier milestones. |
| 2 | `Language` is a BCP 47 code and `Domain` is a value from the registry's domain list | Pass | See the action item of [RC-035]. |
| 3 | The content is written in the stated language | Pass | English throughout. |
| 4 | The register matches the one the registry gives for the artifact type | Pass | IT Executive English for MIL. |
| 5 | Domain terms are the PO terms of the domain's dictionary | Pass | Repository, `config.env`, branch protection rule, status check. |
| 6 | Metadata keys, section headings, IDs and statuses are in English | Pass | |
| 7 | No translated twin exists beside the document | Pass | |
| 8 | A change of language or domain since the previous accepted version has a Version History row | N-A | First version. |
| 9 | A reviewer competent in the domain and the language has confirmed the domain terms | Pass | Drafted and checked by the AI; S02 confirms or challenges. |
| 10 | Abbreviations are spelled out on first use | Pass | |

## Change checks on the other artifacts

| Artifact | Change | Status | Evidence/Notes |
| --- | --- | --- | --- |
| [PP-001] | Phase [MIL-033], its window, the Gantt, the scope coverage, the dependency chain and the link | Pass | `sync-project.sh` dry run lists the milestone and its three tasks. The plan row stays `Proposed` until the user accepts the plan change. |
| [TM-001] | Row for [MIL-033] and this record; the downstream column of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Not covered by this review: the code review against `qc-programming-shell`, which is done before the pull request.

## Findings

| # | Finding | Severity | Status |
| --- | --- | --- | --- |
| F1 | With no default workflow pattern the status checks apply nowhere unless a project sets a pattern: neither `main` nor any other branch requires them. The owner chose this in chat. | Info | Accepted by S01 |
| F2 | An existing `release/**` rule on a repository is not deleted by `--protect`; it is removed in Gitea by hand. | Info | Open |

## Overall Verdict

Go — every criterion of the checklist passes. The review is not independent: the AI drafted the milestone and reviewed it. Supervised mode: S01 accepted the milestone in chat, so its row is `Accepted`; [PP-001] and [TM-001] stay `Proposed`, and S02 confirms or challenges this review at the gate.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Confirm or challenge this review | S02 | at the gate of [MIL-033] |
| Remove the `release/**` rule from the repositories that have it | S01 | at the gate of [MIL-033] |

---

## Artifact Under Review

- Instance reviewed: [<INSTANCE-ID>]
- Checklist used: [<QC-ID>] (`QC-<short-name>-<version>`, e.g. `QC-BC-001`)
- Scope: <full review | delta re-review of criteria <numbers>, reason, earlier record [<RC-ID>]>
- Language and domain: <Language> / <Domain> (the artifact's Metadata rows), or `n/a` for a technical type
- Language reviewer: <stakeholder ID>, or `none` when the reviewer reads the language and knows the domain
- Mode: <supervised | autonomous, not independent> (autonomous: the reviewer is `AI as stand-in for <stakeholder ID>`)

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | <criterion copied from the QC checklist> | Pass/Fail/N-A/Pending | |

## Language and Domain Results

Only for an artifact of a type written in the PO language: the rows of
`QC-LANG-001`, in order. Delete this section for a technical type.

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | <criterion copied from QC-LANG-001> | Pass/Fail/N-A/Pending | |

## Risk Exceptions

Only when a blocking finding is accepted for a time; delete this section when
there is none. Every cell is filled (`process/review-checklist-process.md`).

| Finding | Owner | Approver | Expiry | Compensating controls |
| --- | --- | --- | --- | --- |
| <criterion or security finding, with its rating> | <stakeholder ID> | <stakeholder ID of the escalation role> | <YYYY-MM-DD> | <what reduces the risk, and how it is checked> |

## Overall Verdict

<Go / Go-with-conditions / No-Go> — <rationale; a blocking finding gives No-Go unless a risk exception covers it; a Pending criterion allows Go-with-conditions at most>

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| <action> | <stakeholder ID, e.g. S07> | <date> |

---

[MIL-033]: ../../milestones/mil-033-drop-workflow-rule-default.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-032]: ../../milestones/mil-032-narrow-status-checks.md
[MIL-021]: ../../milestones/mil-021-protect-default-branch.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
[9b53535]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/9b5353592fd518472b96b50817d3b7c390daefc4
