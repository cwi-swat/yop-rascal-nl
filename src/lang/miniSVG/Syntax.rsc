module lang::miniSVG::Syntax

data MiniSVG = miniSVG(list[Element] elements);

data Element(Color stroke=black(), int \stroke-width=1, Color fill=\none())
    = circle(int cx, int cy, int r)
    | rectangle(int x, int y, int width, int height, int rx=0, int ry=0)
    | ellipse(int cx, int cy, int rx, int ry)
    | line(int x1, int x2, int y1, int y2)
    | polyline(lrel[int x, int y] points)
    | polygon(lrel[int x, int y] points)
    ;

data Color
    = black()
    | white()
    | none()
    ;