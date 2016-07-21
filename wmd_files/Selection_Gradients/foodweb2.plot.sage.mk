# helper makefile automatically generated from foodweb2.plot.sage.step
foodweb2.plot.sage foodweb2.plot.sage.out foodweb2.plot.sage.tried : foodweb2-adap-traj.sobj
foodweb2.plot.sage.out.tex  : foodweb2.plot.sage.out ;
foodweb2-pred-prey-adap.png foodweb2-pred-prey-adap.svg : foodweb2.plot.sage.out ;
foodweb2-pred-prey-adap-difference.png : foodweb2.plot.sage.out ;
foodweb2-pred-prey-a-vs-t.png foodweb2-pred-prey-a-vs-a.png : foodweb2.plot.sage.out ;
foodweb2-pred-prey-x-vs-t.png : foodweb2.plot.sage.out ;
foodweb2.plot.sage foodweb2.plot.sage.out foodweb2.plot.sage.tried : STEP_PRODUCTS= foodweb2.plot.sage.out.tex  foodweb2-pred-prey-adap.png foodweb2-pred-prey-adap.svg foodweb2-pred-prey-adap-difference.png foodweb2-pred-prey-a-vs-t.png foodweb2-pred-prey-a-vs-a.png foodweb2-pred-prey-x-vs-t.png
