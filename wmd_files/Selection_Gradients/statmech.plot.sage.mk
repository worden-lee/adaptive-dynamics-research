# helper makefile automatically generated from statmech.plot.sage.step
statmech.plot.sage.out statmech.plot.sage.tried : statmech.sobj
statmech.plot.sage.out statmech.plot.sage.tried : $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
statmech.plot.sage.out statmech.plot.sage.tried : $(SageUtils)/latex_output.py lotkavolterra.py
statmech.plot.sage.out.tex  : statmech.plot.sage.out ;
statmech-pred-prey-adap.png statmech-pred-prey-adap.svg : statmech.plot.sage.out ;
statmech-pred-prey-adap-difference.png : statmech.plot.sage.out ;
statmech-pred-prey-a-vs-t.png statmech-pred-prey-a-vs-a.png : statmech.plot.sage.out ;
statmech-pred-prey-x-vs-t.png : statmech.plot.sage.out ;
statmech.plot.sage.out statmech.plot.sage.tried : STEP_PRODUCTS= statmech.plot.sage.out.tex  statmech-pred-prey-adap.png statmech-pred-prey-adap.svg statmech-pred-prey-adap-difference.png statmech-pred-prey-a-vs-t.png statmech-pred-prey-a-vs-a.png statmech-pred-prey-x-vs-t.png
