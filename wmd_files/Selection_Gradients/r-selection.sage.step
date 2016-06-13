# requires: r_selection.py masel_model.py
# produces: masel-replicator.tex r-selection.tex
from sage.all import *
import dynamicalsystems
import masel_model, r_selection

mm = masel_model.MaselModel(2)
rsel = r_selection.ReplicatorDynamics( mm )

ltx = dynamicalsystems.latex_output( 'masel-replicator.tex' )
ltx.write( rsel )
ltx.close()

rsel = r_selection.ReplicatorDynamics( masel_model.MaselModel( 2, K=dynamicalsystems.indexer( lambda x:oo ) ) )

ltx = dynamicalsystems.latex_output( 'r-selection.tex' )
ltx.write( rsel )
ltx.close()

rsel = r_selection.ReplicatorDynamics( masel_model.MaselModel( 1, K=dynamicalsystems.indexer( lambda x:oo ) ) )
ad = dynamicalsystems.AdaptiveDynamicsModel(
	rsel,
	[ dynamicalsystems.indexer('r'), dynamicalsystems.indexer('c'), dynamicalsystems.indexer('K') ],
	equilibrium=rsel.symbolic_equilibria()
    )

ltx = dynamicalsystems.latex_output( 'r-adap.tex' )
ltx.write( ad )
ltx.close()

