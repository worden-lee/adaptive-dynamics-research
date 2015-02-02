# helper makefile automatically generated from maclev-1-2-p.sage.step
maclev-1-2-p.sage.out maclev-1-2-p.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-1-2-p.sage.out maclev-1-2-p.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
maclev-1-2-p.sage.out maclev-1-2-p.sage.tried : maclev_1_2_defs.py maclev-1-2-adap.sobj
maclev-1-2-p.sage.out.tex maclev-1-2-c-vs-t.png : maclev-1-2-p.sage.tried ;
maclev-1-2-c-vs-c.png maclev-1-2-total-c-vs-u.png : maclev-1-2-p.sage.tried ;
maclev-1-2-p.sage.out maclev-1-2-p.sage.tried : STEP_PRODUCTS= maclev-1-2-p.sage.out.tex maclev-1-2-c-vs-t.png maclev-1-2-c-vs-c.png maclev-1-2-total-c-vs-u.png
