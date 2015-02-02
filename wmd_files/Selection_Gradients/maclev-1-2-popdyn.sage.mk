# helper makefile automatically generated from maclev-1-2-popdyn.sage.step
maclev-1-2-popdyn.sage.out maclev-1-2-popdyn.sage.tried : maclev_1_2_defs.py
maclev-1-2-popdyn.sage.out maclev-1-2-popdyn.sage.tried : $(SageDynamics)/dynamicalsystems.py maclevmodels.py
maclev-1-2-popdyn.sage.out maclev-1-2-popdyn.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
maclev-1-2-popdyn.sage.out.tex maclev-1-2-popdyn.sobj : maclev-1-2-popdyn.sage.tried ;
maclev-1-2-popdyn.png maclev-1-2-r-zngis.png maclev-1-2-c-vs-u.png  : maclev-1-2-popdyn.sage.tried ;
maclev-1-2-popdyn.sage.out maclev-1-2-popdyn.sage.tried : STEP_PRODUCTS= maclev-1-2-popdyn.sage.out.tex maclev-1-2-popdyn.sobj maclev-1-2-popdyn.png maclev-1-2-r-zngis.png maclev-1-2-c-vs-u.png 
