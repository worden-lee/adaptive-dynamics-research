# helper makefile automatically generated from foodweb.sage.step
foodweb.sage.out foodweb.sage.tried : $(SageDynamics)/dynamicalsystems.py
foodweb.sage.out foodweb.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
foodweb.sage.out foodweb.sage.tried : $(SageUtils)/latex_output.py
foodweb.sobj foodweb.sage.out.tex : foodweb.sage.out ;
foodweb.sage.out foodweb.sage.tried : STEP_PRODUCTS= foodweb.sobj foodweb.sage.out.tex
