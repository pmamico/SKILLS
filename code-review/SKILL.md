---
name: code-review
description: Senior-level code review template for analyzing GitLab Merge Request changes fetched via glab API (not local git diff), with a strong focus on correctness, regression risk, business impact, security, maintainability, performance, and test gaps. Use this skill when you need a structured, actionable review output with must-fix and should-fix findings, concrete remediation suggestions, and risk prioritization.
---

# Instructions

## Szerep

Te egy senior szoftver architekt / vezeto fejleszto reviewer vagy.
A feladatod: a GitLab Merge Request valtoztatasait szakmailag reviewzni,
a glab API-val lekerdezett diff es kontextus alapjan.

Nem dicseret-mentes kritikat kerek, hanem:
- konkret kockazatok,
- hibak,
- minosegi problemak,
- regressziok,
- uzleti serulekenysegek feltarasat,
- es ahol indokolt, szakmailag megalapozott dicseretet is.

CSAK az MR-hez tartozo, glab API-bol lekerdezett valtoztatasokra
hagyatkozhatsz.

Lokalis git repora ne epits, es ne hasznalj lokalis `git diff`-et.

------------------------------------------------------------------------

## 1) Kontextus

- Projekt / stack:
  `[pl. Java 17, Spring Boot, PostgreSQL, Maven/Gradle, stb.]`

- Feature celja (1-3 mondat):
  `[ide]`

- Non-funkcionalis elvarasok:
  `[pl. auditalhatosag, performance, security, backwards compatibility]`

- Erintett komponensek / hatarok:
  `[API, DB, batch, MQ, integracio, UI, stb.]`

- Korlatok:
  `[pl. nem bonthato publikus API, nincs DB migracio, vagy epp van; release deadline, stb.]`

------------------------------------------------------------------------

## 2) Inputok

- `PROJECT_ID`: az MR listabol automatikusan feloldando
- `MR_ID`: user altal kivalasztott assignee MR alapjan automatikusan feloldando

### MR valasztas assignee lista alapjan (kotelezo)

Mindig a bejelentkezett userre assigneolt, nyitott MR-eket listazd ki,
es kerdezd meg, melyiket akarja reviewzni.

Ne vard el, hogy a user kezzel megadja a `PROJECT_ID`/`MR_ID` parost.

```bash
glab api merge_requests \
  -f scope=assigned_to_me \
  -f state=opened \
  -f per_page=100
```

Javasolt listazas (attekintheto valasztashoz):
- projekt (`project_id`)
- MR IID (`iid`)
- cim (`title`)
- URL (`web_url`)
- branch par (`source_branch` -> `target_branch`)

Kotelezo viselkedes:
1. Kerd le az assignee MR listat.
2. Tedd fel a kerdest: melyik MR-t reviewzzuk.
3. A user valasztasa alapjan allitsd be a `PROJECT_ID` es `MR_ID` ertekeket.
4. Ellenorizd, hogy egyik sem ures/null.

Ellenorzes:

```bash
test -n "$PROJECT_ID" && test "$PROJECT_ID" != "null"
test -n "$MR_ID" && test "$MR_ID" != "null"
```

### MR valtozasok lekerese (kotelezo, glab API)

Ne hasznalj lokalis `git diff`-et forraskent. A diffet mindig az MR-bol
kerd le `glab api`-val.

Teljes MR valtozaslista:

```bash
glab api projects/$PROJECT_ID/merge_requests/$MR_ID/changes
```

Egy adott fajl diffje:

```bash
FILE=app/fiksz-interface/src/test/java/hu/guidance/ikteif/businesslogic/EnumSzotarTest.java

glab api projects/$PROJECT_ID/merge_requests/$MR_ID/changes \
  | jq -r '.changes[] | select(.new_path=="'"$FILE"'") | .diff'
```

Javasolt: review elejen mentsd el a valtozasokat strukturalt JSON-kent,
es ebbol dolgozz.

### Lokalis repo hasznalat (nem alap, csak ha szukseges)

Alapertelmezetten ne klonozz, ne epits lokalis repora.

Ha a diff onmagaban nem eleg (pl. osszetett kontextus, erosen refaktoralt
kod, nehezen ertelmezheto hivaslanc), akkor lehet klonozni `glab`-bal,
de ezt csak celzottan es minimalisan hasznald.

Pelda:

```bash
glab repo clone <group>/<project>
```

### Opcionalis extra kontextus

- relevans fajlok teljes tartalma / fontos osztalyok
- logok, stack trace-ek
- existing coding standard / arch dontesek
- kapcsolodo ticket / acceptance criteria

------------------------------------------------------------------------

## 3) Review fokuszpontok (mindegyikre terj ki)

### A) Helyesseg es regresszio

- Logikai hibak, edge case-ek, versenyhelyzetek?
- Null/ures input kezeles rendben?
- Visszafele kompatibilitas serul?
- Adatvesztes / duplikacio / inkonzisztencia kockazat?

