# helper makefile automatically generated from maclev-S-A-curve.sage.step
maclev-S-A-curve.sage maclev-S-A-curve.sage.out maclev-S-A-curve.sage.tried : maclevmodels.py maclev-1-1-mc-adap-geom.sobj
maclev-S-A-curve.sage maclev-S-A-curve.sage.out maclev-S-A-curve.sage.tried : S-A-vf.sobj
maclev-S-A-curve.png : maclev-S-A-curve.sage.out ;
maclev-S-A-more-curve.png : maclev-S-A-curve.sage.out ;
maclev-S-A-curve.sage maclev-S-A-curve.sage.out maclev-S-A-curve.sage.tried : STEP_PRODUCTS= maclev-S-A-curve.png maclev-S-A-more-curve.png
