# Ajanlott Projektstruktura

## Cel

Ez a szerkezet azt tamogatja, hogy az ATDD alapu uzleti forgatokonyv, a futtathato Robot suite, a Page Object Model, es a keyword reteg tisztan elkulonuljon.

## Mintastruktura

```text
projekt/
  README.md
  requirements.txt
  .venv/
  tests/
    scenarios/
      belepes.robot
      rendeleskezeles.robot
    suites/
      login_suite.robot
      order_suite.robot
  resources/
    keywords/
      common.resource
      login.resource
      order.resource
    variables/
      common.py
  libraries/
    base/
      base_page.py
      base_keywords.py
    pages/
      login_page.py
      order_page.py
    keywords/
      login_keywords.py
      order_keywords.py
```

## Ertelmezes

- `tests/scenarios/`: uzleti, egyeztetett `.robot` forgatokonyvek.
- `tests/suites/`: futtathato automatizalt suite-ok.
- `resources/keywords/`: Robot szintu, olvashato kulcsszavak.
- `libraries/base/`: kozos Python alapreteg.
- `libraries/pages/`: oldalankenti Page Object osztalyok.
- `libraries/keywords/`: kozos alapra epulo, tematikus Python keyword osztalyok.

## Szerkezeti Elvek

- Az uzleti forgatokonyv ne keveredjen a lokatorokkal.
- A futtathato suite az uzleti celokat kovesse, ne az implementacios reszleteket.
- A page objektumok oldalspecifikus felelosseget kapjanak.
- A kozos browser, varakozasi, navigacios es ellenorzesi logika kozos alapba keruljon.
- A Robot keyword reteg maradjon olvashato es uzleti nyelvu.

## Python Alapreteg

Ha Python library reteg keszul, az oroklodes ajanlott helye a kozos bazisosztalyok szintje:

- `BasePage`: kozos oldalmuveletek.
- `BaseKeywords`: kozos keyword tamogato muveletek.
- Az oldalspecifikus osztalyok ezekre epuljenek.

Ez ugy ad rendezett oroklodeses szerkezetet, hogy a Robot oldali suite-ok tovabbra is egyszeruek es olvashatoak maradnak.
