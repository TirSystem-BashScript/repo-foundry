<!-- translation of GpgSigning.md, source sha256 9847249f0b97 -->

> Ini ialah terjemahan [`GpgSigning`](GpgSigning). Halaman Inggeris ialah rujukan utama, dan perubahan di sini akan ditimpa apabila wiki diterbitkan semula

[English](GpgSigning) | [Dansk](GpgSigning.da) | Bahasa Melayu

# Kunci GPG supaya Gitea boleh menandatangani commit gabungan

Halaman ini untuk **pentadbir** pelayan Gitea. Peraturan branch Repo Foundry mewajibkan commit bertandatangan secara lalai. Commit anda sendiri ditandatangani dengan kunci SSH anda (lihat [Menandatangani commit](SshSigning.ms)), tetapi gabungan yang dibuat dalam antara muka web Gitea, suntingan dalam editor web dan commit pertama sebuah repositori baharu dibuat oleh **Gitea sendiri**. Gitea menandatanganinya hanya jika pelayan mempunyai kunci tandatangan. Tanpanya, peraturan menolak gabungan itu, atau gabungan gagal dengan `gpg failed to sign the data`.

Anda perlu melakukan lima perkara: mencipta kunci, menambah bahagian awamnya ke Gitea, memberitahu Gitea untuk menggunakannya, memberi Gitea bahagian rahsianya, dan menguji.

## 1. Cipta kunci

Lakukannya pada mesin yang anda percayai, dengan GnuPG 2.2 atau lebih baharu. Kunci ini untuk pelayan, jadi ia **tiada frasa laluan** (Gitea tidak boleh menaipnya) dan tidak luput. Gunakan alamat e-mel akaun Gitea, biasanya akaun anda sendiri, supaya Gitea boleh memadankan kunci dengan akaun itu.

```bash
gpg --batch --pinentry-mode loopback --passphrase '' \
  --quick-generate-key "Gitea Signing <you@example.com>" rsa4096 sign never
```

Cari ID kunci. Ia ialah 16 aksara terakhir cap jari:

```bash
gpg --list-secret-keys --keyid-format long you@example.com
```

Dalam output, `sec   rsa4096/0123456789ABCDEF` menunjukkan ID kunci `0123456789ABCDEF`. Contoh di bawah menggunakannya; gunakan ID anda sendiri.

Kunci yang mempunyai frasa laluan gagal apabila Gitea menandatangani. Jika anda menggunakan kunci sedia ada, buang frasa laluan: `gpg --edit-key 0123456789ABCDEF`, kemudian `passwd`, dan biarkan kedua-dua medan kosong.

## 2. Tambah kunci awam ke Gitea

Cetak kunci awam:

```bash
gpg --armor --export 0123456789ABCDEF
```

Dalam Gitea buka tetapan anda, **SSH / GPG Keys**, klik **Add Key** di sebelah **Manage GPG Keys**, tampal keseluruhan blok (dari `-----BEGIN PGP PUBLIC KEY BLOCK-----` hingga `-----END PGP PUBLIC KEY BLOCK-----`) dan klik **Add Key**. Halamannya ialah `https://gitea-anda/user/settings/keys`.

![Langkah 2: borang Manage GPG Keys dengan medan Content dan butang Add Key](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-gpg-1-add-key.png)

Kunci itu mesti ditunjukkan sebagai **Verified Key** dengan alamat e-mel anda di bawah **Matched Identities**. Gitea memadankan alamat e-mel kunci dengan alamat pada akaun anda yang telah anda sahkan. Jika kunci itu tidak disahkan, semak bahawa alamat e-mel kunci itu disahkan di **Settings, Account**. Jika Gitea menunjukkan butang **Verify**, klik padanya dan tandatangani token yang ditunjukkan Gitea:

```bash
echo -n 'TOKEN-DARI-GITEA' | gpg -a --default-key 0123456789ABCDEF --detach-sig
```

Tampal keseluruhan blok yang dicetak arahan itu ke dalam medan dan sahkan.

![Langkah 2: kunci GPG ditunjukkan sebagai Verified Key, dengan identiti yang dipadankan dan ID kunci](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-gpg-2-verified-key.png)

## 3. Beritahu Gitea untuk menggunakan kunci itu

Dalam `app.ini` (dalam Docker, `/data/gitea/conf/app.ini`) tambahkan:

