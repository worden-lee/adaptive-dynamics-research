# helper makefile automatically generated from r-selection.sage.step
r-selection.sage r-selection.sage.out r-selection.sage.tried : r_selection.py masel_model.py
masel-replicator.tex r-selection.tex : r-selection.sage.out ;
r-selection.sage r-selection.sage.out r-selection.sage.tried : STEP_PRODUCTS= masel-replicator.tex r-selection.tex
