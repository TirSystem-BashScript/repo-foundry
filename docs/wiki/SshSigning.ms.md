<!-- translation of SshSigning.md, source sha256 3989f5e0ebe3 -->

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

`commit.gpgsign true` menandatangani setiap commit. Tinggalkannya, dan tandatangani satu commit pada satu masa dengan `git commit -S`. Gunakan `git config` tanpa `--global` dalam repositori untuk mengubah repositori itu sahaja.

## 2. Biarkan Gitea mengesahkan tandatangan

Buka **Settings**, **SSH / GPG Keys** dalam Gitea. Kunci awam yang anda gunakan untuk push sudah ada di situ; Gitea menggunakan kunci akaun anda untuk mengesahkan tandatangan SSH. Jika anda menandatangani dengan kunci lain, tambahkannya di sini juga.

Alamat e-mel dalam `git config user.email` mestilah salah satu alamat akaun Gitea anda, jika tidak commit ditunjukkan sebagai tidak disahkan.

## 3. Semak bahawa ia berfungsi

```bash
git commit --allow-empty -m "Test signing"
git log --show-signature -1
```

Push satu branch dan lihat commit itu dalam Gitea: lencana hijau **Verified** bermaksud Gitea menerima tandatangan itu.

## Catatan

- Commit yang dibuat pada mesin lain, atau oleh alat yang tidak menggunakan konfigurasi git anda, tidak ditandatangani. Sediakan penandatanganan pada setiap mesin tempat anda membuat commit.
- Gitea menandatangani commit gabungan yang dibuatnya hanya jika pentadbir telah menyediakan kunci penandatanganan untuk instans itu.
- Peraturan branch yang memerlukan commit bertandatangan menolak pull request yang mempunyai satu commit tidak bertandatangan. Tandatangani dahulu, kemudian hidupkan peraturan itu.

Kembali ke [SSH dan token](SshAndTokens) atau [Penyelesaian masalah](Troubleshooting).
