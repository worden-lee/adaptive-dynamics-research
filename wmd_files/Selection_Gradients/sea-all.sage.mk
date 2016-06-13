# helper makefile automatically generated from sea-all.sage.step
sea-all.sage sea-all.sage.out sea-all.sage.tried : sea-down.sobj
sea-all.sage.out.tex sea-all-sel.tex : sea-all.sage.out ;
sea-all-ts.svg sea-all-values.svg : sea-all.sage.out ;
sea-all-ts2.svg sea-all-values2.svg : sea-all.sage.out ;
sea-all.sage sea-all.sage.out sea-all.sage.tried : STEP_PRODUCTS= sea-all.sage.out.tex sea-all-sel.tex sea-all-ts.svg sea-all-values.svg sea-all-ts2.svg sea-all-values2.svg
