# helper makefile automatically generated from cross.sage.step
cross.sage.out cross.sage.tried : boxmodel.py
cross.sage.out cross.sage.tried : $(SageDynamics)/dynamicalsystems.py
cross.sage.out cross.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
cross.sage.out.tex classes.boxes.tex cross.boxes.tex : cross.sage.tried ;
cross.trajectory.png : cross.sage.tried ;
cross.sage.out cross.sage.tried : STEP_PRODUCTS= cross.sage.out.tex classes.boxes.tex cross.boxes.tex cross.trajectory.png