```ini
[repository.signing]
SIGNING_KEY = 0123456789ABCDEF
SIGNING_NAME = Gitea Signing
SIGNING_EMAIL = you@example.com
MERGES = pubkey, twofa, approved, always
```

`SIGNING_EMAIL` mesti alamat e-mel kunci itu, dan alamat yang disahkan pada akaun yang memegang kunci awam; jika tidak commit ditandatangani tetapi tidak ditanda **Verified**. `MERGES` menyatakan bila Gitea menandatangani commit gabungan; `always` menandatangani semuanya. Commit pertama repositori baharu ditandatangani secara lalai (`INITIAL_COMMIT`).

## 4. Beri Gitea kunci rahsia

Inilah langkah yang mudah terlepas. Kunci awam dalam profil anda tidak mencukupi: `gpg` pada pelayan memerlukan kunci **rahsia**, dalam rantai kunci yang dibaca `git` Gitea. Gitea menjalankan `git` dengan `HOME` ditetapkan kepada direktori rumahnya sendiri, `[git] HOME_PATH` (lalai `data/home`, dalam Docker `/data/gitea/home`), jadi `gpg` membaca `HOME_PATH/.gnupg`. Kunci dalam rantai kunci biasa pengguna `git`, atau root, tidak ditemui: ralatnya `gpg: skipped "0123456789ABCDEF": No secret key`.

Docker (imej tiada `sudo`; `su-exec` menjalankan arahan sebagai `git`):

```bash
# rantai kunci pemilik kunci -> rantai kunci yang dibaca Gitea
gpg --export-secret-keys 0123456789ABCDEF | docker exec -i -u git gitea sh -c \
  'mkdir -p /data/gitea/home/.gnupg && chmod 700 /data/gitea/home/.gnupg && GNUPGHOME=/data/gitea/home/.gnupg gpg --import'
```

Tanpa Docker, jalankan import sebagai pengguna yang menjalankan Gitea, dengan `GNUPGHOME` ditetapkan kepada `HOME_PATH/.gnupg`. Jangan biarkan fail dengan kunci rahsia pada pelayan; paip di atas tidak mencipta satu pun.

Semak bahawa kunci berada dalam rantai kunci yang betul dan boleh menandatangani tanpa frasa laluan:

```bash
docker exec -u git gitea sh -c 'GNUPGHOME=/data/gitea/home/.gnupg gpg --list-secret-keys'
docker exec -u git gitea sh -c 'echo test | GNUPGHOME=/data/gitea/home/.gnupg gpg --batch --yes --clearsign -u 0123456789ABCDEF'
```

Arahan kedua mencetak blok yang bermula dengan `-----BEGIN PGP SIGNED MESSAGE-----`.

## 5. Uji

Gabungkan satu pull request dalam antara muka web. Commit gabungan menunjukkan lencana **Verified**. Pada pull request, Gitea menulis `This commit will be signed with key "0123456789ABCDEF"` di atas butang gabung. Untuk menguji tanpa pull request, cipta repositori baharu dengan lesen: commit pertamanya ditandatangani oleh pelayan, dan gagal serta-merta jika kunci tiada.

## Jika tidak berjaya

| Apa yang anda lihat | Sebab dan penyelesaian |
| --- | --- |
| `gpg: skipped "…": No secret key` | Kunci rahsia tiada dalam rantai kunci yang dibaca Gitea. Import dengan `GNUPGHOME=HOME_PATH/.gnupg` (langkah 4). |
| `gpg: signing failed: Inappropriate ioctl` atau permintaan frasa laluan | Kunci mempunyai frasa laluan. Buangnya (langkah 1). |
| Commit ditandatangani tetapi tidak **Verified** | Kunci awam tiada pada akaun, atau alamat e-melnya (dan `SIGNING_EMAIL`) bukan alamat akaun yang disahkan. |
| `gpg: command not found` | Pasang GnuPG dalam imej atau pada pelayan, kemudian mulakan semula Gitea. |
| Tiada perubahan selepas `app.ini` disunting | Mulakan semula Gitea. |

Jika anda tidak boleh menandatangani pada pelayan, matikan peraturan untuk repositori baharu dengan `PROTECTED_REQUIRE_SIGNED_COMMITS=false` dalam `config.env`, dan nilai yang sama untuk repositori sedia ada dengan `--protect`.

Kembali ke [Menandatangani commit](SshSigning.ms) atau [Penyelesaian masalah](Troubleshooting.ms).
