module lang::yop::Tests

import IO;
import util::FileSystem;
import lang::yop::Syntax;
import ParseTree;

test bool parseAllFile() {
    for (f <- find(|project://yop-rascal-nl/voorbeelden|, "yop")) {
        parse(#start[Programma], f);
    }
    return true;
}