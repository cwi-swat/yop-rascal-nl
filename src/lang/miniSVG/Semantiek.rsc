module lang::miniSVG::Semantiek

import lang::miniSVG::Syntax;
import String;

// Dit vertaalt een-op-een een lijst van miniSVG teken-instructies naar de textuele XML vorm die "SVG" heet.
// Én het regelt de assen (van waar tot waar (-1000 tot 1000), en de richting (y-as omhoog en x-as naar rechts))
str toSVG(miniSVG(list[Element] elements))
    = "\<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" viewBox=\"0 0 1000 1000\" preserveAspectRatio=\"xMidYMid slice\" height=\"100%\" \>
      '\<rect x=\"0\" y=\"0\" width=\"1000\" height=\"1000\" style=\"fill: lightyellow\"/\>
      '\<g transform=\"matrix(1 0 0 -1 500 500)\" \>
      '    <for (e <- elements) {>
      '    <toSVG(e)><}>
      '    \<line x1=\"0\" y1=\"-500\" x2=\"0\" y2=\"500\" stroke-dasharray=\"2\" stroke=\"orange\" stroke-opacity=\".5\" /\> 
      '    \<line x1=\"-500\" y1=\"0\" x2=\"500\" y2=\"0\" stroke-dasharray=\"2\" stroke=\"orange\" stroke-opacity=\".5\" /\> 
      '\</g\>
      '\</svg\>
      '";

str toSVG(e:circle(real cx, real cy, real r)) 
    = "\<circle cx=\"<cx * 1.0>\" cy=\"<cy * 1.0>\" r=\"<r * 1.0>\" <style(e)> /\>"; 

str toSVG(e:rectangle(real x, real y, real width, real height)) 
    = "\<rect x=\"<x * 1.0>\" y=\"<y * 1.0>\" width=\"<width * 1.0>\" height=\"<height * 1.0>\" <style(e)> /\>";

str toSVG(e:ellipse(real cx, real cy, real rx, real ry)) 
    = "\<ellipse cx=\"<cx * 1.0>\" cy=\"<cy * 1.0>\" rx=\"<rx * 1.0>\" ry=\"<ry * 1.0>\" <style(e)> /\>";
    
str toSVG(e:line(real x1, real x2, real y1, real y2)) 
    = "\<line x1=\"<x1 * 1.0>\" x2=\"<x2 * 1.0>\" y1=\"<y1 * 1.0>\" y2=\"<y2 * 1.0>\" <style(e)> /\>";

str toSVG(e:polyline(lrel[real x, real y] poreals)) 
    = "\<polyline poreals=\"<for (<x,y> <- poreals) {><x * 1.0>,<y * 1.0> <}>\" <style(e)> /\>";

str toSVG(e:polygon(lrel[real x, real y] poreals)) 
    = "\<polygon poreals=\"<for (<x,y> <- poreals) {><x * 1.0>,<y * 1.0> <}>\" <style(e)> /\>";

str toSVG(move(real x, real y, list[Element] elements)) 
    = "\<g transform=\"matrix(1 0 0 1 <x * 1.0> <1.0 * y>)\" \>
      '    <for (e <- elements) {>
      '    <toSVG(e)><}>
      '\</g\>";

str toSVG(scale(real factor, list[Element] elements)) 
    = "\<g transform=\"scale(<factor * 1.0> <factor * 1.0>)\" \>
      '    <for (e <- elements) {><toSVG(e)>
      '    <}>
      '\</g\>";

str toSVG(rotate(real angle, list[Element] elements)) 
    = "\<g transform=\"rotate(<angle * 1.0>)\" \>
      '    <for (e <- elements) {><toSVG(e)>
      '    <}>
      '\</g\>";

str toSVG(link(loc src, Element element)) 
    = "\<a href=\"#\" onclick=\"fetch(\'/editor?\' + new URLSearchParams({src: \'<escape("<src>", ( "\<" : "&lt;", "\>" : "&gt;" ))>\'}));\"\>
      '  <toSVG(element)>
      '\</a\>";

str x = "&gt;";

str toSVG(comment(str bericht)) = "\<!-- <bericht> --\>";

// Omdat het assenstelsel op zijn kop staat, staat alle tekst ook op zijn kop.
// Daarom draaien we hier alles weer terug voordat we het tekenen door eerst y met -1
// te vermenigvuldigen en daarna alles verticaal terug te schuiven (anders komt het onder de y-as terecht)
// Maar niet voordat we de text in de gevraagde richting hebben gedraaid (om de richting van de schildpad te kunnen gebruiken)
str toSVG(e:text(real x, real y, real angle, str alinea)) 
    = "\<text x=\"<x * 1.0>\" y=\"<y * 1.0>\"  transform=\"rotate(<angle * 1.0> <x * 1.0> <y * 1.0>) scale(1,-1) translate(<0.0> <-2.0 * y>) \" <style(e)> \>
      '   <alinea>
      '\</text\>
      '";

default str toSVG(Element e) {
    throw "can not translate element yet: <e>";
}

str style(Element e) 
    = "stroke=\"<toSVGColor(e.stroke)>\" 
      '    fill=\"<toSVGColor(e.fill)>\" 
      '    stroke-width=\"<1.0 * e.\stroke-width>\" 
      '    fill-opacity=\"<1.0 * e.\fill-opacity>\" 
      '    stroke-opacity=\"<1.0 * e.\stroke-opacity>\"";



str toSVGColor(rgb(int r, int g, int b, real a)) = "rgb(<r>,<g>,<b>,<a * 1.0>)";




