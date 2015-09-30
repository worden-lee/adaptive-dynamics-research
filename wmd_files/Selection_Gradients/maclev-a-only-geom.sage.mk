# helper makefile automatically generated from maclev-a-only-geom.sage.step
maclev-a-only-geom.sage maclev-a-only-geom.sage.out maclev-a-only-geom.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-a-only-geom.sage maclev-a-only-geom.sage.out maclev-a-only-geom.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-a-only-geom.sage maclev-a-only-geom.sage.out maclev-a-only-geom.sage.tried : lotkavolterra.py
maclev-a-only-geom.sage maclev-a-only-geom.sage.out maclev-a-only-geom.sage.tried : maclev_a_only_defs.py maclev-a-only-adap.sobj
maclev-a-only-geom.sage.out.tex : maclev-a-only-geom.sage.out ;
maclev-a-only-k-vs-t.png maclev-a-only-a-vs-t.png : maclev-a-only-geom.sage.out ;
maclev-a-only-Xhat-vs-t.png maclev-a-only-Rhat-vs-t.png : maclev-a-only-geom.sage.out ;
maclev-a-only-a-vs-a.png : maclev-a-only-geom.sage.out ;
maclev-a-only-a-vs-k.png maclev-a-only-a-arrows.png : maclev-a-only-geom.sage.out ;
maclev-a-only-geom.sage maclev-a-only-geom.sage.out maclev-a-only-geom.sage.tried : STEP_PRODUCTS= maclev-a-only-geom.sage.out.tex maclev-a-only-k-vs-t.png maclev-a-only-a-vs-t.png maclev-a-only-Xhat-vs-t.png maclev-a-only-Rhat-vs-t.png maclev-a-only-a-vs-a.png maclev-a-only-a-vs-k.png maclev-a-only-a-arrows.png
