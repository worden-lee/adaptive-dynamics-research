# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: toc.sobj toc.sage.out.tex
from sage.all import * 
from sage.misc.latex import _latex_file_

import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )
import latex_output
import dynamicalsystems
import adaptivedynamics

ltx = latex_output.latex_output( 'toc.sage.out.tex' )

class TragedyOfCommonsModel(dynamicalsystems.PopulationDynamicsSystem):
    def __init__(
	self,
	x_indices=None,
	X = dynamicalsystems.indexer('X'),
	h = dynamicalsystems.indexer('h'),
	m = dynamicalsystems.indexer('m'),
	bindings=dynamicalsystems.Bindings()):
	self._indexers = { 'm':m, 'h':h }
	super(TragedyOfCommonsModel,self).__init__(
	    [], x_indices, X, bindings=bindings
	)
    def flow(self):
	X = self._population_indexer
	h = self._indexers['h']
	m = self._indexers['m']
	return {
	    X[i] : (h[i]*(SR.symbol('q_0') - SR.symbol('d')*sum(h[j]*X[j] for j in self._population_indices)) - m[i]) * X[i]
	    for i in self._population_indices
	}

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
toc = TragedyOfCommonsModel(
    x_indices=[0],
    X = dynamicalsystems.indexer( lambda i: i and 'X_i' or 'X' ),
    h = dynamicalsystems.indexer( lambda i: i and 'h_i' or 'h' ),
    m = dynamicalsystems.indexer( lambda i: 1 )
);

ltx.write( 'The ToC model:' )
ltx.write_block( toc )

toc_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    toc,
    [ toc._indexers['h'] ]
)

ltx.write( 'Whence the adaptive dynamics of $h$ is' )
ltx.write_environment( 'align*', [ r'\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(toc_adap._S[v])) for v in toc_adap._vars ) ] )

ltx.close()

save_session('toc')
