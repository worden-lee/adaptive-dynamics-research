# helper makefile automatically generated from SIR.sage.step
SIR.sage.out SIR.sage.tried : boxmodel.py
SIR.sage.out SIR.sage.tried : $(SageDynamics)/dynamicalsystems.py
SIR.sage.out SIR.sage.tried : $(SageAdaptiveDynamics)/adaptivedynamics.py
SIR.sage.out.tex SIR.boxes.tex SIR.trajectory.png : SIR.sage.tried ;
SIR.sage.out SIR.sage.tried : STEP_PRODUCTS= SIR.sage.out.tex SIR.boxes.tex SIR.trajectory.png
