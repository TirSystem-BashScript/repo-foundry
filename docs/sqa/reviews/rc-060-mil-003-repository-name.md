# Lowercase framework repository name in MIL-003

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-060 |
| CrossReference | [MIL-003], [QC-MIL-001], [RC-015], [RC-017] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go | pending |

---

## Artifact Under Review

- Instance reviewed: [MIL-003], and the change it causes in [RC-017].
- Checklist used: [QC-MIL-001]
- Scope: delta re-review of criterion 2, because the change touches only the framework repository name in criterion 2 and task 2. The other criteria are unchanged since [RC-015]; their results hold.
- Language and domain: none stated; the Metadata of [MIL-003] has no `Language` and `Domain` rows (see F1)
- Language reviewer: none; the reviewer reads the language and knows the domain
- Mode: supervised; drafted and reviewed by the AI, so the review is not independent of the draft. S02 confirms or challenges it.
- Why: the Gitea repositories are named `sqa-qc-framework` and `sqa-qc-checklists`. The milestone named the framework as `SQA-QC-Framework`. The change brings the name in line with `DEFAULT_FRAMEWORK_REPO`, the README and the tests.
- Review date: 2026-11-20

## Checklist Results (delta: criterion 2)

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 2 | Explicit Go/No-Go criteria are stated for each gate | Pass | Criterion 2 names `ssh://git@git.tirsystem.com:10022/TirSystem/sqa-qc-framework.git`, which is the address in `.gitmodules` and the default of `FRAMEWORK_REPO`; Go and No-Go stay objective. The test suite (1648 checks) passes with the new name. Task 2 repeats the same address. |

## Change checks on the other artifacts

| Artifact | Change | Status | Evidence/Notes |
| --- | --- | --- | --- |
| [RC-017] | The framework address in the Run B evidence and in its criterion 2 uses the lowercase name | Pass | Text only; no result changes. Its row stays `Proposed`: the record keeps its own status. |
| [TM-001] | Row of [MIL-003] lists this record | Pass | See the matrix. |

Not covered by this review: the criteria 1 and 3 to 6 of [QC-MIL-001], which are unchanged since [RC-015] and [RC-031].

## Findings

| # | Finding | Severity | Status |
| --- | --- | --- | --- |
| F1 | The Metadata of [MIL-003] has no `Language` and `Domain` rows, as the older milestones; `check-languages.sh --list` shows none for MIL-001 to MIL-009. | Info | Open |

## Overall Verdict

Go: criterion 2 passes and nothing else changed. The review is not independent: the AI drafted the change and reviewed it. Supervised mode: S02 confirms or challenges this review.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Confirm or challenge this review | S02 | at the next pull request review |
| Decide whether the older milestones get `Language` and `Domain` rows | S01 | when MIL-003 is next edited |

---

[MIL-003]: ../../milestones/mil-003-scaffold-and-release.md
[QC-MIL-001]: ../../../framework/qc/artifacts/qc-milestones-gateways.md
[RC-015]: ./rc-015-mil-003.md
[RC-017]: ./rc-017-e2e-security-review.md
[RC-031]: ./rc-031-gitea-only-remote.md
[TM-001]: ../traceability-matrix.md
