## Opdracht 2 - Tekst schrijven 

* Het is nog leuker als je ook teksten kunt schrijven met YOP zonder dat je daarvoor de schildpad tureluurs moet laten rondlopen.
* Voeg toe aan `src/lang/yop/Syntax.rsc`, ergens in het bestand tussen de andere `syntax` regels:
```
syntax Tekening = "schrijf" Tekst;
lexical Tekst = ![\n]+ !>> ![\n];
```
* Voeg daarna toe aan `src/lang/yop/Semantiek.rsc`, ergens bij de andere vertaal regels voor `Tekening`en:
```
Element vertaal((Tekening) `schrijf <Tekst zin>`) 
    = text(huidigeX, huidigeY, "<zin>");
```
* Uitproberen!
* Wat gaat er mis?
* Repareren door dit te veranderen:
```
Element vertaal((Tekening) `schrijf <Tekst zin>`) 
    = rotate(huidigeRichting, [text(huidigeX, huidigeY, "<zin>")]);
```
* gelukkig zat er nog een `rotate` in miniSVG, anders moesten we dat eerst nog toevoegen!