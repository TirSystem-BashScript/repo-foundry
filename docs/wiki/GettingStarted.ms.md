<!-- translation of GettingStarted.md, source sha256 6f58bcedcf67 -->

> Ini ialah terjemahan [`GettingStarted`](GettingStarted). Halaman bahasa Inggeris ialah teks yang sah, dan perubahan di sini akan ditimpa pada penerbitan wiki yang seterusnya.

[English](GettingStarted) | [Dansk](GettingStarted.da) | Bahasa Melayu

# Bermula

## Keperluan

| Alat | Digunakan untuk |
| --- | --- |
| bash 4.4 atau lebih baharu | skrip (macOS dibekalkan dengan 3.2: pasang bash yang lebih baharu dahulu) |
| `git` | projek tempatan dan submodul framework |
| `curl` | API GitHub dan Gitea |
| `ssh` (pilihan) | semakan SSH; tanpanya langkah framework dilangkau |
| `jq` (pilihan) | penghuraian JSON; tanpanya pembaca terbina dalam yang kecil digunakan |

## Pemasangan

```bash
git clone https://git.tirsystem.com/TirSystem-BashScript/repo-foundry.git
cd repo-foundry
src/create-project.sh --help
```

Tiada apa-apa dipasang pada seluruh sistem: skrip berjalan dari checkout.

## Konfigurasi

Salin `config.env.example` ke `config.env` dan `.env.example` ke `.env`, kemudian tetapkan alamat perkhidmatan dan token (lihat [SSH dan token](SshAndTokens.ms)). `.env` mengandungi kelayakan (credentials) dan tidak pernah di-commit.

## Larian

Mulakan skrip dari folder yang akan menyimpan projek baharu:

```bash
src/create-project.sh            # larian percubaan: membaca dari hos, tidak mencipta apa-apa
src/create-project.sh --apply    # mencipta semuanya selepas ya terakhir
```

Tiada commit dibuat dalam projek baharu. Bekerja pada branch di sana: hook framework menolak commit pada `main`.

## Pembersihan branch

Repositori Gitea baharu mempunyai tetapan "Delete pull request branch after merge by default" dihidupkan, supaya branch pull request yang telah digabungkan dipadam oleh Gitea. Repositori yang digunakan semula tidak diubah. Untuk mematikannya, buka tetapan repositori dalam Gitea, di bawah Pull Requests.

## Perlindungan branch

Repositori Gitea baharu mendapat dua peraturan perlindungan branch. Peraturan utama melarang push terus ke `main`: setiap perubahan datang melalui pull request. Kedua-dua peraturan menyekat penggabungan apabila ada ulasan yang ditolak, permintaan ulasan rasmi, apabila pull request sudah lapuk, dan untuk pentadbir; tiada kunci yang mematikannya. Peraturan workflow, pada `release/**`, juga memerlukan semakan status. Gitea menggunakan satu peraturan bagi setiap branch, jadi kedua-dua corak tidak boleh sepadan dengan branch yang sama. Commit pertama projek baharu mengikut laluan yang sama: push satu branch dan buka pull request.

Peraturan ditetapkan dengan lima kunci pilihan dalam `config.env` (corak glob, senarai dipisahkan dengan `;`): `PROTECTED_BRANCH_PATTERN` (lalai `main`), `PROTECTED_WORKFLOW_PATTERN` (lalai `release/**`, kosong bermakna tiada peraturan workflow), `PROTECTED_FILE_PATTERNS` (lalai tiada), `PROTECTED_STATUS_CHECKS` (lalai `TirSystem/git-workflows: Validate / *;TirSystem/git-workflows: Release / *;TirSystem/git-workflows: OpenGrep / *`) dan `PROTECTED_REQUIRE_SIGNED_COMMITS` (`true` atau `false`, lalai `true`; `false` jika anda tidak boleh menandatangani; lihat [Menandatangani commit](SshSigning.ms)). Lihat [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-branch-protection-optional).

Untuk memberi repositori sedia ada peraturan yang sama:

```bash
src/create-project.sh --protect OWNER/NAME           # larian kering: membaca, tiada perubahan
src/create-project.sh --protect OWNER/NAME --apply   # mencipta atau menukar peraturan
```

Peraturan sedia ada yang berbeza hanya ditukar selepas jawapan ya.

## Nama projek

Nama sesebuah projek juga ialah nama repositori Gitea dan GitHub-nya dan, secara lalai, nama folder-nya. Nama itu ialah `kebab-case` melainkan anda menyatakan sebaliknya: huruf kecil dan digit dalam perkataan yang disambung dengan satu sempang, seperti `my-app`. Nama seperti `My_App` ditolak, bentuk kebab-case (`my-app`) dicadangkan, dan anda ditanya sekali lagi.

Untuk mengekalkan gaya huruf lain, tetapkan `PROJECT_NAME_STYLE=any` dalam `config.env` (pilihan; `kebab-case` ialah nilai lalai). Peraturan nama repositori pada hos kemudian terpakai: huruf, digit, `.`, `_` dan `-`. `PROJECT_NAME` dalam `config.env` yang bukan kebab-case menghentikan larian melainkan gayanya `any`. Nama repositori yang sedia ada (`--protect OWNER/NAME`) tidak pernah disemak. Lihat [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-project-details-optional).

## Lesen

Lesen bagi projek baharu ialah `PROJECT_LICENSE` dalam `config.env` (pilihan): kunci lesen Gitea seperti `AGPL-3.0` atau `MIT`, atau `none` untuk tiada lesen. Untuk melihat kunci yang ditawarkan pelayan Gitea anda:

```bash
src/create-project.sh --list-licenses     # satu kunci lesen setiap baris; hanya membaca
```

Pelayan Maintainer menawarkan 30 kunci; ia disenaraikan sebagai ulasan dalam `config.env.example`.

## Gunakan sebagai arahan

Untuk memulakan skrip dengan `repo-foundry` dari mana-mana folder, pautkannya ke dalam folder yang ada pada `PATH` anda. Jalankan ini sekali, dari akar checkout anda:

```bash
mkdir -p ~/bin
ln -s "$PWD/src/create-project.sh" ~/bin/repo-foundry
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
```

Buka terminal baharu (atau jalankan `source ~/.bashrc`) dan mulakannya dengan `repo-foundry`. Skrip mengikut pautan kembali ke checkout, jadi ia menjumpai fail-failnya sendiri, dan kemas kini dengan `git pull` dalam checkout sampai ke arahan itu serta-merta. Pada macOS, gunakan `~/.zshrc` dan bukan `~/.bashrc` jika shell anda ialah zsh.

Pada Windows, gunakan WSL: buka terminal WSL (contohnya Ubuntu), klon Repo Foundry di dalamnya, dan jalankan arahan di atas di situ.
