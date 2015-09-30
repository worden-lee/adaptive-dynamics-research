# helper makefile automatically generated from statmech-assemble.sage.step
statmech-assemble.sage statmech-assemble.sage.out statmech-assemble.sage.tried : statmech.py
statmech-assemble.sage statmech-assemble.sage.out statmech-assemble.sage.tried : $(SageDynamics)/dynamicalsystems.py
statmech-assemble.sage statmech-assemble.sage.out statmech-assemble.sage.tried : $(SageUtils)/latex_output.py
statmech-assemble.sobj : statmech-assemble.sage.out ;
statmech-assemble.sage statmech-assemble.sage.out statmech-assemble.sage.tried : STEP_PRODUCTS= statmech-assemble.sobj
