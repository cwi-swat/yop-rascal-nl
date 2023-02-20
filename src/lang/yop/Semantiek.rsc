module lang::yop::Semantiek

import lang::miniSVG::Syntax;
import lang::yop::Syntax;

// MiniSVG vertaal(Programma p) {
     
//     return miniSVG([ t <- p.tekeningen, ], 0, -250, 500, 500);
// }

data Geheugen = geheugen(Tekening* werklijst, list[Element] gedaan, int x, int y, int richting, bool pen);

Geheugen vertaal((Tekening) `vooruit <Getal g>`, Geheugen g) = line(x, y, 0, 0);

