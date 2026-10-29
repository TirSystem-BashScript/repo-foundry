<!-- translation of SshPassphrase.md, source sha256 b16dd69274a5 -->

> Dette er en oversættelse af [`SshPassphrase`](SshPassphrase). Den engelske side er autoritativ, og ændringer her bliver overskrevet, næste gang wikien publiceres.

[English](SshPassphrase) | Dansk | [Bahasa Melayu](SshPassphrase.ms)

# SSH-nøgler med adgangskode

Repo Foundry spørger aldrig om en adgangskode. Det kører `ssh` og `git` uden nogen prompt (`BatchMode`), så en kørsel aldrig kan hænge på et spørgsmål, og ingen adgangskode passerer gennem det. En nøgle, der er beskyttet af en adgangskode, virker derfor kun, når den allerede er indlæst i en **SSH-agent**, et lille program der holder den oplåste nøgle til din session.

## Hvad du ser, når nøglen ikke er indlæst

- planen siger `SSH test: failed`, og den lokale `origin`-remote bruger HTTPS i stedet for SSH;
- framework-trinnene kræver SSH, så scriptet spørger, om det skal fortsætte uden frameworket.

Der er ikke noget galt med nøglen. Indlæs den i agenten og kør scriptet igen.

## 1. Indlæs nøglen i agenten

Brug den nøgle, du har lagt ind i din Gitea-konto. Eksemplerne bruger `~/.ssh/id_ed25519`.

**Linux og Git Bash på Windows** (agenten lever, så længe denne terminal er åben):

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

**macOS** (nøglering husker adgangskoden):

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

**Windows med OpenSSH-agenttjenesten** (PowerShell som administrator, én gang; tjenesten starter derefter med Windows):

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

`ssh-add` spørger om adgangskoden én gang. Skriv den dér, i din egen terminal, ikke i en fil eller på en kommandolinje.

## 2. Tjek at det virker

```bash
ssh-add -l
ssh -p 10022 -T git@git.tirsystem.com
```

`ssh-add -l` viser den indlæste nøgle. Den anden kommando skal sige, at du er godkendt (Gitea giver ikke shell-adgang).

## 3. Kør Repo Foundry fra samme terminal

Agenten findes via miljøvariabler i den terminal, hvor den blev startet, så start `src/create-project.sh` fra den terminal. Et nyt terminalvindue kræver `ssh-add` igen, medmindre agenten kører som tjeneste (Windows) eller i nøgleringen (macOS).

Hvis `ssh-add -l` viser nøglen, men SSH-testen stadig fejler, kan `ssh` i din terminal og den `ssh`, som Git bruger, være to forskellige programmer (Git for Windows har sin egen). Tjek med `which ssh` i Git Bash, og brug agenten til den `ssh`.

## En anden måde

Lav en særskilt nøgle uden adgangskode, som kun bruges til dette, og læg den ind i din Gitea-konto. Så er ingen agent nødvendig, men enhver, der får filen, får adgang, så hold filen privat (`chmod 600`) og slet nøglen i Gitea, hvis maskinen går tabt.

Tilbage til [SSH og tokens](SshAndTokens.da) eller [Fejlfinding](Troubleshooting.da).
