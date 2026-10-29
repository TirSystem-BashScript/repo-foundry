<!-- translation of SshAndTokens.md, source sha256 179abdc8a49e -->

> Ini ialah terjemahan [`SshAndTokens`](SshAndTokens). Halaman bahasa Inggeris ialah teks yang sah, dan perubahan di sini akan ditimpa pada penerbitan wiki yang seterusnya.

[English](SshAndTokens) | [Dansk](SshAndTokens.da) | Bahasa Melayu

# SSH dan token

## Akses SSH ke Gitea

Submodul framework diambil melalui SSH pada port **10022**. Sebelum anda menjalankan skrip:

1. Tambahkan kunci awam SSH anda ke akaun Gitea anda.
2. Sambung sekali secara manual supaya kunci hos pelayan dikenali (skrip menolak kunci hos yang tidak dikenali):

   ```bash
   ssh -p 10022 -T git@git.tirsystem.com
   ```

   Mesej bahawa anda telah berjaya disahkan, tanpa akses shell, bermakna ia berfungsi.

> **Kunci dengan frasa laluan.** Skrip tidak pernah meminta frasa laluan. Kunci dengan frasa laluan mesti sudah dimuatkan dalam `ssh-agent` (`ssh-add`). Lihat [Kunci SSH dengan frasa laluan](SshPassphrase.ms).

## Token

| Token | Kunci dalam `.env` | Diperlukan | Jenis |
| --- | --- | --- | --- |
| Token akses Gitea | `TOKEN_FOR_GITEA_REPO` | sentiasa | token akses dengan skop |
| GitHub personal access token | `GITHUB_PAT` | diperlukan apabila anda memilih GitHub (cermin) | personal access token **klasik** |
| Token akses Gitea untuk wiki | `TOKEN_FOR_GITEA_WIKI` | pilihan (hanya untuk menerbitkan wiki) | token akses dengan skop tulis repositori sahaja (`write:repository`); skrip menerimanya tetapi tidak pernah menggunakannya |

Langkah demi langkah dengan gambar: [cara mencipta token akses](AccessTokens.ms). Kebenaran yang tepat terdapat di bawah [Token permissions](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#token-permissions) dalam README.
