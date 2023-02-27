# Opdracht 0. Fluisterspel

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

1. We werken met 4 talen vandaag, YOP, miniSVG en SVG en pixels op het scherm:
   * *YOP* is je eigen tekenprogrammeertaal, met zinnen als `pen op` en `pen neer`, `herhaal { vooruit 40 }` en `cirkel 50`.
   * *miniSVG* is een nogal abstracte, lelijke, maar simpele mini taal voor 2 dimensionele graphics, met zinnen als `circle(0,0,50,\stroke-color="orange")`. Programmeurs zien deze taal niet maar wij gebruiken het als tussenstation richting de vertaling naar SVG.
   * [*SVG*](https://www.w3.org/TR/SVG2/) is een [XML](https://www.w3.org/xml) dialect met zeer uitgebreide teken en transformatie mogelijkheden. Een cirkel ziet er bijvoorbeeld zo uit: `</circle cx=0 cy=0 r=50>`, maar er zijn duizenden opties en trucjes die we hier even niet laten zien.
   * Pixels op het scherm; de uiteindelijke tekening is ook een taal. Hier is een typisch voorbeeld: </br><img width="25%" alt="image" src="https://user-images.githubusercontent.com/1990295/220865657-e771c297-d9e8-4c49-ad00-3d73c75bc717.png">
   * De vijfde taal is Rascal, dat is de taal om de andere talen mee te maken.

2. We maken vandaag zelf de Syntax van YOP en de Semantiek (vertaling naar miniSVG)
3. Als je helemaal los wilt gaan, kun je ook de Syntax en Semantiek van miniSVG eerst uitbreiden.
4. SVG *hergebruiken* we. We kunnen er niets aan veranderen want we hebben de code van de browsers of viewers voor SVG niet. Die vertalingen zijn er wel!
