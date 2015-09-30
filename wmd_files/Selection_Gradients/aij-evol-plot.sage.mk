# helper makefile automatically generated from aij-evol-plot.sage.step
aij-evol-plot.sage aij-evol-plot.sage.out aij-evol-plot.sage.tried : aij-evol.sobj
aij-evol-plot.sage.out.tex  : aij-evol-plot.sage.out ;
aij-a-vs-t.svg aij-a-vs-a.svg : aij-evol-plot.sage.out ;
aij-evol-plot.sage aij-evol-plot.sage.out aij-evol-plot.sage.tried : STEP_PRODUCTS= aij-evol-plot.sage.out.tex  aij-a-vs-t.svg aij-a-vs-a.svg
