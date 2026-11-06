<!-- translation of SshSigning.md, source sha256 9f5a64b1b78a -->

> Dette er en oversættelse af [`SshSigning`](SshSigning). Den engelske side er autoritativ, og ændringer her bliver overskrevet, næste gang wikien publiceres.

[English](SshSigning) | Dansk | [Bahasa Melayu](SshSigning.ms)

# Signering af commits med en SSH-nøgle

Et signeret commit bærer en signatur, der er lavet med din private nøgle. Gitea tjekker den mod de offentlige nøgler på din konto og markerer commit'et **Verified**. Det viser, at commit'et virkelig kommer fra dig. Du kan signere med den SSH-nøgle, du allerede bruger til Gitea; du behøver ikke GPG.

Repo Foundry signerer ikke noget, men den branchregel, det opretter, kræver som standard signerede commits. Sæt `PROTECTED_REQUIRE_SIGNED_COMMITS=false` i `config.env`, hvis du ikke kan signere. Denne side er til opsætning af signering.

## Hvad du skal bruge

- Git 2.34 eller nyere (`git --version`) og OpenSSH 8.0 eller nyere (`ssh -V`).
- Den SSH-nøgle, du har lagt på din Gitea-konto. Eksemplerne bruger `~/.ssh/id_ed25519.pub`.
- Har nøglen en adgangskode, skal den først være indlæst i SSH-agenten, se [SSH-nøgler med adgangskode](SshPassphrase). Ellers spørger git om adgangskoden ved hvert commit.

## 1. Fortæl git, at den skal signere med nøglen

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

På Windows, i PowerShell:

```powershell
git config --global gpg.format ssh
git config --global user.signingkey "$env:USERPROFILE\.ssh\id_ed25519.pub"
git config --global commit.gpgsign true
```

`commit.gpgsign true` signerer hvert commit. Udelad den, og signér ét commit ad gangen med `git commit -S`. Brug `git config` uden `--global` inde i et repository for kun at ændre det repository.

## 2. Lad Gitea verificere signaturerne

Åbn **Settings**, **SSH / GPG Keys** i Gitea. Den offentlige nøgle, du pusher med, ligger allerede der; Gitea bruger nøglerne på din konto til at verificere SSH-signaturer. Signerer du med en anden nøgle, så læg den også her.

