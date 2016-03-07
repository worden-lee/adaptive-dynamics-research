# helper makefile automatically generated from direct-assemble-plot.sage.step
direct-assemble-plot.sage direct-assemble-plot.sage.out direct-assemble-plot.sage.tried : direct.py
direct-assemble-plot.sage direct-assemble-plot.sage.out direct-assemble-plot.sage.tried : direct-assemble.sobj
direct-assemble.sage.out.tex direct-assemble.svg : direct-assemble-plot.sage.out ;
direct-assemble-plot.sage direct-assemble-plot.sage.out direct-assemble-plot.sage.tried : STEP_PRODUCTS= direct-assemble.sage.out.tex direct-assemble.svg
