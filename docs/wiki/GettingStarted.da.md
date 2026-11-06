<!-- translation of GettingStarted.md, source sha256 1fe40c0e670a -->

> Dette er en oversættelse af [`GettingStarted`](GettingStarted). Den engelske side er autoritativ, og ændringer her bliver overskrevet, næste gang wikien publiceres.

[English](GettingStarted) | Dansk | [Bahasa Melayu](GettingStarted.ms)

# Kom godt i gang

## Krav

| Værktøj | Bruges til |
| --- | --- |
| bash 4.4 eller nyere | scriptet (macOS leveres med 3.2: installér først en nyere bash) |
| `git` | det lokale projekt og framework-submodulet |
| `curl` | GitHub- og Gitea-API'erne |
| `ssh` (valgfri) | SSH-kontrollen; uden den springes framework-trinnene over |
| `jq` (valgfri) | JSON-læsning; uden den bruges en lille indbygget læser |

## Installation

```bash
git clone https://git.tirsystem.com/TirSystem-BashScript/repo-foundry.git
cd repo-foundry
src/create-project.sh --help
```

Intet installeres på hele systemet: scriptet kører fra checkout'et.

## Konfiguration

Kopiér `config.env.example` til `config.env` og `.env.example` til `.env`, og angiv derefter tjenesternes adresser og tokens (se [SSH og tokens](SshAndTokens.da)). `.env` indeholder credentials og committes aldrig.

## Kørsel

Start scriptet fra den mappe, der skal indeholde det nye projekt:

```bash
src/create-project.sh            # tør kørsel: læser fra værterne, opretter intet
src/create-project.sh --apply    # opretter alt efter et sidste ja
```

Der laves ingen commit i det nye projekt. Arbejd på en branch der: frameworkets hooks afviser commits på `main`.

## Oprydning af branches

Et nyt Gitea-repository har indstillingen "Delete pull request branch after merge by default" slået til, så Gitea sletter en pull request-branch, når den er merged. Et genbrugt repository ændres ikke. Vil du slå den fra, så åbn repositoryets indstillinger i Gitea under Pull Requests.

## Beskyttelse af branch

Et nyt Gitea-repository får en regel for beskyttet branch: ingen direkte push til `main`, hver ændring kommer via en pull request. En merge blokeres også ved afviste reviews, ved officielle review-anmodninger, når pull requesten er forældet, og for administratorer; ingen nøgle slår det fra. Det nye projekts første commit går samme vej: push en branch og åbn en pull request.

Reglen sættes med fire valgfrie nøgler i `config.env` (glob-mønstre, lister adskilt af `;`): `PROTECTED_BRANCH_PATTERN` (standard `main`), `PROTECTED_FILE_PATTERNS` (standard ingen), `PROTECTED_STATUS_CHECKS` (standard `TirSystem/git-workflows: *`) og `PROTECTED_REQUIRE_SIGNED_COMMITS` (`true` eller `false`, standard `true`; `false` hvis du ikke kan signere; se [Signering af commits](SshSigning.da)). Se [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-branch-protection-optional).

Sådan giver du et eksisterende repository samme regel:

```bash
src/create-project.sh --protect OWNER/NAME           # tørkørsel: læser, ændrer intet
src/create-project.sh --protect OWNER/NAME --apply   # opretter eller ændrer reglen
```

En eksisterende regel, der afviger, ændres kun efter et ja.

## Brug det som en kommando

For at starte scriptet med `repo-foundry` fra en vilkårlig mappe lægger du et link til det i en mappe på din `PATH`. Kør dette én gang fra roden af dit checkout:

```bash
mkdir -p ~/bin
ln -s "$PWD/src/create-project.sh" ~/bin/repo-foundry
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
```

Åbn en ny terminal (eller kør `source ~/.bashrc`), og start det med `repo-foundry`. Scriptet følger linket tilbage til checkout'et og finder derfor sine egne filer, og en opdatering med `git pull` i checkout'et når kommandoen med det samme. På macOS bruger du `~/.zshrc` i stedet for `~/.bashrc`, hvis dit shell er zsh.

På Windows bruger du WSL: åbn en WSL-terminal (for eksempel Ubuntu), klon Repo Foundry i den, og kør kommandoerne ovenfor dér.
