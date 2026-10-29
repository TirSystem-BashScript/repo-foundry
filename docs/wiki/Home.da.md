<!-- translation of Home.md, source sha256 3affc71fbc28 -->

> Dette er en oversættelse af [`Home`](Home). Den engelske side er autoritativ, og ændringer her bliver overskrevet, næste gang wikien publiceres.

[English](Home) | Dansk | [Bahasa Melayu](Home.ms)

# Repo Foundry

Repo Foundry (`src/create-project.sh`) er et Bash-script, der opretter et nyt projekt i én kørsel, på samme måde hver gang.

## Formål

Repo Foundry findes for at:

- **oprette repositories ensartet.** Hvert projekt får samme opbygning, samme remotes, samme licensregler og samme framework-opsætning, uanset hvem der kører det og hvornår;
- **gøre det hurtigt og gentageligt at oprette et projekt.** Én kommando og nogle få svar erstatter en tjekliste, og svar du ofte giver kan gemmes i `config.env`, så de ikke spørges om igen;
- **holde credentials sikre.** Tokens ligger i en `.env`-fil eller indtastes, når der spørges. De lægges aldrig i en remote, på en kommandolinje, i en log eller i en fejlmeddelelse;
- **vise før det gør.** Det udskriver først en plan og opretter intet, før du angiver `--apply` og svarer ja;
- **lade hvert projekt starte under frameworket.** SQA-QC-Framework (tjeklister, skills, git-hooks og skabeloner) er en del af projektet fra første minut og ikke noget, der tilføjes senere.

## Hvad én kørsel opretter

- et **Gitea**-repository, som er den autoritative kilde, med den licens der gælder for projektet;
- eventuelt et tomt **GitHub**-repository, der får alt via et push-spejl fra Gitea, så du kun pusher ét sted;
- et **lokalt projekt** med én remote uden credentials, `origin`, og SQA-QC-Framework som git-submodul, med dets skills, git-hooks og skabeloner installeret. De filer det installerer (`.claude`, `.agents` og `AGENTS.md`) er udelukket fra git i det nye projekt.

Der laves ingen commit i det nye projekt. Du gennemgår det og arbejder derefter på en branch.

> **Adgang til frameworket.** SQA-QC-Framework er ophavsretligt beskyttet, og du har ikke adgang til det som standard. Kontakt [Jens Tirsvad](https://www.linkedin.com/in/tirsvad74/) for at få adgang. En hjemmeside med vores kontaktoplysninger kommer på <https://www.tirsystem.com>.

## Sådan virker det

1. Du starter scriptet fra den mappe, der skal rumme projektet. Det spørger om repositoryets navn, beskrivelse, synlighed og ejer (en bruger eller en organisation, særskilt på hver vært) og om GitHub skal bruges.
2. Det tjekker begge værter med skrivebeskyttede forespørgsler og udskriver en **plan**: hvad det vil oprette, hvor, og med hvilke indstillinger.
3. Uden `--apply` sker der ikke mere. Med `--apply` spørger det "Create these now" (standard nej) og opretter derefter repositories, spejl, lokalt projekt og framework i en fast rækkefølge.
4. Hvis et trin fejler, siger rapporten hvad der findes nu, og hvad du skal gøre. En kørsel du starter igen genbruger det, der allerede findes, og spørger før den rører en eksisterende mappe eller fil.

Det sletter aldrig noget, og intet overskrives uden et ja.

## Hvem det er til

En vedligeholder eller et lille team, der starter flere projekter og vil have dem til at se ud og opføre sig ens: de samme værter, det samme spejl, de samme tjek og den samme arbejdsgang fra første commit.

## Sider

| Side | Hvad den dækker |
| --- | --- |
| [Kom godt i gang](GettingStarted.da) | Krav, installation og første kørsel |
| [SSH og tokens](SshAndTokens.da) | SSH-adgang til Gitea og de to adgangstokens |
| [Adgangstokens](AccessTokens.da) | Opret adgangstokens trin for trin med billeder |
| [Opdatering af frameworket](UpdatingTheFramework.da) | Hold et projekts framework-submodul opdateret |
| [Fejlfinding](Troubleshooting.da) | Almindelige fejl og hvad du skal gøre |
| [Appendiks](Appendix.da) | Links til al projektdokumentation i `docs/` |

Den fulde reference (konfigurationsfiler, sikkerhedsbeslutninger, fejlhåndtering, kendte begrænsninger) er [README](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/src/branch/main/README.md).
Meld et problem som en [issue](https://git.tirsystem.com/TirSystem-BashScript/repo-foundry/issues).
