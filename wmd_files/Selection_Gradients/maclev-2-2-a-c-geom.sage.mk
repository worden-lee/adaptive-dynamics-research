# helper makefile automatically generated from maclev-2-2-a-c-geom.sage.step
maclev-2-2-a-c-geom.sage.out maclev-2-2-a-c-geom.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-a-c-geom.sage.out maclev-2-2-a-c-geom.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-2-2-a-c-geom.sage.out maclev-2-2-a-c-geom.sage.tried : lotkavolterra.py
maclev-2-2-a-c-geom.sage.out maclev-2-2-a-c-geom.sage.tried : maclev_2_2_defs.py maclev-2-2-a-c-adap.sobj
maclev-2-2-a-c-geom.sage.out.tex : maclev-2-2-a-c-geom.sage.out ;
maclev-2-2-a-c-k-vs-t.png maclev-2-2-a-c-a-vs-t.png : maclev-2-2-a-c-geom.sage.out ;
maclev-2-2-a-c-Xhat-vs-t.png maclev-2-2-a-c-Rhat-vs-t.png : maclev-2-2-a-c-geom.sage.out ;
maclev-2-2-a-c-a-vs-a.png : maclev-2-2-a-c-geom.sage.out ;
maclev-2-2-a-c-a-vs-k.png maclev-2-2-a-c-a-arrows.png : maclev-2-2-a-c-geom.sage.out ;
maclev-2-2-a-c-geom.sage.out maclev-2-2-a-c-geom.sage.tried : STEP_PRODUCTS= maclev-2-2-a-c-geom.sage.out.tex maclev-2-2-a-c-k-vs-t.png maclev-2-2-a-c-a-vs-t.png maclev-2-2-a-c-Xhat-vs-t.png maclev-2-2-a-c-Rhat-vs-t.png maclev-2-2-a-c-a-vs-a.png maclev-2-2-a-c-a-vs-k.png maclev-2-2-a-c-a-arrows.png
