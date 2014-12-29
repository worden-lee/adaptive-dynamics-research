maclev-1-1.sage.out : maclevmodels.py $(SageDynamics)/dynamicalsystems.py
maclev-1-1.sage.out : $(SageAdaptiveDynamics)/adaptivedynamics.py
maclev-1-1.sage.out : $(SageUtils)/latex_output.py
maclev-1-1.sobj maclev-1-1.sage.out.tex : maclev-1-1.sage.out ;
