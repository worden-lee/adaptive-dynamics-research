# helper makefile automatically generated from maclev-a-only-adap.sage.step
maclev-a-only-adap.sage.out maclev-a-only-adap.sage.tried : $(SageDynamics)/dynamicalsystems.py
maclev-a-only-adap.sage.out maclev-a-only-adap.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
maclev-a-only-adap.sage.out maclev-a-only-adap.sage.tried : maclev-a-only-popdyn.sobj maclev_a_only_defs.py
maclev-a-only-adap.sage.out.tex maclev-a-only-adap.sobj : maclev-a-only-adap.sage.tried ;
maclev-a-only-u-vs-t.png : maclev-a-only-adap.sage.tried ;
maclev-a-only-u-vs-u.png : maclev-a-only-adap.sage.tried ;
maclev-a-only-adap.sage.out maclev-a-only-adap.sage.tried : STEP_PRODUCTS= maclev-a-only-adap.sage.out.tex maclev-a-only-adap.sobj maclev-a-only-u-vs-t.png maclev-a-only-u-vs-u.png
