# helper makefile automatically generated from popdyn-example.sage.step
popdyn-example.sage.out popdyn-example.sage.tried : $(SageDynamics)/dynamicalsystems.py
popdyn-example.sage.out popdyn-example.sage.tried : $(SageUtils)/latex_output.py
popdyn-example.cd.tex popdyn-example.svg : popdyn-example.sage.out ;
popdyn-example.sage.out popdyn-example.sage.tried : STEP_PRODUCTS= popdyn-example.cd.tex popdyn-example.svg
