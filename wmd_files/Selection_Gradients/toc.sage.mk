# helper makefile automatically generated from toc.sage.step
toc.sage.out toc.sage.tried : $(SageDynamics)/dynamicalsystems.py
toc.sage.out toc.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
toc.sage.out toc.sage.tried : $(SageUtils)/latex_output.py
toc.sobj toc.sage.out.tex : toc.sage.out ;
toc.sage.out toc.sage.tried : STEP_PRODUCTS= toc.sobj toc.sage.out.tex
