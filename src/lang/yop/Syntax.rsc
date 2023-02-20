module lang::yop::Syntax

start syntax Programma = Tekening* tekeningen;

syntax Tekening
    = "vooruit" Getal afstand
    | "rechts" Getal graden
    | "links" Getal graden
    | "pen" ("op" | "neer")
    | "cirkel" Getal diameter
// voeg dit eens toe: 
    // | "ellipse" Getal xDiameter Getal yDiameter

// voeg hierna je eigen dingen toe, zoals bijv:
    // | "herhaal" Getal aantal "{" Tekening* "}"
    // | "spiegel" "in" ("x"|"y") "{" Tekening* "}"
    // | "draai" Getal aantal "keer" "{" Tekening* "}"
    ;

lexical Getal = [1-9][0-9]+;

layout WS = [\ \t\n\r]*;
