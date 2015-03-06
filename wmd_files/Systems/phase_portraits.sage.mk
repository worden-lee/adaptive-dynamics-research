# helper makefile automatically generated from phase_portraits.sage.step
phase_portraits.sage.out phase_portraits.sage.tried : $(SageDynamics)/dynamicalsystems.py
phase_portraits.sage.out phase_portraits.sage.tried : $(SageUtils)/latex_output.py
phase_portraits.sobj SI.sage.out.tex SI.png : phase_portraits.sage.out ;
competition.sage.out.tex competition.png : phase_portraits.sage.out ;
phase_portraits.sage.out phase_portraits.sage.tried : STEP_PRODUCTS= phase_portraits.sobj SI.sage.out.tex SI.png competition.sage.out.tex competition.png
