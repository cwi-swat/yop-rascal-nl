module lang::miniSVG::Syntax

data MiniSVG 
    = miniSVG(list[Element] elements);

data Element(Color stroke=rgb(0,0,0), real \stroke-width=1., Color fill=rgb(230,230,230), real \fill-opacity=0.8, real \stroke-opacity=1.)
    = circle(real cx, real cy, real r)
    | rectangle(real x, real y, real width, real height, real rx=0, real ry=0)
    | ellipse(real cx, real cy, real rx, real ry)
    | line(real x1, real x2, real y1, real y2)
    | polyline(lrel[real x, real y] poreals)
    | polygon(lrel[real x, real y] poreals)
    | text(real x, real y, real angle, str sentence)
    | move(real x, real y, list[Element] elements)
    | rotate(real angle, list[Element] elements)
    | scale(real factor, list[Element] elements)
    | link(loc src, Element element)
    | comment(str what)
    ;

data Color = rgb(int r, int g, int b, real transparancy);

