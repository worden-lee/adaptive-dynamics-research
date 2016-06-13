# helper makefile automatically generated from sea-ass.sage.step
sea-ass.sage sea-ass.sage.out sea-ass.sage.tried : sea-down.sobj
sea-ass.sage.out.tex : sea-ass.sage.out ;
sea-ass-ts.svg sea-ass-sel.tex : sea-ass.sage.out ;
sea-ass.sage sea-ass.sage.out sea-ass.sage.tried : STEP_PRODUCTS= sea-ass.sage.out.tex sea-ass-ts.svg sea-ass-sel.tex
