# helper makefile automatically generated from SI.sage.step
SI.sage.out SI.sage.tried : $(SageDynamics)/dynamicalsystems.py
SI.sage.out SI.sage.tried : $(SageUtils)/latex_output.py
SI.sobj SI.sage.out.tex SI.png : SI.sage.out ;
SI.sage.out SI.sage.tried : STEP_PRODUCTS= SI.sobj SI.sage.out.tex SI.png
