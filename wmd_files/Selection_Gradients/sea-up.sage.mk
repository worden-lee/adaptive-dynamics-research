# helper makefile automatically generated from sea-up.sage.step
sea-up.sage sea-up.sage.out sea-up.sage.tried : sea-down.sobj
sea-up.sage.out.tex sea-up-sel.tex : sea-up.sage.out ;
sea-up-ts.svg sea-up-values.svg : sea-up.sage.out ;
sea-up.sage sea-up.sage.out sea-up.sage.tried : STEP_PRODUCTS= sea-up.sage.out.tex sea-up-sel.tex sea-up-ts.svg sea-up-values.svg
