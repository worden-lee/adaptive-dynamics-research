# helper makefile automatically generated from maclev-2-2-p.sage.step
maclev-2-2-p.sage.out maclev-2-2-p.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-p.sage.out maclev-2-2-p.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
maclev-2-2-p.sage.out maclev-2-2-p.sage.tried : maclev_2_2_defs.py maclev-2-2-adap.sobj
maclev-2-2-p.sage.out.tex maclev-2-2-c-vs-t.png : maclev-2-2-p.sage.out ;
maclev-2-2-c-vs-c.png maclev-2-2-total-c-vs-u.png : maclev-2-2-p.sage.out ;
maclev-2-2-p.sage.out maclev-2-2-p.sage.tried : STEP_PRODUCTS= maclev-2-2-p.sage.out.tex maclev-2-2-c-vs-t.png maclev-2-2-c-vs-c.png maclev-2-2-total-c-vs-u.png
