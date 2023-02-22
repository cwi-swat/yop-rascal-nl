module lang::yop::Syntax

start syntax Programma = Tekening* tekeningen;

syntax Tekening
    = "vooruit" Som afstand
    | "rechts" Som graden
    | "links" Som graden
    | "pen" ("op" | "neer")
    | Naam "=" Som
    | "cirkel" Som diameter
    | "herhaal" Som "{" Tekening* "}"

// voeg dit eens toe: 
    // | "ellipse" Getal xDiameter Getal yDiameter

// voeg hierna je eigen dingen toe, zoals bijv:
    
    // | "spiegel" "in" ("x"|"y") "{" Tekening* "}"
    // | "draai" Getal aantal "keer" "{" Tekening* "}"
    ;

syntax Som 
    = Getal
    | Naam
    | "wortel" Som
    // | "willekeurig" Som
    | "(" Som ")"
    > left ( Som "x" Som
           | Som "/" Som
           )
    > left ( Som "+" Som
           | Som "-" Som
           )
    ;

lexical Getal  = [0-9]+;
lexical Naam   = [a-z]+;
layout Spaties = [\ \t\n\r]*;
