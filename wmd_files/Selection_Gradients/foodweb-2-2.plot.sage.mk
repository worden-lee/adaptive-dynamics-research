# helper makefile automatically generated from foodweb-2-2.plot.sage.step
foodweb-2-2.plot.sage.out foodweb-2-2.plot.sage.tried : foodweb-2-2.sobj
foodweb-2-2.plot.sage.out foodweb-2-2.plot.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
foodweb-2-2.plot.sage.out foodweb-2-2.plot.sage.tried : $(SageUtils)/latex_output.py
foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png : foodweb-2-2.plot.sage.out ;
foodweb-2-2.plot.sage.out foodweb-2-2.plot.sage.tried : STEP_PRODUCTS= foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png
