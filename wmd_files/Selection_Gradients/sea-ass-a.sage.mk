# helper makefile automatically generated from sea-ass-a.sage.step
sea-ass-a.sage sea-ass-a.sage.out sea-ass-a.sage.tried : sealv.py
sea-ass-a.sage sea-ass-a.sage.out sea-ass-a.sage.tried : sea-ass.sobj
sea-ass-a.sage.out.tex : sea-ass-a.sage.out ;
#sea-ass-a.svg : sea-ass-a.sage.out ;
sea-ass-a.sage sea-ass-a.sage.out sea-ass-a.sage.tried : STEP_PRODUCTS= sea-ass-a.sage.out.tex #sea-ass-a.svg
