# helper makefile automatically generated from sea-tran.sage.step
sea-tran.sage sea-tran.sage.out sea-tran.sage.tried : sea-down.sobj
sea-tran.sage.out.tex : sea-tran.sage.out ;
sea-tran-ts.svg sea-tran-sel.tex : sea-tran.sage.out ;
sea-tran.sage sea-tran.sage.out sea-tran.sage.tried : STEP_PRODUCTS= sea-tran.sage.out.tex sea-tran-ts.svg sea-tran-sel.tex
