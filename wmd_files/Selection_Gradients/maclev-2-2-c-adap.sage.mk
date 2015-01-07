# helper makefile automatically generated from maclev-2-2-c-adap.sage.step
maclev-2-2-c-adap.sage.out maclev-2-2-c-adap.sage.tried : $(SageDynamics)/dynamicalsystems.py
maclev-2-2-c-adap.sage.out maclev-2-2-c-adap.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
maclev-2-2-c-adap.sage.out maclev-2-2-c-adap.sage.tried : maclev-2-2-c-popdyn.sobj maclev_2_2_defs.py
maclev-2-2-c-adap.sage.out.tex maclev-2-2-c-adap.sobj : maclev-2-2-c-adap.sage.tried ;
maclev-2-2-c-adap.sage.out maclev-2-2-c-adap.sage.tried : STEP_PRODUCTS= maclev-2-2-c-adap.sage.out.tex maclev-2-2-c-adap.sobj
