# helper makefile automatically generated from masel.sage.step
masel.sage masel.sage.out masel.sage.tried : masel_model.py
masel-model.tex masel-2-model.tex : masel.sage.out ;
masel-model.sobj : masel.sage.out ;
masel.sage masel.sage.out masel.sage.tried : STEP_PRODUCTS= masel-model.tex masel-2-model.tex masel-model.sobj
