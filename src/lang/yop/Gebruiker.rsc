module lang::yop::Gebruiker

import lang::yop::Syntax;
import lang::yop::Semantiek;
import lang::yop::Controle;

import lang::miniSVG::Syntax;
import lang::miniSVG::Semantiek;
import lang::miniSVG::Bekijken;

import util::Reflective;
import util::IDEServices;
import util::LanguageServer;

import ParseTree;
import IO;

PathConfig pcfg = getProjectPathConfig(|project://yop-rascal-nl|);
Language yopLang = language(pcfg, "YOP", {"yop"}, "lang::yop::Gebruiker", "contribs");

data Command
    = run(Programma p)
    | svg(Programma p)
    | mini(Programma p)
    ;

set[LanguageService] contribs() = {
    parsing(start[Programma] (str program, loc src) {
        return parse(#start[Programma], program, src);
    }),

    codeLens(lrel[loc src, Command lens] (start[Programma] p) {
        return [
            <p.src, run (p.top, title="Bekijk plaatje")>,
            <p.src, mini(p.top, title="Bekijk MiniSVG code")>,
            <p.src, svg(p.top,  title="Bekijk SVG code")>
        ];
    }),

    analysis(Summary (loc _, start[Programma] p) {
        return controleer(p.top);
    }),

    execution(exec)
};

value exec(run(Programma p)) {
    try {
        bekijken(vertaal(p));
        return ("result": true);
    }
    catch StackOverflow(): {
        registerDiagnostics([error("Oneindige recursie", src)]);
        return ("result": false);
    }
    catch loc src : {
        registerDiagnostics([error("Delen door nul is flauwekul", src)]);
        return ("result": false);
    }
}

value exec(mini(Programma p)) {
    try {
        MiniSVG mini = vertaal(p);
        bestand = (p.src.top.parent.parent + "resultaten" + "mini" + p.src.top.file)[extension="mini"];
        iprintToFile(bestand, mini);
        edit(bestand, viewColumn=2);
        return ("result": true);
    }
    catch loc src : {
        registerDiagnostics([error("Delen door nul is flauwekul", src)]);
        return ("result": false);
    }
}

value exec(svg(Programma p)) {
    try {
        str svg = toSVG(vertaal(p));
        bestand = (p.src.top.parent.parent + "resultaten" + "svg" + p.src.top.file)[extension="svg"];
        writeFile(bestand, svg);
        edit(bestand, viewColumn=2);
        return ("result": true);
    }
    catch loc src : {
        registerDiagnostics([error("Delen door nul is flauwekul", src)]);
        return ("result": false);
    }
}

void main() {
    registerLanguage(yopLang);
}