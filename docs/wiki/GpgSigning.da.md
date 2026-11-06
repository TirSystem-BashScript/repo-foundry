<!-- translation of GpgSigning.md, source sha256 9847249f0b97 -->

> Dette er en oversættelse af [`GpgSigning`](GpgSigning). Den engelske side er autoritativ, og ændringer her bliver overskrevet, næste gang wikien publiceres

[English](GpgSigning) | Dansk | [Bahasa Melayu](GpgSigning.ms)

# En GPG-nøgle, så Gitea kan signere merge commits

Denne side er til **administratoren** af Gitea-serveren. Repo Foundrys branchregel kræver som standard signerede commits. Dine egne commits signeres med din SSH-nøgle (se [Signering af commits](SshSigning)), men et merge i Gitea's webgrænseflade, en rettelse i webeditoren og det første commit i et nyt repository laver **Gitea selv**. Gitea signerer dem kun, hvis serveren har en signeringsnøgle. Uden den afviser reglen merge, eller merge fejler med `gpg failed to sign the data`.

Du skal gøre fem ting: lave en nøgle, lægge dens offentlige halvdel i Gitea, fortælle Gitea at den skal bruges, give Gitea den hemmelige halvdel og teste.

## 1. Lav nøglen

Gør det på en maskine, du stoler på, med GnuPG 2.2 eller nyere. Nøglen er til serveren, så den har **ingen passphrase** (Gitea kan ikke taste en) og udløber ikke. Brug e-mailadressen på en Gitea-konto, normalt din egen, så Gitea kan knytte nøglen til kontoen.

```bash
gpg --batch --pinentry-mode loopback --passphrase '' \
  --quick-generate-key "Gitea Signing <you@example.com>" rsa4096 sign never
```

Find nøgle-id'et. Det er de sidste 16 tegn af fingeraftrykket:

```bash
gpg --list-secret-keys --keyid-format long you@example.com
```

I outputtet viser `sec   rsa4096/0123456789ABCDEF` nøgle-id'et `0123456789ABCDEF`. Eksemplerne herunder bruger det; brug dit eget.

En nøgle med passphrase fejler, når Gitea signerer. Brugte du en eksisterende nøgle, så fjern passphrasen: `gpg --edit-key 0123456789ABCDEF`, så `passwd`, og lad begge felter stå tomme.

## 2. Læg den offentlige nøgle i Gitea

Skriv den offentlige nøgle ud:

```bash
gpg --armor --export 0123456789ABCDEF
```

Åbn dine indstillinger i Gitea, **SSH / GPG Keys**, klik **Add Key** ved **Manage GPG Keys**, indsæt hele blokken (fra `-----BEGIN PGP PUBLIC KEY BLOCK-----` til `-----END PGP PUBLIC KEY BLOCK-----`) og klik **Add Key**. Siden er `https://din-gitea/user/settings/keys`.

![Trin 2: formularen Manage GPG Keys med feltet Content og knappen Add Key](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-gpg-1-add-key.png)

Nøglen skal stå som **Verified Key** med din e-mailadresse under **Matched Identities**. Gitea sammenligner nøglens e-mailadresse med en adresse på din konto, som du har bekræftet. Står den som ikke verificeret, så tjek, at nøglens e-mailadresse er bekræftet under **Settings, Account**. Viser Gitea en knap **Verify**, så klik på den og signér det token, Gitea viser:

```bash
echo -n 'TOKENET-FRA-GITEA' | gpg -a --default-key 0123456789ABCDEF --detach-sig
```

Indsæt hele den blok, kommandoen skriver, i feltet og bekræft.

