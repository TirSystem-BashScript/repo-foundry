<!-- translation of SshSigning.md, source sha256 92815584a40c -->

> Ini ialah terjemahan [`SshSigning`](SshSigning). Halaman bahasa Inggeris ialah teks yang sah, dan perubahan di sini akan ditimpa pada penerbitan wiki yang seterusnya.

[English](SshSigning) | [Dansk](SshSigning.da) | Bahasa Melayu

# Menandatangani commit dengan kunci SSH

Commit yang ditandatangani membawa tandatangan yang dibuat dengan kunci peribadi anda. Gitea menyemaknya dengan kunci awam akaun anda dan menandakan commit itu **Verified**. Ia menunjukkan commit itu benar-benar datang daripada anda. Anda boleh menandatangani dengan kunci SSH yang sudah anda gunakan untuk Gitea; anda tidak memerlukan GPG.

Repo Foundry tidak menandatangani apa-apa dan tidak mewajibkan commit bertandatangan. Halaman ini untuk hari anda mahu menandatangani sendiri, atau projek anda memerlukannya.

## Apa yang anda perlukan

- Git 2.34 atau lebih baharu (`git --version`) dan OpenSSH 8.0 atau lebih baharu (`ssh -V`).
- Kunci SSH yang anda tambah pada akaun Gitea anda. Contoh menggunakan `~/.ssh/id_ed25519.pub`.
- Jika kunci mempunyai frasa laluan, ia mesti dimuatkan dahulu dalam ejen SSH, lihat [Kunci SSH dengan frasa laluan](SshPassphrase). Jika tidak, git meminta frasa laluan pada setiap commit.

## 1. Beritahu git supaya menandatangani dengan kunci itu

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

Pada Windows, dalam PowerShell:

```powershell
git config --global gpg.format ssh
git config --global user.signingkey "$env:USERPROFILE\.ssh\id_ed25519.pub"
git config --global commit.gpgsign true
```

`commit.gpgsign true` menandatangani setiap commit. Tinggalkannya, dan tandatangani satu commit pada satu masa dengan `git commit -S`. Gunakan `git config` tanpa `--global` dalam repositori untuk mengubah repositori itu sahaja.

## 2. Biarkan Gitea mengesahkan tandatangan

Buka **Settings**, **SSH / GPG Keys** dalam Gitea. Kunci awam yang anda gunakan untuk push sudah ada di situ; Gitea menggunakan kunci akaun anda untuk mengesahkan tandatangan SSH. Jika anda menandatangani dengan kunci lain, tambahkannya di sini juga.

**Sahkan kunci itu.** Gitea mempercayai kunci SSH untuk tandatangan hanya selepas anda membuktikan bahawa kunci itu milik anda. Kunci yang belum disahkan ditunjukkan sebagai *Unverified* dalam senarai, dan commit anda tidak mendapat lencana **Verified** (API menjawab `no_gpg_keys_found`). Klik **Verify** di sebelah kunci itu: Gitea menunjukkan satu token dan arahan yang perlu dijalankan. Ia kelihatan seperti ini (gunakan arahan yang ditunjukkan Gitea, dengan token dan fail kunci anda sendiri):

```bash
echo -n 'THE-TOKEN-FROM-GITEA' | ssh-keygen -Y sign -n gitea -f ~/.ssh/id_ed25519
```

Pada Windows, jalankannya dalam Git Bash, atau dalam PowerShell dengan bentuk yang ditunjukkan Gitea untuk Windows:

```powershell
cmd /c "<NUL set /p=`"THE-TOKEN-FROM-GITEA`"| ssh-keygen -Y sign -n gitea -f $env:USERPROFILE\.ssh\id_ed25519"
```

Arahan itu mencetak satu blok yang bermula dengan `-----BEGIN SSH SIGNATURE-----`. Tampal keseluruhan blok itu ke dalam medan dalam Gitea dan sahkan.

Alamat e-mel dalam `git config user.email` mestilah salah satu alamat akaun Gitea anda, jika tidak commit ditunjukkan sebagai tidak disahkan.

## 3. Biarkan git mengesahkan tandatangan pada mesin anda

Git menandatangani dengan kunci peribadi anda, tetapi untuk *mengesahkan* tandatangan (dalam `git log --show-signature`, atau semasa menggabungkan) ia memerlukan senarai kunci yang dipercayainya: fail **allowed signers**. Tanpanya commit tetap ditandatangani dan Gitea tetap menunjukkannya sebagai Verified, tetapi git anda sendiri menjawab `No principal matched` dan tidak dapat mengesahkannya.

Linux, macOS dan Git Bash (jalankan dalam shell, dari mana-mana folder; ia menggunakan alamat e-mel konfigurasi git anda):

```bash
mkdir -p ~/.ssh
printf '%s namespaces="git" %s\n' \
  "$(git config user.email)" \
  "$(cat ~/.ssh/id_ed25519.pub)" \
  > ~/.ssh/allowed_signers
chmod 600 ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Windows, dalam PowerShell:

```powershell
"$(git config user.email) namespaces=`"git`" $((Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" -Raw).Trim())" |
  Set-Content -Encoding ascii "$env:USERPROFILE\.ssh\allowed_signers"

git config --global gpg.ssh.allowedSignersFile "$env:USERPROFILE\.ssh\allowed_signers"
```

Fail itu mempunyai satu baris: alamat e-mel anda, `namespaces="git"` dan kunci awam anda. Pastikan `git config user.email` telah ditetapkan sebelum anda menjalankannya.

## 4. Semak bahawa ia berfungsi

```bash
git commit --allow-empty -m "Test signing"
git log --show-signature -1
```

Push satu branch dan lihat commit itu dalam Gitea: lencana hijau **Verified** bermaksud Gitea menerima tandatangan itu.

## Catatan

- Commit yang dibuat pada mesin lain, atau oleh alat yang tidak menggunakan konfigurasi git anda, tidak ditandatangani. Sediakan penandatanganan pada setiap mesin tempat anda membuat commit.
- Gitea menandatangani commit gabungan yang dibuatnya hanya jika pentadbir telah menyediakan kunci penandatanganan untuk instans itu.
- Peraturan branch yang memerlukan commit bertandatangan menolak pull request yang mempunyai satu commit tidak bertandatangan. Tandatangani dahulu, kemudian hidupkan peraturan itu.

## Penyelesaian masalah

Jika commit tidak ditandatangani, semak tetapan yang sebenarnya digunakan git dan dari mana ia datang (`--show-origin` menamakan failnya), kemudian lihat tandatangan commit yang terakhir:

```bash
git config --show-origin --get commit.gpgsign
git config --show-origin --get gpg.format
git config --show-origin --get user.signingkey

git log -1 --show-signature
```

Tiga tetapan itu patut menunjukkan `true`, `ssh` dan laluan kunci awam anda. Nilai daripada fail repositori (`.git/config`) mengatasi nilai global. `git log -1 --show-signature` menunjukkan `Good "git" signature` apabila commit ditandatangani dan fail allowed signers anda mengenali kunci itu; `No principal matched` bermaksud fail allowed signers tiada atau mempunyai alamat e-mel lain (langkah 3), dan tiada tandatangan langsung bermaksud commit dibuat tanpa penandatanganan.

Kembali ke [SSH dan token](SshAndTokens) atau [Penyelesaian masalah](Troubleshooting).
