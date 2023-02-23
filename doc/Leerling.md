# Maak je eigen programmeertaal, "YOP", met Rascal

* [Rascal](https://www.rascal-mpl.org) is een "meta" programmeertaal: een programmeertaal om programmeertalen mee te *maken*.
* Je breidt vandaag een kleine programmeertaal voor tekenen uit met je eigen ideeën. Dat doen we in kleine stapjes.
* Programmeertalen bestaan uit twee onderdelen:
   1. *Syntax* is wat je kunt opschrijven, de regels van de grammatica en het woordenboek. 
   2. *Semantiek* is wat het betekent, altijd door een *vertaling* naar een andere taal.
* We gaan de *Syntax* en *Semantiek* van "YOP" -dat staat voor Your Own Programming language- dus veranderen.

Dit is een voorbeeld YOP programma met de resulterende tekening, plus uitleg:

<table>
<tr> <td>
   
```
i = 0
herhaal 3600 { 
    vooruit 10 
    rechts i + (1 / 10)
    i = i + 1
}
```
   </td><td>

<img width="100%" alt="image" src="https://user-images.githubusercontent.com/1990295/220869648-48068480-4d67-47fe-bc9a-2b4d927cd8b3.png"></td>
<td>
   
Dit programma gaat alleen maar `rechts` af en `vooruit`. Hoe kan het nou dat er zulke mooie krullen uit komen? Dat komt doordat `i` steeds groter wordt, dat is de hoek 
waarmee de schildpad draait. Van 0 tot 180 wordt de hoek (rechtsaf) steeds groter, en tussen 180 en 360 (linksaf) wordt de hoek weer kleiner tot we weer rechtdoor gaan (360 graden). Dan begint het weer opnieuw.
   
</td>
</tr>
</table>

## Even inkomen: fluisterspel

### Opdracht

1. Maak groepjes van 4
   * nummer 1 spreekt Nederlands en verzint iets om te tekenen. Dat mag een cirkel, een rechthoek, een driehoek, een vierkant of een ellipse zijn, met doorsnede minder dan 10 cm (kies een getal).
   * nummer 2 verstaat Nederlands en spreekt een andere taal **X** (die nummer drie verstaat). Dus bijv. Frans, Arabisch, Papiaments, Turks.
   * nummer 3 verstaat taal **X** en kan gebarentaal (gebruik je handen en je vingers; zelf verzinnen)
   * nummer 4 begrijpt die gebarentaal en tekent wat er gecommuniceerd wordt op papier (vorm en ongeveer aangegeven grootte)
2. Doorgeven van de informatie:
   * nummer 1 bedenkt de vorm en fluistert dat in het oor van 2.
   * nummer 2 luistert naar 1, maakt de vertaling en fluistert het resultaat in het oor van 3.
   * nummer 3 luistert naar 2, vertaalt dat naar gebaren taal en geeft dat door aan 4.
   * nummer 4 kijkt naar de gebaren, interpreteert ze en zet dat idee op papier met en pen of potlood.
4. Je hebt een paar minuten. Als het lekker snel gaat, draai je de rollen om en probeer je het nog een keer: `1->2, 2->3, 3->4, 4->1`

### Conclusie
   * *Wat* je zegt of  gebaart of tekent is de *Syntax* van een taal. Die betekent niets op zich.
   * *De vertaling* geeft *Semantiek*, dat is de betekenis van wat je wilde zeggen.
   * Dat is alles wat er nodig is om een taal te maken: eerst Syntax, en dan Semantiek.
   * Met programmeertalen is het niet anders.

### Brug

1. We werken met 4 talen vandaag, net zoals in het fluisterspel:
   * *YOP* is je eigen tekenprogrammeertaal, met zinnen als `pen op` en `pen neer`, `herhaal { vooruit 40 }` en `cirkel 50`.
   * *miniSVG* is een nogal abstracte, lelijke, maar simpele mini taal voor 2 dimensionele graphics, met zinnen als `circle(0,0,50,\stroke-color="orange")`. Programmeurs zien deze taal niet maar wij gebruiken het als tussenstation richting de vertaling naar SVG.
   * [*SVG*](https://www.w3.org/TR/SVG2/) is een [XML](https://www.w3.org/xml) dialect met zeer uitgebreide teken en transformatie mogelijkheden. Een cirkel ziet er bijvoorbeeld zo uit: `</circle cx=0 cy=0 r=50>`, maar er zijn duizenden opties en trucjes die we hier even niet laten zien.
   * Pixels op het scherm; de uiteindelijke tekening is ook een taal. Hier is een typisch voorbeeld: </br><img width="25%" alt="image" src="https://user-images.githubusercontent.com/1990295/220865657-e771c297-d9e8-4c49-ad00-3d73c75bc717.png">
   * De vijfde taal is Rascal, dat is de taal om de andere talen mee te maken.

2. We maken vandaag zelf de Syntax van YOP en de Semantiek (vertaling naar miniSVG)
3. Als je helemaal los wilt gaan, kun je ook de Syntax en Semantiek van miniSVG eerst uitbreiden.
4. SVG *hergebruiken* we. We kunnen er niets aan veranderen want we hebben de code van de browsers of viewers voor SVG niet. Die vertalingen zijn er wel!

## Voorbereidingen

1. Je hebt Microsoft VScode nodig. Download van <https://code.visualstudio.com/download>
2. Je hebt Rascal nodig, als "extensie". 
   * Ga naar de extensions view <img width="24" alt="image" src="https://user-images.githubusercontent.com/1990295/220860845-cd93d69e-9fbc-4662-a3d4-551d2ca702f1.png"> en zoek op Rascal. 
   * Zoek op "rascal" en kies "Rascal Metaprogramming Language" van "Usethesource".
   * Soms komen er wat vragen over installatie van Java. Alle keuzes zijn goed, maar mischien heb je zelf voorkeuren.
3. Je hebt het YOP project nodig. 
   * Download de zip hier <TODODODODODO>
   * Pak de zip ergens uit. Onthoudt waar ergens is. Bijvoorbeeld in `Mijn Documenten/yop-rascal-nl`
      * de folder moet `yop-rascal-nl` heten.
      * in die folder staat `src` en `META-INF`, etc.
      * als dit niet klopt, vraag even hulp.
   * Voeg `Mijn Documenten/yop` toe aan je VScode "workspace":
      * "File" menu, "Add folder to workspace..."
   * Het `yop-rascal-nl` project verschijnt in het bestandsoverzicht aan de linkerkant.
   * Open het bestand `src/lang/yop/Gebruiker.rsc`. Dit is een Rascal programma.
      * Beneden staat de `main` functie, met daarboven `Run in new Rascal terminal`.
      * Klik daarop
      * Na even wachten komt er een nieuw "console" onder in het scherm. Het `main()` commando is al uitgevoerd.
      * Focus op de terminal met je muis.
      * Pijltje omhoog en het `main()` command verschijnt weer.
      * "Enter" en `main` wordt nog een keer uitgevoerd.
   * **Elke keer als je `main` uitvoert, leert VScode pas over de laatste versie van YOP.**
4. Open een `.yop` bestand uit `voorbeelden`
   * Er staan altijd drie opties bovenaan, mits het YOP programma syntactisch correct is (een geldige zin):
      * `Bekijk plaatje` vertaalt eerst naar miniSVG, dan naar SVG, dan naar pixels en laat het plaatje ook zien.
      * `Bekijk mini SVG` vertaalt naar miniSVG, slaat het resultaat op in een `.mini` bestand en opent dat bestand om het te kunnen lezen.
      * `Bekijk SVG` vertaalt naar miniSVG, dan naar SVG, , slaat het resultaat op in een `.svg` bestand en opent dat bestand om het te kunnen lezen.
   * `.svg` bestanden kun je bewaren en aan iemand sturen. De meeste mensen hebben SVG viewers op hun telefoon en computer.
   * Lekker even programmeren in YOP is leuk.
5. Alles wat je met YOP kunt doen, is geprogrammeerd in dit project. Zelfs de drie opties hierboven staan geprogrammeerd in `src/lang/yop/Gebruiker.rsc`.

## Opdracht nul; kennismaking met YOP.

* Werk in teams van twee achter één laptop samen. Help elkaar. Wissel het toetsenbord af en toe. 
* Het idee van YOP is gebaseerd op het klassieke ["LOGO"](https://nl.wikipedia.org/wiki/Logo_(programmeertaal)): 
   * YOP heeft een (platonische) notie van een 🐢 die wandelt over een stuk plat papier met een pen in zijn pootjes. 
   * Als de 🐢 `vooruit` loopt, dan trekt hij kaarsrechte strepen achter zich aan.
   * De 🐢 kan naar `links` en `rechts` van richting veranderen
   * De 🐢 kan de `pen` tijdelijk `op`trekken om te verplaatsen zonder strepen te trekken.
   * Er is een XY assenstelsel van -500 tot 500, met de oorsprong `(0,0)` precies in het midden.
   * De 🐢 begint in de oorsprong met als richting omhoog op de y-as.
* De opdracht is **spelen** en **uitproberen**:
   1. Speel met YOP zoals het nu is. Gebruik de voorbeelden maar probeer ook je eigen dingen.
   2. Streepjes zijn "links"! Klik maar eens ergens op in een plaatje.
   2. Schrijf alvast op wat er bij je op komt op:
      * wat je irritant vindt aan YOP, of
      * waar je kansen ziet voor verbetering, of 
      * "wat als"-achtige ideeën. Wat als je ook kleuren kon gebruiken? Wat als je ook in een kromme beweging kon lopen? etc. 
      * later gaan je één van jullie ideeën proberen te maken.
   3. Loop je vast? Dat hoort erbij. Steek je hand op!
   
## Opdracht 1 - "vooruit" is toch ouderwets?
 
### Deel 1 - snel resultaat
   
* `vooruit <getal>` is in YOP nu hét middel om een streep te trekken, maar misschien bekt `loop <getal>` wel wat lekkerder?
* Vervang in `src/lang/yop/Syntax` waar `vooruit` staat door `loop`. Nu is de Syntax aangepast.
* Vervang in `src/lang/yop/Semantiek`, in de vertaler naar miniSVG, waar `vooruit` staat door `loop`. Nu is de semantiek ook aangepast.
* Probeer een yop programma uit te voeren:
   * eerst de `main` functie van `Gebruiker` nog eens draaien. Daarna ziet VScode de wijzigingen.
   * maar het gaat niet, want nu is het programma niet meer "syntactisch correct". `vooruit` zit niet meer in de woordenschat.
   * pas dus `vooruit` aan naar `loop` in het yop programma.
   * nu werkt het wel.

### Deel 2 - een beetje spijt
   
* Nu zijn alle oude programma's stuk; en het is werk om die aan te passen :-(
* Laten we de oude `vooruit` **ook** toestaan. Dan zijn we "backwards compatible".
* Voeg in `src/lang/yop/Syntax` een kopie van de `loop` regel toe en vervang daarin `loop` door `vooruit`
* Kopiëer in `src/lang/yop/Semantiek` de vertaalregel voor `loop` en maak hiervan en variant voor `vooruit` van.
* Probeer yop programma's waar zowel `loop` als vooruit in `voorkomen`

## Opdracht 2 - handiger herhalen of kleuren?
   
## Opdracht 3 - vrije creativiteit
   

