# helper makefile automatically generated from maclev-2-2-a-c-p.sage.step
maclev-2-2-a-c-p.sage.out maclev-2-2-a-c-p.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-a-c-p.sage.out maclev-2-2-a-c-p.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
maclev-2-2-a-c-p.sage.out maclev-2-2-a-c-p.sage.tried : maclev_2_2_defs.py maclev-2-2-a-c-adap.sobj
maclev-2-2-a-c-p.sage.out.tex : maclev-2-2-a-c-p.sage.out ;
maclev-2-2-a-c-c-vs-t.sage.out.tex maclev-2-2-a-c-c-vs-c.png : maclev-2-2-a-c-p.sage.out ;
maclev-2-2-a-c-p.sage.out maclev-2-2-a-c-p.sage.tried : STEP_PRODUCTS= maclev-2-2-a-c-p.sage.out.tex maclev-2-2-a-c-c-vs-t.sage.out.tex maclev-2-2-a-c-c-vs-c.png
