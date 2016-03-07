# helper makefile automatically generated from large-assemble-plot.sage.step
large-assemble-plot.sage large-assemble-plot.sage.out large-assemble-plot.sage.tried : large.py
large-assemble-plot.sage large-assemble-plot.sage.out large-assemble-plot.sage.tried : large-assemble.sobj
large-assemble.sage.out.tex large-assemble.svg : large-assemble-plot.sage.out ;
large-assemble-plot.sage large-assemble-plot.sage.out large-assemble-plot.sage.tried : STEP_PRODUCTS= large-assemble.sage.out.tex large-assemble.svg
