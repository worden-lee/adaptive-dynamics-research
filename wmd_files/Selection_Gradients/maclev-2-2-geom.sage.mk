maclev-2-2-geom.sage.out : $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
maclev-2-2-geom.sage.out : $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
maclev-2-2-geom.sage.out : lotkavolterra.py
maclev-2-2-geom.sage.out : maclev_2_2_defs.py maclev-2-2-adap.sobj
maclev-2-2-geom.sage.out.tex : maclev-2-2-geom.sage.out ;
maclev-2-2-k-vs-t.png maclev-2-2-a-vs-t.png : maclev-2-2-geom.sage.out ;
maclev-2-2-Xhat-vs-t.png maclev-2-2-Rhat-vs-t.png : maclev-2-2-geom.sage.out ;
maclev-2-2-a-vs-a.png : maclev-2-2-geom.sage.out ;
maclev-2-2-a-vs-k.png maclev-2-2-a-arrows.png : maclev-2-2-geom.sage.out ;
