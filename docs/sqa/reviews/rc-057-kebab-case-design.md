# SQA Review Record: Kebab-case project names, use case and design documents

## Metadata
| Key | Value |
| --- | --- |
| ID | RC-057 |
| CrossReference | [MIL-031], [UC-001], [SD-001], [DCD-001], [DCD-002], [DICT-001], [QC-UC-001], [QC-SD-001], [QC-DCD-001], [QC-DICT-001] |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-15 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version: Go for UC-001 and SD-001, Go-with-conditions for DCD-001 and DCD-002<br>The condition (F1) is met: ProjectNameStyle is recorded in DICT-001, so the verdict for DCD-001 and DCD-002 is Go | pending |

---

## Artifact Under Review

- Instance reviewed: [UC-001], [SD-001], [DCD-001] and [DCD-002], as changed by task 4 of [MIL-031]. One record covers the four, as [RC-021] and [RC-032] did, because one change causes all four and they are checked against each other.
- Checklist used: [QC-UC-001] for [UC-001] (format Fully Dressed), [QC-SD-001] for [SD-001], [QC-DCD-001] for [DCD-001] and [DCD-002]. [DICT-001] was changed during the review to close F1 and is checked against [QC-DICT-001] below.
- Scope: delta re-review. The change is small and the four documents were accepted earlier ([RC-032] is the latest record that lists all four). Every criterion the change can touch is checked; a criterion the change does not touch is `N-A` with the reason, so the earlier verdict stands for it.
- Language and domain: n/a (technical types: the Metadata of the four documents has no `Language` or `Domain` row, and the registry marks use cases, sequence diagrams and class diagrams as IT Professional English)
- Language reviewer: none
- Mode: supervised; drafted and reviewed by the AI, so the review is not independent of the draft. S02 confirms or challenges it, and the user (S01) accepts the rows.
- Why: task 4 of [MIL-031] makes the project name kebab-case by default and adds the key `PROJECT_NAME_STYLE` (`kebab-case`, `any`). The use case, its sequence diagram, its class diagram and the project class diagram have to say the same as the code and the README.
- Review date: 2026-11-15

## Checklist Results

### [UC-001] against [QC-UC-001] (Fully Dressed)

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | Consists of a single, concise paragraph summarizing only the primary success scenario | N-A | Brief format only. |
| 2 | Written as an informal multi-paragraph narrative | N-A | Casual format only. |
| 3 | All standard sections are present | Pass | Actors, preconditions, postconditions, main success scenario and extensions are all there. The new extension 3c sits in the Extensions section, after 3b. |
| 4 | Preconditions and postconditions are explicitly defined | Pass | The precondition now says that `config.env` may set `PROJECT_NAME_STYLE`. The postconditions are unchanged; see F2. |
| 5 | Primary actor is explicitly stated | N-A | Not touched: the Maintainer. |
| 6 | Stakeholders and their interests are stated | N-A | Not touched. |
| 7 | Main success scenario is written as clear, numbered steps | Pass | Step 3 gains one sentence ("The repository name follows the project name style: kebab-case unless `config.env` says `any`"); the numbering is unchanged. |
| 8 | Alternative/exception flows reference `<<include>>`/`<<extend>>` use cases where relevant | N-A | No include or extend is involved. |
| 9 | Explicit business rules are captured per step | Pass | One new row for step 3 holds the rule: the pattern, 100 characters, what `any` allows, where the key may be set, and that `--protect` names are never checked. Checked against the code: `is_valid_kebab_name` (`^[a-z0-9]+(-[a-z0-9]+)*$`, 100) and `is_valid_repo_name` (letters, digits, `.`, `_`, `-`, 100, not ending in `.git`). |
| 10 | Naming of actors and use case title is consistent with the Use Case Diagram and User Stories | Pass | Title and actor are unchanged, so [UCD-001] and [US-001] still agree; see F5 for the acceptance criteria of [US-001]. |
| 11 | Scope/level is explicitly stated | N-A | Not touched. |
| 12 | Use case is written from the actor's goal perspective, free of UI or implementation detail | Pass | The rule is stated in words first; the pattern is its exact definition. Key names are already used in the use case (`PROTECTED_*`, `PROJECT_LICENSE`). See F3. |

Statements of the use case checked against the code and the tests: 3b (a `PROJECT_NAME` that is not kebab-case stops the run before any request and names `PROJECT_NAME_STYLE=any`; an empty or unknown style stops it too) is `check_project_name_preset` and `check_preset_choice` in `src/lib/config.sh`, with tests in `tests/test-presets.sh`. 3c (refused, the kebab-case form is proposed, asked again) is `prompt_value` with `suggest_project_name`; under `any` no form is proposed, and the extension says "for the style kebab-case". `--protect` keeps `is_valid_repo_name`.

