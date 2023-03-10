module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;
import String;
import IO;
import util::Math;
import ParseTree;
import Exception;

// de toestand van de schildpad is X, Y en Richting
data Toestand =
  toestand(
    map[str,real] waarden,
    map[str, Tekening] recepten,
    real huidigeX = 0.,
    real huidigeY = 0.,
    real huidigeRichting = 0.,
    real huidigePenDikte = 2.,
    Color huidigePenKleur = rgb(0,0,0,1.),
    bool pen = true,
    Toestand vorige = toestand((),())
  );

Toestand huidigeToestand = toestand((),());

Tekening zoekRecept(str naam) = zoekRecept(naam, huidigeToestand);
Tekening zoekRecept(str naam, Toestand t) {
    if (t.recepten[naam]?) {
        println("found <naam>");
        return t.recepten[naam];
    }
    else if (t.vorige?) {
        println("scope up!");
        return zoekRecept(naam, t.vorige);
    }
    else {
        println("no luck!");
        return (Tekening) `doe xxx { }`;
    }
}


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
    huidigeToestand = toestand((),());
    
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

Element vertaal(t:(Tekening) `recept <Naam n> { <Tekening* _> }`) {
    huidigeToestand.recepten["<n>"] = t;
    return comment("recept <n> geregistreerd");
}

Element vertaal(t:(Tekening) `recept <Naam n> met <{Naam ","}+ _> { <Tekening* _> }`) {
    huidigeToestand.recepten["<n>"] = t;
    return comment("recept <n> geregistreerd");
}

Element vertaal(t:(Tekening) `als <Conditie c> { <Tekening* tekeningen> }`) {
    println("testen van <c>");
    if (vertaal(c)) {
        println("<c> was waar");
        return move(0.0, 0.0, [vertaal(x) | x <- tekeningen]);
    }
    else {
        println("<c> was onwaar");
        return comment("conditie <c> was onwaar");
    }
}

Element vertaal(t:(Tekening) `doe <Naam n>`) {
    try {
        // maak een nieuwe lege toestand aan die een clone is van de vorige
        huidigeToestand = huidigeToestand[vorige=huidigeToestand];

        // gewoon het recept stap-voor-stap vertalen
        return move(0.0, 0.0, [ vertaal(stap) | stap <- zoekRecept("<n>").stappen]);
    }
    catch value e: {
        throw e;
    }
    finally {
        // oude toestand wordt weer de huidige toestand, maar wel met de X en de Y en de R waar we gebleven waren
        // huidigeToestand = huidigeToestand.vorige[huidigeX=huidigeToestand.huidigeX][huidigeY=huidigeToestand.huidigeY][huidigeRichting=huidigeToestand.richting];
        huidigeToestand = huidigeToestand.vorige;
    }
}

Element vertaal(t:(Tekening) `doe <Naam n> met <{Som ","}+ argumenten>`) {
    try {
        // maak een nieuwe lege toestand aan die een clone is van de vorige
        huidigeToestand = huidigeToestand[vorige=huidigeToestand];
        println("executie van <n> met <argumenten>");

        // doe niets als het recept niet bestaat
        Tekening recept = zoekRecept("<n>");

        println("recept gevonden: <recept.naam>");

        if ((Tekening) `recept <Naam n> met <{Naam ","}+ parameters> { <Tekening* _> }` := recept) {
            int i = 0;
            
            for (Naam a <- parameters) {
                // als iemand een argument vergeet wordt het 0
                huidigeToestand.waarden["<a>"] = vertaal(argumenten[i]?0.0);
                i=i+1;
            }
        }

        println("bindings <huidigeToestand.waarden>");

        // gewoon het recept stap-voor-stap vertalen
        
        return move(0.0, 0.0, [ vertaal(stap) | stap <- recept.stappen]);
    }
    catch e: throw e;
    finally {
        // oude toestand terug zetten van voor het recept
        huidigeToestand = huidigeToestand.vorige;
    }
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
real vertaal((Som) `<Naam n>`)          = huidigeToestand.waarden["<n>"]?0.;
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
bool vertaal((Conditie) `(<Conditie c>)`) = vertaal(l);
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
Element comment(Tekening t) = comment("🐢 <t>; x: <huidigeToestand.huidigeX>, y: <huidigeToestand.huidigeY>, richting: <huidigeToestand.huidigeRichting>, pen: <huidigeToestand.pen> 🐢");

// handige functie om de link op te zoeken bij een tekening
Element link(Tekening t, Element e) = link(t.src, e);

// handige functie om van graden naar radialen te gaan, zodat we sin en cos kunnen gebruiken
real radialen(real graden) = (graden / 180.0) * PI();


