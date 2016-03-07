from sage.all import * 
import dynamicalsystems

def LargeNumbersPopulation( n=0, k=2 ):
    M = random_matrix( RDF, k )
    ## notes on how this business is indexed.
    ##  k is a fixed number of dimensions for the phenotypes.
    ##  a population index is a 2-tuple (n,i) where
    ##    n is a lineage and i is which mutation within that lineage.
    ##  the phenotype of a population is a k-vector u_ni, so
    ##    u_nij is a number.
    ##  the interaction coefficient a(i1,i2) (where i* are 2-tuples)
    ##    is the inner product of their u vectors defined by the vector M.
    ## Therefore we need:
    ##  a population indexer that makes 2-tuples into X variables
    ##  a phenotype indexer that makes 2-tuples into vectors
    ##    of u_ variables
    ##  an a indexer that makes a pair of 2-tuples into an a value that's
    ##    an inner product of vectors
    class X_indexer(dynamicalsystems.indexer):
	def __init__(self): pass
	def __getitem__(self,i):
	    ## i a population index, i.e. a 2-tuple of numbers
	    return dynamicalsystems.subscriptedsymbol( 'X', *i )
    class u_indexer(dynamicalsystems.indexer):
	def __init__(self): pass
	def __getitem__(self,i):
	    ## i is a population index
	    ## a population index is a 2-tuple of numbers
	    ## we wish to return a vector of phenotypic values
	    import sys
	    print( "u indexer for ", i ); sys.stdout.flush()
	    return vector( [ dynamicalsystems.subscriptedsymbol( 'u', i[0], i[1], j ) for j in range(k) ] )
    class a_indexer(dynamicalsystems.indexer):
        def __init__(self, model):
            self._model = model
        def __getitem__(self, i):
	    ## i and then j are population indices
            class a_indexer_inner(dynamicalsystems.indexer):
                def __init__(self, model, i):
            	    self._model = model
            	    self._i = i
                def __getitem__(self, j):
		    return (
			self._model._u_indexer[i] *
			M *
			self._model._u_indexer[j]
		    )
            return a_indexer_inner( self._model, i )
    class LargeNumbersPopulationClass(dynamicalsystems.PopulationDynamicsSystem):
        def __init__(
            self,
            n=10,
            bindings=dynamicalsystems.Bindings()):
            # our u is a vector of population indexers
	    # it would be better if it was just vector-valued,
	    # if AdaptiveDynamicsModel could differentiate wrt a vector
            self._u_indexer = u_indexer()
            self._r_indexer = dynamicalsystems.const_indexer(1)
            self._a_indexer = a_indexer(self)
            super(LargeNumbersPopulationClass,self).__init__(
                [], [], X_indexer(), bindings=bindings
            )
            self.generate_random_community(n)
        def flow(self):
            flo = {}
            for i in self._population_indices:
                xi = self._population_indexer[i]
                flo[xi] = self._r_indexer[i]*xi
                for j in self._population_indices:
                    xj = self._population_indexer[j]
                    flo[xi] += xi * xj * self._a_indexer[i][j]
            return flo
        def generate_random_community(self, n):
            for _ in range(n):
                self.add_random_species()
        def add_random_species(self):
            try:
                n = 1 + max( i[0] for i in self._population_indices )
            except ValueError: # empty sequence
                n = 0
            ni = (n,0)
            self.set_population_indices( self._population_indices + [ni] )
            return ni
        def mutate(self, index):
	    sport = (index[0], 1 + max( i for m,i in self._population_indices if m==index[0] ))
            self.set_population_indices( self._population_indices + [ sport ] )
            return sport
        def fake_population_index(self):
            return ('Fake',0)
    return LargeNumbersPopulationClass(n)