### [SD-001] against [QC-SD-001]

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | Message passing strictly follows UML sync/async/return arrow syntax | N-A | No diagram changed. |
| 2 | GRASP/GoF patterns applied and annotated | N-A | Not touched. |
| 3 | Lifelines show activation bars matching the call nesting | N-A | No diagram changed. |
| 4 | Object creation and destruction shown with correct UML notation | N-A | No diagram changed. |
| 5 | Diagram realizes the postconditions of a specific Operation Contract | Pass | The name arrives in `provideProjectDetails` already checked, so P1 to P15 of [OC-001] are realized by the same messages. The Responsibility Check says so and names `projectNameStyle`. |
| 6 | Responsibility assignment favors low coupling and high cohesion | N-A | Not touched. |
| 7 | Loop, alt and opt fragments used correctly | N-A | No diagram changed. |
| 8 | Each exception of the Operation Contract is shown, or its absence is justified | Pass | [OC-001] has no exception for a refused name, as it has none for an invalid configured value (3b existed before this change). The new sentence in the Responsibility Check justifies that no message is added: a preset name is checked by `ConfigLoader`, a typed name before `provideProjectDetails`. |
| 9 | The Purpose names the concerns the diagram answers | N-A | Not touched; optional. |

### [DCD-001] and [DCD-002] against [QC-DCD-001]

The two documents received the same edit; the new lines of their diagrams, class tables and Version History rows are identical (checked by comparing the added lines).

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | SOLID principles applied; no god classes | Pass | `ConfigLoader` already validates every value of `config.env`; one more value is the same responsibility. The only new type is an enumeration. |
| 2 | Visibility markers correct and consistent | Pass | `-projectNameStyle` is private, like the other attributes of `Configuration`. |
| 3 | Relationships correctly distinguished | Pass | `Configuration "0..*" --> "1" ProjectNameStyle` is an association to an enumeration, drawn like `ProjectRequest --> Visibility`. |
| 4 | Multiplicities and navigability specified on all associations | Pass | Both ends have a multiplicity and the arrow gives the direction. |
| 5 | Applied design patterns are annotated | N-A | No pattern added. |
| 6 | Method signatures are traceable to Operation Contracts and Sequence Diagrams | Pass | No method is added or changed; the traceability rows of `ConfigLoader.load` still hold. |
| 7 | Class names and structure remain consistent with the Domain Model concepts they refine | Pass | `Configuration` still refines the concept of that name. `ProjectNameStyle` has no domain concept ("none (enumeration of a `Configuration` attribute)"), like `Visibility`. The dictionary did not record it when this review began (F1); it does now, see the change check of [DICT-001]. |
| 8 | No circular dependencies | Pass | The enumeration has no outgoing dependency; the Dependency Check text stays true. |
| 9 | Dependencies point inward | Pass | A value type; no domain class depends on an outer class because of it. |
| 10 | The Purpose names the concerns the diagram answers | N-A | Not touched; optional. |

### Change check on [DICT-001] against [QC-DICT-001]

Added during the review to close F1. The change is one sentence of the Rules section and a Version History row; no dictionary row is added or changed.

| # | Criterion | Status | Evidence/Notes |
| --- | --- | --- | --- |
| 1 | Every row has a PO term, its language, an IT term and a definition | N-A | No row changed. |
| 2 | Each PO term maps to exactly one IT term and the reverse | N-A | No row changed; `ProjectNameStyle` has no PO term, like `Visibility` and `InstallResult`. |
| 3 | Every Domain Model concept has a row | Pass | `ProjectNameStyle` is not a domain concept, so it needs no row; the Rules section says so. |
| 4 | The design artifacts use the IT term, not the PO term | Pass | [DCD-001] and [DCD-002] use `ProjectNameStyle` and `projectNameStyle`, which the Rules now record. |
| 5 to 8 | Definitions, artifact names, language and domain, order of rows | N-A | Not touched. |

Mechanical checks run for this review: every relative link of the four documents points at an existing file; no link is used without a definition except the one in F4; the definition of the commit link of each dropped Version History row is removed and no new unused one was left; the two-row rule holds in all four documents (the retained `Accepted` row and the new `Proposed` row); `projectNameStyle` and `ProjectNameStyle` are spelled the same in the use case, the sequence diagram note, both diagrams and both class tables; all four files are LF.

## Findings

