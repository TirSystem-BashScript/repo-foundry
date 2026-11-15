# MIL-031 Kebab-case project names by default

## Metadata
| Key | Value |
| --- | --- |
| ID | MIL-031 |
| CrossReference | [BC-001], [US-001], [MIL-004], [MIL-029] |
| Language | en |
| Domain | it |

## Version History
| Date | Status | Author | Reviewer | Change | Commit |
| --- | --- | --- | --- | --- | --- |
| 2026-11-14 | Accepted | Jens Tirsvad Nielsen | S02 | Initial version | [df7c80c] |

---

## Purpose

A project's name, its folder and its git repository carry one name, and by default that name is `kebab-case` (lowercase words joined by hyphens, for example `sqa-and-qc`). The framework's `create-project` skill now says so (Intake, question 9): a deviation is stated in the `config.env` of the tool that creates the project, and when the AI creates a project it asks first. RepoFoundry is that tool, and today it accepts any valid repository name (letters, digits, `.`, `_`, `-`) without a default or a proposal. This phase makes the kebab-case rule the behaviour of `create-project.sh`, and gives `config.env` the place where a project says that it wants another casing.

## Deliverable

`create-project.sh` requires a kebab-case repository name unless `config.env` says otherwise:

- A new optional key `PROJECT_NAME_STYLE` in `config.env`, with the values `kebab-case` (the default when the key is absent) and `any` (the repository-name rules of today: letters, digits, `.`, `_` and `-`, at most 100 characters, not ending in `.git`). It is validated like the other preset keys: a present key counts as set, an invalid value stops the run before any request and names the key. It is rejected in `.env`.
- With `kebab-case`, a kebab-case name is lowercase letters and digits in words joined by single hyphens, at most 100 characters: `^[a-z0-9]+(-[a-z0-9]+)*$`. A name that the Maintainer types is refused with the rule and the kebab-case form of what was typed (`My_App` gives `my-app`), and is asked again. A `PROJECT_NAME` set in `config.env` that is not kebab-case stops the run before any request, names `PROJECT_NAME`, and names `PROJECT_NAME_STYLE=any` as the way to keep it.
- With `any`, nothing changes from today.
- The name of an existing repository (`--protect OWNER/NAME`) is never checked against the rule.

`config.env.example` documents `PROJECT_NAME_STYLE`, still commented out. The README (the table of keys), `--help`, the wiki page `GettingStarted` (three languages), `CHANGELOG.md` and UC-001 (step 3 and the business rules) describe it. A release is a separate phase: a default that refuses names that were valid is a change of behaviour, and the Maintainer decides the version number there.

## Go / No-Go Criteria

| # | Criterion (objectively checkable) | Go | No-Go |
| --- | --- | --- | --- |
| 1 | With no `PROJECT_NAME_STYLE`, a typed name that is not kebab-case (`My_App`, `app_1`, `App`, `-app`, `app--x`, `app-`) is refused with the rule and the kebab-case suggestion, and asked again; a kebab-case name (`my-app`, `app2`) is accepted | Tests pass | A refused kebab-case name, or an accepted other name |
| 2 | A `PROJECT_NAME` in `config.env` that is not kebab-case stops the run before any request, names `PROJECT_NAME` and `PROJECT_NAME_STYLE=any`, and asks nothing instead | Tests pass | A request is sent, or the name is asked |
| 3 | With `PROJECT_NAME_STYLE=any` the name rules are those of today: a name that is valid but not kebab-case is accepted, an invalid name is refused as before | Tests pass | A changed result |
| 4 | `PROJECT_NAME_STYLE` accepts `kebab-case` and `any` in any letter case (stored in lower case); an empty or other value stops the run before any request and names the key; the key is rejected in `.env` | Tests pass | A wrong value is accepted |
| 5 | `--protect OWNER/NAME`, `--list-licenses` and the check of an existing repository do not apply the casing rule | Tests pass | A refused existing name |
| 6 | The default local directory still carries the project name, so folder and repository agree | Tests pass | A different name |
| 7 | `config.env.example` documents `PROJECT_NAME_STYLE` with both values and the default, still commented out | Reviewed by S02 | Undocumented, or switched on |
| 8 | The README, `--help`, `GettingStarted` (three languages, translation headers updated), `CHANGELOG.md` (`## [Unreleased]`, Changed group, saying the default refuses names that were valid) and UC-001 describe the rule | Reviewed by S02 | Not documented |
| 9 | The full run of `tests/run-tests.sh` reports 0 failed checks and 0 failed static checks | Tests pass | A failed check |
| 10 | The Quality run on the tip of `main` after the merge is green | Verified on Gitea | A red run |

## Dependencies

| Depends on | Reason |
| --- | --- |
| [MIL-004] | The new key follows its pattern: an optional key of `config.env`, validated before any request |
| [MIL-029] | The latest change to the options and the example file; this one goes into the version after it |
| framework `create-project` skill, Intake question 9 (unreleased in `sqa-qc-framework`) | The rule is defined there; this phase implements it. The framework pin is not moved by this phase |

## Traceability

| Business Case objective / KPI / user story | Reference |
| --- | --- |
| Repeatable creation with the settings a project needs | [BC-001] |
| User story US-001, a project is created with its repositories | [US-001] |

## Ownership

| Role | Stakeholder ID (SA) |
| --- | --- |
| Owner | S01 |
| Approving reviewer | S02 |

## Target Date

2027-03-17 to 2027-03-19 — proposed, after the release 0.5.1 phase ([MIL-030]); the Business Case sets no deadline.

## Tasks

| # | Task | Summary | Needs its own Use Case/User Story? | Reference |
| --- | --- | --- | --- | --- |
| 1 | Validators and the new key | `is_valid_kebab_name` in `src/lib/validate.sh`; `PROJECT_NAME_STYLE` read and checked in `src/lib/config.sh` with `check_preset_choice` and rejected in `.env`; the hint text and the kebab-case suggestion (criteria 3 and 4). | No | US-001 |
| 2 | Apply the rule to the name | The prompt and the preset check of `PROJECT_NAME` use the validator of the chosen casing; the refusal shows the suggestion; `--protect` and the existing-repository checks keep `is_valid_repo_name` (criteria 1, 2, 5 and 6). Tests in `tests/test-presets.sh` and `tests/test-prompts.sh`. | No | US-001 |
| 3 | Document the key in `config.env.example` | `PROJECT_NAME_STYLE` as a commented-out key with both values and the default (criterion 7). | No | |
| 4 | Update the use case documents | The business rule and step 3 of UC-001, its sequence diagram and DCD, and `docs/dcd.md` (criterion 8). | Yes, an extension of UC-001 | US-001 |
| 5 | Document the rule | README (the table of keys and the name rule), `--help`, `GettingStarted` in three languages (translation headers updated) and `CHANGELOG.md`, with a note for existing `config.env` files whose `PROJECT_NAME` is not kebab-case (criterion 8). | No | |

---

[BC-001]: ../business-case.md
[US-001]: ../user-stories.md
[MIL-004]: ./mil-004-configurable-details.md
[MIL-029]: ./mil-029-list-licenses.md
[MIL-030]: ./mil-030-release-0-5-1.md
[df7c80c]: https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/commit/df7c80c33815d9c4c900e6bedc21018e5155f850
