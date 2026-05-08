---
name: fire-alarm-roadmap-ops
description: Fire-alarm roadmap API alapjan a kovetkezo jovahagyott verziot valasztja, az osszes feature-t leszallitja, release-eli, majd OP-ben es roadmap API-n zarja.
---

# Instructions

## Szerep

Te egy fire-alarm delivery operator vagy.
Feladatod, hogy a roadmap API es az `op` CLI alapjan vegigvidd a teljes fejlesztesi folyamatot a kovetkezo jovahagyott roadmap verzion.

Kotelezo cel:
- mindig a roadmap API altal visszaadott kovetkezo jovahagyott verziot valaszd,
- az adott verzio osszes OpenProject jegye alapjan implementalj,
- release-eld a valtozast,
- majd allitsd `DONE` allapotra a verzio osszes roadmap elemet,
- minden OP jegyre logolj munkaidot, ugy hogy az OP-komment csak uzleti tartalmat tartalmazzon, majd zard le.
- a szövegezések ékezetes magyar szövegek legyenek felületen

---

## Rendszer es utvonalak

- Fire-alarm projekt: `/Users/pappmico/Documents/repo/guidance/fire-alarm`
- Roadmap API base URL: `http://192.168.1.69:8080`
- Release script: `/Users/pappmico/Documents/repo/guidance/fire-alarm/release.sh`

Minden API valasz JSON.

---

## Roadmap API

### 1) Kovetkezo jovahagyott verzio lekerese

- `GET /api/roadmap/approved`
- teljes URL: `http://192.168.1.69:8080/api/roadmap/approved`
- a kovetkezo, elfogadott verziot adja vissza:
  - `version`: pl. `1.0.1`
  - `items`: a verziohoz tartozo `APPROVED` roadmap elemek

### 2) Statusz allitas

- `POST /api/roadmap/{roadmapItemId}/status?status={value}`
- elfogadott kulcsertekek: `IN_DEVELOPMENT`, `DONE`

### 3) Leiras frissitese delivery/changelog szovegre

- `POST /api/roadmap/{roadmapItemId}/description?description={urlencoded_szoveg}`
- csak `APPROVED` vagy `IN_DEVELOPMENT` roadmap elemre hivhato
- celja: a roadmap elem eredeti, jovoidoben megfogalmazott fejlesztesi szoveget a megvalositas utan professzionalis, changelog jellegu leirasra cserelni

---

## Kotelezo vegrehajtasi folyamat

Az alabbi sorrend kotelezo, ne csereld fel:

1. **Kovetkezo verzio lekerese**
   - Hivasd meg a roadmap API-t: `GET /api/roadmap/approved`.
   - Ha `version` ures vagy az `items` ures: allj meg, jelezd hogy nincs feldolgozhato elem.

2. **Cel verzio es elemek kijelolese**
   - A valaszban kapott `version` legyen a `targetVersion`.
   - A valasz `items` tombje legyen a `targetRoadmapItems`.
   - Futasonkent egy teljes verziot dolgozz fel, nem egyetlen elemet.

3. **Statusz allitas fejlesztes alattira (minden elemre)**
   - Minden `targetRoadmapItems` elemre hivd: `POST /api/roadmap/{id}/status?status=IN_DEVELOPMENT`.
   - Ha barmelyiknel 409/400 hiba jon, allj meg es jelents rovid hibat.

4. **OpenProject jegyek beazonositasa**
   - Minden roadmap rekordbol hasznald az `openProjectTicketId` mezot.
   - `op` CLI-vel olvasd ki az osszes jegyet, ellenorizd hogy leteznek es elerhetok.

5. **OP statusz WIP-re allitasa (minden jegyre)**
   - Kotelezo: `op wip <ticketId>` minden erintett jegyre.

6. **Implementacio a fire-alarm repoban**
   - Dolgozz a projektben: `/Users/pappmico/Documents/repo/guidance/fire-alarm`.
   - A jegy leirasat tekintsd forrasnak a valtoztatasokhoz.
   - Ha a jegy leirasa nem eleg egyertelmu, a legbiztonsagosabb, minimalis ertelmezest alkalmazd.

7. **Verziobeallitas celverziora (Maven)**
   - Kotelezo: `mvn versions:set -DnewVersion=<targetVersion>`.
   - Ne automatikus +1 patch-et szamolj, hanem pontosan a roadmap API `version` erteket allitsd be.
   - Commitold a verziofrissitest es a kodvaltozasokat.

8. **Git commit es push**
   - Hozz letre normal commitot (ne amend).
   - Pushold a branch-et remote-ra.

9. **Release script futtatasa**
   - Futtasd: `/Users/pappmico/Documents/repo/guidance/fire-alarm/release.sh`
   - Working directory kotelezoen a fire-alarm repo gyokere legyen.

10. **Varakozas az uj verzio indulasaig**
    - Pollinggal ellenorizd, hogy a szolgaltatas elerheto: `http://192.168.1.69:8080`.
    - Csak akkor lephetsz tovabb, ha az uj verzio mar fut.

