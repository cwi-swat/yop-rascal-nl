module lang::yop::Proberen

import lang::yop::Syntax;
import lang::yop::Gebruiker;
import ParseTree;

@synopsis{Voert een commando uit op een .yop-bestand, hier in de REPL in plaats van in de language server.}
@description{
De language server voert `exec` uit in een apart proces, waar de debugger niet bij kan.
Klik op "Run in new Rascal terminal" boven `main()` hieronder en typ dan `testExec()`:
dan stoppen breakpoints in `exec`, `vertaal` enzovoort wel. Gebruik `command="svg"` of
`command="mini"` voor de andere commando's, en `file=|project://yop-rascal-nl/voorbeelden/...|`
voor een ander voorbeeld.

Het commando is een woord, niet `run`/`svg`/`mini` uit Gebruiker zelf: een terminal die alleen
deze module importeert, kent die namen niet (Rascal geeft imports niet door).
}
value testExec(loc file = |project://yop-rascal-nl/voorbeelden/1-basis/cirkels.yop|, str command = "run") {
    Programma p = parse(#start[Programma], file).top;
    Command opdracht = ("run": run(p), "svg": svg(p), "mini": mini(p))[command];
    return exec(opdracht);
}

@synopsis{Staat hier alleen voor de CodeLens "Run in new Rascal terminal": die importeert deze module met de debugger aan.}
value main() {
    return testExec();
}
