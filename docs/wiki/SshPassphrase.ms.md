<!-- translation of SshPassphrase.md, source sha256 b16dd69274a5 -->

> Ini ialah terjemahan [`SshPassphrase`](SshPassphrase). Halaman bahasa Inggeris ialah teks yang sah, dan perubahan di sini akan ditimpa pada penerbitan wiki yang seterusnya.

[English](SshPassphrase) | [Dansk](SshPassphrase.da) | Bahasa Melayu

# Kunci SSH dengan frasa laluan

Repo Foundry tidak pernah meminta frasa laluan. Ia menjalankan `ssh` dan `git` tanpa sebarang prompt (`BatchMode`), supaya satu larian tidak pernah tergantung pada soalan dan tiada frasa laluan melaluinya. Kunci yang dilindungi frasa laluan hanya berfungsi apabila ia sudah dimuatkan dalam **ejen SSH**, program kecil yang menyimpan kunci yang telah dibuka untuk sesi anda.

## Apa yang anda lihat apabila kunci tidak dimuatkan

- pelan menyatakan `SSH test: failed`, dan remote `origin` tempatan menggunakan HTTPS dan bukan SSH;
- langkah framework memerlukan SSH, jadi skrip bertanya sama ada hendak diteruskan tanpa framework.

Tiada yang salah dengan kunci itu. Muatkan ia ke dalam ejen dan jalankan skrip sekali lagi.

## 1. Muatkan kunci ke dalam ejen

Gunakan kunci yang anda tambah pada akaun Gitea anda. Contoh menggunakan `~/.ssh/id_ed25519`.

**Linux dan Git Bash pada Windows** (ejen hidup selagi terminal ini terbuka):

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**macOS** (keychain mengingati frasa laluan):

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Windows dengan perkhidmatan ejen OpenSSH** (PowerShell sebagai pentadbir, sekali sahaja; perkhidmatan itu kemudian bermula bersama Windows):

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

`ssh-add` meminta frasa laluan sekali. Taipkan di situ, dalam terminal anda sendiri, bukan dalam fail atau pada baris arahan.

## 2. Semak bahawa ia berfungsi

```bash
ssh-add -l
ssh -p 10022 -T git@git.tirsystem.com
```

`ssh-add -l` menyenaraikan kunci yang dimuatkan. Arahan kedua sepatutnya menyatakan anda berjaya disahkan (Gitea tidak memberi akses shell).

## 3. Jalankan Repo Foundry dari terminal yang sama

Ejen ditemui melalui pemboleh ubah persekitaran terminal tempat ia dimulakan, jadi mulakan `src/create-project.sh` dari terminal itu. Tetingkap terminal baharu memerlukan `ssh-add` sekali lagi, kecuali ejen berjalan sebagai perkhidmatan (Windows) atau dalam keychain (macOS).

Jika `ssh-add -l` menyenaraikan kunci tetapi ujian SSH masih gagal, `ssh` dalam terminal anda dan `ssh` yang digunakan Git mungkin dua program yang berbeza (Git for Windows membawa `ssh` sendiri). Semak dengan `which ssh` dalam Git Bash, dan gunakan ejen untuk `ssh` itu.

## Cara lain

Buat kunci berasingan tanpa frasa laluan yang hanya digunakan untuk ini, dan tambahkan pada akaun Gitea anda. Maka tiada ejen diperlukan, tetapi sesiapa yang mendapat fail itu mendapat akses, jadi pastikan fail itu peribadi (`chmod 600`) dan padam kunci itu daripada Gitea jika mesin hilang.

Kembali ke [SSH dan token](SshAndTokens.ms) atau [Diagnosis](Troubleshooting.ms).
