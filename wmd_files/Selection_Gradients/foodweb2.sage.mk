# helper makefile automatically generated from foodweb2.sage.step
foodweb2.sage foodweb2.sage.out foodweb2.sage.tried : foodweb2.py
foodweb2.sobj foodweb2.sage.out.tex foodweb2.tikz.tex : foodweb2.sage.out ;
foodweb2.sage foodweb2.sage.out foodweb2.sage.tried : STEP_PRODUCTS= foodweb2.sobj foodweb2.sage.out.tex foodweb2.tikz.tex
