<!-- translation of SshSigning.md, source sha256 3989f5e0ebe3 -->

> Dette er en oversættelse af [`SshSigning`](SshSigning). Den engelske side er autoritativ, og ændringer her bliver overskrevet, næste gang wikien publiceres.

[English](SshSigning) | Dansk | [Bahasa Melayu](SshSigning.ms)

# Signering af commits med en SSH-nøgle

Et signeret commit bærer en signatur, der er lavet med din private nøgle. Gitea tjekker den mod de offentlige nøgler på din konto og markerer commit'et **Verified**. Det viser, at commit'et virkelig kommer fra dig. Du kan signere med den SSH-nøgle, du allerede bruger til Gitea; du behøver ikke GPG.

Repo Foundry signerer ikke noget og kræver ikke signerede commits. Denne side er til den dag, du selv vil signere, eller dit projekt kræver det.

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

`commit.gpgsign true` signerer hvert commit. Udelad den, og signér ét commit ad gangen med `git commit -S`. Brug `git config` uden `--global` inde i et repository for kun at ændre det repository.

## 2. Lad Gitea verificere signaturerne

Åbn **Settings**, **SSH / GPG Keys** i Gitea. Den offentlige nøgle, du pusher med, ligger allerede der; Gitea bruger nøglerne på din konto til at verificere SSH-signaturer. Signerer du med en anden nøgle, så læg den også her.

Mailadressen i `git config user.email` skal være en af adresserne på din Gitea-konto, ellers vises commit'et som ikke verificeret.

## 3. Tjek at det virker

```bash
git commit --allow-empty -m "Test signing"
git log --show-signature -1
```

Push en branch og se commit'et i Gitea: et grønt **Verified**-mærke betyder, at Gitea godkender signaturen.

## Bemærkninger

- Et commit lavet på en anden maskine eller af et værktøj, der ikke bruger din git-konfiguration, er ikke signeret. Sæt signering op på hver maskine, hvor du committer.
- Gitea signerer de merge-commits, den selv laver, kun hvis administratoren har sat en signeringsnøgle op for instansen.
- En branchregel, der kræver signerede commits, afviser en pull request med ét usigneret commit. Signér først, og slå så reglen til.

Tilbage til [SSH og tokens](SshAndTokens) eller [Fejlfinding](Troubleshooting).
