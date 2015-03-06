# helper makefile automatically generated from foodweb.plot.sage.step
foodweb.plot.sage.out foodweb.plot.sage.tried : foodweb.sobj
foodweb.plot.sage.out foodweb.plot.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
foodweb.plot.sage.out foodweb.plot.sage.tried : $(SageUtils)/latex_output.py
foodweb.plot.sage.out.tex foodweb-pred-prey-adap.png : foodweb.plot.sage.out ;
foodweb.plot.sage.out foodweb.plot.sage.tried : STEP_PRODUCTS= foodweb.plot.sage.out.tex foodweb-pred-prey-adap.png
