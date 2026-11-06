English | [Dansk](SshSigning.da) | [Bahasa Melayu](SshSigning.ms)

# Signing commits with an SSH key

A signed commit carries a signature made with your private key. Gitea checks it against the public keys of your account and marks the commit **Verified**. It shows that the commit really comes from you. You can sign with the SSH key you already use for Gitea; you do not need GPG.

Repo Foundry does not sign anything, but the branch rule it creates requires signed commits by default. Set `PROTECTED_REQUIRE_SIGNED_COMMITS=false` in `config.env` if you cannot sign. This page is for setting up signing.

## What you need

- Git 2.34 or later (`git --version`) and OpenSSH 8.0 or later (`ssh -V`).
- The SSH key you added to your Gitea account. The examples use `~/.ssh/id_ed25519.pub`.
- If the key has a passphrase, it must be loaded in the SSH agent first, see [SSH keys with a passphrase](SshPassphrase). Otherwise git asks for the passphrase at every commit.

## 1. Tell git to sign with the key

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

On Windows, in PowerShell:

```powershell
git config --global gpg.format ssh
git config --global user.signingkey "$env:USERPROFILE\.ssh\id_ed25519.pub"
git config --global commit.gpgsign true
```

`commit.gpgsign true` signs every commit. Leave it out, and sign one commit at a time with `git commit -S`. Use `git config` without `--global` inside a repository to change only that repository.

## 2. Let Gitea verify the signatures

In Gitea open **Settings**, **SSH / GPG Keys**. The public key you use for pushing is already there; Gitea uses the keys of your account to verify SSH signatures. If you sign with another key, add it here too.

**Verify the key.** Gitea trusts an SSH key for signatures only after you have proved that the key is yours. A key that is not verified shows as *Unverified* in the list, and your commits get no **Verified** badge (the API says `no_gpg_keys_found`). Click **Verify** next to the key: Gitea shows a token and the command to run. It looks like this (use the command that Gitea shows, with your own token and key file):

![The SSH key list in the Gitea settings: a verified key, and a key that is not verified with a Verify button](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-ssh-1-verify-button.png)

```bash
echo -n 'THE-TOKEN-FROM-GITEA' | ssh-keygen -Y sign -n gitea -f ~/.ssh/id_ed25519
```

On Windows, run it in Git Bash, or in PowerShell with the form that Gitea shows for Windows:

```powershell
cmd /c "<NUL set /p=`"THE-TOKEN-FROM-GITEA`"| ssh-keygen -Y sign -n gitea -f $env:USERPROFILE\.ssh\id_ed25519"
```

The command prints a block that starts with `-----BEGIN SSH SIGNATURE-----`. Paste the whole block into the field in Gitea and confirm.

![The verification form with the token, the command to run and the field for the signature](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-ssh-2-verify-form.png)

The e-mail address in `git config user.email` must be one of the addresses of your Gitea account, or the commit is shown as unverified.

## 3. Let git verify the signatures on your machine

Git signs with your private key, but to *verify* a signature (in `git log --show-signature`, or when you merge) it needs a list of the keys it trusts: an **allowed signers** file. Without it the commit is still signed and Gitea still shows it as Verified, but your own git answers `No principal matched` and cannot confirm it.

Linux, macOS and Git Bash (run it in the shell, from any folder; it uses the e-mail address of your git configuration):

```bash
mkdir -p ~/.ssh
printf '%s namespaces="git" %s\n' \
  "$(git config user.email)" \
  "$(cat ~/.ssh/id_ed25519.pub)" \
  > ~/.ssh/allowed_signers
chmod 600 ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Windows, in PowerShell:

```powershell
"$(git config user.email) namespaces=`"git`" $((Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" -Raw).Trim())" |
  Set-Content -Encoding ascii "$env:USERPROFILE\.ssh\allowed_signers"

git config --global gpg.ssh.allowedSignersFile "$env:USERPROFILE\.ssh\allowed_signers"
```

The file holds one line: your e-mail address, `namespaces="git"` and your public key. Make sure `git config user.email` is set before you run it.

## 4. Check that it works

```bash
git commit --allow-empty -m "Test signing"
git log --show-signature -1
```

Push a branch and look at the commit in Gitea: a green **Verified** badge means that Gitea accepts the signature.

## Notes

- A commit made on another machine, or by a tool that does not use your git configuration, is not signed. Set up signing on every machine where you commit.
- Gitea signs the merge commits it makes only if the administrator has set up a signing key for the instance: see [A GPG key so Gitea can sign merge commits](GpgSigning).
- A branch rule that requires signed commits rejects a pull request with one unsigned commit. Sign first, or the pull request cannot be merged. A repository made by Repo Foundry has this rule unless `config.env` says `PROTECTED_REQUIRE_SIGNED_COMMITS=false`.

## Troubleshooting

If a commit is not signed, check which settings git really uses and where they come from (`--show-origin` names the file), then look at the signature of the last commit:

```bash
git config --show-origin --get commit.gpgsign
git config --show-origin --get gpg.format
git config --show-origin --get user.signingkey

git log -1 --show-signature
```

The three settings should read `true`, `ssh` and the path of your public key. A value from a repository file (`.git/config`) overrides the global one. `git log -1 --show-signature` shows `Good "git" signature` when the commit is signed and your allowed signers file knows the key; `No principal matched` means the allowed signers file is missing or has another e-mail address (step 3), and no signature at all means that the commit was made without signing.

Back to [SSH and tokens](SshAndTokens) or [Troubleshooting](Troubleshooting).
