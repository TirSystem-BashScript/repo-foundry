English | [Dansk](SshPassphrase.da) | [Bahasa Melayu](SshPassphrase.ms)

# SSH keys with a passphrase

Repo Foundry never asks for a passphrase. It runs `ssh` and `git` without any prompt (`BatchMode`), so that a script run can never hang on a question and no passphrase passes through it. A key that is protected by a passphrase therefore works only when it is already loaded in an **SSH agent**, a small program that holds the unlocked key for your session.

## What you see when the key is not loaded

- the plan says `SSH test: failed`, and the local `origin` remote uses HTTPS instead of SSH;
- the framework steps need SSH, so the script asks whether to go on without the framework.

Nothing is wrong with the key. Load it into the agent and run the script again.

## 1. Load the key into the agent

Use the key you added to your Gitea account. The examples use `~/.ssh/id_ed25519`.

**Linux and Git Bash on Windows** (the agent lives as long as this terminal):

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**macOS** (the macOS keychain remembers the passphrase):

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Windows with the OpenSSH agent service** (PowerShell as administrator, once; the service then starts with Windows):

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

`ssh-add` asks for the passphrase once. Type it there, in your own terminal, not in a file or a command line.

## 2. Check that it works

```bash
ssh-add -l
ssh -p 10022 -T git@git.tirsystem.com
```

`ssh-add -l` lists the loaded key. The second command should say that you have successfully authenticated (Gitea gives no shell access).

## 3. Run Repo Foundry from the same terminal

The agent is found through environment variables of the terminal where you started it, so start `src/create-project.sh` from that terminal. A new terminal window needs `ssh-add` again, unless the agent runs as a service (Windows) or in the keychain (macOS).

If `ssh-add -l` lists the key but the SSH test still fails, `ssh` in your terminal and the `ssh` that Git uses may be different programs (Git for Windows ships its own). Check with `which ssh` in Git Bash, and use the agent of that `ssh`.

## Another way

Make a separate key without a passphrase that is only used for this, and add it to your Gitea account. Then no agent is needed, but anyone who gets the file gets access, so keep the file private (`chmod 600`) and delete the key from Gitea if the machine is lost.

Back to [SSH and tokens](SshAndTokens) or [Troubleshooting](Troubleshooting).
