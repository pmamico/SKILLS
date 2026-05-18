---
name: robotframework-atdd-playwright
description: Use when writing or preparing Robot Framework tests, Robot test scenarios, `.robot` suites, or Playwright-based Robot automation. Start from ATDD-style business-readable `.robot` scenario files in Hungarian, then implement with Robot Framework Browser library, Page Object Model, separate page representations, and structured reusable keywords.
---

# Robot Framework ATDD Playwright

## Purpose

Keszit es elokeszit Robot Framework teszteket ugy, hogy eloszor uzletileg ertheto, magyar nyelvu `.robot` forgatokonyvek szuletnek, majd ezek validalasa utan keszul el a technikai implementacio Robot Framework es Playwright alapokon.

## Trigger

Hasznald ezt a skillt, amikor a feladat Robot Framework tesztiras, teszt elokeszites, `.robot` fajlok letrehozasa, ATDD alapu tesztforgatokonyv-iras, vagy Playwright alapu Robot implementacio.

Kulonosen akkor aktiv, ha a user ilyesmit ker:

- Robot Framework tesztet kell irni.
- Nincs meg tesztforgatokonyv vagy leirofajl.
- A forgatokonyvet eloszor uzleti nyelven kell megfogalmazni.
- A megoldasnak Page Object Model alapu szerkezetet kell kovetnie.
- A megvalositasnak Playwright alapu Robot kornyezetben kell futnia.

## Core Principle

Az ATDD szemlelet szerint a legfontosabb artefaktum a felhasznaloi, uzletileg ertheto leiras. A technikai implementacio csak a jovahagyott forgatokonyv utan kezdodik.

## Required Workflow

1. Ellenorizd, hogy van-e mar tesztforgatokonyv, specifikacio, leirofajl vagy elfogadasi feltetel.
2. Ha nincs, eloszor keszits `.robot` fajlba irott forgatokonyvet.
3. A forgatokonyv uzletileg ertheto, magyar nyelvu, lepesenkenti leiras legyen.
4. A forgatokonyv suite-onkent strukturalt legyen, az uzleti helyzetek es esetek jol elkulonuljenek.
5. Ebben a fazisban ne irj technikai megvalositast.
6. Kerd vagy vard meg a user validalasat, illetve vezesd vegig a javitasi kort.
7. Csak a jovahagyott `.robot` forgatokonyv utan implementald a futtathato teszteket.
8. Az implementaciot Robot Framework + Playwright alapon keszitsd el.
9. Oldalankent kulon Page Object reprezentaciot hozz letre.
10. A keywordok kulon, rendezett rendszerben legyenek, kozos alappal es ujrafelhasznalhato szerkezettel.
11. A Python kornyezet minden esetben `.venv` alatt legyen kezelve.
12. Minden Python fuggoseg keruljon bele `requirements.txt`-be.
13. A `README.md` mindig irja le, hogyan kell a `.venv`-t letrehozni, a fuggosegeket telepiteni, a Browser/Playwright kornyezetet inicializalni, es a teszteket futtatni.

## Phase 1: Scenario Authoring Rules

Amikor a forgatokonyv keszul, az alabbi szabalyok kotelezoek:

- A kimenet `.robot` fajl legyen.
- A szoveg magyar nyelvu legyen.
- A leiras uzletileg ertheto legyen.
- Lepesenkenti, olvashato forma kell.
- Hasonlitson uzleti folyamatleirasra.
- Latszodjon a suite, scenario es eset struktura.
- Ne legyen benne Given, When, Then.
- Ne legyen benne angol kulcsszo.
- Ne legyen benne XPath.
- Ne legyen benne technikai zargon, fejlesztoi vagy automatizalasi nyelv.
- Ne szivargasd be ebbe a fazisba az implementacios reszleteket.

## Phase 1 Output Style

Az elso fazis kimenete egy olyan `.robot` fajl, amely:

- suite-okba rendezi az uzleti folyamatokat,
- tesztesetenkent bemutatja a helyzetet es az elvart eredmenyt,
- emberileg olvashato marad technikai tudas nelkul is,
- kesobb egyertelmuen lekovetheto az implementacios retegre.

Hasznald mintanak a `references/scenario-template.robot` fajlt.

## Phase 2: Implementation Rules

Miutan a forgatokonyv jovahagyott:

- A megvalositas Robot Framework alapokon keszuljon.
- Playwright alapu konyvtarat hasznalj, alapertelmezetten `robotframework-browser` csomaggal.
- A projekt Python virtualis kornyezete `.venv` legyen.
- A csomagfuggeseket `requirements.txt` rogzitse.
- A dokumentaciot `README.md` tartalmazza.

