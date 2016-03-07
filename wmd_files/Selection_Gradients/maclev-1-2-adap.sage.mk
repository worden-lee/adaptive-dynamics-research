# helper makefile automatically generated from maclev-1-2-adap.sage.step
maclev-1-2-adap.sage maclev-1-2-adap.sage.out maclev-1-2-adap.sage.tried : maclevmodels.py
maclev-1-2-adap.sage maclev-1-2-adap.sage.out maclev-1-2-adap.sage.tried : maclev-1-2-popdyn.sobj maclev_1_2_defs.py
maclev-1-2-adap.sage.out.tex maclev-1-2-adap.sobj : maclev-1-2-adap.sage.out ;
maclev-1-2-u-vs-t.png : maclev-1-2-adap.sage.out ;
maclev-1-2-u-vs-u.png : maclev-1-2-adap.sage.out ;
maclev-1-2-adap.sage maclev-1-2-adap.sage.out maclev-1-2-adap.sage.tried : STEP_PRODUCTS= maclev-1-2-adap.sage.out.tex maclev-1-2-adap.sobj maclev-1-2-u-vs-t.png maclev-1-2-u-vs-u.png
