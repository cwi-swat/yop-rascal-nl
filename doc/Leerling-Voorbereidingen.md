## Voorbereidingen

1. Je hebt Microsoft VScode nodig. Download van <https://code.visualstudio.com/download>
2. Je hebt Rascal nodig, als "extensie". 
   * Ga naar de extensions view <img width="24" alt="image" src="https://user-images.githubusercontent.com/1990295/220860845-cd93d69e-9fbc-4662-a3d4-551d2ca702f1.png"> en zoek op Rascal. 
   * Zoek op "rascal" en kies "Rascal Metaprogramming Language" van "Usethesource".
   * Soms komen er wat vragen over installatie van Java. Alle keuzes zijn goed, maar mischien heb je zelf voorkeuren.
3. Je hebt het YOP project nodig. 
   * óf download de zip hier:
      * https://github.com/cwi-swat/yop-rascal-nl/releases/download/2023-03-03/yop-rascal-nl.zip
      * **kortere URL** voor hetzelfde: https://tinyurl.com/2yfup2rr
      * Pak de zip ergens uit. Onthoudt waar ergens is. Bijvoorbeeld in `Mijn Documenten/yop-rascal-nl`
      * de folder **moet** `yop-rascal-nl` heten.
      * in die folder staat `src` en `META-INF`, etc.
      * als dit niet klopt, vraag even hulp!
      * Voeg `Mijn Documenten/yop` toe aan je VScode "workspace":
      * "File" menu, "Add folder to workspace..." ![image](https://user-images.githubusercontent.com/1990295/223061902-65cba65c-c7ea-4ae3-a4dc-4a34fc2b2dde.png)
   * óf je "cloned" hem met "git" 
      * `CMD+P` op de mac of `CTRL+SHIFT+P` op Windows, dan `clone` typen en ENTER, of vindt die feature via dit menu: ![image](https://user-images.githubusercontent.com/1990295/223062054-e43a91de-e89f-4ae2-9b67-f7940a8fd1ff.png)

      * CMD+P op de mac of CTRL+SHIFT+P op Windows, dan `clone` typen en ENTER. 
      * Kies `https://github.com/cwi-swat/yop-rascal-nl` als repository (precies overtypen)
      * kies een locatie: Bijvoorbeeld in `Mijn Documenten/yop-rascal-nl`
      * dan gaat de rest vanzelf
   * Het `yop-rascal-nl` project verschijnt in het bestandsoverzicht aan de linkerkant.
   * Open het bestand `src/lang/yop/Gebruiker.rsc`. Dit is een Rascal programma.
      * Beneden  staat de `main` functie, met daarboven `Run in new Rascal terminal`.
      * Klik daarop: ![image](https://user-images.githubusercontent.com/1990295/223062349-878dcad2-4cb4-44a0-85c1-03264afbf3e9.png)
      * Na even wachten komt er een nieuw "terminal" onder in het scherm. Het `main()` commando is al uitgevoerd.
      * Focus op de terminal met je muis.
      * Pijltje omhoog en het `main()` command verschijnt weer
      * "Enter" en `main` wordt nog een keer uitgevoerd.
   * Onthoudt dat **elke keer als je `main` uitvoert, leert VScode pas over de laatste versie van YOP die je hebt gemaakt.**
4. Open een `.yop` bestand uit `voorbeelden`
   * Er staan altijd drie opties bovenaan, mits het YOP programma syntactisch correct is (een geldige zin):
      * `Bekijk plaatje` vertaalt eerst naar miniSVG, dan naar SVG, dan naar pixels en laat het plaatje ook zien.
      * `Bekijk mini SVG` vertaalt naar miniSVG, slaat het resultaat op in een `.mini` bestand en opent dat bestand om het te kunnen lezen.
      * `Bekijk SVG` vertaalt naar miniSVG, dan naar SVG, , slaat het resultaat op in een `.svg` bestand en opent dat bestand om het te kunnen lezen.
   * `.svg` bestanden kun je bewaren en aan iemand sturen. De meeste mensen hebben SVG viewers op hun telefoon en computer.
   * Lekker even programmeren in YOP is leuk.
5. Alles wat je met YOP kunt doen, is geprogrammeerd in dit project. Zelfs de drie opties hierboven staan geprogrammeerd in `src/lang/yop/Gebruiker.rsc`.
