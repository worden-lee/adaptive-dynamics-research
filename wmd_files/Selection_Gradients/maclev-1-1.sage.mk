# helper makefile automatically generated from maclev-1-1.sage.step
maclev-1-1.sage.out maclev-1-1.sage.tried : maclevmodels.py $(SageDynamics)/dynamicalsystems.py
maclev-1-1.sage.out maclev-1-1.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
maclev-1-1.sage.out maclev-1-1.sage.tried : $(SageUtils)/latex_output.py
maclev-1-1.sobj maclev-1-1.sage.out.tex : maclev-1-1.sage.tried ;
maclev-1-1.sage.out maclev-1-1.sage.tried : STEP_PRODUCTS= maclev-1-1.sobj maclev-1-1.sage.out.tex