**Verificér nøglen.** Gitea stoler kun på en SSH-nøgle til signaturer, når du har bevist, at nøglen er din. En nøgle, der ikke er verificeret, har intet **Verified**-mærke på listen og en knap **Verify**, og dine commits får intet **Verified**-mærke (API'et siger `no_gpg_keys_found`). Gør disse trin for hver nøgle, du signerer med:

1. Find nøglen uden mærket **Verified Key** under **Manage SSH Keys**, og klik på den blå knap **Verify** ved siden af den (markeret med rødt herunder).

![Trin 1: SSH-nøglelisten; den anden nøgle er ikke verificeret og har en Verify-knap, markeret med rødt](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-ssh-1-verify-button.png)

2. Gitea viser et **Token** og den kommando, du skal køre, til Linux og macOS, Windows PowerShell og Windows CMD. Kopiér tokenet. Formularen er åben, til du klikker **Cancel**, og tokenet skifter, hvis du åbner den igen, så gør trin 3 og 4 uden at forlade siden.

3. Signér tokenet med den **private** nøgle, der hører til den offentlige, i en terminal på din maskine (brug den kommando, Gitea viser, med dit eget token og din egen nøglefil):

```bash
echo -n 'THE-TOKEN-FROM-GITEA' | ssh-keygen -Y sign -n gitea -f ~/.ssh/id_ed25519
```

På Windows kører du den i Git Bash, eller i PowerShell med den form, Gitea viser til Windows:

```powershell
cmd /c "<NUL set /p=`"THE-TOKEN-FROM-GITEA`"| ssh-keygen -Y sign -n gitea -f $env:USERPROFILE\.ssh\id_ed25519"
```

Kommandoen skriver en blok, der starter med `-----BEGIN SSH SIGNATURE-----` og slutter med `-----END SSH SIGNATURE-----`.

4. Indsæt hele blokken, begge linjer med, i feltet **Armored SSH signature**, og klik på den blå knap **Verify** under det (markeret med rødt).

![Trin 2 til 4: tokenet, kommandoerne, feltet til signaturen og Verify-knappen, markeret med rødt](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-ssh-2-verify-form.png)

5. Gitea viser nøglen med **Verified Key**. Siger den, at signaturen er ugyldig, så tjek, at du har signeret formularens token med den private nøgle til netop denne nøgle, og at du har kopieret hele blokken.

Mailadressen i `git config user.email` skal være en af adresserne på din Gitea-konto, ellers vises commit'et som ikke verificeret.

## 3. Lad git verificere signaturerne på din maskine

Git signerer med din private nøgle, men for at *verificere* en signatur (i `git log --show-signature` eller ved en merge) skal den bruge en liste over de nøgler, den stoler på: en **allowed signers**-fil. Uden den er commit'et stadig signeret, og Gitea viser det stadig som Verified, men din egen git svarer `No principal matched` og kan ikke bekræfte det.

Linux, macOS og Git Bash (kør det i shellen fra en vilkårlig mappe; det bruger mailadressen fra din git-konfiguration):

```bash
mkdir -p ~/.ssh
printf '%s namespaces="git" %s\n' \
  "$(git config user.email)" \
  "$(cat ~/.ssh/id_ed25519.pub)" \
  > ~/.ssh/allowed_signers
chmod 600 ~/.ssh/allowed_signers
git config --global gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers
```

Windows, i PowerShell:

```powershell
"$(git config user.email) namespaces=`"git`" $((Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub" -Raw).Trim())" |
  Set-Content -Encoding ascii "$env:USERPROFILE\.ssh\allowed_signers"

git config --global gpg.ssh.allowedSignersFile "$env:USERPROFILE\.ssh\allowed_signers"
```

Filen har én linje: din mailadresse, `namespaces="git"` og din offentlige nøgle. Sørg for, at `git config user.email` er sat, før du kører den.

## 4. Tjek at det virker

```bash
git commit --allow-empty -m "Test signing"
git log --show-signature -1
```

Push en branch og se commit'et i Gitea: et grønt **Verified**-mærke betyder, at Gitea godkender signaturen.

## Bemærkninger

- Et commit lavet på en anden maskine eller af et værktøj, der ikke bruger din git-konfiguration, er ikke signeret. Sæt signering op på hver maskine, hvor du committer.
- Gitea signerer de merge-commits, den selv laver, kun hvis administratoren har sat en signeringsnøgle op for instansen: se [En GPG-nøgle, så Gitea kan signere merge commits](GpgSigning.da).
- En branchregel, der kræver signerede commits, afviser en pull request med ét usigneret commit. Signér først, ellers kan pull requesten ikke merges. Et repository oprettet af Repo Foundry har denne regel, medmindre `config.env` siger `PROTECTED_REQUIRE_SIGNED_COMMITS=false`.

## Fejlfinding

Bliver et commit ikke signeret, så tjek hvilke indstillinger git i virkeligheden bruger, og hvor de kommer fra (`--show-origin` nævner filen), og se derefter signaturen på det seneste commit:

```bash
git config --show-origin --get commit.gpgsign
git config --show-origin --get gpg.format
git config --show-origin --get user.signingkey

git log -1 --show-signature
```

De tre indstillinger skal vise `true`, `ssh` og stien til din offentlige nøgle. En værdi fra en repository-fil (`.git/config`) tilsidesætter den globale. `git log -1 --show-signature` viser `Good "git" signature`, når commit'et er signeret, og din allowed signers-fil kender nøglen; `No principal matched` betyder, at allowed signers-filen mangler eller har en anden mailadresse (trin 3), og ingen signatur overhovedet betyder, at commit'et er lavet uden signering.

Tilbage til [SSH og tokens](SshAndTokens) eller [Fejlfinding](Troubleshooting).
