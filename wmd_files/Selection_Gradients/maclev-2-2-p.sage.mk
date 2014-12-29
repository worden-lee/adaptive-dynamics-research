maclev-2-2-p.sage.out : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-p.sage.out : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-2-2-p.sage.out : maclev_2_2_defs.py maclev-2-2-adap.sobj
maclev-2-2-p.sage.out.tex : maclev-2-2-p.sage.out ;
