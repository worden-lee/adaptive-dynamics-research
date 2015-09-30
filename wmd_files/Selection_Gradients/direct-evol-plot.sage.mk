# helper makefile automatically generated from direct-evol-plot.sage.step
direct-evol-plot.sage direct-evol-plot.sage.out direct-evol-plot.sage.tried : direct-evol.sobj
direct-evol-plot.sage.out.tex  : direct-evol-plot.sage.out ;
direct-a-vs-t.svg direct-a-vs-a.svg : direct-evol-plot.sage.out ;
direct-evol-plot.sage direct-evol-plot.sage.out direct-evol-plot.sage.tried : STEP_PRODUCTS= direct-evol-plot.sage.out.tex  direct-a-vs-t.svg direct-a-vs-a.svg
