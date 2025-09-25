module lang::yop::Controle

import Message;
import util::LanguageServer;
import lang::yop::Syntax;
import ParseTree;

Summary controleer(start[Programma] p) = controleer(p.top);

Summary controleer(Programma p) {
    rel[str, loc] recepten   = {<"<r.naam>", r.naam.src> | r <- p.recepten};
    rel[str, loc] def = definities(p.tekeningen) + recepten;
    rel[loc, str] geb = gebruiken(p.tekeningen);

    summaries = [controleer(r, recepten) | r <- p.recepten];

    return summary(p.src,
        definitions = geb o def + {*r.definitions | r <- summaries},
        messages    = controleer(def, geb) + {*r.messages | r <- summaries}
    );
}

Summary controleer((Recept) `recept <Naam n> { <Tekening* p> }`, rel[str, loc] recepten) {
    rel[str, loc] def = definities(p) + recepten;
    rel[loc, str] geb = gebruiken(p);

    return summary(n.src,
        definitions = geb o def,
        messages    = controleer(def, geb)
    );
}

Summary controleer((Recept) `recept <Naam n> met <{Naam ","}+ args> { <Tekening* p> }`, rel[str, loc] recepten) {
    rel[str, loc] def = definities(p) + recepten + {<"<a>", a.src> | a <- args};
    rel[loc, str] geb = gebruiken(p);
    
    return summary(n.src,
        definitions = geb o def,
        messages = controleer(def, geb)
    );
}

rel[loc, Message] controleer(rel[str,loc] definities, rel[loc, str] gebruiken) 
    = { <l, warning("Kan geen definitie voor naam <n> vinden", l)> 
    | str n <- (gebruiken<1> - definities<0>), <loc l, n> <- gebruiken};
    
rel[str, loc] definities(Tekening* p) 
    = {<"<n>", n.src> | /(Tekening) `<Naam n> = <Som _>` := p};

rel[loc, str] gebruiken(Tekening* p) 
    = {<n.src, "<n>"> | /(Som) `<Naam n>` := p}
    + {<n.src, "<n>"> | /(Tekening) `doe <Naam n>` := p}
    + {<n.src, "<n>"> | /(Tekening) `doe <Naam n> met <{Som ","}+ _>` := p};