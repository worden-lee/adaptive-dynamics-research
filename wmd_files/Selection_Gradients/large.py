from sage.all import * 
import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )
import latex_output
import dynamicalsystems
import adaptivedynamics

def LargeNumbersPopulation( k ):
    M = random_matrix( RDF, k )
    class a_indexer(dynamicalsystems.indexer):
        def __init__(self, model):
            self._model = model
        def __getitem__(self, i):
            class a_indexer_inner(dynamicalsystems.indexer):
                def __init__(self, model, i):
            	    self._model = model
            	    self._i = i
                def __getitem__(self, j):
		    return (
			vector( [ self._model._u_indexer[a][i] for a in range(k) ] ) *
			M *
			vector( [ self._model._u_indexer[a][j] for a in range(k) ] )
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
	    vu = dynamicalsystems.indexer_2d('u')
            self._u_indexers = [ vu[i] for i in range(k) ]
            self._r_indexer = dynamicalsystems.const_indexer(1)
            self._a_indexer = a_indexer(self)
            super(LargeNumbersPopulation,self).__init__(
                [], [], vertex_indexer('X'), bindings=bindings
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
            import numpy
            self._a_lookup[n] = { n: (-1,0,0) }
            for i in self._population_indices:
                bin = RDF(numpy.random.normal(0,1))
                bni = RDF(numpy.random.normal(0,1))
                c = 1
                d = 1
                theta = RDF(numpy.random.uniform(0,2*pi))
                rho = RDF(numpy.random.uniform(0,2*pi))
                self._a_lookup[i[0]][n] = (bin, c*cos(theta), d*cos(rho))
                self._a_lookup[n][i[0]] = (bni, c*sin(theta), d*sin(rho))
            ni = (n,0)
            self.set_population_indices( self._population_indices + [ni] )
            return ni
        def mutate(self, index):
            sport = index + 1
            self.set_population_indices( self._population_indices + [ sport ] )
            return sport
        def fake_population_index(self):
            return 'Fake'

