# requires: masel_model.py
# produces: masel-model.tex
from sage.all import *
import os, sys
sys.path.append( os.environ['SageDynamicsRepo'] )
import masel_model
from latex_output import latex_output

ltx = latex_output( 'masel-model.tex' )
ltx.write( masel_model.MaselModel(1) )
ltx.close()
