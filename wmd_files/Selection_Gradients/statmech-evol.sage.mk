# helper makefile automatically generated from statmech-evol.sage.step
statmech-evol.sage statmech-evol.sage.out statmech-evol.sage.tried : statmech.py
statmech-evol.sage statmech-evol.sage.out statmech-evol.sage.tried : lotkavolterra.py
statmech-evol.sage statmech-evol.sage.out statmech-evol.sage.tried : statmech-assemble.sobj
statmech-evol.sobj : statmech-evol.sage.out ;
statmech-evol.sage statmech-evol.sage.out statmech-evol.sage.tried : STEP_PRODUCTS= statmech-evol.sobj
