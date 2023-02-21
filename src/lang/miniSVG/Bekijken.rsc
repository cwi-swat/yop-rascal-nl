module lang::miniSVG::Bekijken

import lang::miniSVG::Semantiek;
import lang::miniSVG::Syntax;

import Content;
import util::IDEServices;
import IO;

void davidsPlaatje() {
    plaatje = [
        
        line(10,-10,100,-100),
        line(-800,200,10,-10),
        circle(0,0,50),
        circle(10,10,50,stroke=lightred()),
        circle(-10,-10,50), 
        rectangle(-100,-100,200,200,stroke=red(),\stroke-width=10,\fill=white(),\fill-opacity=.5,\stroke-opacity=1.0),
        polyline([<0,0>,<0,10>,<10,-10>,<-10,10>]),
        text(-100,110,"Hallo! Groetjes van David"),
        polygon([<100,0>,<0,10>,<10,-10>,<-10,10>])
    ];

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