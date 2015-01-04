# helper makefile automatically generated from maclev-1-1-adap.sage.step
maclev-1-1-adap.sage.out maclev-1-1-adap.sage.tried : maclevmodels.py $(SageAdaptiveDynamics)/adaptivedynamics.py maclev-1-1.sobj
maclev-1-1-adap.sage.out maclev-1-1-adap.sage.tried : $(SageUtils)/latex_output.py
maclev-1-1-c00.png maclev-1-1-X.png maclev-1-1-ak.png maclev-1-1-adap.sage.out.tex maclev-1-1-adap.sobj : maclev-1-1-adap.sage.tried ;
maclev-1-1-adap.sage.out maclev-1-1-adap.sage.tried : STEP_PRODUCTS= maclev-1-1-c00.png maclev-1-1-X.png maclev-1-1-ak.png maclev-1-1-adap.sage.out.tex maclev-1-1-adap.sobj
