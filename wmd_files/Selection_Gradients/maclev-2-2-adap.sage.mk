maclev-2-2-adap.sage.out : $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py maclev_2_2_defs.py
maclev-2-2-adap.sage.out.tex maclev-2-2-adap.sobj : maclev-2-2-adap.sage.out ;
maclev-2-2-c-vs-u.png maclev-2-2-u-vs-t.png  : maclev-2-2-adap.sage.out ;
maclev-2-2-u-vs-u.png maclev-2-2-c-vs-c.png : maclev-2-2-adap.sage.out ;
