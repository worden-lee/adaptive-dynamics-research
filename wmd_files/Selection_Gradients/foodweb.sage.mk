# helper makefile automatically generated from foodweb.sage.step
foodweb.sage foodweb.sage.out foodweb.sage.tried : foodweb.py
foodweb.sobj foodweb.sage.out.tex foodweb.tikz.tex : foodweb.sage.out ;
foodweb.sage foodweb.sage.out foodweb.sage.tried : STEP_PRODUCTS= foodweb.sobj foodweb.sage.out.tex foodweb.tikz.tex
