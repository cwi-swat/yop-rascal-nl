module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;
import String;
import util::Math;
import ParseTree;
import Exception;

// de toestand van de schildpad is X, Y en Richting
real huidigeX = 0.;
real huidigeY = 0.;
real huidigeRichting = 90.;
bool pen = true;
map[str,real] waarden = ();

// richting veranderen kan, maar als je klokje rond bent, begin je weer bij 0
void veranderRichting(real graden) {
    huidigeRichting = huidigeRichting + graden;
    while (huidigeRichting > 360.0)
        huidigeRichting -= 360;
    while (huidigeRichting < -360.0)
        huidigeRichting += 360;
}

MiniSVG vertaal(Programma p) {
    // eerst de schildpad terug in de oorsprong
    huidigeX = 0.;
    huidigeY = 0.;
    huidigeRichting = 90.;
    pen = true;
    waarden = ();

    // dan de lijst van tekeningen vertalen
    return miniSVG(vertaal(p.tekeningen));
}

// 1-voor-1 de teken instructies vertalen
// de tekening komt alleen in de lijst als de pen `true` is
list[Element] vertaal(Tekening* tekeningen) 
    = [e | t <- tekeningen, e := vertaal(t), pen];

Element vertaal(t:(Tekening) `vooruit <Som afstand>`) {
    // waar komen we vandaan?
    vorigeX = huidigeX;
    vorigeY = huidigeY;

    // en waar gaan we naartoe?
    huidigeX = huidigeX + cos(radialen(huidigeRichting)) * vertaal(afstand);
    huidigeY = huidigeY + sin(radialen(huidigeRichting)) * vertaal(afstand);

    return link(t, line(vorigeX, huidigeX, vorigeY, huidigeY));
}

Element vertaal(t:(Tekening) `naar <Som x> <Som y>`) {
    // waar komen we vandaan?
    vorigeX = huidigeX;
    vorigeY = huidigeY;

    // en waar gaan we naartoe?
    huidigeX = vertaal(x);
    huidigeY = vertaal(y);

    return link(t, line(vorigeX, huidigeX, vorigeY, huidigeY));
}

Element vertaal(t:(Tekening) `spring <Som afstand>`) {
    // simuleer een sprong door pen op, vooruit, pen neer

    pen = false;
    vertaal((Tekening) `vooruit <Som afstand>`);
    pen = true;

    return comment(t);
}

Element vertaal(t:(Tekening) `rechts <Som graden>`) {
    veranderRichting(-1 * vertaal(graden));
    return comment(t);
}

Element vertaal(t:(Tekening) `links <Som graden>`) {
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

Element vertaal(t:(Tekening) `<Naam n> = <Som s>`) {
    waarden["<n>"] = vertaal(s);
    return comment(t);
}

Element vertaal(t:(Tekening) `cirkel <Som diameter>`) 
    = link(t, circle(huidigeX, huidigeY, vertaal(diameter)));

Element vertaal((Tekening) `herhaal <Som aantal> { <Tekening* tekeningen> }`) 
    = move(0., 0., [*vertaal(tekeningen) | _ <- [0..round(vertaal(aantal))]]);

// uitrekenen van sommen gaat door stap voor stap vertalen van
// yop sommen naar Rascal sommen:
real vertaal((Som) `<Getal g>`)         = vertaal(g);
real vertaal((Som) `wortel <Som w>`)    = sqrt(vertaal(w));
real vertaal((Som) `sin <Som w>`)       = sin(vertaal(w));
real vertaal((Som) `cos <Som w>`)       = cos(vertaal(w));
real vertaal((Som) `PI`)                = PI();
real vertaal((Som) `<Som a> + <Som b>`) = vertaal(a) + vertaal(b);
real vertaal((Som) `<Som a> - <Som b>`) = vertaal(a) - vertaal(b);
real vertaal((Som) `<Som a> x <Som b>`) = vertaal(a) * vertaal(b);
real vertaal((Som) `<Som a> / <Som b>`) {
    try 
        return vertaal(a) / vertaal(b); 
    catch ArithmeticException("Division by zero"): 
        throw b.src;
} 
real vertaal((Som) `<Naam n>`)          = waarden["<n>"]?0.;
real vertaal((Som) `(<Som s>)`)         = vertaal(s);

// int vertaal((Som) `willekeurig <Som w>`) = arbInt(vertaal(w));

// van syntax naar Rascal `int` getallen waar we mee kunnen rekenen
real vertaal(Getal g) = 1. * toInt("<g>");

// handige functie om even een commentaar te produceren op basis van de huidige 🐢
Element comment(Tekening t) = comment("🐢 <t>; x: <huidigeX>, y: <huidigeY>, richting: <huidigeRichting>, pen: <pen> 🐢");

// handige functie om de link op te zoeken bij een tekening
Element link(Tekening t, Element e) = link(t.src, e);

// handige functie om van graden naar radialen te gaan, zodat we sin en cos kunnen gebruiken
real radialen(real graden) = (graden / 180.0) * PI();


