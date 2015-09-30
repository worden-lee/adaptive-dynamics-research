# helper makefile automatically generated from statmech-evol-plot.sage.step
statmech-evol-plot.sage statmech-evol-plot.sage.out statmech-evol-plot.sage.tried : statmech-evol.sobj
statmech-evol-plot.sage.out.tex  : statmech-evol-plot.sage.out ;
statmech-a-vs-t.svg statmech-a-vs-a.svg : statmech-evol-plot.sage.out ;
statmech-evol-plot.sage statmech-evol-plot.sage.out statmech-evol-plot.sage.tried : STEP_PRODUCTS= statmech-evol-plot.sage.out.tex  statmech-a-vs-t.svg statmech-a-vs-a.svg
