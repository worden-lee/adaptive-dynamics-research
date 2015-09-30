# helper makefile automatically generated from maclev-2-2-popdyn.sage.step
maclev-2-2-popdyn.sage maclev-2-2-popdyn.sage.out maclev-2-2-popdyn.sage.tried : maclev_2_2_defs.py
maclev-2-2-popdyn.sage maclev-2-2-popdyn.sage.out maclev-2-2-popdyn.sage.tried : $(SageDynamics)/dynamicalsystems.py maclevmodels.py
maclev-2-2-popdyn.sage.out.tex maclev-2-2-popdyn.sobj : maclev-2-2-popdyn.sage.out ;
maclev-2-2-popdyn.png maclev-2-2-r-zngis.png maclev-2-2-c-vs-u.png : maclev-2-2-popdyn.sage.out ;
maclev-2-2-popdyn.sage maclev-2-2-popdyn.sage.out maclev-2-2-popdyn.sage.tried : STEP_PRODUCTS= maclev-2-2-popdyn.sage.out.tex maclev-2-2-popdyn.sobj maclev-2-2-popdyn.png maclev-2-2-r-zngis.png maclev-2-2-c-vs-u.png
