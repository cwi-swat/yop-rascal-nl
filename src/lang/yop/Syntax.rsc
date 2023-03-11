module lang::yop::Syntax

start syntax Programma = Recept* recepten Tekening* tekeningen;

syntax Tekening
    = "vooruit" Som afstand
    | "naar" Som x Som y
    | "spring" Som afstand
    | "rechts" Som graden
    | "links" Som graden
    | "pen" ("op" | "neer")
    | "pen" "kleur" Kleur kleur
    | "pen" "dikte" Som dikte
    | "als" Conditie "{" Tekening* stappen "}"
    | Naam "=" Som
    | "cirkel" Som diameter
    | "herhaal" Som "{" Tekening* "}"
    
    | "doe" Naam recept ("met" {Som ","}+)?
    ;

syntax Recept 
    = "recept" Naam naam ("met" {Naam ","}+ )? "{" Tekening* stappen "}"
    ;

syntax Conditie
    = Som l "==" Som r
    | Som l "!=" Som r
    | Som l "\<=" Som r
    | Som l "\<"  Som r
    | Som l "\>"  Som l
    | Som l "\>=" Som r
    | bracket "(" Conditie ")"
    | "niet" Conditie c
    > left Conditie lc "en" Conditie rc
    > left Conditie lc "of" Conditie rc
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

// TE DOEN: pen dikte instellen.
// Kijk bij de vertaling van `naar` hoe je dit zou kunnen doen voor pendikte.
//   * er moet een `real huidigePenDikte = 1.0` bij komen
//   * die variabele moet veranderen als `pen dikte <Som s>` langs komt tijdens `vertaal`
//   * ALLES wat iets tekent in miniSVG moet die variabele gaan vertalen naar `\stroke-width` in miniSVG. Bijvoorbeeld: `circle(\stroke-width=huidigePenDikte)`
// syntax Tekening = "pen" "dikte" Som;

// TE DOEN: pen kleur instellen
// Kijk bij de vertaling van `naar` hoe je dit zou kunnen doen voor pendikte.
//   * er moet een `Color huidigePenKleur = 1.0` bij komen
//   * die variabele moet veranderen als `pen kleurr <Kleur s>` langs komt tijdens `vertaal`
//   * ALLES wat iets tekent in miniSVG moet die variabele gaan vertalen naar `\stroke-width` in miniSVG. Bijvoorbeeld: `circle(\stroke-width=huidigePenDikte)`
 // syntax Tekening = "pen" "kleur" Kleur;

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