from sage.all import * 
import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )
import latex_output
import dynamicalsystems
import adaptivedynamics

class vertex_indexer(dynamicalsystems.indexer):
    def init(self, x):
	self._f = x
    def __getitem__(self, tup):
	# tup is a tuple (vertex, number)
	v, i = tup
	return SR.symbol(
	    '%s_%s_%s' % (self._f, str(v), str(i)),
	    latex_name = '%s_{%s%s}' % (self._f, latex(v), latex(i))
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
		    '_'.join( [self._f, str(v), str(i), str(w), str(j)] ),
		    latex_name = '%s_{%s%s%s%s}' % (self._f, latex(v), latex(i), latex(w), latex(j))
		)
	return vertex_indexer_2d_inner(self._f, tupi)

class a_indexer(dynamicalsystems.indexer):
    def __init__(self, model):
	self._model = model
    def __getitem__(self, i):
	class a_indexer_inner(dynamicalsystems.indexer):
	    def __init__(self, model, i):
		self._model = model
		self._i = i
	    def __getitem__(self, j):
		b,c,d = self._model._a_lookup[i[0]][j[0]]
		return b + c*self._model._u_indexer[i] + d*self._model._u_indexer[j]
	return a_indexer_inner( self._model, i )

class StatMechPopulation(dynamicalsystems.PopulationDynamicsSystem):
    def __init__(
	self,
	n=10,
	bindings=dynamicalsystems.Bindings()):
	# population indices in this model are tuples (lookup index, sequential number)
	self._u_indexer = vertex_indexer('u')
	self._r_indexer = dynamicalsystems.const_indexer(1)
	self._a_lookup = {}
	self._a_indexer = a_indexer(self)
	super(StatMechPopulation,self).__init__(
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
	i = 1 + max( i[1] for i in self._population_indices )
	sport = (index[0], i)
	self.set_population_indices( self._population_indices + [ sport ] )
	return sport
    def fake_population_index(self):
	return ('Fake', 0)
