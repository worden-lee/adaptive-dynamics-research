from sage.all import *
import dynamicalsystems

class MaselModel(dynamicalsystems.PopulationDynamicsSystem):
    def __init__( self, n,
	r = dynamicalsystems.indexer('r'),
	c = dynamicalsystems.indexer('c'),
	K = dynamicalsystems.indexer('K'),
	X = dynamicalsystems.indexer('X') ):
	self._indexers = dict( r=r, c=c, K=K, X=X )
	super(MaselModel,self).__init__( [], range(n), X )
    def flow(self):
	def _flow( r, c, K, X ):
	    return { X[i]: r[i]*X[i]*(1 - sum( c[j]*X[j] / K[j] for j in self._population_indices ) / c[i]) for i in self._population_indices }
	return _flow( **self._indexers )

class Masel2Model(dynamicalsystems.PopulationDynamicsSystem):
    def __init__( self, n,
	r = dynamicalsystems.indexer('r'),
	s = dynamicalsystems.indexer('s'),
	c = dynamicalsystems.indexer('c'),
	K = dynamicalsystems.indexer('K'),
	X = dynamicalsystems.indexer('X') ):
	self._indexers = dict( r=r, s=s, c=c, K=K, X=X )
	super(Masel2Model,self).__init__( [], range(n), X )
    def flow(self):
	def _flow( r, s, c, K, X ):
	    return { X[i]: X[i]*(r[i] - s[i]*sum( c[j]*X[j] / K[j] for j in self._population_indices ) / c[i]) for i in self._population_indices }
	return _flow( **self._indexers )