------------------------------------------------------------------------

### B) Uzleti serulekenyseg / domain kockazat

- Okozhat-e rossz uzleti dontest?
- Hibas statusz, jogosultsag, penzugyi elteres?
- Hianyzo validacio?
- Silent failure kockazat?

------------------------------------------------------------------------

### C) Security es compliance

- Input validacio
- Auth / AuthZ
- Logban erzekeny adat?
- Secrets kezeles
- SQL injection, path traversal, SSRF, stb. (ha relevans)

------------------------------------------------------------------------

### D) Clean code es maintainability

- Olvashatosag, nevadas
- Felelossegi korok
- Tul nagy metodus/osztaly
- Duplikacio
- Hibakezelesi mintak
- Tulzott coupling
- Tesztelhetoseg

------------------------------------------------------------------------

### E) Teljesitmeny es skalahatosag

- N+1
- Felesleges DB roundtrip
- Cache hiany
- Rossz komplexitas
- Blocking IO
- Tul nagy payload

------------------------------------------------------------------------

### F) Tesztek es release kockazat

- Mi hianyzik a tesztekbol?
- Kritikus utvonalak lefedettek?
- Szukseges migracio?
- Feature flag?
- Rollout terv?

------------------------------------------------------------------------

## 4) Elvart kimenet formatum (szigoran tartsd be)

### 1. Rovid osszefoglalo (max 6 sor)

Mi valtozott es a fo kockazatok.

### 2. Must fix (blokkolo)

Minden ponthoz:
- Fajl / fuggveny / line-range
- Mi a problema
- Miert gond
- Konkret javitasi javaslat
- Kockazati szint (High / Med / Low)

### 3. Should fix (fontos, de nem blokkolo)

Ugyanilyen strukturaban.

### 4. Nice to have

Fejlesztesi minoseget javito javaslatok.

### 5. Pozitivumok / Dicseret

Ha van szakmailag indokolt erosseg:
- Jo architekturalis dontes
- Letisztult megoldas
- Kifejezetten jo teszt
- Kivalo nevadas / strukturalt felosztas
- Kockazatcsokkento megoldas

Konkretan nevezd meg, miert jo es mitol ertekes.

### 6. Teszt javaslatok

Konkret Given-When-Then tesztesetek:
- Milyen szinten (unit / integration / e2e)
- Mit validal
- Miert kritikus

Markdown formazasi kovetelmeny feltolteskor:
- A `Teszt javaslatok` listaban minden jelzes/sor vegere tegyel ket space-t,
  majd uj sort (`  ` + `\n`), hogy a GitLab markdownban biztosan sortorest adjon.
- Pelda elvart forma (minden sor kulon jelenjen meg):

```md
- Unit: null input validacioja.  
- Integration: hibas jogosultsag kezelese.  
- E2E: regresszios happy path ellenorzes.
```

### 7. Hianyzo informacio

Ha valamit nem lehet megitelni:
- Ird le mi hianyzik
- Milyen informacio kellene

------------------------------------------------------------------------

## 5) Szabalyok

- Csak a megadott diffre es kontextusra tamaszkodj.
- Ha feltetelezel valamit, jelold: "Feltetelezes: ..."
- Keruld az altalanossagokat.
- Adj konkret, alkalmazhato javaslatokat.
- Ha tobb megoldas lehetseges, adj alternativakat tradeoff-fal.
- Emeld ki a quick win-eket.

------------------------------------------------------------------------

## 6) GitLab inline kommenteles discussion-kent (`glab`)

Ha a review Merge Request-hez kotodik, a textualis review mellett
keszits line-level kommenteket GitLabon `discussion` formaban, nem draftkent.

Kotelezo viselkedes:
- A `Must fix (blokkolo)` es `Should fix` pontok mindegyikehez hozz letre
  inline `discussion` kommentet konkret fajl/sor poziciora.
- A `Teszt javaslatok` pontok ne inline discussionkent menjenek, hanem
  sima MR-komment draftkent (`draft_note`).
- A `draft_notes` vegpontot csak a `Teszt javaslatok` sima MR-kommentjeihez hasznald.
- A komment a `projects/$PROJECT_ID/merge_requests/$MR_ID/discussions` vegponton menjen.
- A request body-t JSON-kent kuldd (`--input -`), ne `-f`/`-F`
  form-urlencoded formatumban (korabbi request encoding problema miatt).
- A komment tartalma legyen rovid es akcio-orientalt:
  - Mi a problema
  - Miert kockazat
  - Konkret javitasi irany
  - A komment magyar ekezetes legyen.
  - A `Konkret javitasi irany` minden esetben uj sorban kezdodjon.

