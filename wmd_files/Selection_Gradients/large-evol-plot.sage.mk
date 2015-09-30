# helper makefile automatically generated from large-evol-plot.sage.step
large-evol-plot.sage large-evol-plot.sage.out large-evol-plot.sage.tried : large-evol.sobj
large-evol-plot.sage.out.tex  : large-evol-plot.sage.out ;
large-a-vs-t.svg large-a-vs-a.svg : large-evol-plot.sage.out ;
large-evol-plot.sage large-evol-plot.sage.out large-evol-plot.sage.tried : STEP_PRODUCTS= large-evol-plot.sage.out.tex  large-a-vs-t.svg large-a-vs-a.svg
