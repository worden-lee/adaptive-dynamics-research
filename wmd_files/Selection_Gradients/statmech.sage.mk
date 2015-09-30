# helper makefile automatically generated from statmech.sage.step
statmech.sage.out statmech.sage.tried : statmech.py
statmech.sage.out statmech.sage.tried : $(SageDynamics)/dynamicalsystems.py
statmech.sage.out statmech.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
statmech.sage.out statmech.sage.tried : $(SageUtils)/latex_output.py
statmech.sobj statmech.sage.out.tex statmech.svg : statmech.sage.out ;
statmech.sage.out statmech.sage.tried : STEP_PRODUCTS= statmech.sobj statmech.sage.out.tex statmech.svg
