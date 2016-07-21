from sage.all import * 
import dynamicalsystems

class vertex_indexer(dynamicalsystems.indexer):
    def init(self, x):
	self._f = x
    def __getitem__(self, tup):
	# tup is a tuple (vertex, number)
	v, i = tup
	return SR.symbol(
	    '%s_%s_%s' % (self._f, str(i), str(v)),
	    latex_name = '%s_{' '%s%s}' % (self._f, latex(i), latex(v))
	)

class vertex_indexer_2d(dynamicalsystems.indexer):
    def __init__(self, x):
	self._f = x
    def __getitem__(self, tupi):
        class vertex_indexer_2d_inner( dynamicalsystems.indexer ):
	    def __init__(self, x, tupi):
		self._f = x
		self._tupi = tupi
	    def __getitem__(self, tupj):
		# tup* is a tuple (vertex, number)
		v, i = self._tupi
		w, j = tupj
		return SR.symbol(
		    '_'.join( [self._f, str(i), str(v), str(j), str(w)] ),
		    latex_name = '%s_{''%s%s%s%s}' % (self._f, latex(i), latex(v), latex(j), latex(w))
		)
	return vertex_indexer_2d_inner(self._f, tupi)

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
	basal = self._graph.sources()
	print 'basal:', basal
	k = SR.symbol( 'k' )
	for i in self._population_indices:
	    xi = self._population_indexer[i]
	    for j in self._population_indices:
	        xj = self._population_indexer[j]
		if i != j and self._graph.has_edge( j[0], i[0] ):
		    axx = self._f( i, j ) * xi * xj
		    outflo[ xj ] += axx
		    inflo[ xi ] += k * axx
		if i[0] in basal and j[0] in basal:
		    outflo[ xj ] += xi*xj
	    if inflo[xi] == 0:
		inflo[xi] += self._bindings( 'r' ) * xi
	    else:
		outflo[xi] += self._bindings( 'm' ) * xi
	return {
	    v : self._bindings( inflo[v] - outflo[v] ) for v in inflo.keys()
	}
    def _f(self, i, j):
	from sage.symbolic.function_factory import function
	return function('f')( self._u_indexer[i], self._u_indexer[j] )
    def mutate(self, index):
	i = 1 + max( i[1] for i in self._population_indices )
	sport = (index[0], i)
	self.set_population_indices( self._population_indices + [ sport ] )
	return sport
    def fake_population_index(self):
	return ('Fake', 0)
    def plot_tikz(self, filename):
	from sage.misc.latex import _latex_file_
	LF = open( filename, 'w' )
	# put all arrows pointing upward
	self._graph.set_pos( self._graph.layout_acyclic() )
	LF.write( _latex_file_( self._graph, title='' ) )
	LF.close()
