module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;
import String;
import IO;
import util::Math;

// de toestand van de schildpad is X, Y en Richting
int huidigeX = 0;
int huidigeY = 0;
int huidigeRichting = 0;
bool pen = true;

bool schildpad(Tekening t) {
    println("Na <t>:");
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
    vorigeX = huidigeX;
    vorigeY = huidigeY;
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

Element vertaal((Tekening) `cirkel <Getal diameter>`) {
    return circle(huidigeX, huidigeY, vertaal(diameter));
}



public Programma example 
    = (Programma) `vooruit 40 
                  'links 90 
                  'vooruit 40 
                  'rechts 90 
                  'pen op
                  'vooruit 40 
                  'pen neer
                  'links 90 
                  'vooruit 40
                  'cirkel 40`;