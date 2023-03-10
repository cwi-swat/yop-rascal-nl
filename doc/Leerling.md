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

We hebben een aantal opdrachten voor je. Elke op zijn eigen A4 vel.

1. Opdracht 0 - Fluisterspel
2. Opdracht 1 - Programmeertaal verbeteren
3. Opdracht 2 - Programmeertaal uitbreiden
4. Opdracht 3 - Zelfs iets bedenken voor je programmeertaal
5. Opdracht 4 - Demo tijd!

