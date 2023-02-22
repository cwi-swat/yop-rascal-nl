module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;
import String;
import IO;
import util::Math;
import ParseTree;

// de toestand van de schildpad is X, Y en Richting
int huidigeX = 0;
int huidigeY = 0;
int huidigeRichting = 0;
bool pen = true;

// richting veranderen kan, maar als je klokje rond bent, begin je weer bij 0
void veranderRichting(int graden) {
    huidigeRichting = (huidigeRichting + graden) % 360;
}

real radialen(int graden) = ((graden * 1.) / 180) * PI();

// van syntax naar Rascal `int` getallen waar we mee kunnen rekenen
int vertaal(Getal g) = toInt("<g>");

MiniSVG vertaal(Programma p) {
    // eerst de schildpad terug in de oorsprong
    huidigeX = 0;
    huidigeY = 0;
    huidigeRichting = 0;
    pen = true;

    // dan de lijst van tekeningen vertalen
    return miniSVG(vertaal(p.tekeningen));
}

// 1-voor-1 de teken instructies vertalen
// de tekening komt alleen in de lijst als de pen `true` is
list[Element] vertaal(Tekening* tekeningen) 
    = [e | t <- tekeningen, e := vertaal(t), pen];

Element vertaal(t:(Tekening) `vooruit <Getal afstand>`) {
    // waar komen we vandaan?
    vorigeX = huidigeX;
    vorigeY = huidigeY;

    // en waar gaan we naartoe?
    huidigeX = round(huidigeX + cos(radialen(huidigeRichting)) * vertaal(afstand));
    huidigeY = round(huidigeY + sin(radialen(huidigeRichting)) * vertaal(afstand));

    return link(t, line(vorigeX, huidigeX, vorigeY, huidigeY));
}

Element vertaal(t:(Tekening) `rechts <Getal graden>`) {
    veranderRichting(-1 * vertaal(graden));
    return comment(t);
}

Element vertaal(t:(Tekening) `links <Getal graden>`) {
    veranderRichting(vertaal(graden));
    return comment(t);
}

Element vertaal(t:(Tekening) `pen op`) {
    pen = false;
    return comment(t);
}

Element vertaal(t:(Tekening) `pen neer`) {
    pen = true;
    return comment(t);
}

Element vertaal(t:(Tekening) `cirkel <Getal diameter>`) 
    = link(t, circle(huidigeX, huidigeY, vertaal(diameter)));

Element vertaal((Tekening) `herhaal <Getal aantal> { <Tekening* tekeningen> }`) 
    = move(0, 0, [*vertaal(tekeningen) | _ <- [0..vertaal(aantal)]]);

// handige functie om even een commentaar te produceren op basis van de huidige 🐢
Element comment(Tekening t) = comment("🐢 <t>; x: <huidigeX>, y: <huidigeY>, richting: <huidigeRichting>, pen: <pen> 🐢");

// handige functie om de link op te zoeken bij een tekening
Element link(Tekening t, Element e) = link(t.src, e);