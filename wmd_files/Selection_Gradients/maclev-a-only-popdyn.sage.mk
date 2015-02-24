# helper makefile automatically generated from maclev-a-only-popdyn.sage.step
maclev-a-only-popdyn.sage.out maclev-a-only-popdyn.sage.tried : maclev_a_only_defs.py
maclev-a-only-popdyn.sage.out maclev-a-only-popdyn.sage.tried : $(SageDynamics)/dynamicalsystems.py maclevmodels.py
maclev-a-only-popdyn.sage.out maclev-a-only-popdyn.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
maclev-a-only-popdyn.sage.out.tex maclev-a-only-popdyn.sobj : maclev-a-only-popdyn.sage.out ;
maclev-a-only-popdyn.png maclev-a-only-r-zngis.png maclev-a-only-c-vs-u.png  : maclev-a-only-popdyn.sage.out ;
maclev-a-only-popdyn.sage.out maclev-a-only-popdyn.sage.tried : STEP_PRODUCTS= maclev-a-only-popdyn.sage.out.tex maclev-a-only-popdyn.sobj maclev-a-only-popdyn.png maclev-a-only-r-zngis.png maclev-a-only-c-vs-u.png 
