# helper makefile automatically generated from maclev-2-2-geom.sage.step
maclev-2-2-geom.sage.out maclev-2-2-geom.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-geom.sage.out maclev-2-2-geom.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-2-2-geom.sage.out maclev-2-2-geom.sage.tried : lotkavolterra.py
maclev-2-2-geom.sage.out maclev-2-2-geom.sage.tried : maclev_2_2_defs.py maclev-2-2-adap.sobj
maclev-2-2-geom.sage.out.tex : maclev-2-2-geom.sage.tried ;
maclev-2-2-k-vs-t.png maclev-2-2-a-vs-t.png : maclev-2-2-geom.sage.tried ;
maclev-2-2-Xhat-vs-t.png maclev-2-2-Rhat-vs-t.png : maclev-2-2-geom.sage.tried ;
maclev-2-2-a-vs-a.png : maclev-2-2-geom.sage.tried ;
maclev-2-2-a-vs-k.png maclev-2-2-a-arrows.png : maclev-2-2-geom.sage.tried ;
maclev-2-2-geom.sage.out maclev-2-2-geom.sage.tried : STEP_PRODUCTS= maclev-2-2-geom.sage.out.tex maclev-2-2-k-vs-t.png maclev-2-2-a-vs-t.png maclev-2-2-Xhat-vs-t.png maclev-2-2-Rhat-vs-t.png maclev-2-2-a-vs-a.png maclev-2-2-a-vs-k.png maclev-2-2-a-arrows.png
