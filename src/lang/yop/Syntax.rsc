module lang::yop::Syntax

start syntax Programma = Tekening* tekeningen;

syntax Tekening
    = "vooruit" Som afstand
    | "naar" Som x Som y
    | "spring" Som afstand
    | "rechts" Som graden
    | "links" Som graden
    | "pen" ("op" | "neer")
    | "pen" "kleur" Kleur kleur
    | "pen" "dikte" Som dikte
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

syntax Kleur
    = "rood"
    | "groen"
    | "blauw"
    | "wit"
    | "zwart"
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
// Ga je de vertaling van dezelfde tekening nog eens maken vanuit een andere schildpadpositie? 
// Of ga je de miniSVG tekening kopieren en daarin absolute coordinaten wijzigen? Wees lui en slim!
// syntax Tekening = "draai" Getal aantal "keer" "{" Tekening* "}";