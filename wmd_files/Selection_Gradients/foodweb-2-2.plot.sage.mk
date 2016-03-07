# helper makefile automatically generated from foodweb-2-2.plot.sage.step
foodweb-2-2.plot.sage foodweb-2-2.plot.sage.out foodweb-2-2.plot.sage.tried : foodweb-2-2.sobj
foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png : foodweb-2-2.plot.sage.out ;
foodweb-2-2-a-vs-a.png foodweb-2-2-a-vs-t.png : foodweb-2-2.plot.sage.out ;
foodweb-2-2-x-vs-t.png : foodweb-2-2.plot.sage.out ;
foodweb-2-2.plot.sage foodweb-2-2.plot.sage.out foodweb-2-2.plot.sage.tried : STEP_PRODUCTS= foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png foodweb-2-2-a-vs-a.png foodweb-2-2-a-vs-t.png foodweb-2-2-x-vs-t.png
