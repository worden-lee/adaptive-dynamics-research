# helper makefile automatically generated from aij-assemble.sage.step
aij-assemble.sage aij-assemble.sage.out aij-assemble.sage.tried : aij.py
aij-assemble.sage aij-assemble.sage.out aij-assemble.sage.tried : $(SageDynamics)/dynamicalsystems.py
aij-assemble.sage aij-assemble.sage.out aij-assemble.sage.tried : $(SageUtils)/latex_output.py
aij-assemble.sobj : aij-assemble.sage.out ;
aij-assemble.sage aij-assemble.sage.out aij-assemble.sage.tried : STEP_PRODUCTS= aij-assemble.sobj
