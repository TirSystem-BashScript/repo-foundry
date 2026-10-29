English | [Dansk](Home.da) | [Bahasa Melayu](Home.ms)

# Repo Foundry

Repo Foundry (`src/create-project.sh`) is a Bash script that sets up a new project in one run, the same way every time.

## Why it exists

Setting up a project by hand means many small steps on two hosts and on your own machine: create the repository, choose its visibility and owner, add a license, create a second repository and a mirror, clone, add the framework, install its skills and hooks, and keep secrets out of the remotes. Done by hand, no two projects end up quite alike, and a forgotten step is found weeks later.

Repo Foundry exists to:

- **create repositories in a uniform way.** Every project gets the same layout, the same remotes, the same license rules and the same framework setup, whoever runs it and whenever it is run;
- **make creating a project quick and repeatable.** One command and a few answers replace a checklist, and answers you give often can be kept in `config.env` so they are not asked again;
- **keep credentials safe.** Tokens live in a `.env` file or are typed when asked. They are never put in a remote, a command line, a log or an error message;
- **show before it does.** It prints a plan first and creates nothing until you pass `--apply` and answer yes;
- **start every project under the framework.** The SQA-QC-Framework (checklists, skills, git hooks and templates) is part of the project from the first minute, not added later.

## What one run creates

- a **Gitea** repository, the source of truth, with the license that applies to the project;
- optionally an empty **GitHub** repository that receives everything through a push mirror from Gitea, so you push to one place only;
- a **local project** with one credential-free remote, `origin`, and the SQA-QC-Framework as a git submodule, with its skills, git hooks and templates installed. The files it installs (`.claude`, `.agents` and `AGENTS.md`) are excluded from git in the new project.

No commit is made in the new project. You review it, then work on a branch.

> **Framework access.** The SQA-QC-Framework is copyrighted and you do not have access to it by default. Contact [Jens Tirsvad](https://www.linkedin.com/in/tirsvad74/) to get access. A website with our contact information is coming at <https://www.tirsystem.com>.

## How it works

1. You start the script from the folder that should hold the project. It asks for the repository name, description, visibility and owner (a user or an organization, separately on each host), and whether to use GitHub.
2. It checks both hosts with read-only requests and prints a **plan**: what it will create, where, and with which settings.
3. Without `--apply` that is all that happens. With `--apply` it asks "Create these now" (default no) and then creates the repositories, the mirror, the local project and the framework in a fixed order.
4. If a step fails, the report says what exists now and what to do; a run you start again reuses what is already there and asks before it touches an existing directory or file.

It never deletes anything, and nothing is overwritten without a yes.

## Who it is for

A maintainer or a small team that starts several projects and wants them to look and behave the same: the same hosts, the same mirror, the same checks, the same way to work from the first commit.

## Pages

| Page | What it covers |
| --- | --- |
| [Getting started](GettingStarted) | Requirements, install and the first run |
| [SSH and tokens](SshAndTokens) | SSH access to Gitea and the two access tokens |
| [Access tokens](AccessTokens) | Create the access tokens, step by step with pictures |
| [Updating the framework](UpdatingTheFramework) | Keep the framework submodule of a project up to date |
| [Troubleshooting](Troubleshooting) | Common failures and what to do |
| [Appendix](Appendix) | Links to all project documentation in `docs/` |

The full reference (configuration files, security decisions, error handling, known limitations) is the [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md).
Report a problem as an [issue](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/issues).
