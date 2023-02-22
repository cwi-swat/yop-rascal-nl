module lang::yop::Controle

import Message;
import util::LanguageServer;
import lang::yop::Syntax;
import ParseTree;

Summary controleer(Programma p) {
    definities = {<"<n>", n.src> | /(Tekening) `<Naam n> = <Som _>` := p};
    gebruiken  = {<"<n>", n.src> | /(Som) `<Naam n>` := p};
    
    return summary(p.src,
        messages = {<l, warning("Kan geen enkele definitie voor naam <n> vinden", l)> 
                   | n <- gebruiken<0> - definities<0>, l <- gebruiken[n]}

                 + {<l, warning("Deze naam <n> wordt zo te zien pas later gedefinieerd op regel <m.begin.line>", l)> 
                   | <n,l> <- gebruiken, !any(m <- definities[n], l.begin.line >= m.begin.line), m <- definities[n]},
        
        definitions = gebruiken<1,0> o definities
    );
}