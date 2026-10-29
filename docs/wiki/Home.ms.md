<!-- translation of Home.md, source sha256 9e1e36dacd34 -->

> Ini ialah terjemahan [`Home`](Home). Halaman bahasa Inggeris ialah teks yang sah, dan perubahan di sini akan ditimpa pada penerbitan wiki yang seterusnya.

[English](Home) | [Dansk](Home.da) | Bahasa Melayu

# Repo Foundry

Repo Foundry (`src/create-project.sh`) ialah skrip Bash yang menyediakan projek baharu dalam satu larian, dengan cara yang sama setiap kali.

## Mengapa ia wujud

Menyediakan projek secara manual bermakna banyak langkah kecil pada dua hos dan pada mesin anda: cipta repositori, pilih keterlihatan dan pemilik, tambah lesen, cipta repositori kedua dan mirror, klon, tambah framework, pasang skill dan hook-nya, serta pastikan rahsia tidak berada dalam remote. Jika dibuat secara manual, tiada dua projek yang benar-benar serupa, dan langkah yang terlupa hanya ditemui beberapa minggu kemudian.

Repo Foundry wujud untuk:

- **mencipta repositori secara seragam.** Setiap projek mendapat susunan yang sama, remote yang sama, peraturan lesen yang sama dan persediaan framework yang sama, siapa pun yang menjalankannya dan bila-bila masa ia dijalankan;
- **menjadikan penciptaan projek pantas dan boleh diulang.** Satu arahan dan beberapa jawapan menggantikan senarai semak, dan jawapan yang kerap anda beri boleh disimpan dalam `config.env` supaya tidak ditanya lagi;
- **memastikan kelayakan (credentials) selamat.** Token disimpan dalam fail `.env` atau ditaip apabila ditanya. Ia tidak pernah diletakkan dalam remote, baris arahan, log atau mesej ralat;
- **menunjukkan sebelum bertindak.** Ia mencetak pelan dahulu dan tidak mencipta apa-apa sehingga anda memberikan `--apply` dan menjawab ya;
- **memulakan setiap projek di bawah framework.** SQA-QC-Framework (senarai semak, skill, git hook dan templat) menjadi sebahagian daripada projek sejak minit pertama, bukan ditambah kemudian.

## Apa yang dicipta oleh satu larian

- repositori **Gitea**, iaitu sumber yang sah, dengan lesen yang terpakai untuk projek;
- secara pilihan repositori **GitHub** kosong yang menerima semuanya melalui push mirror dari Gitea, supaya anda hanya push ke satu tempat;
- **projek tempatan** dengan satu remote tanpa kelayakan, `origin`, dan SQA-QC-Framework sebagai submodul git, dengan skill, git hook dan templatnya terpasang. Fail yang dipasangnya (`.claude`, `.agents` dan `AGENTS.md`) dikecualikan daripada git dalam projek baharu.

Tiada commit dibuat dalam projek baharu. Anda menyemaknya, kemudian bekerja pada satu branch.

> **Akses kepada framework.** SQA-QC-Framework dilindungi hak cipta dan anda tidak mempunyai akses kepadanya secara lalai. Hubungi [Jens Tirsvad](https://www.linkedin.com/in/tirsvad74/) untuk mendapatkan akses. Laman web dengan maklumat hubungan kami akan tersedia di <https://www.tirsystem.com>.

## Cara ia berfungsi

1. Anda memulakan skrip dari folder yang akan menempatkan projek. Ia bertanya nama repositori, penerangan, keterlihatan dan pemilik (pengguna atau organisasi, berasingan pada setiap hos), dan sama ada GitHub digunakan.
2. Ia menyemak kedua-dua hos dengan permintaan baca sahaja dan mencetak **pelan**: apa yang akan dicipta, di mana, dan dengan tetapan apa.
3. Tanpa `--apply`, hanya itu yang berlaku. Dengan `--apply` ia bertanya "Create these now" (lalai tidak) dan kemudian mencipta repositori, mirror, projek tempatan dan framework dalam urutan tetap.
4. Jika satu langkah gagal, laporan menyatakan apa yang wujud sekarang dan tindakan yang perlu diambil. Larian yang anda mulakan semula menggunakan semula apa yang sudah ada dan bertanya sebelum menyentuh direktori atau fail sedia ada.

Ia tidak pernah memadam apa-apa, dan tiada apa ditimpa tanpa jawapan ya.

## Untuk siapa

Penyelenggara atau pasukan kecil yang memulakan beberapa projek dan mahu semuanya kelihatan dan berfungsi sama: hos yang sama, mirror yang sama, semakan yang sama dan cara kerja yang sama sejak commit pertama.

## Halaman

| Halaman | Kandungan |
| --- | --- |
| [Bermula](GettingStarted.ms) | Keperluan, pemasangan dan larian pertama |
| [SSH dan token](SshAndTokens.ms) | Akses SSH ke Gitea dan dua token akses |
| [Token akses](AccessTokens.ms) | Cipta token akses langkah demi langkah dengan gambar |
| [Mengemas kini framework](UpdatingTheFramework.ms) | Pastikan submodul framework projek sentiasa terkini |
| [Diagnosis](Troubleshooting.ms) | Kegagalan lazim dan tindakan yang perlu diambil |
| [Lampiran](Appendix.ms) | Pautan ke semua dokumentasi projek dalam `docs/` |

Rujukan penuh (fail konfigurasi, keputusan keselamatan, pengendalian ralat, had yang diketahui) ialah [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md).
Laporkan masalah sebagai [issue](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/issues).