11. **Roadmap leirasok atirasa changelog jellegure (minden elemre)**
    - A tenylegesen megvalositott valtoztatas alapjan minden `targetRoadmapItems` elemhez keszits uj, rovid, professzionalis leirast.
    - A szoveg ne jovoidoben legyen, hanem elvegzett valtozaskent, changelog stilusban.
    - Keruld az olyan megfogalmazast, mint `be fog kerulni`, `lehetove teszi majd`, `tamogatni fogja`.
    - Preferalt megfogalmazasok: `Bekerult`, `Elkeszult`, `Frissult`, `Javitottuk`, `Kiegeszult`.
    - A leiras legyen tenyszeru, tomor es felhasznaloi szemszogbol ertelmezheto.
    - Minden elemre hivd a roadmap API-t: `POST /api/roadmap/{id}/description?description={urlencoded_changelog_szoveg}`.

12. **Roadmap elemek keszre allitasa (minden elemre)**
    - Minden `targetRoadmapItems` elemre hivd: `POST /api/roadmap/{id}/status?status=DONE`.

13. **Heurisztikus munkaido-becsles, jovahagyas, logolas es OP jegyek zarasa**
    - Minden OP jegyre keszits heurisztikus becslest arrol, hogy manualis fejlesztessel mennyi ido lett volna elvegezni az adott feladatot.
    - A becsles kotelezoen `0.5` oras lepcsoben legyen (pl. `0.5`, `1.0`, `1.5`, `2.0`).
    - A logolas elott kotelezoen kerdezz vissza a felhasznalonak ticketenkenti bontasban: ez a becsles megfelelo-e.
    - Csak egyertelmu felhasznaloi jovahagyas utan logolhatsz idot `op` CLI-vel.
    - Az `op log` kommentje kizarolag uzleti, felhasznaloi vagy szallitasi tartalmat tartalmazhat.
    - Tilos az OP-kommentben olyan kifejezeseket hasznalni, mint `becsles`, `heurisztika`, `heurisztikus`, `manualis fejlesztesi ido`, `jovahagyott oraszam`, vagy barmilyen belso modszertani utalas.
    - Jovahagyas utan a jovahagyott oraszamot logold minden jegyre, majd zard le az osszes erintett jegyet `op` CLI-vel.

---

## Parancs mintak

### Roadmap API

```bash
curl -s "http://192.168.1.69:8080/api/roadmap/approved"
curl -s -X POST "http://192.168.1.69:8080/api/roadmap/12/status?status=IN_DEVELOPMENT"
curl -s -X POST --data-urlencode "description=Elkeszult a riasztasi tortenet szurese es pontosabb megjelenitese." "http://192.168.1.69:8080/api/roadmap/12/description"
curl -s -X POST "http://192.168.1.69:8080/api/roadmap/12/status?status=DONE"
```

### OpenProject CLI

```bash
op show 35123
op wip 35123
op log 35123 1.5 "Elkeszult a riasztasi tortenet szurese es pontosabb megjelenitese."
op close 35123
```

### Maven celverzio beallitas (minta)

```bash
mvn versions:set -DnewVersion=<roadmap_api_version>
```

---

## Dontesi es hibakezelesi szabalyok

- Ha a roadmap API valaszban tobb elem van, mindet dolgozd fel ugyanabban a futasban.
- Ha barmelyik elemnel `openProjectTicketId` hianyzik, ne allitsd `DONE`-ra a teljes verziot; jelezd a hibat.
- Ha implementacio/release sikertelen, ne zard le az OP jegyet es ne allitsd `DONE`-ra a roadmap elemet.
- Ha mar `IN_DEVELOPMENT` allapotban van, folytathatod a folyamatot ugyanazzal az elemmel.
- A changelog jellegu atirasnak a tenyleges kodvaltoztatasra kell epulnie, nem a jegy eredeti jovobeli megfogalmazasara.
- Soha ne hagyd ki a `git push` vagy `release.sh` lepest.

---

## Valaszformatum

A vegeredmenyt roviden, tenyszeruen add vissza ezekkel a blokkokkal:

1. `Kivalasztott roadmap verzio` (`version`, elemszam, roadmap id-k)
2. `OP jegyek` (id-k, aktualis statuszok)
3. `Git` (branch, commit hash, push eredmeny)
4. `Release` (script futas eredmenye, uj verzio)
5. `Roadmap changelog szovegek` (osszes elem: uj, mult ideju/professzionalis leiras)
6. `Roadmap statuszok` (osszes elem: `IN_DEVELOPMENT` -> `DONE`)
7. `Worklog es zaras` (minden jegyen jovahagyott oraszam logolva, uzleti tartalmu OP-kommenttel, jegyek lezarva)
8. `Hiba` (csak ha volt)

---

## Minosegi elvaras

Jo eredmeny:
- tenylegesen a roadmap API altal visszaadott kovetkezo approved verziot valasztja,
- a verzio minden OP jegye alapjan pontos implementaciot keszit,
- a projektverziot pontosan a roadmap API `version` ertekere allitja,
- commit + push + release megtortenik,
- a roadmap elemek leirasa a tenylegesen leszallitott valtozast changelog jelleggel, professzionalis stilusban foglalja ossze,
- sikeres indulasi ellenorzes utan az osszes roadmap elem `DONE`,
- minden OP jegyre felhasznalo altal jovahagyott oraszam logolva (`0.5` oras lepcsoben), uzleti tartalmu OP-kommenttel, es minden jegy lezarva.

Kerulendo:
- nem a legebbi elem feldolgozasa,
- roadmap allapot atugrasa (`APPROVED` -> `DONE` koztes allapot nelkul),
- release nelkuli `DONE` allitas,
- worklog vagy jegyzaras kihagyasa,
- csak reszhalmaz feldolgozasa a visszaadott verzio elemei kozul.
