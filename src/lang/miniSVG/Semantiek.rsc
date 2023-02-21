module lang::miniSVG::Semantiek

import lang::miniSVG::Syntax;

// Dit vertaalt een-op-een een lijst van miniSVG teken-instructies naar de textuele XML vorm die "SVG" heet.
// Én het regelt de assen (van waar tot waar (-1000 tot 1000), en de richting (y-as omhoog en x-as naar rechts))
str toSVG(miniSVG(list[Element] elements))
    = "\<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" viewBox=\"0 0 1000 1000\" preserveAspectRatio=\"xMidYMid slice\" height=\"100%\" \>
      '\<rect x=\"0\" y=\"0\" width=\"1000\" height=\"1000\" style=\"fill: lightyellow\"/\>
      '\<g transform=\"matrix(1 0 0 -1 500 500)\" \>
      '    <for (e <- elements) {><toSVG(e)>
      '    <}>
      '    \<line x1=\"0\" y1=\"-500\" x2=\"0\" y2=\"500\" stroke-dasharray=\"2\" stroke=\"orange\" stroke-opacity=\".5\" /\> 
      '    \<line x1=\"-500\" y1=\"0\" x2=\"500\" y2=\"0\" stroke-dasharray=\"2\" stroke=\"orange\" stroke-opacity=\".5\" /\> 
      '\</g\>
      '\</svg\>
      '";

str toSVG(e:circle(int cx, int cy, int r)) 
    = "\<circle cx=\"<cx>\" cy=\"<cy>\" r=\"<r>\" <stroke(e)> /\>"; 

str toSVG(e:rectangle(int x, int y, int width, int height)) 
    = "\<rect x=\"<x>\" y=\"<y>\" width=\"<width>\" height=\"<height>\" <stroke(e)> /\>";

str toSVG(e:ellipse(int cx, int cy, int rx, int ry)) 
    = "\<ellipse cx=\"<cx>\" cy=\"<cy>\" rx=\"<rx>\" ry=\"<ry>\" <stroke(e)> /\>";
    
str toSVG(e:line(int x1, int x2, int y1, int y2)) 
    = "\<line x1=\"<x1>\" x2=\"<x2>\" y1=\"<y1>\" y2=\"<y2>\" <stroke(e)> /\>";

str toSVG(e:polyline(lrel[int x, int y] points)) 
    = "\<polyline points=\"<for (<x,y> <- points) {><x>,<y> <}>\" <stroke(e)> /\>";

str toSVG(e:polygon(lrel[int x, int y] points)) 
    = "\<polygon points=\"<for (<x,y> <- points) {><x>,<y> <}>\" <stroke(e)> /\>";

str toSVG(move(int x, int y, list[Element] elements)) 
    = "\<g transform=\"matrix(1 0 0 1 <x> <1 * y>)\" \>
      '    <for (e <- elements) {><toSVG(e)>
      '    <}>
      '\</g\>";

str toSVG(scale(real factor, list[Element] elements)) 
    = "\<g transform=\"scale(<factor> <factor>)\" \>
      '    <for (e <- elements) {><toSVG(e)>
      '    <}>
      '\</g\>";

str toSVG(link(loc src, Element element)) 
    = "\<a href=# onclick=\"fetch(\'/editor?\' + new URLSearchParams({src: <"<src>"[1..-1]>}));\"\>
      '  <toSVG(element)>
      '\</a\>";

str toSVG(nothing()) = "";

// Omdat het assenstelsel op zijn kop staat, staat alle tekst ook op zijn kop.
// Daarom draaien we hier alles weer terug voordat we het tekenen door eerst y met -1
// te vermenigvuldigen en daarna alles verticaal terug te schuiven (anders komt het onder de y-as terecht)
str toSVG(e:text(int x, int y, str alinea)) 
    = "\<g transform=\"matrix(1 0 0 -1 0 <2 * y>)\" \>
      '    \<text x=\"<x>\" y=\"<y>\"\>
      '        <alinea>
      '    \</text\>
      '\</g\>";

default str toSVG(Element e) {
    throw "can not translate element yet: <e>";
}

str stroke(Element e) 
    = "stroke=\"<toSVGColor(e.stroke)>\" fill=\"<toSVGColor(e.fill)>\" stroke-width=\"<e.\stroke-width>\" fill-opacity=\"<e.\fill-opacity>\" stroke-opacity=\"<e.\stroke-opacity>\"";

str toSVGColor(str colorName()) = colorName;
default str toSVGColor(Color _) = "pink";