## Implementation Architecture

Kovetendo szerkezet:

```text
projekt/
  README.md
  requirements.txt
  .venv/
  tests/
    scenarios/
      ... uzletileg ertheto .robot suite-ok ...
    suites/
      ... futtathato .robot suite-ok ...
  resources/
    pages/
      ... oldalankenti resource vagy python page objektumok ...
    keywords/
      common.resource
      business.resource
      ... tematikus keyword fajlok ...
  libraries/
    base/
      base_page.py
      base_keywords.py
    pages/
      ... oldal specifikus python osztalyok ...
    keywords/
      ... oroklodesre epulo keyword konyvtarak ...
```

## Page Object Model Guidance

- Minden fontos oldal vagy kepernyo kulon reprezentaciot kapjon.
- Az oldal reprezentacio csak az adott oldal viselkedeseert es elemeiert feleljen.
- A kozos muveletek kozos alapretegbe keruljenek.
- Az oldalak kozotti ujrafelhasznalas ne masolas legyen, hanem kozos alap vagy jol elhatarolt segitok.

## Keyword Structure Guidance

- Minden lenyeges uzleti muvelethez legyen kulcsszo.
- A keywordok ne keveredjenek az oldalak technikai reszleteivel.
- A kozos keywordok kulon fajlba keruljenek.
- Az oldalhoz kotott keywordok kulon modulban legyenek.
- Ha Python library reteg keszul, hasznalj kozos alaposztalyt es vilagos felelossegi hatarokat.
- A Robot oldalon a keyword nevek maradjanak uzletileg erthetoek.

## Documentation Requirements

Minden ilyen projektben legyen vagy frissuljon:

- `README.md`
- `requirements.txt`
- `.robot` forgatokonyv vagy forgatokonyvek
- futtathato suite-ok
- oldal reprezentaciok
- keyword gyujtemenyek

A `README.md` minimum tartalma:

1. A projekt celja.
2. A `.venv` letrehozasa.
3. A `pip install -r requirements.txt` hasznalata.
4. A Browser library telepitese es inicializalasa.
5. A tesztek futtatasa.
6. A forgatokonyv es az implementacio kapcsolat anak leirasa.

## Official Guidance Rule

Mindig a hivatalos Robot Framework ajanlasokhoz es dokumentaciokhoz igazodj. Ha ket megoldas kozul kell valasztani, azt valaszd, amelyik jobban illeszkedik a Robot Framework ajanlott szerkezethez, olvashatosaghoz es karbantarthatosaghoz.

Elsodleges technologiai alapok:

- Robot Framework
- Robot Framework Browser library
- Playwright alapok a Browser library mogott

## Working Mode

1. Eloszor tisztazd, mi a tesztelt uzleti folyamat.
2. Ha hianyzik a forgatokonyv, azt keszitsd el `.robot` fajlban.
3. Mutasd be a suite szerkezetet es a teszteseteket magyarul.
4. Validasd a userrel.
5. Javitsd a forgatokonyvet a visszajelzes alapjan.
6. Ezutan epitsd fel a futtathato tesztprojektet.
7. Alakits ki kulon page, keyword, es kozos alapretegeket.
8. Rogzits minden fuggoseget es futtatasi lepest.

## Must Do

- Eloszor forgatokonyv, utana implementacio.
- A forgatokonyv `.robot` fajl legyen.
- A forgatokonyv magyar es uzletileg ertheto legyen.
- A megvalositas Robot Framework + Playwright alapon tortenjen.
- Hasznalj Page Object Model szerkezetet.
- Hasznalj kulon page es keyword mappakat.
- Hasznalj `.venv` virtualis kornyezetet.
- Hasznalj `requirements.txt`-t.
- Dokumentalj `README.md`-ben.

## Must Not Do

- Ne kezdd technikai implementacioval, ha nincs jovahagyott forgatokonyv.
- Ne irj Given/When/Then stilust.
- Ne hasznalj angol kulcsszavas uzleti leirast.
- Ne irj XPath alapu megoldast a forgatokonyvbe.
- Ne keverd a technikai lokatorokat az uzleti leirassal.
- Ne hagyd impliciten a Python kornyezet letrehozasat.
- Ne hagyd ki a dependency rogzitest.

## References

- `references/scenario-template.robot`: uzleti nyelvu `.robot` forgatokonyv minta.
- `references/project-structure.md`: ajanlott mappaszerkezet es retegek.
- `references/official-links.md`: hivatalos Robot Framework es Browser library hivatkozasok.
