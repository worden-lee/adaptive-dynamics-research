from sage.all import *
import os, sys
sys.path.append( os.environ['SageDynamics'] )
import dynamicalsystems
from latex_output import latex_output

def masel_model( n ):
    return PopulationDynamicsSystem( [], range(n), 
	dynamicalsystems.indexer('X')
    )

ltx = latex_output( 'masel-model.tex' )
ltx.write( masel_model(2) )
ltx.close()
