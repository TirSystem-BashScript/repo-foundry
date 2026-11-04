English | [Dansk](SshSigning.da) | [Bahasa Melayu](SshSigning.ms)

# Signing commits with an SSH key

A signed commit carries a signature made with your private key. Gitea checks it against the public keys of your account and marks the commit **Verified**. It shows that the commit really comes from you. You can sign with the SSH key you already use for Gitea; you do not need GPG.

Repo Foundry does not sign anything and does not require signed commits. This page is for the day you want to sign by hand, or your project requires it.

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

`commit.gpgsign true` signs every commit. Leave it out, and sign one commit at a time with `git commit -S`. Use `git config` without `--global` inside a repository to change only that repository.

## 2. Let Gitea verify the signatures

In Gitea open **Settings**, **SSH / GPG Keys**. The public key you use for pushing is already there; Gitea uses the keys of your account to verify SSH signatures. If you sign with another key, add it here too.

The e-mail address in `git config user.email` must be one of the addresses of your Gitea account, or the commit is shown as unverified.

## 3. Check that it works

```bash
git commit --allow-empty -m "Test signing"
git log --show-signature -1
```

Push a branch and look at the commit in Gitea: a green **Verified** badge means that Gitea accepts the signature.

## Notes

- A commit made on another machine, or by a tool that does not use your git configuration, is not signed. Set up signing on every machine where you commit.
- Gitea signs the merge commits it makes only if the administrator has set up a signing key for the instance.
- A branch rule that requires signed commits rejects a pull request with one unsigned commit. Sign first, then turn the rule on.

Back to [SSH and tokens](SshAndTokens) or [Troubleshooting](Troubleshooting).
