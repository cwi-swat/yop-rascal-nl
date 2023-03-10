module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;
import String;
import util::Math;
import ParseTree;
import Exception;

// de toestand van de schildpad is X, Y en Richting
data Toestand =
  toestand(
    real huidigeX = 0.,
    real huidigeY = 0.,
    real huidigeRichting = 0.,
    real huidigePenDikte = 2.,
    Color huidigePenKleur = rgb(0,0,0,1.),
    bool pen = true,
    map[str,real] waarden = (),
    map[str, Tekening] recepten = (),
    Toestand vorige = toestand()
  );

Toestand huidigeToestand = toestand();

// richting veranderen kan, maar als je klokje rond bent, begin je weer bij 0
void veranderRichting(real graden) {
    huidigeToestand.huidigeRichting = huidigeToestand.huidigeRichting + graden;
    while (huidigeToestand.huidigeRichting > 360.0)
        huidigeToestand.huidigeRichting -= 360.0;
    while (huidigeToestand.huidigeRichting < -360.0)
        huidigeToestand.huidigeRichting += 360.0;
}

MiniSVG vertaal(Programma p) {
    // eerst de schildpad terug in de oorsprong
    huidigeToestand = toestand();
    
    // dan de lijst van tekeningen vertalen
    return miniSVG(vertaal(p.tekeningen));
}

// 1-voor-1 de teken instructies vertalen
// de tekening komt alleen in de lijst als de pen `true` is
list[Element] vertaal(Tekening* tekeningen) 
    = [e | t <- tekeningen, e := vertaal(t), huidigeToestand.pen];

Element vertaal(t:(Tekening) `vooruit <Som afstand>`) {
    // waar komen we vandaan?
    vorigeX = huidigeToestand.huidigeX;
    vorigeY = huidigeToestand.huidigeY;

    // en waar gaan we naartoe?
    huidigeToestand.huidigeX = huidigeToestand.huidigeX + cos(radialen(huidigeToestand.huidigeRichting)) * vertaal(afstand);
    huidigeToestand.huidigeY = huidigeToestand.huidigeY + sin(radialen(huidigeToestand.huidigeRichting)) * vertaal(afstand);

    return link(t, line(vorigeX, huidigeToestand.huidigeX, vorigeY, huidigeToestand.huidigeY, \stroke-width=huidigeToestand.huidigePenDikte, \stroke=huidigeToestand.huidigePenKleur));
}

Element vertaal(t:(Tekening) `naar <Som x> <Som y>`) {
    // waar komen we vandaan?
    vorigeX = huidigeToestand.huidigeX;
    vorigeY = huidigeToestand.huidigeY;

    // en waar gaan we naartoe?
    huidigeX = vertaal(x);
    huidigeY = vertaal(y);

    return link(t, line(vorigeX, huidigeToestand.huidigeX, vorigeY, huidigeToestand.huidigeY,  \stroke-width=huidigeToestand.huidigePenDikte, \stroke=huidigeToestand.huidigePenKleur));
}

Element vertaal(t:(Tekening) `spring <Som afstand>`) {
    // simuleer een sprong door pen op, vooruit, pen neer

    huidigeToestand.pen = false;
    vertaal((Tekening) `vooruit <Som afstand>`);
    huidigeToestand.pen = true;

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
    huidigeToestand.pen = false;
    return comment(t);
}

Element vertaal(t:(Tekening) `pen neer`) {
    huidigeToestand.pen = true;
    return comment(t);
}

Element vertaal(t:(Tekening) `<Naam n> = <Som s>`) {
    huidigeToestand.waarden["<n>"] = vertaal(s);
    return comment(t);
}

Element vertaal(t:(Tekening) `pen dikte <Som s>`) {
    huidigeToestand.huidigePenDikte = vertaal(s);
    return comment(t);
}

Element vertaal(t:(Tekening) `pen kleur <Kleur k>`) {
    huidigeToestand.huidigePenKleur = vertaal(k);
    return comment(t);
}

Element vertaal(t:(Tekening) `cirkel <Som diameter>`) 
    = link(t, circle(huidigeToestand.huidigeX, huidigeToestand.huidigeY, vertaal(diameter),  \stroke-width=huidigeToestand.huidigePenDikte,\stroke=huidigeToestand.huidigePenKleur));

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

real vertaal((Som) `random <Som w>`) = 1. * arbInt(round(vertaal(w)));

// van syntax naar Rascal `int` getallen waar we mee kunnen rekenen
real vertaal(Getal g) = 1. * toInt("<g>");

// er is alvast een vertaling voor kleuren, maar die wordt nog nergens
// gebruikt. Bedenk zelf een manier om kleuren te gebruiken in YOP!
Color vertaal((Kleur) `rood`)  = rgb(255,0,0,1.);
Color vertaal((Kleur) `groen`) = rgb(0,255,0,1.);
Color vertaal((Kleur) `blauw`) = rgb(0,0,255,1.);
Color vertaal((Kleur) `wit`)    = rgb(255,255,255,1.);
Color vertaal((Kleur) `zwart`)  = rgb(0,0,0,1.);
Color vertaal((Kleur) `transparant`)  = rgb(255,255,255,0.);
Color vertaal((Kleur) `<Som s> delen <Kleur k>`) = vertaal(k);

Color vertaal((Kleur) `meng <{Kleur "met"}+ elems>`)
    = mix([<vertaal(s), vertaal(k)> | (Kleur) `<Som s> delen <Kleur k>` <- elems]);

Color mix(lrel[real parts, Color color] mixture) {
    total = (0. | it + p | p <- mixture<parts>);
    
    if (total <= 0.) {
        return rgb(0,0,0,1.);
    }
    
    mixR = 0.;
    mixG = 0.;
    mixB = 0.; 
    mixT = 0.;   

    for (<p, rgb(r, g, b, t)> <- mixture) {
        mixR += r * p / total;
        mixG += g * p / total;
        mixB += b * p / total;
        mixT += t * p / total;
    }

    return rgb(round(mixR), round(mixG), round(mixB), mixT);
}

// handige functie om even een commentaar te produceren op basis van de huidige 🐢
Element comment(Tekening t) = comment("🐢 <t>; x: <huidigeToestand.huidigeX>, y: <huidigeToestand.huidigeY>, richting: <huidigeToestand.huidigeRichting>, pen: <huidigeToestand.pen> 🐢");

// handige functie om de link op te zoeken bij een tekening
Element link(Tekening t, Element e) = link(t.src, e);

// handige functie om van graden naar radialen te gaan, zodat we sin en cos kunnen gebruiken
real radialen(real graden) = (graden / 180.0) * PI();


