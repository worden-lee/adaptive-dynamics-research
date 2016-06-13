# helper makefile automatically generated from sea-col.sage.step
sea-col.sage sea-col.sage.out sea-col.sage.tried : sea-down.sobj
sea-col.sage.out.tex : sea-col.sage.out ;
sea-col-ts.svg sea-col-sel.tex : sea-col.sage.out ;
sea-col.sage sea-col.sage.out sea-col.sage.tried : STEP_PRODUCTS= sea-col.sage.out.tex sea-col-ts.svg sea-col-sel.tex
