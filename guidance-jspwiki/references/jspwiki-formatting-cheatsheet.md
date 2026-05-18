# JSPWiki Formatting Cheatsheet

Ez rovid referencia a `https://jspwiki-wiki.apache.org/Wiki.jsp?page=TextFormattingRules` alapjan.

## Gyakori elemek

- Kis cim: `!Cim`
- Kozepes cim: `!!Cim`
- Nagy cim: `!!!Cim`
- Dolt: `''szoveg''`
- Felkover: `__szoveg__`
- Monospace: `{{szoveg}}`
- Vonaltores: `\\`
- Vizszintes vonal: `----`

## Linkek

- Belsso wiki link: `[OldalNev]`
- Feliratos belso link: `[Felirat|OldalNev]`
- Kulso link: `[https://pelda.hu]`
- Feliratos kulso link: `[Felirat|https://pelda.hu]`
- Linkesites tiltasa CamelCase szora: `~NoLink`

## Listak

- Felsorolas: `* elem`
- Tobb szint: `** alelem`
- Szamozott lista: `# elem`
- Tobb szint: `## alelem`

## Definicio

- `;fogalom:magyarazat`

## Kod es preformatalt blokk

```text
{{{
pelda kod
}}}
```

## Informacios dobozok

```text
%%information
Szoveg
%%
```

Lehetseges tipikus blokkok: `information`, `warning`, `error`, `quote`.

## Tablazat

```text
|| Fejlec 1 || Fejlec 2
| cella 1 | cella 2
```

## Szerkesztesi szabalyok ehhez a skillhez

- Mindig a meglevo oldal stilusahoz igazodj.
- Mentest megelozoen ellenorizd a linkeket, listaszinteket es tablazatokat.
- Nagyobb atiras elott mutass diffet es kerj jovahagyast.

## Hivatalos referencia

- `https://jspwiki-wiki.apache.org/Wiki.jsp?page=TextFormattingRules`
