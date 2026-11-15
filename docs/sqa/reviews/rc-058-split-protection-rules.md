# SQA Review Record: Split the protection rules and narrow the status checks

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-058 |
| CrossReference | [MIL-032], [QC-MIL-001], [MIL-021], [MIL-022], [MIL-031], [BC-001], [US-001], [PP-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-15 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | [df7c80c] |

---

## Artifact Under Review

- Instance reviewed: [MIL-032], and the changes it causes in [PP-001] and [TM-001].
- Checklist used: [QC-MIL-001]
- Scope: full review of [MIL-032]; [PP-001] and [TM-001] were changed, not created, and their change is checked below.
- Language and domain: en / it (the Metadata rows of [MIL-032])
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted and reviewed by the AI, so the review is not independent of the draft. S02 confirms or challenges it. The user (S01) accepted the milestone in chat on 2026-11-15, after the draft was revised to two rules.
- Why: one Gitea rule on `main` carried a status check pattern (`TirSystem/git-workflows: *`) that also matches checks that never run on a pull request, and Gitea applies one rule per branch. The phase splits the rule and narrows the checks. It changes the scope of [MIL-021] and [MIL-022], whose accepted records are not edited.
- Review date: 2026-11-15

## Checklist Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | A concrete deliverable is defined for every gate | Pass | Two rules (main: no direct push, protected files, signed commits; workflow: status checks and block-merge settings), the new key `PROTECTED_WORKFLOW_PATTERN`, the three default checks, and `--protect` turning on branch cleanup. |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Ten criteria, each with an objective Go and No-Go and a test, a review or a run on Gitea as evidence. Criterion 4 lists patterns to refuse. |
| 3 | Dependencies on other milestones are explicitly mapped | Pass | [MIL-021] (the rule and the key), [MIL-022] (`--protect`), [MIL-031] (the unreleased changelog). The workflow names of `TirSystem/git-workflows` are named as a dependency that is not a milestone. |
| 4 | Each milestone is traceable to a Business Case objective or KPI | Pass | [BC-001] (one repeatable, reviewed procedure for every new project) and [US-001]. |
| 5 | Milestone owner and approving reviewer are identified | Pass | Owner S01, approving reviewer S02; both exist in the Stakeholder Analysis. |
| 6 | Milestone has a defined target date consistent with project constraints | Pass | 2027-03-22 to 2027-03-23, proposed in [PP-001], after [MIL-031] ends on 2027-03-19. The Business Case sets no deadline. |

## Language and Domain Results

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | The Metadata table has a `Language` row and a `Domain` row, and neither is a placeholder | Pass | `en` and `it`. The scaffold wrote a placeholder for the domain because the registry has no `PO domain`; it was set to `it` by hand, as in the earlier milestones. |
| 2 | `Language` is a BCP 47 code and `Domain` is a value from the registry's domain list | Pass | `en` is a BCP 47 code; the registry still holds no domain list, see the action item of [RC-035]. |
| 3 | The content is written in the stated language | Pass | English throughout. |
| 4 | The register matches the one the registry gives for the artifact type | Pass | IT Executive English for MIL. |
| 5 | Domain terms are the PO terms of the domain's dictionary | Pass | Repository, `config.env`, branch protection rule, status check, as in [MIL-021]. |
| 6 | Metadata keys, section headings, IDs and statuses are in English | Pass | |
| 7 | No translated twin exists beside the document | Pass | |
| 8 | A change of language or domain since the previous accepted version has a Version History row | N-A | First version. |
| 9 | A reviewer competent in the domain and the language has confirmed the domain terms | Pass | Drafted and checked by the AI; S02 reads English and knows the domain and confirms or challenges. |
| 10 | Abbreviations are spelled out on first use | Pass | |

## Change checks on the other artifacts

| Artifact | Change | Status | Evidence/Notes |
| --- | --- | --- | --- |
| [PP-001] | Phase [MIL-032], its window, the Gantt, the scope coverage, the dependency chain and the link | Pass | `sync-project.sh` dry run lists the milestone and its six tasks. The plan row stays `Proposed` until the user accepts the plan change. |
| [TM-001] | Row for [MIL-032] and this record; the downstream column of [BC-001], [PP-001] and [US-001] | Pass | See the matrix. |

Facts checked while reviewing: the default of `PROTECTED_STATUS_CHECKS` is the three patterns (`src/lib/constants.sh`); the full run of `tests/run-tests.sh` ended with one failing check, a quoting mistake in a new test, which was fixed; the tests for criteria 1 to 6 exist in `tests/test-protection.sh`.

Not covered by this review: the code review against `qc-programming-shell`, criteria 7 (the Quality run on `main`) and 10 (a real repository), which are checked at the gate.

## Findings

| # | Finding | Severity | Status |
| --- | --- | --- | --- |
| F1 | Task 1 and criterion 7 name UC-001 and its diagrams. The step 7b text of UC-001 and the `ProtectionRule` rows of the two DCD documents were updated, but the sequence diagram of UC-001 and the class attributes of `ProtectionRule` still show one rule. | Low | Fixed on 2026-11-15: the sequence diagram has a loop over the two rules, `Configuration` has `protectedWorkflowPattern`, `ProtectionRule` has `kind`. The new rows of UC-001, SD-001, DCD-001 and DCD-002 are `Proposed` and not yet reviewed. |
| F2 | The two patterns are checked for overlap by a shell glob heuristic, because Gitea's matcher is not available here. A few pairs that cannot overlap are refused (for example because `*` is read as crossing a slash). This is the safe direction and is documented in the code. | Info | Covered |
| F3 | `main` no longer requires status checks or reviews, only `release/**` does. The user chose this in chat on 2026-11-15; it lowers the protection of `main` against a pull request that fails its checks. | Info | Accepted by S01 |
| F4 | The file name of [MIL-032] (`mil-032-narrow-status-checks.md`) predates its new title. | Info | Open; rename with the next change |

## Overall Verdict

Go — every criterion of the checklist passes and the changed documents agree with each other. The review is not independent: the AI drafted the milestone and reviewed it. Supervised mode: S01 accepted the milestone in chat, so its row is `Accepted`; [PP-001] and [TM-001] stay `Proposed` until S01 accepts them, and S02 confirms or challenges this review at the gate.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Review the changes of UC-001, SD-001, DCD-001 and DCD-002 (F1) against their checklists and accept their rows | S01 | before the gate of [MIL-032] |
| Confirm or challenge this review | S02 | at the gate of [MIL-032] |
| Run `--protect` on the real repositories and check a merge and a refused push (criterion 10) | S01 | at the gate of [MIL-032] |

---

[MIL-032]: ../../milestones/mil-032-narrow-status-checks.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[MIL-021]: ../../milestones/mil-021-protect-default-branch.md
[MIL-022]: ../../milestones/mil-022-protect-existing-repository.md
[MIL-031]: ../../milestones/mil-031-kebab-case-project-name.md
[BC-001]: ../../business-case.md
[US-001]: ../../user-stories.md
[PP-001]: ../../project-plan.md
[TM-001]: ../traceability-matrix.md
[RC-035]: ./rc-035-release-0-3-5.md
[df7c80c]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/df7c80c33815d9c4c900e6bedc21018e5155f850
