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

## Branch cleanup

A new Gitea repository has the setting "Delete pull request branch after merge by default" turned on, so a merged pull request branch is deleted by Gitea. A reused repository is not changed. To turn it off, open the repository settings in Gitea, under Pull Requests.

## Branch protection

A new Gitea repository gets two branch protection rules. The main rule forbids a direct push to `main`: every change arrives by a pull request. Both rules block a merge on rejected reviews, on official review requests, when the pull request is outdated, and for administrators; no key turns these off. The workflow rule, on `release/**`, also requires the status checks. Gitea applies one rule per branch, so the two patterns must not match a common branch. The first commit of the new project goes the same way: push a branch and open a pull request.

The rule is set with five optional keys in `config.env` (glob patterns, lists separated by `;`): `PROTECTED_BRANCH_PATTERN` (default `main`), `PROTECTED_WORKFLOW_PATTERN` (default `release/**`, empty for no workflow rule), `PROTECTED_FILE_PATTERNS` (default none), `PROTECTED_STATUS_CHECKS` (default `TirSystem/git-workflows: Validate / *;TirSystem/git-workflows: Release / *;TirSystem/git-workflows: OpenGrep / *`) and `PROTECTED_REQUIRE_SIGNED_COMMITS` (`true` or `false`, default `true`; `false` if you cannot sign; see [Signing commits](SshSigning)). See the [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-branch-protection-optional).

To give an existing repository the same rule:

```bash
src/create-project.sh --protect OWNER/NAME           # dry run: reads, changes nothing
src/create-project.sh --protect OWNER/NAME --apply   # creates or changes the rule
```

An existing rule that differs is changed only after a yes.

## Project name

The name of a project is also the name of its Gitea and GitHub repository and, by default, of its folder. It is `kebab-case` unless you say otherwise: lowercase letters and digits in words joined by single hyphens, such as `my-app`. A name such as `My_App` is refused, the kebab-case form (`my-app`) is proposed, and you are asked again.

To keep another casing, set `PROJECT_NAME_STYLE=any` in `config.env` (optional; `kebab-case` is the default). The repository-name rules of the hosts then apply: letters, digits, `.`, `_` and `-`. A `PROJECT_NAME` in `config.env` that is not kebab-case stops the run unless the style is `any`. The name of an existing repository (`--protect OWNER/NAME`) is never checked. See the [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-project-details-optional).

## License

The license of a new project is `PROJECT_LICENSE` in `config.env` (optional): a Gitea license key such as `AGPL-3.0` or `MIT`, or `none` for no license. To see the keys your Gitea server offers:

```bash
src/create-project.sh --list-licenses     # one license key per line; reads only
```

The Maintainer's server offers 30 keys; they are listed as a comment in `config.env.example`.

## Run it as a command

To start the script with `repo-foundry` from any folder, link it into a folder on your `PATH`. Run this once, from the root of your checkout:

```bash
mkdir -p ~/bin
ln -s "$PWD/src/create-project.sh" ~/bin/repo-foundry
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
```

Open a new terminal (or run `source ~/.bashrc`) and start it with `repo-foundry`. The script follows the link back to the checkout, so it finds its own files, and an update with `git pull` in the checkout reaches the command at once. On macOS, use `~/.zshrc` instead of `~/.bashrc` if your shell is zsh.

On Windows, use WSL: open a WSL terminal (for example Ubuntu), clone Repo Foundry inside it, and run the commands above there.