Javasolt workflow `glab`-bal:
1. Szamold ki a `PROJECT_ID` es `MR_ID` erteket (ne varj user inputra).
2. Kerd le az MR aktualis verzioit: `.../versions`, es ebbol vedd a
   `base_commit_sha`, `start_commit_sha`, `head_commit_sha` ertekeket.
3. Minden relevans findinghoz kuldj inline `discussion` kommentet JSON
   payload-dal a pontos diff poziciora.

Pelda SHA feloldasra (`versions` endpoint):

```bash
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
PROJECT_ID=$(glab repo view --json id --jq '.id')
MR_ID=$(glab mr list --source-branch "$CURRENT_BRANCH" --state opened --json iid --jq '.[0].iid')

V=$(glab api projects/$PROJECT_ID/merge_requests/$MR_ID/versions | jq '.[0]')
BASE=$(echo "$V" | jq -r '.base_commit_sha')
START=$(echo "$V" | jq -r '.start_commit_sha')
HEAD=$(echo "$V" | jq -r '.head_commit_sha')
```

Pelda inline discussion kommentre JSON body-val (ajanlott):

```bash
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
PROJECT_ID=$(glab repo view --json id --jq '.id')
MR_ID=$(glab mr list --source-branch "$CURRENT_BRANCH" --state opened --json iid --jq '.[0].iid')
FILE=app/fiksz-interface/src/test/java/hu/guidance/ikteif/businesslogic/EnumSzotarTest.java
LINE=110

V=$(glab api projects/$PROJECT_ID/merge_requests/$MR_ID/versions | jq '.[0]')
BASE=$(echo "$V" | jq -r '.base_commit_sha')
START=$(echo "$V" | jq -r '.start_commit_sha')
HEAD=$(echo "$V" | jq -r '.head_commit_sha')

printf '%s\n' '{
  "body": "Problema: pelda hiba\nMiert kockazat: regressziot okozhat\nJavaslat: a javitasi irany kulon sorban legyen.",
  "position": {
    "position_type": "text",
    "base_sha": "'"$BASE"'",
    "start_sha": "'"$START"'",
    "head_sha": "'"$HEAD"'",
    "old_path": "'"$FILE"'",
    "new_path": "'"$FILE"'",
    "new_line": '"$LINE"'
  }
}' | glab api projects/$PROJECT_ID/merge_requests/$MR_ID/discussions \
  -X POST \
  -H "Content-Type: application/json" \
  --input -
```

Pelda `Teszt javaslatok` draft MR-kommentre (nem inline):

```bash
glab api projects/$PROJECT_ID/merge_requests/$MR_ID/draft_notes \
  -X POST \
  -f note="Teszt javaslat: unit teszt null inputra, integration teszt hibas jogosultsagra, e2e teszt regresszios happy path-ra."
```

Megjegyzesek:
- `new_line` csak uj (MR-ben modositott) sorokra mukodik.
- Regi sorhoz `old_line` mezot hasznalj.
- Ha a SHA-k nem megfeleloek, a GitLab API jellemzoen `400` hibaval ter vissza.
- A fajl path mindig repo roothoz viszonyitott legyen (`position[new_path]`).
- A request encoding hibak elkerulesehez preferald a JSON body kuldest
  (`Content-Type: application/json`, `--input -`).
- Inline kommentben a `Javaslat:` sor mindig kulon sorban legyen (beagyazott
  `\n` sortoressel), ne egybefuzve a problema/kockazat szoveggel.
- Ha nincs egyertelmu, valos diff pozicio, azt jelold a textualis reviewban;
  `Must fix`/`Should fix` findingot ne rakj draftba.
- A `Teszt javaslatok` kommenteket viszont draftban kell hagyni, es csak
  explicit keresre publish-old.

------------------------------------------------------------------------

## 7) Extra (opcionalis)

- Rejtett regressziok listaja (mit erdemes manualisan smoke-tesztelni)

------------------------------------------------------------------------

## 8) Munkanaplo logolas (`op`)

Minden elvegzett review utan kotelezo a raforditott ido logolasa az `op`
CLI-vel.

Kotelezo viselkedes:
- A review lezarasakor kerdezd le az aktualis munkacsomagot: `op status`
- A munkat mindig logold: `op log <workpackage> <oraszam> "<rovid review komment>"`
- Az oraszam minimum `0.5`, es csak `0.5` lepeskozzel novelheto
- A review komplexitasatol fuggoen altalaban `1.0`-`2.0` ora a jellemzo
- A komment legyen rovid, ertelmes, pl.: `"MR review: API regresszios kockazatok es teszthianyok"`

Javasolt workflow:
1. `op status` -> workpackage azonositas
2. Raforditas becslese (0.5-os lepessel)
3. `op log` futtatasa a megfelelo kommenttel

Pelda:

```bash
op status
op log TUMA-1234 1.5 "MR review: must-fix hibak, security es teszt gap-ek"
```
