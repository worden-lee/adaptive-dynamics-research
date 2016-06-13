# helper makefile automatically generated from masel-adap.sage.step
masel-adap.sage masel-adap.sage.out masel-adap.sage.tried : masel_model.py
masel-adap.sage masel-adap.sage.out masel-adap.sage.tried : masel-model.sobj
masel-adap.tex : masel-adap.sage.out ;
masel-adap.sage masel-adap.sage.out masel-adap.sage.tried : STEP_PRODUCTS= masel-adap.tex
