English | [Dansk](GettingStarted.da) | [Bahasa Melayu](GettingStarted.ms)

# Getting started

## Requirements

| Tool | Needed for |
| --- | --- |
| bash 4.4 or later | the script (macOS ships 3.2: install a newer bash first) |
| `git` | the local project and the framework submodule |
| `curl` | the GitHub and Gitea APIs |
| `ssh` (optional) | the SSH check; without it the framework steps are skipped |
| `jq` (optional) | JSON parsing; without it a small built-in reader is used |

## Install

```bash
git clone https://git.tirsystem.com/TirSystem-BashScript/repo-foundry.git
cd repo-foundry
src/create-project.sh --help
```

Nothing is installed system-wide: the script runs from the checkout.

## Configure

Copy `config.env.example` to `config.env` and `.env.example` to `.env`, then set the service addresses and the tokens (see [SSH and tokens](SshAndTokens)). `.env` holds credentials and is never committed.

## Run

Start the script from the folder that should hold the new project:

```bash
src/create-project.sh            # dry run: reads from the hosts, creates nothing
src/create-project.sh --apply    # creates everything after a final yes
```

No commit is made in the new project. Work on a branch there: the framework's hooks refuse commits on `main`.

## Branch protection

A new Gitea repository gets a branch protection rule: no direct push to `main`, every change arrives by a pull request. The first commit of the new project goes the same way: push a branch and open a pull request.

The rule is set with three optional keys in `config.env` (glob patterns, lists separated by `;`): `PROTECTED_BRANCH_PATTERN` (default `main`), `PROTECTED_FILE_PATTERNS` (default none) and `PROTECTED_STATUS_CHECKS` (default `TirSystem/git-workflows: *`). See the [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-branch-protection-optional).

To give an existing repository the same rule:

```bash
src/create-project.sh --protect OWNER/NAME           # dry run: reads, changes nothing
src/create-project.sh --protect OWNER/NAME --apply   # creates or changes the rule
```

An existing rule that differs is changed only after a yes.
