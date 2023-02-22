module lang::miniSVG::Bekijken

import lang::miniSVG::Semantiek;
import lang::miniSVG::Syntax;

import Content;
import util::IDEServices;
import ValueIO;

void bekijken(MiniSVG plaatje) {
    // eerst vertalen
    echteSVG = toSVG(plaatje);

    // dan laten zien
    bekijkSVG(echteSVG);
}

// dit start een web server en een web viewer op met het plaatje er in:
private void bekijkSVG(str svg, str id="miniSVG") {
    showInteractiveContent(content(id, webServer(svg)));
}

// dit is een kleine webserver die twee dingen doet:
//   1. een simpele HTML webpagina met daarin het SVG plaatje opsturen
//   2. antwoord geven als er op iets geklikt wordt (dan opent hij een editor)
Response (Request) webServer(str svg) {
    // iemand heeft ergens op geklikt:
    Response reply(get(/^\/editor/, parameters=pms)) {
        // open een editor met de broncode
        edit(readTextValueString(#loc, pms["src"]));
        return response("done");
    }

    // hier sturen we de hele pagina met het plaatje er alvast in
    default Response reply(get(_)) {
        return response(pagina(svg));
    }

    return reply;
}

str pagina(str svg) 
    =   "\<html\>
        '   \<head\>
        '       \<style\>
        '           html, body, svg {
        '               width: 100%;
        '               height: 100%;
        '               margin: 0;
        '           }
        '       \</style\>
        '   \</head\>
        '   \<body\>
        '       <svg>
        '   \<body\>
        '\<html\>";