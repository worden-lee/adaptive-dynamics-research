# helper makefile automatically generated from aij-assemble-plot.sage.step
aij-assemble-plot.sage aij-assemble-plot.sage.out aij-assemble-plot.sage.tried : aij.py
aij-assemble-plot.sage aij-assemble-plot.sage.out aij-assemble-plot.sage.tried : aij-assemble.sobj
aij-assemble.sage.out.tex aij-assemble.svg : aij-assemble-plot.sage.out ;
aij-assemble-plot.sage aij-assemble-plot.sage.out aij-assemble-plot.sage.tried : STEP_PRODUCTS= aij-assemble.sage.out.tex aij-assemble.svg
