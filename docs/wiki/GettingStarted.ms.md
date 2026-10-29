<!-- translation of GettingStarted.md, source sha256 12a0dc0d0857 -->

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

## Perlindungan branch

Repositori Gitea baharu mendapat peraturan perlindungan branch: tiada push terus ke `main`, setiap perubahan datang melalui pull request. Commit pertama projek baharu mengikut laluan yang sama: push satu branch dan buka pull request.

Peraturan ditetapkan dengan tiga kunci pilihan dalam `config.env` (corak glob, senarai dipisahkan dengan `;`): `PROTECTED_BRANCH_PATTERN` (lalai `main`), `PROTECTED_FILE_PATTERNS` (lalai tiada) dan `PROTECTED_STATUS_CHECKS` (lalai `TirSystem/git-workflows: *`). Lihat [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-branch-protection-optional).

Untuk memberi repositori sedia ada peraturan yang sama:

```bash
src/create-project.sh --protect OWNER/NAME           # larian kering: membaca, tiada perubahan
src/create-project.sh --protect OWNER/NAME --apply   # mencipta atau menukar peraturan
```

Peraturan sedia ada yang berbeza hanya ditukar selepas jawapan ya.
