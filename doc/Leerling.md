# Maak je eigen programmeertaal, "YOP", met Rascal

* Rascal is een "meta" programmeertaal: een programmeertaal om programmeertalen mee te *maken*.
* Je breidt vandaag een kleine programmeertaal voor tekenen uit met je eigen ideeën. Dat doen we in kleine stapjes.
* Programmeertalen bestaan uit twee onderdelen:
   1. *Syntax* is wat je kunt opschrijven, de regels van de grammatica en het woordenboek. 
   2. *Semantiek* is wat het betekent, altijd door een *vertaling* naar een andere taal.
* We gaan de *Syntax* en *Semantiek* van "YOP" -dat staat voor Your Own Programming language- dus veranderen.

## Ongevraagde adviezen

* Programmeertaalontwerp is een kwestie van smaak en efficiëntie;
   * Over smaak valt niet te twisten, dus volg vooral je gevoel. Wat lijkt je leuk? Wat lijkt je handig? Wat lijkt je elegant?
   * Er is één basisprincipe: **"lui én slim"** zijn
      * probeer dat het minder saai wordt en minder werk om te programmeren in YOP, zonder dat je minder kan tekenen.
      * probeer dat je zelf ook weinig werk hoeft te doen om een uitbreiding toe te voegen. Laat de computer het werk doen.
* Metaprogrammeren gaat niet gelijk goed!
   * Je maakt iets wat nog *nooit* iemand heeft gemaakt, want je hebt het zelf bedacht 👍
   * Je weet niet precies alles van al die verschillende talen die in het spel zijn. Logisch.
   * Snel en vaak fouten maken, zorgt dat je snel meer verkent van de uitdagingen en sneller leert.
   * Probeer één fout tegelijkertijd te maken, dan leer je sneller omdat je weet waar het aan ligt. Dus hele korte stukjes programmeren en tussendoor héél veel testen.
   * Perfectie is de vijand van lol en effectiviteit. Maak in ieder geval *iets*, en probeer als het werkt het uit te breiden naar je grotere visie.

## Even inkomen: fluisterspel

1. Maak groepjes van 4
   * nummer 1 spreekt Nederlands en verzint iets om te tekenen. Dat mag een cirkel, een rechthoek, een driehoek, een vierkant of een ellipse zijn, met doorsnede minder dan 10 cm (kies een getal).
   * nummer 2 verstaat Nederlands en spreekt een andere taal **X** (die nummer drie verstaat). Dus bijv. Frans, Arabisch, Papiaments, Turks.
   * nummer 3 verstaat taal **X** en kan gebarentaal (gebruik je handen en je vingers; zelf verzinnen)
   * nummer 4 begrijpt die gebarentaal en tekent wat er gecommuniceerd wordt op papier (vorm en ongeveer aangegeven grootte)
2. Je hebt een paar minuten. Als het lekker snel gaat, draai je de rollen om en probeer je het nog een keer: `1->2, 2->3, 3->4, 4->1`

Conclusie:
   * *Wat* je zegt of  gebaart of tekent is de *Syntax* van een taal. Die betekent niets op zich.
   * *De vertaling* geeft *Semantiek*, dat is de betekenis van wat je wilde zeggen.
   * Dat is alles wat er nodig is om een taal te maken: eerst Syntax, en dan Semantiek.
   * Met programmeertalen is het niet anders.

## Voorbereidingen

1. Je hebt Microsoft VScode nodig. Download van <https://code.visualstudio.com/download>
2. Je hebt Rascal nodig, als "extensie". 
   * Ga naar de extensions view <img width="48" alt="image" src="https://user-images.githubusercontent.com/1990295/220860845-cd93d69e-9fbc-4662-a3d4-551d2ca702f1.png"> en zoek op Rascal. 
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
   * Het yop project verschint

