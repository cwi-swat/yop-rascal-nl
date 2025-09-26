module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;
import String;
import util::Math;
import ParseTree;
import Exception;
import IO;

map[str, Recept] recepten = ();

data Werk(
    map[str,real] waarden = (),
    real x = 0.,
    real y = 0.,
    real richting = 90.0, // "omhoog"
    real penDikte = 2.,
    Color penKleur = rgb(0,0,0,1.),
    bool pen = true)
    = hoofdtaak()
    | taak(Werk vorige)
    ;

Werk huidigeWerk = hoofdtaak();

// richting veranderen kan, maar als je klokje rond bent, begin je weer bij 0
Werk veranderRichting(Werk taak, real graden) {
    taak.richting = taak.richting + graden;
    while (taak.richting > 360.0)
        taak.richting -= 360.0;
    while (taak.richting < -360.0)
        taak.richting += 360.0;

    return taak;
}

MiniSVG vertaal(Programma p) {
    huidigeWerk = hoofdtaak();
    recepten=();

    // dan recepten registreren
    for (r <- p.recepten) {
        registreer(r);
    }

    // dan de lijst van tekeningen vertalen
    return miniSVG(vertaalMeer(p.tekeningen), title=p@\loc[extension=""].file);
}

// 1-voor-1 de teken instructies vertalen
// de tekening komt alleen in de lijst als de pen `true` is
list[Element] vertaalMeer(Tekening* tekeningen) 
    = [e | t <- tekeningen, e := vertaal(t), huidigeWerk.pen];

void registreer(t:(Recept) `recept <Naam n> { <Tekening* _> }`) {
    recepten["<n>"] = t;
}

void registreer(t:(Recept) `recept <Naam n> met <{Naam ","}+ _> { <Tekening* _> }`) {
    recepten["<n>"] = t;
}

Element vertaal(t:(Tekening) `vooruit <Som afstand>`) {
    // waar komen we vandaan?
    vorigeX = huidigeWerk.x;
    vorigeY = huidigeWerk.y;

    // en waar gaan we naartoe?
    huidigeWerk.x = huidigeWerk.x + cos(radialen(huidigeWerk.richting)) * vertaal(afstand);
    huidigeWerk.y = huidigeWerk.y + sin(radialen(huidigeWerk.richting)) * vertaal(afstand);

    return link(t, line(vorigeX, huidigeWerk.x, vorigeY, huidigeWerk.y, \stroke-width=huidigeWerk.penDikte, \stroke=huidigeWerk.penKleur));
}

Element vertaal(t:(Tekening) `naar <Som x> <Som y>`) {
    // waar komen we vandaan?
    vorigeX = huidigeWerk.x;
    vorigeY = huidigeWerk.y;

    // en waar gaan we naartoe?
    huidigeWerk.x = vertaal(x);
    huidigeWerk.y = vertaal(y);

    return link(t, line(vorigeX, huidigeWerk.x, vorigeY, huidigeWerk.y,  \stroke-width=huidigeWerk.penDikte, \stroke=huidigeWerk.penKleur));
}

Element vertaal(t:(Tekening) `spring <Som afstand>`) {
    // simuleer een sprong door pen op, vooruit, pen neer

    huidigeWerk.pen = false;
    vertaal((Tekening) `vooruit <Som afstand>`);
    huidigeWerk.pen = true;

    return comment(t);
}

Element vertaal(t:(Tekening) `rechts <Som graden>`) {
    huidigeWerk = veranderRichting(huidigeWerk, -1 * vertaal(graden));
    return comment(t);
}

Element vertaal(t:(Tekening) `links <Som graden>`) {
    huidigeWerk = veranderRichting(huidigeWerk, vertaal(graden));
    return comment(t);
}

Element vertaal(t:(Tekening) `pen op`) {
    huidigeWerk.pen = false;
    return comment(t);
}

Element vertaal(t:(Tekening) `pen neer`) {
    huidigeWerk.pen = true;
    return comment(t);
}

Element vertaal(t:(Tekening) `<Naam n> = <Som s>`) {
    huidigeWerk.waarden["<n>"] = vertaal(s);
    return comment(t);
}

Element vertaal(t:(Tekening) `pen dikte <Som s>`) {
    huidigeWerk.penDikte = vertaal(s);
    return comment(t);
}

Element vertaal(t:(Tekening) `pen kleur <Kleur k>`) {
    huidigeWerk.penKleur = vertaal(k);
    return comment(t);
}

Element vertaal(t:(Tekening) `cirkel <Som diameter>`) 
    = link(t, circle(huidigeWerk.x, huidigeWerk.y, vertaal(diameter),  \stroke-width=huidigeWerk.penDikte,\stroke=huidigeWerk.penKleur));

Element vertaal((Tekening) `herhaal <Som aantal> { <Tekening* tekeningen> }`) 
    = move(0., 0., [*vertaalMeer(tekeningen) | _ <- [0..round(vertaal(aantal))]]);

