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
    bekijkSVG(echteSVG, id=plaatje.title);
}

// dit start een web server en een web viewer op met het plaatje er in:
private void bekijkSVG(str svg, str id="miniSVG") {
    showInteractiveContent(content(id, webServer(svg)), viewColumn=1, title=id);
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
    Response reply(get("/")) { 
        return response(pagina(svg));
    }

    Response reply(get("/index.html")) { 
        return response(pagina(svg));
    }

    default Response reply(get("/favicon.ico")) { 
        return response(notFound(), "we hebben geen favicon");
    }

    default Response reply(get(str path)) { 
        return response(notFound(), "<path> bestaat niet in dit plaatje.");
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
        '       \<script src=\"https://unpkg.com/panzoom@9.4.0/dist/panzoom.min.js\"\>\</script\>
        '   \</head\>
        '   \<body\>
        '       <svg>
        '       \<script\>
        '           document.addEventListener(\"DOMContentLoaded\", function() {
        '               var svgElement = document.getElementById(\'yop\');
        '               panzoom(svgElement);
        '           });
        '       \</script\>
        '   \<body\>
        '\<html\>";