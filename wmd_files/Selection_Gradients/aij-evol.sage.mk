# helper makefile automatically generated from aij-evol.sage.step
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : aij.py
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : $(SageUtils)/latex_output.py
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : $(SageDynamics)/dynamicalsystems.py
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : lotkavolterra.py
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : aij-assemble.sobj
aij-evol.sobj : aij-evol.sage.out ;
aij-evol.sage aij-evol.sage.out aij-evol.sage.tried : STEP_PRODUCTS= aij-evol.sobj
