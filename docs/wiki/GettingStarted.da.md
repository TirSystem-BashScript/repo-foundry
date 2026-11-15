<!-- translation of GettingStarted.md, source sha256 6f58bcedcf67 -->

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

Et nyt Gitea-repository får en regel for beskyttet branch, og en anden når `PROTECTED_WORKFLOW_PATTERN` er sat. Hovedreglen forbyder direkte push til `main`: hver ændring kommer via en pull request. Begge regler blokerer en merge ved afviste reviews, ved officielle review-anmodninger, når pull requesten er forældet, og for administratorer; ingen nøgle slår det fra. Workflow-reglen, der kun laves når `PROTECTED_WORKFLOW_PATTERN` er sat (for eksempel `release/**`), kræver desuden status checks. Gitea anvender én regel pr. branch, så de to mønstre må ikke ramme samme branch. Det nye projekts første commit går samme vej: push en branch og åbn en pull request.

Reglen sættes med fem valgfrie nøgler i `config.env` (glob-mønstre, lister adskilt af `;`): `PROTECTED_BRANCH_PATTERN` (standard `main`), `PROTECTED_WORKFLOW_PATTERN` (standard ingen, ingen workflow-regel), `PROTECTED_FILE_PATTERNS` (standard ingen), `PROTECTED_STATUS_CHECKS` (standard `TirSystem/git-workflows: Validate / *;TirSystem/git-workflows: Release / *;TirSystem/git-workflows: OpenGrep / *`) og `PROTECTED_REQUIRE_SIGNED_COMMITS` (`true` eller `false`, standard `true`; `false` hvis du ikke kan signere; se [Signering af commits](SshSigning.da)). Se [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-branch-protection-optional).

Sådan giver du et eksisterende repository samme regel:

```bash
src/create-project.sh --protect OWNER/NAME           # tørkørsel: læser, ændrer intet
src/create-project.sh --protect OWNER/NAME --apply   # opretter eller ændrer reglen
```

En eksisterende regel, der afviger, ændres kun efter et ja.

## Projektnavn

Et projekts navn er også navnet på dets Gitea- og GitHub-repository og som standard på dets mappe. Det er `kebab-case`, medmindre du siger andet: små bogstaver og cifre i ord, der er forbundet med enkelte bindestreger, for eksempel `my-app`. Et navn som `My_App` afvises, kebab-case-formen (`my-app`) foreslås, og du bliver spurgt igen.

Vil du beholde en anden skrivemåde, så sæt `PROJECT_NAME_STYLE=any` i `config.env` (valgfri; `kebab-case` er standard). Så gælder værternes regler for repository-navne: bogstaver, cifre, `.`, `_` og `-`. Et `PROJECT_NAME` i `config.env`, der ikke er kebab-case, stopper kørslen, medmindre stilen er `any`. Navnet på et eksisterende repository (`--protect OWNER/NAME`) kontrolleres aldrig. Se [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md#configenv-project-details-optional).

## Licens

Licensen på et nyt projekt er `PROJECT_LICENSE` i `config.env` (valgfri): en Gitea-licensnøgle som `AGPL-3.0` eller `MIT`, eller `none` for ingen licens. Sådan ser du de nøgler, din Gitea-server tilbyder:

```bash
src/create-project.sh --list-licenses     # én licensnøgle pr. linje; læser kun
```

Maintainerens server tilbyder 30 nøgler; de står som kommentar i `config.env.example`.

## Brug det som en kommando

For at starte scriptet med `repo-foundry` fra en vilkårlig mappe lægger du et link til det i en mappe på din `PATH`. Kør dette én gang fra roden af dit checkout:

```bash
mkdir -p ~/bin
ln -s "$PWD/src/create-project.sh" ~/bin/repo-foundry
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
```

Åbn en ny terminal (eller kør `source ~/.bashrc`), og start det med `repo-foundry`. Scriptet følger linket tilbage til checkout'et og finder derfor sine egne filer, og en opdatering med `git pull` i checkout'et når kommandoen med det samme. På macOS bruger du `~/.zshrc` i stedet for `~/.bashrc`, hvis dit shell er zsh.

På Windows bruger du WSL: åbn en WSL-terminal (for eksempel Ubuntu), klon Repo Foundry i den, og kør kommandoerne ovenfor dér.
