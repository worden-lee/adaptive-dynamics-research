# helper makefile automatically generated from masel-2.sage.step
masel-2.sage masel-2.sage.out masel-2.sage.tried : masel_model.py
masel-model.tex : masel-2.sage.out ;
masel-2.sage masel-2.sage.out masel-2.sage.tried : STEP_PRODUCTS= masel-model.tex
