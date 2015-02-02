# helper makefile automatically generated from maclev-2-2-a-c-popdyn.sage.step
maclev-2-2-a-c-popdyn.sage.out maclev-2-2-a-c-popdyn.sage.tried : maclev_a_c.py maclev_2_2_defs.py
maclev-2-2-a-c-popdyn.sage.out maclev-2-2-a-c-popdyn.sage.tried : $(SageDynamics)/dynamicalsystems.py maclevmodels.py
maclev-2-2-a-c-popdyn.sage.out.tex maclev-2-2-a-c-popdyn.sobj : maclev-2-2-a-c-popdyn.sage.tried ;
maclev-2-2-a-c-popdyn.png maclev-2-2-a-c-r-zngis.png : maclev-2-2-a-c-popdyn.sage.tried ;
maclev-2-2-a-c-popdyn.sage.out maclev-2-2-a-c-popdyn.sage.tried : STEP_PRODUCTS= maclev-2-2-a-c-popdyn.sage.out.tex maclev-2-2-a-c-popdyn.sobj maclev-2-2-a-c-popdyn.png maclev-2-2-a-c-r-zngis.png
