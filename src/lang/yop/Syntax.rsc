module lang::yop::Syntax

start syntax Programma = Tekening* tekeningen;

syntax Tekening
    = "vooruit" Som afstand
    | "naar" Som x Som y
    | "spring" Som afstand
    | "rechts" Som graden
    | "links" Som graden
    | "pen" ("op" | "neer")
    | Naam "=" Som
    | "cirkel" Som diameter
    | "herhaal" Som "{" Tekening* "}"
    ;

syntax Som 
    = Getal
    | Naam 
    | "wortel" Som
    | "sin" Som
    | "cos" Som
    | "PI"
    | "random" Som
    | "(" Som ")"
    > left ( Som "x" Som
           | Som "/" Som
           )
    > left ( Som "+" Som
           | Som "-" Som
           )
    ;

// Kleur wordt nog nergens gebruikt, maar er is wel
// een handige vertaling alvast. Dus gebruik `Kleur`
// in je eigen Syntax uitbreiding en dan kun je de vertaling
// in Semantiek ook gebruiken
syntax Kleur
    = "rood"
    | "groen"
    | "blauw"
    | "transparant"
    | Som "delen" Kleur
    | "meng" {Kleur "met"}+
    ;

lexical Getal  = [0-9]+;
lexical Naam   = @category="Variable" naam: [a-z]+;
lexical Spaties = [\ \t\n\r]+ !>> [\ \t\n\r];

lexical Commentaar = @category="Comment" "//" ![\n]* !>> ![\n] $;
layout  Ertussen   = (Spaties | Commentaar)* !>> [\ \t\n\r] !>> "--";

// Hieronder ideeen voor mogelijke uitbreidingen:

// TE DOEN: pen dikte instellen.
// Kijk bij de vertaling van `naar` hoe je dit zou kunnen doen voor pendikte.
//   * er moet een `real huidigePenDikte = 1.0` bij komen
//   * die variabele moet veranderen als `pen <Som s>` langs komt
//   * ALLES wat iets tekent in miniSVG moet die variabele gaan vertalen naar `\stroke-width` in miniSVG. Bijvoorbeeld: `circle(\stroke-width=huidigePenDikte)`
// syntax Tekening = "pen" "dikte" Som;

// TE DOEN: Letters kunnen schrijven:
// syntax Tekening = "schrijf" Tekst;
// lexical Tekst = ![\n]+ !>> ![\n];

// TE DOEN: Ellipse tekenen zonder hele grote veelhoeken.
// Zoek in Semantiek hoe cirkel vertaald wordt, en in miniSVG::Syntax waar je naartoe vertaalt.
// syntax Tekening = "ellipse" Getal breedte Getal hoogte;

// LASTIG: hele tekening kopieren en gespiegeld terugplakken
// Ga je twee de vertaling maken vanuit een andere schildpadpositie? Of ga je de miniSVG tekening kopieren en
// daarin absolute coordinaten wijzigen? Wees lui en slim!
// syntax Tekening = "spiegel" "in" ("x"|"y") "{" Tekening* "}";

// LASTIG: hele tekening kopieren en gedraaid terugplakken
// Ga je twee de vertaling maken vanuit een andere schildpadpositie? Of ga je de miniSVG tekening kopieren en
// daarin absolute coordinaten wijzigen? Wees lui en slim!
// syntax Tekening = "draai" Getal aantal "keer" "{" Tekening* "}";