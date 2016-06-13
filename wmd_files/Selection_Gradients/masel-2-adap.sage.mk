# helper makefile automatically generated from masel-2-adap.sage.step
masel-2-adap.sage masel-2-adap.sage.out masel-2-adap.sage.tried : masel_model.py
masel-2-adap.sage masel-2-adap.sage.out masel-2-adap.sage.tried : masel-model.sobj
masel-2-adap.tex : masel-2-adap.sage.out ;
masel-2-adap.sage masel-2-adap.sage.out masel-2-adap.sage.tried : STEP_PRODUCTS= masel-2-adap.tex
