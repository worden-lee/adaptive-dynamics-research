# helper makefile automatically generated from sea.sage.step
sea.sage sea.sage.out sea.sage.tried : seamodel.py
sea.sobj sea.sage.out.tex : sea.sage.out ;
sea.sage sea.sage.out sea.sage.tried : STEP_PRODUCTS= sea.sobj sea.sage.out.tex
