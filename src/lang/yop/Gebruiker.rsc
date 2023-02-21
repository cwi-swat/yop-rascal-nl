module lang::yop::Gebruiker

import util::LanguageServer;
import lang::yop::Syntax;
import lang::yop::Semantiek;
import lang::miniSVG::Syntax;
import lang::miniSVG::Bekijken;
import util::Reflective;
import ParseTree;
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
            <p.src, run(p.top, title="Uitvoeren!")>,
            <p.src, mini(p.top, title="Bekijk MiniSVG")>
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
    iprintToFile(p.src[extension="mini"], mini);
    return ("result": true);
}

void main() {
    registerLanguage(yopLang);
}