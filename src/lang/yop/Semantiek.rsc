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

bool schildpad(Tekening t) {
    println("🐢 na <t>:");
    println("  X: <huidigeX>
            '  Y: <huidigeY>
            '  R: <huidigeRichting>
            '  P: <pen>");
    return true;
}

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

    // dan 1-voor-1 de teken instructies vertalen
    // de tekening komt alleen in de lijst als de pen `true` is
    return miniSVG([e | t <- p.tekeningen, e := vertaal(t), schildpad(t), pen]);
}


Element vertaal((Tekening) `vooruit <Getal afstand>`) {
    // waar komen we vandaan?
    vorigeX = huidigeX;
    vorigeY = huidigeY;

    // en waar gaan we naartoe?
    huidigeX = round(huidigeX + cos(radialen(huidigeRichting)) * vertaal(afstand));
    huidigeY = round(huidigeY + sin(radialen(huidigeRichting)) * vertaal(afstand));

    return line(vorigeX, huidigeX, vorigeY, huidigeY);
}

Element vertaal((Tekening) `rechts <Getal graden>`) {
    veranderRichting(-1 * vertaal(graden));
    return nothing();
}

Element vertaal((Tekening) `links <Getal graden>`) {
    veranderRichting(vertaal(graden));
    return nothing();
}

Element vertaal((Tekening) `pen op`) {
    pen = false;
    return nothing();
}

Element vertaal((Tekening) `pen neer`) {
    pen = true;
    return nothing();
}

Element vertaal(t:(Tekening) `cirkel <Getal diameter>`) 
    = link(t.src, circle(huidigeX, huidigeY, vertaal(diameter)));

Element vertaal((Tekening) `herhaal <Getal aantal> { <Tekening* tekeningen> }`) 
    = move(0, 0, [vertaal(t) | _ <- [0..vertaal(aantal)], t <- tekeningen]);
