# helper makefile automatically generated from maclev-2-2-adap.sage.step
maclev-2-2-adap.sage maclev-2-2-adap.sage.out maclev-2-2-adap.sage.tried : $(SageDynamics)/dynamicalsystems.py
maclev-2-2-adap.sage maclev-2-2-adap.sage.out maclev-2-2-adap.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
maclev-2-2-adap.sage maclev-2-2-adap.sage.out maclev-2-2-adap.sage.tried : maclev-2-2-popdyn.sobj maclev_2_2_defs.py
maclev-2-2-adap.sage.out.tex maclev-2-2-adap.sobj : maclev-2-2-adap.sage.out ;
maclev-2-2-u-vs-t.png : maclev-2-2-adap.sage.out ;
maclev-2-2-u-vs-u.png : maclev-2-2-adap.sage.out ;
maclev-2-2-adap.sage maclev-2-2-adap.sage.out maclev-2-2-adap.sage.tried : STEP_PRODUCTS= maclev-2-2-adap.sage.out.tex maclev-2-2-adap.sobj maclev-2-2-u-vs-t.png maclev-2-2-u-vs-u.png
