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
* Kopiëer in `src/lang/yop/Semantiek` de vertaalregel voor `loop` en maak hiervan een variant voor `vooruit` van.
* Probeer yop programma's waar zowel `loop` als vooruit in `voorkomen`