![Trin 2: GPG-nøglen vist som Verified Key, med den matchede identitet og nøgle-id'et](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/raw/branch/main/docs/wiki/img/gitea-gpg-2-verified-key.png)

## 3. Fortæl Gitea at den skal bruge nøglen

Tilføj i `app.ini` (i Docker `/data/gitea/conf/app.ini`):

```ini
[repository.signing]
SIGNING_KEY = 0123456789ABCDEF
SIGNING_NAME = Gitea Signing
SIGNING_EMAIL = you@example.com
MERGES = pubkey, twofa, approved, always
```

`SIGNING_EMAIL` skal være nøglens e-mailadresse og en bekræftet adresse på den konto, der har den offentlige nøgle; ellers bliver commit signeret, men ikke markeret **Verified**. `MERGES` siger, hvornår Gitea signerer et merge commit; `always` signerer alle. Det første commit i et nyt repository signeres som standard (`INITIAL_COMMIT`).

## 4. Giv Gitea den hemmelige nøgle

Det er det trin, der let overses. Den offentlige nøgle i din profil er ikke nok: `gpg` på serveren skal bruge den **hemmelige** nøgle, i den nøglering, som Gitea's `git` læser. Gitea kører `git` med `HOME` sat til sin egen hjemmemappe, `[git] HOME_PATH` (standard `data/home`, i Docker `/data/gitea/home`), så `gpg` læser `HOME_PATH/.gnupg`. En nøgle i `git`-brugerens almindelige nøglering, eller i roots, bliver ikke fundet: fejlen er `gpg: skipped "0123456789ABCDEF": No secret key`.

Docker (imaget har ikke `sudo`; `su-exec` kører en kommando som `git`):

```bash
# nøgleringen hos nøglens ejer -> den nøglering, Gitea læser
gpg --export-secret-keys 0123456789ABCDEF | docker exec -i -u git gitea sh -c \
  'mkdir -p /data/gitea/home/.gnupg && chmod 700 /data/gitea/home/.gnupg && GNUPGHOME=/data/gitea/home/.gnupg gpg --import'
```

Uden Docker kører du importen som den bruger, der kører Gitea, med `GNUPGHOME` sat til `HOME_PATH/.gnupg`. Lad ikke en fil med den hemmelige nøgle ligge på serveren; pipen ovenfor laver ingen.

Tjek, at nøglen ligger i den rigtige nøglering, og at den kan signere uden passphrase:

```bash
docker exec -u git gitea sh -c 'GNUPGHOME=/data/gitea/home/.gnupg gpg --list-secret-keys'
docker exec -u git gitea sh -c 'echo test | GNUPGHOME=/data/gitea/home/.gnupg gpg --batch --yes --clearsign -u 0123456789ABCDEF'
```

Den anden kommando skriver en blok, der starter med `-----BEGIN PGP SIGNED MESSAGE-----`.

## 5. Test det

Merge en pull request i webgrænsefladen. Merge commit får mærket **Verified**. På pull requesten skriver Gitea `This commit will be signed with key "0123456789ABCDEF"` over merge-knappen. Vil du teste uden en pull request, så opret et nyt repository med en licens: dets første commit signeres af serveren og fejler med det samme, hvis nøglen mangler.

## Virker det ikke

| Det du ser | Årsag og løsning |
| --- | --- |
| `gpg: skipped "…": No secret key` | Den hemmelige nøgle ligger ikke i den nøglering, Gitea læser. Importér den med `GNUPGHOME=HOME_PATH/.gnupg` (trin 4). |
| `gpg: signing failed: Inappropriate ioctl` eller en forespørgsel om passphrase | Nøglen har en passphrase. Fjern den (trin 1). |
| Commit er signeret, men ikke **Verified** | Den offentlige nøgle ligger ikke på kontoen, eller dens e-mailadresse (og `SIGNING_EMAIL`) er ikke en bekræftet adresse på kontoen. |
| `gpg: command not found` | Installér GnuPG i imaget eller på serveren, og genstart Gitea. |
| Intet ændrer sig efter rettelsen af `app.ini` | Genstart Gitea. |

Kan du ikke signere på serveren, så slå reglen fra for nye repositories med `PROTECTED_REQUIRE_SIGNED_COMMITS=false` i `config.env`, og den samme værdi for et eksisterende repository med `--protect`.

Tilbage til [Signering af commits](SshSigning.da) eller [Fejlfinding](Troubleshooting.da).
