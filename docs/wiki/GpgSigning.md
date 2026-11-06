English | [Dansk](GpgSigning.da) | [Bahasa Melayu](GpgSigning.ms)

# A GPG key so Gitea can sign merge commits

This page is for the **administrator** of the Gitea server. Repo Foundry's branch rule requires signed commits by default. Your own commits are signed with your SSH key (see [Signing commits](SshSigning)), but a merge made in the Gitea web interface, an edit made in the web editor and the first commit of a new repository are made by **Gitea itself**. Gitea signs them only if the server has a signing key. Without it, the rule rejects the merge, or the merge fails with `gpg failed to sign the data`.

You need to do five things: create a key, add its public half to Gitea, tell Gitea to use it, give Gitea the secret half, and test.

## 1. Create the key

Do this on a machine you trust, with GnuPG 2.2 or later. The key is for the server, so it has **no passphrase** (Gitea cannot type one) and it does not expire. Use the e-mail address of a Gitea account, normally yours, so Gitea can match the key to that account.

```bash
gpg --batch --pinentry-mode loopback --passphrase '' \
  --quick-generate-key "Gitea Signing <you@example.com>" rsa4096 sign never
```

Find the key ID. It is the last 16 characters of the fingerprint:

```bash
gpg --list-secret-keys --keyid-format long you@example.com
```

In the output, `sec   rsa4096/0123456789ABCDEF` shows the key ID `0123456789ABCDEF`. The examples below use it; use your own.

A key that has a passphrase fails when Gitea signs, so remove the passphrase if you used an existing key: `gpg --edit-key 0123456789ABCDEF`, then `passwd`, and leave both fields empty.

## 2. Add the public key to Gitea

Print the public key:

```bash
gpg --armor --export 0123456789ABCDEF
```

In Gitea open your settings, **SSH / GPG Keys**, click **Add Key** next to **Manage GPG Keys**, paste the whole block (from `-----BEGIN PGP PUBLIC KEY BLOCK-----` to `-----END PGP PUBLIC KEY BLOCK-----`) and click **Add Key**. The page is `https://your-gitea/user/settings/keys`.

![Step 2: the Manage GPG Keys form with the Content field and the Add Key button](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-gpg-1-add-key.png)

The key must show **Verified Key** and your e-mail address under **Matched Identities**, as in the picture below. Gitea matches the e-mail address of the key to an address on your account that you have confirmed (**Settings, Account**). If the key is not verified, it has no **Verified Key** mark and a blue **Verify** button next to it. Verify it like an SSH key; the form is the one shown in step 2 of [Signing commits](SshSigning):

1. Click the blue **Verify** button next to the key.
2. Copy the **Token** that Gitea shows. Do the next two steps without leaving the page: the token changes if you open the form again.
3. Sign the token with the secret key, in a terminal on the machine that holds the key:

```bash
echo -n 'THE-TOKEN-FROM-GITEA' | gpg -a --default-key 0123456789ABCDEF --detach-sig
```

4. Paste the whole block that the command prints, from `-----BEGIN PGP SIGNATURE-----` to `-----END PGP SIGNATURE-----`, into the signature field and click the blue **Verify** button below it.
5. Gitea shows **GPG key … has been verified**, and the key shows **Verified Key**.

![Step 2: the GPG key shown as Verified Key, with the matched identity and the key ID](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-gpg-2-verified-key.png)

## 3. Tell Gitea to use the key

In `app.ini` (in Docker, `/data/gitea/conf/app.ini`) add:

```ini
[repository.signing]
SIGNING_KEY = 0123456789ABCDEF
SIGNING_NAME = Gitea Signing
SIGNING_EMAIL = you@example.com
MERGES = pubkey, twofa, approved, always
```

`SIGNING_EMAIL` must be the e-mail address of the key, and a confirmed address on the account that holds the public key; otherwise the commit is signed but is not marked **Verified**. `MERGES` says when Gitea signs a merge commit; `always` signs every one. The initial commit of a new repository is signed by default (`INITIAL_COMMIT`).

## 4. Give Gitea the secret key

This is the step that is easy to miss. The public key in your profile is not enough: `gpg` on the server needs the **secret** key, in the key ring that Gitea's `git` reads. Gitea runs `git` with `HOME` set to its own home directory, `[git] HOME_PATH` (default `data/home`, in Docker `/data/gitea/home`), so `gpg` reads `HOME_PATH/.gnupg`. A key in the ordinary key ring of the `git` user, or of root, is not found: the error is `gpg: skipped "0123456789ABCDEF": No secret key`.

Docker (the image has no `sudo`; `su-exec` runs a command as `git`):

```bash
# the key ring of the key's owner -> the key ring Gitea reads
gpg --export-secret-keys 0123456789ABCDEF | docker exec -i -u git gitea sh -c \
  'mkdir -p /data/gitea/home/.gnupg && chmod 700 /data/gitea/home/.gnupg && GNUPGHOME=/data/gitea/home/.gnupg gpg --import'
```

Without Docker, run the import as the user that runs Gitea, with `GNUPGHOME` set to `HOME_PATH/.gnupg`. Do not leave a file with the secret key on the server; the pipe above does not create one.

Check that the key is in the right key ring and that it can sign without a passphrase:

```bash
docker exec -u git gitea sh -c 'GNUPGHOME=/data/gitea/home/.gnupg gpg --list-secret-keys'
docker exec -u git gitea sh -c 'echo test | GNUPGHOME=/data/gitea/home/.gnupg gpg --batch --yes --clearsign -u 0123456789ABCDEF'
```

The second command prints a block that starts with `-----BEGIN PGP SIGNED MESSAGE-----`.

## 5. Test it

Merge a pull request in the web interface. The merge commit shows the **Verified** badge. On the pull request, Gitea says `This commit will be signed with key "0123456789ABCDEF"` above the merge button. To test without a pull request, create a new repository with a license: its first commit is signed by the server, and it fails at once if the key is missing.

## If it does not work

| What you see | Cause and fix |
| --- | --- |
| `gpg: skipped "…": No secret key` | The secret key is not in the key ring Gitea reads. Import it with `GNUPGHOME=HOME_PATH/.gnupg` (step 4). |
| `gpg: signing failed: Inappropriate ioctl` or a request for a passphrase | The key has a passphrase. Remove it (step 1). |
| The commit is signed but not **Verified** | The public key is not on the account, or its e-mail address (and `SIGNING_EMAIL`) is not a confirmed address of that account. |
| `gpg: command not found` | Install GnuPG in the image or on the server, then restart Gitea. |
| Nothing changes after the edit of `app.ini` | Restart Gitea. |

If you cannot sign on the server, turn the rule off for new repositories with `PROTECTED_REQUIRE_SIGNED_COMMITS=false` in `config.env`, and the same value for an existing repository with `--protect`.

Back to [Signing commits](SshSigning) or [Troubleshooting](Troubleshooting).
