module lang::miniSVG::Bekijken

import lang::miniSVG::Semantiek;
import lang::miniSVG::Syntax;

import Content;
import util::IDEServices;
import IO;

void bekijken(MiniSVG plaatje) {
    echteSVG = toSVG(plaatje);

    bekijkSVG(echteSVG);
}

void opslaan(MiniSVG plaatje, str bestandsnaam) {
    writeFile((|home:///| + bestandsnaam)[extension="svg"], 
        "\<?xml version=\"1.0\" standalone=\"yes\"?\>
        '<toSVG(plaatje)>");
}

private void bekijkSVG(str svg) {
    showInteractiveContent(content(response(ok(), "text/html", (), 
    "\<html\>
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
    '\<html\>")));
}