| # | Finding | Severity | Status |
| --- | --- | --- | --- |
| F1 | The dictionary ([DICT-001], rules) names the IT-only types that no domain concept has, `InstallResult` and the enumeration `Visibility`. The new enumeration `ProjectNameStyle` is IT-only in the same way and was not recorded, so [DCD-001] and [DCD-002] used a term that the dictionary did not hold. | Low | Closed on 2026-11-15: the rule names `ProjectNameStyle` and cites [DCD-001] and [DCD-002]; [DICT-001] has a new `Proposed` row |
| F2 | The postconditions of [UC-001] do not say that the Gitea repository carries a name that follows the style. The rule is in step 3, extension 3c and the business rule, so criterion 4 passes; a postcondition would make it testable from the use case alone. | Info | Open, optional |
| F3 | The business rule of [UC-001] gives the pattern `^[a-z0-9]+(-[a-z0-9]+)*$`. It is the exact definition of a rule that is also stated in words, and the use case already names keys and a glob specification (rule 7b), so it is accepted. | Info | Covered |
| F4 | [SD-001] cites `[UC-001]` in its Note and does not define the link. This was already so before the change. The four documents also hold older commit-link definitions that no row uses; the Version History rule removes only the definition of a row that is dropped, so they were left. | Info | Open; fix when [SD-001] is next edited |
| F5 | [OC-001] and the acceptance criteria of [US-001] (US-001.01 lists "the repository name") do not mention the style. [MIL-031] task 4 does not include them and the rule is in the use case, so no criterion fails. | Info | Covered |
| F6 | The PlantUML diagrams of [DCD-001] and [DCD-002] were not rendered, because no PlantUML server is configured and the framework does not choose one, and sending a diagram to an outside server is the user's decision. The edit is an enumeration block, one attribute line and one association, written like the existing `Visibility` ones. No diagram of [SD-001] changed. | Info | Open; see the action items |

## Overall Verdict

- [UC-001]: Go. Every criterion that the change touches passes; F2 to F5 are not blocking.
- [SD-001]: Go. No diagram changed and the added text is correct.
- [DCD-001] and [DCD-002]: Go. Every criterion passes. The review began as Go-with-conditions because the term `ProjectNameStyle` was not in the dictionary (F1); the condition is met, see the change check of [DICT-001].
- [DICT-001]: Go for the one-sentence change; it is checked here only against the criteria that the change touches.

The review is not independent: the AI drafted the documents and reviewed them. Supervised mode: the user (S01, who also holds S02 for now) accepted the rows of the five documents in chat on 2026-11-15. Their rows are `Accepted` and the rows before them `Deprecated`. The diagram check (F6) stays open.

## Action Items

| Action | Owner | Due |
| --- | --- | --- |
| Done 2026-11-15: record `ProjectNameStyle` as an IT-only enumeration in the rules of [DICT-001] and give [DICT-001] its Version History row (F1, the condition) | S01 | done |
| Done 2026-11-15: accept the rows of [UC-001], [SD-001], [DCD-001], [DCD-002] and [DICT-001], or challenge this review | S01 | done |
| Confirm or challenge this review (the acceptance in chat of 2026-11-15 was given by the one person who holds S01 and S02) | S02 | done |
| Render the changed diagrams of [DCD-001] and [DCD-002] on a PlantUML server, or waive the check in chat as in [RC-032] (F6) | S02 | before the gate of [MIL-031] |
| Optional: add a postcondition for the name to [UC-001] (F2); define the `[UC-001]` link in [SD-001] (F4) | S01 | next edit of the document |

---

[MIL-031]: ../../milestones/mil-031-kebab-case-project-name.md
[UC-001]: ../../use-cases/uc-001/uc.md
[SD-001]: ../../use-cases/uc-001/sd.md
[DCD-001]: ../../use-cases/uc-001/dcd.md
[DCD-002]: ../../dcd.md
[OC-001]: ../../use-cases/uc-001/oc.md
[UCD-001]: ../../use-case-diagram.md
[US-001]: ../../user-stories.md
[DICT-001]: ../../dictionary.md
[QC-UC-001]: ../../../framework/qc/artifacts/qc-use-case.md
[QC-SD-001]: ../../../framework/qc/artifacts/qc-sequence-diagram.md
[QC-DCD-001]: ../../../framework/qc/artifacts/qc-dcd.md
[QC-DICT-001]: ../../../framework/qc/artifacts/qc-dictionary.md
[RC-021]: ./rc-021-dcd.md
[RC-032]: ./rc-032-exclude-framework-files.md
