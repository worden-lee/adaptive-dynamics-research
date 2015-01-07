# helper makefile automatically generated from maclev-2-2-c-popdyn.sage.step
maclev-2-2-c-popdyn.sage.out maclev-2-2-c-popdyn.sage.tried : maclev_2_2_defs.py
maclev-2-2-c-popdyn.sage.out maclev-2-2-c-popdyn.sage.tried : $(SageDynamics)/dynamicalsystems.py maclevmodels.py
maclev-2-2-c-popdyn.sage.out.tex maclev-2-2-c-popdyn.sobj : maclev-2-2-c-popdyn.sage.tried ;
maclev-2-2-c-popdyn.png maclev-2-2-c-r-zngis.png : maclev-2-2-c-popdyn.sage.tried ;
maclev-2-2-c-popdyn.sage.out maclev-2-2-c-popdyn.sage.tried : STEP_PRODUCTS= maclev-2-2-c-popdyn.sage.out.tex maclev-2-2-c-popdyn.sobj maclev-2-2-c-popdyn.png maclev-2-2-c-r-zngis.png
