module lang::miniSVG::Semantiek

import lang::miniSVG::Syntax;

// Dit vertaalt een-op-een een lijst van miniSVG teken-instructies naar de textuele XML vorm die "SVG" heet.
// Én het regelt de assen (van waar tot waar (-1000 tot 1000), en de richting (y-as omhoog en x-as naar rechts))
str toSVG(miniSVG(list[Element] elements))
    = "\<svg 
      '    viewBox=\"0 0 1000 1000\"
      '    preserveAspectRatio=\"xMidYMid slice\" height=\"100%\"
      '    stroke=\"black\"
      '    fill=\"grey\"
      '    fill-opacity=\".5\"
      '    stroke-opacity=\".8\"
      '\>
      '\<rect x=\"0\" y=\"0\" width=\"1000\" height=\"1000\" style=\"fill: lightyellow\"/\>
      '\<g transform=\"matrix(1 0 0 -1 500 500)\" \>
      '    <for (e <- elements) {><toSVG(e)>
      '    <}>
      '    \<line x1=\"0\" y1=\"-500\" x2=\"0\" y2=\"500\" stroke-dasharray=\"2\" stroke=\"orange\" stroke-opacity=\".5\" /\> 
      '    \<line x1=\"-500\" y1=\"0\" x2=\"500\" y2=\"0\"stroke-dasharray=\"2\" stroke=\"orange\" stroke-opacity=\".5\" /\> 
      '\</g\>
      '\</svg\>
      '";

str toSVG(e:circle(int cx, int cy, int r)) 
    = "\<circle cx=\"cx\" cy=\"<cy>\" r=\"<r>\" <stroke(e)> /\>"; 

str toSVG(e:rectangle(int x, int y, int width, int height)) 
    = "\<rect x=\"<x>\" y=\"<y>\" width=\"<width>\" height=\"<height>\" <stroke(e)> /\>";

str toSVG(e:ellipse(int cx, int cy, int rx, int ry)) 
    = "\<ellipse cx=\"<cx>\" cy=\"<cy>\" rx=\"<rx>\" ry=\"<ry>\" <stroke(e)> /\>";
    
str toSVG(e:line(int x1, int x2, int y1, int y2)) 
    = "\<line x1=\"<x1>\" x2=\"<x2>\" y1=\"<y2>\" y2=\"<y2>\" <stroke(e)> /\>";

str toSVG(e:polyline(lrel[int x, int y] points)) 
    = "\<polyline points=\"<for (<x,y> <- points) {><x>,<y> <}>\" <stroke(e)> /\>";

str toSVG(e:polygon(lrel[int x, int y] points)) 
    = "\<polygon points=\"<for (<x,y> <- points) {><x>,<y> <}>\" <stroke(e)> /\>";

str stroke(Element e) = "stroke=\"<toSVGColor(e.stroke)>\" stroke-width=\"<e.\stroke-width>\" fill-opacity=\".5\" stroke-opacity=\"1\"";

str toSVGColor(black()) = "black";
str toSVGColor(white()) = "white";
str toSVGColor(none())  = "none";
default str toSVGColor(Color _) = "pink";

