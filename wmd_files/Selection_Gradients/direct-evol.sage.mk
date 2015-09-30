# helper makefile automatically generated from direct-evol.sage.step
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : direct.py
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : $(SageUtils)/latex_output.py
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : $(SageDynamics)/dynamicalsystems.py
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : lotkavolterra.py
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : direct-assemble.sobj
direct-evol.sobj : direct-evol.sage.out ;
direct-evol.sage direct-evol.sage.out direct-evol.sage.tried : STEP_PRODUCTS= direct-evol.sobj
