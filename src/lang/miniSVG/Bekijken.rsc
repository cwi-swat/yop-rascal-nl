module lang::miniSVG::Bekijken

import lang::miniSVG::Semantiek;
import lang::miniSVG::Syntax;

import Content;
import util::IDEServices;
import IO;

void davidsPlaatje() {
    plaatje = [  
        circle(50,25,50),
        circle(0,0,75,stroke=lightred()),
        rectangle(-100,-100,200,200,stroke=red(),\stroke-width=10,\fill=white(),\fill-opacity=.5,\stroke-opacity=1.0),
        scale(1.0, [
            move(-10,-10,[
                polyline([<0,0>,<20,0>,<20,20>,<10,30>,<0,20>,<0,0>], \stroke-width=5)
            ])
        ]),
        scale(1.0, [text(-100,110,"Hallo! Groetjes van David")])
    ];

    iprintln(plaatje);
    println(toSVG(miniSVG(plaatje)));
    
    bekijken(miniSVG(plaatje));
}

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