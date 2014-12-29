maclev-1-1-mc-adap-geom.sage.out : maclevmodels.py $(SageAdaptiveDynamics)/adaptivedynamics.py maclev-1-1-adap.sobj
maclev-1-1-mc-adap-geom.sage.out : $(SageUtils)/latex_output.py
maclev-1-1-mc-adap-geom.sobj maclev-1-1-mc.png maclev-1-1-mc-adap-geom.sage.out.tex : maclev-1-1-mc-adap-geom.sage.out ;
