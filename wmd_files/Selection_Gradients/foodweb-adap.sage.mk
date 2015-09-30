# helper makefile automatically generated from foodweb-adap.sage.step
foodweb-adap.sage foodweb-adap.sage.out foodweb-adap.sage.tried : foodweb.py foodweb.sobj
foodweb-adap.sage foodweb-adap.sage.out foodweb-adap.sage.tried : $(SageDynamics)/dynamicalsystems.py
foodweb-adap.sage foodweb-adap.sage.out foodweb-adap.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
foodweb-adap.sage foodweb-adap.sage.out foodweb-adap.sage.tried : $(SageUtils)/latex_output.py
foodweb-adap.sage.out.tex foodweb-adap.sobj : foodweb-adap.sage.out ;
foodweb-adap.sage foodweb-adap.sage.out foodweb-adap.sage.tried : STEP_PRODUCTS= foodweb-adap.sage.out.tex foodweb-adap.sobj
