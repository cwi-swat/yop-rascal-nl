module lang::yop::Gebruiker

import util::LanguageServer;
import lang::yop::Syntax;
import lang::yop::Semantiek;
import lang::miniSVG::Syntax;
import lang::miniSVG::Bekijken;
import lang::miniSVG::Semantiek;
import util::Reflective;
import ParseTree;
import util::IDEServices;
import IO;

PathConfig pcfg = getProjectPathConfig(|project://yop-rascal-nl|);
Language yopLang = language(pcfg, "YOP", "yop", "lang::yop::Gebruiker", "contribs");

data Command
    = run(Programma p)
    | svg(Programma p)
    | mini(Programma p)
    ;

set[LanguageService] contribs() = {
    parser(start[Programma] (str program, loc src) {
        return parse(#start[Programma], program, src);
    }),

    lenses(rel[loc src, Command lens] (start[Programma] p) {
        return {
            <p.src, run (p.top, title="Bekijk plaatje")>,
            <p.src, mini(p.top, title="Bekijk MiniSVG code")>,
            <p.src, svg(p.top, title="Bekijk SVG code")>
        };
    }),

    executor(exec)
};

value exec(run(Programma p)) {
   bekijken(vertaal(p));
   return ("result": true);
}

value exec(mini(Programma p)) {
    MiniSVG mini = vertaal(p);
    bestand = p.src.top[extension="mini"];
    iprintToFile(bestand, mini);
    edit(bestand);
    return ("result": true);
}

value exec(svg(Programma p)) {
    str svg = toSVG(vertaal(p));
    bestand = p.src.top[extension="svg"];
    writeFile(bestand, svg);
    edit(bestand);
    return ("result": true);
}

void main() {
    registerLanguage(yopLang);
}