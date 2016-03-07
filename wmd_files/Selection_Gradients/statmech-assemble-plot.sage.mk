# helper makefile automatically generated from statmech-assemble-plot.sage.step
statmech-assemble-plot.sage statmech-assemble-plot.sage.out statmech-assemble-plot.sage.tried : statmech.py
statmech-assemble-plot.sage statmech-assemble-plot.sage.out statmech-assemble-plot.sage.tried : statmech-assemble.sobj
statmech-assemble.sage.out.tex statmech-assemble.svg : statmech-assemble-plot.sage.out ;
statmech-assemble-plot.sage statmech-assemble-plot.sage.out statmech-assemble-plot.sage.tried : STEP_PRODUCTS= statmech-assemble.sage.out.tex statmech-assemble.svg
