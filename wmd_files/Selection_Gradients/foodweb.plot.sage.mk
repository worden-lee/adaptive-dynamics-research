# helper makefile automatically generated from foodweb.plot.sage.step
foodweb.plot.sage foodweb.plot.sage.out foodweb.plot.sage.tried : foodweb-adap.sobj
foodweb.plot.sage.out.tex  : foodweb.plot.sage.out ;
foodweb-pred-prey-adap.png foodweb-pred-prey-adap.svg : foodweb.plot.sage.out ;
foodweb-pred-prey-adap-difference.png : foodweb.plot.sage.out ;
foodweb-pred-prey-a-vs-t.png foodweb-pred-prey-a-vs-a.png : foodweb.plot.sage.out ;
foodweb-pred-prey-x-vs-t.png : foodweb.plot.sage.out ;
foodweb.plot.sage foodweb.plot.sage.out foodweb.plot.sage.tried : STEP_PRODUCTS= foodweb.plot.sage.out.tex  foodweb-pred-prey-adap.png foodweb-pred-prey-adap.svg foodweb-pred-prey-adap-difference.png foodweb-pred-prey-a-vs-t.png foodweb-pred-prey-a-vs-a.png foodweb-pred-prey-x-vs-t.png