Element vertaal(t:(Tekening) `als <Conditie c> { <Tekening* tekeningen> }`) {
    if (vertaal(c)) {
        return move(0.0, 0.0, [vertaal(x) | x <- tekeningen]);
    }
    else {
        return comment("conditie <c> was onwaar");
    }
}

Element vertaal(t:(Tekening) `doe <Naam n>`) {
    try {
        // maak een nieuwe lege toestand aan
        nieuweWerk = taak(huidigeWerk, 
            x = huidigeWerk.x, 
            y = huidigeWerk.y, 
            richting = huidigeWerk.richting,
            penDikte=huidigeWerk.penDikte, 
            penKleur=huidigeWerk.penKleur,
            pen=huidigeWerk.pen);
    
        huidigeWerk = nieuweWerk;

        // doe niets als het recept niet bestaat
        Recept recept = recepten["<n>"]?(Recept) `recept xxx { }`;

        // gewoon het recept stap-voor-stap vertalen
        return move(0.0, 0.0, vertaalMeer(recept.stappen));
    }
    catch e:42: {
        throw e;
    }
    finally {
        // oude toestand wordt weer de huidige toestand, maar wel met de X en de Y en de R waar we gebleven waren
        // huidigeWerk.vorige.penKleur = huidigeWerk.penKleur;
        huidigeWerk = huidigeWerk.vorige;
    }
}

Element vertaal(t:(Tekening) `doe <Naam n> met <{Som ","}+ argumenten>`) {
    
    // maak een nieuwe lege toestand aan die een clone is van de vorige
    // maak een nieuwe lege toestand aan
    nieuweWerk = taak(huidigeWerk, 
            x = huidigeWerk.x, 
            y = huidigeWerk.y, 
            richting = huidigeWerk.richting,
            penDikte=huidigeWerk.penDikte, 
            penKleur=huidigeWerk.penKleur,
            pen=huidigeWerk.pen);

    // workaround om bug in concrete list indexing
    args = [a | a <- argumenten];

    // doe niets als het recept niet bestaat
    Recept recept = recepten["<n>"]?(Recept) `recept xxx { }`;

    if ((Recept) `recept <Naam n> met <{Naam ","}+ parameters> { <Tekening* _> }` := recept) {
        int i = 0;

        for (Naam a <- parameters) {
            nieuweWerk.waarden = nieuweWerk.waarden? ? nieuweWerk.waarden : ();
            // als iemand een argument vergeet wordt het 0
            nieuweWerk.waarden["<a>"] = vertaal(args[i]? (Som) `0`);
            i=i+1;
        }
    }

    try {
        // huidigeWerk.vorige.penKleur = huidigeWerk.penKleur;
        huidigeWerk = nieuweWerk;
        return move(0.0, 0.0, vertaalMeer(recept.stappen));
    }
    catch e:42: throw e;
    finally {
        huidigeWerk = huidigeWerk.vorige;
    }
}

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
real vertaal((Som) `<Naam n>`)          = huidigeWerk.waarden["<n>"]?0.;
real vertaal((Som) `(<Som s>)`)         = vertaal(s);

real vertaal((Som) `random <Som w>`) = 1. * arbInt(round(vertaal(w)));

// van syntax naar Rascal `int` getallen waar we mee kunnen rekenen
real vertaal(Getal g) = 1. * toInt("<g>");

bool vertaal((Conditie) `<Som l> == <Som r>`) = vertaal(l) == vertaal(r);
bool vertaal((Conditie) `<Som l> != <Som r>`) = vertaal(l) != vertaal(r);
bool vertaal((Conditie) `<Som l> \<= <Som r>`) = vertaal(l) <= vertaal(r);
bool vertaal((Conditie) `<Som l> \>= <Som r>`) = vertaal(l) >= vertaal(r);
bool vertaal((Conditie) `<Som l> \< <Som r>`) = vertaal(l) < vertaal(r);
bool vertaal((Conditie) `<Som l> \> <Som r>`) = vertaal(l) > vertaal(r);
bool vertaal((Conditie) `(<Conditie c>)`) = vertaal(c);
bool vertaal((Conditie) `niet <Conditie c>`) = !vertaal(c);
bool vertaal((Conditie) `<Conditie l> en <Conditie r>`) = vertaal(l) && vertaal(r);
bool vertaal((Conditie) `<Conditie l> of <Conditie r>`) = vertaal(l) || vertaal(r);

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
Element comment(Tekening t) = comment("🐢 <t>; x: <huidigeWerk.x>, y: <huidigeWerk.y>, richting: <huidigeWerk.richting>, pen: <huidigeWerk.pen>, penDikte: <huidigeWerk.penDikte> 🐢");

// handige functie om de link op te zoeken bij een tekening
Element link(Tekening t, Element e) = link(t.src, e);

// handige functie om van graden naar radialen te gaan, zodat we sin en cos kunnen gebruiken
real radialen(real graden) = (graden / 180.0) * PI();


