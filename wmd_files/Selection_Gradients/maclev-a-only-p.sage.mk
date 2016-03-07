# helper makefile automatically generated from maclev-a-only-p.sage.step
maclev-a-only-p.sage maclev-a-only-p.sage.out maclev-a-only-p.sage.tried : maclevmodels.py
maclev-a-only-p.sage maclev-a-only-p.sage.out maclev-a-only-p.sage.tried : maclev_a_only_defs.py maclev-a-only-adap.sobj
maclev-a-only-p.sage.out.tex maclev-a-only-c-vs-t.png : maclev-a-only-p.sage.out ;
maclev-a-only-c-vs-c.png maclev-a-only-total-c-vs-u.png : maclev-a-only-p.sage.out ;
maclev-a-only-p.sage maclev-a-only-p.sage.out maclev-a-only-p.sage.tried : STEP_PRODUCTS= maclev-a-only-p.sage.out.tex maclev-a-only-c-vs-t.png maclev-a-only-c-vs-c.png maclev-a-only-total-c-vs-u.png
