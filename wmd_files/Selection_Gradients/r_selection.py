from sage.all import *
import dynamicalsystems
import masel_model

class ReplicatorDynamics(dynamicalsystems.PopulationDynamicsSystem):
    def __init__( self, model ):
	print 'ReplicatorDynamics init'; sys.stdout.flush()
	self._orig_model = model
	super(ReplicatorDynamics,self).__init__( model._nonpop_vars, model._population_indices, model._population_indexer )
    def set_population_indices(self, ixs):
	self._orig_model.set_population_indices( ixs )
	super(ReplicatorDynamics,self).set_population_indices( ixs )
    def flow(self):
	print 'starting flow'; sys.stdout.flush()
	flux = sum( self._orig_model._flow[ self._population_indexer[i] ] for i in self._population_indices )
	print 'flux', flux; sys.stdout.flush()
	fx = {
	    xi: self._orig_model._flow[xi] - xi*flux
		for xi in [ self._population_indexer[i] for i in self._population_indices ]
	    }
	print 'fx', fx; sys.stdout.flush()
	fv = {
		x : self._orig_model._flow[x] for x in self._orig_model._nonpop_vars
	    }
	print 'fv', fv; sys.stdout.flush()
	fd = dict( fx, **fv )
	print 'flow:', fd; sys.stdout.flush()
	return fd
