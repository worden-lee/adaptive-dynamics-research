# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb.sobj foodweb.sage.out.tex
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

ltx = latex_output.latex_output( 'foodweb.sage.out.tex' )

class vertex_indexer(dynamicalsystems.indexer):
    def init(self, x):
	self._f = x
    def __getitem__(self, tup):
	# tup is a tuple (vertex, number)
	v, i = tup
	return SR.symbol(
	    self._f + '_' + str(v) + '_' + str(i),
	    latex_name = self._f + '_{' + latex(v) + latex(i) + '}'
	)

class FoodWebModel(dynamicalsystems.PopulationDynamicsSystem):
    def __init__(
	self,
	graph,
	bindings=dynamicalsystems.Bindings()):
	self._graph = graph
	# population indices in this model are tuples (vertex, sequential number)
	x_indices = [ (v,0) for v in graph.vertices() ]
        pop_indexer = vertex_indexer('X')
	self._u_indexer = vertex_indexer('u')
	super(FoodWebModel,self).__init__(
	    [], x_indices, pop_indexer, bindings=bindings
	)
    def flow(self):
	inflo = { v: 0 for v in self._vars }
	outflo = { v: 0 for v in self._vars }
	k = self._bindings( 'k' )
	for i in self._population_indices:
	    xi = self._population_indexer[i]
	    for j in self._population_indices:
		if i != j and self._graph.has_edge( j[0], i[0] ):
		    xj = self._population_indexer[j]
		    axx = self._a( i, j ) * xi * xj
		    outflo[ xj ] += axx
		    inflo[ xi ] += k * axx
	    if inflo[xi] == 0:
		inflo[xi] = self._bindings( 'r' ) * xi
	return {
	    v : inflo[v] - outflo[v] for v in inflo.keys()
	}
    def _a(self, i, j):
	from sage.symbolic.function_factory import function
	return function('a')( self._u_indexer[i], self._u_indexer[j] )
    def mutate(self, index):
	i = 1 + max( i[1] for i in self._population_indices )
	return (index[0], i)

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('a b')
foodweb = FoodWebModel(
    DiGraph( { a:[b] } )
);

ltx.write( 'The foodweb model:' )
ltx.write_block( foodweb )

ltx.close()
save_session('foodweb')
sys.exit( 0r )

foodweb_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    foodweb,
    [ foodweb._u_indexer ]
)

ltx.write( 'Whence the adaptive dynamics of $h$ is' )
ltx.write_environment( 'align*', [ r'\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(toc_adap._S[v])) for v in toc_adap._vars ) ] )

ltx.close()

save_session('foodweb')
