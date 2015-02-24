# helper makefile automatically generated from maclev-2-2-c-geom.sage.step
maclev-2-2-c-geom.sage.out maclev-2-2-c-geom.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-c-geom.sage.out maclev-2-2-c-geom.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-2-2-c-geom.sage.out maclev-2-2-c-geom.sage.tried : lotkavolterra.py
maclev-2-2-c-geom.sage.out maclev-2-2-c-geom.sage.tried : maclev_2_2_defs.py maclev-2-2-c-adap.sobj
maclev-2-2-c-geom.sage.out.tex : maclev-2-2-c-geom.sage.out ;
maclev-2-2-c-k-vs-t.png maclev-2-2-c-a-vs-t.png : maclev-2-2-c-geom.sage.out ;
maclev-2-2-c-Xhat-vs-t.png maclev-2-2-c-Rhat-vs-t.png : maclev-2-2-c-geom.sage.out ;
maclev-2-2-c-a-vs-a.png : maclev-2-2-c-geom.sage.out ;
maclev-2-2-c-a-vs-k.png maclev-2-2-c-a-arrows.png : maclev-2-2-c-geom.sage.out ;
maclev-2-2-c-geom.sage.out maclev-2-2-c-geom.sage.tried : STEP_PRODUCTS= maclev-2-2-c-geom.sage.out.tex maclev-2-2-c-k-vs-t.png maclev-2-2-c-a-vs-t.png maclev-2-2-c-Xhat-vs-t.png maclev-2-2-c-Rhat-vs-t.png maclev-2-2-c-a-vs-a.png maclev-2-2-c-a-vs-k.png maclev-2-2-c-a-arrows.png
