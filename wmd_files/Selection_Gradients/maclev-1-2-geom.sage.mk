# helper makefile automatically generated from maclev-1-2-geom.sage.step
maclev-1-2-geom.sage maclev-1-2-geom.sage.out maclev-1-2-geom.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-1-2-geom.sage maclev-1-2-geom.sage.out maclev-1-2-geom.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-1-2-geom.sage maclev-1-2-geom.sage.out maclev-1-2-geom.sage.tried : lotkavolterra.py
maclev-1-2-geom.sage maclev-1-2-geom.sage.out maclev-1-2-geom.sage.tried : maclev_1_2_defs.py maclev-1-2-adap.sobj
maclev-1-2-geom.sage.out.tex : maclev-1-2-geom.sage.out ;
maclev-1-2-k-vs-t.png maclev-1-2-a-vs-t.png : maclev-1-2-geom.sage.out ;
maclev-1-2-Xhat-vs-t.png maclev-1-2-Rhat-vs-t.png : maclev-1-2-geom.sage.out ;
maclev-1-2-a-vs-a.png : maclev-1-2-geom.sage.out ;
maclev-1-2-a-vs-k.png maclev-1-2-a-arrows.png : maclev-1-2-geom.sage.out ;
maclev-1-2-geom.sage maclev-1-2-geom.sage.out maclev-1-2-geom.sage.tried : STEP_PRODUCTS= maclev-1-2-geom.sage.out.tex maclev-1-2-k-vs-t.png maclev-1-2-a-vs-t.png maclev-1-2-Xhat-vs-t.png maclev-1-2-Rhat-vs-t.png maclev-1-2-a-vs-a.png maclev-1-2-a-vs-k.png maclev-1-2-a-arrows.png
