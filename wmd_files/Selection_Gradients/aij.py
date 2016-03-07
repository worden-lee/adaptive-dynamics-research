from sage.all import * 
import dynamicalsystems
import lotkavolterra

class AijModel(lotkavolterra.GeneralizedLotkaVolterraModel):
    def __init__(
        self,
        n=10,
        bindings=dynamicalsystems.Bindings()):
        super(AijModel,self).__init__(
            range(n), bindings=bindings
        )

class NaiveAdaptiveDynamicsModel(dynamicalsystems.AdaptiveDynamicsModel):
    def __init__(self, popdyn, phenotype_indexers,
	early_bindings=dynamicalsystems.Bindings(), late_bindings=dynamicalsystems.Bindings()):
	self._popdyn = early_bindings( popdyn )
        self._phenotype_indexers = phenotype_indexers
        self._early_bindings = early_bindings
        self._late_bindings = late_bindings # use when?
	self._vars = [ ix[i] for ix in phenotype_indexers for i in popdyn_model._population_indices ]
    def solve(self, initial_conditions, pop_initial_conditions=None,
	start_time=0, end_time=10, step=1, **opts):
	state_bindings = dynamicalsystems.Bindings( { x:v for x,v in zip( self._vars, initial_conditions ) } )
	print 'state_bindings:', state_bindings
	## treat the pop models as immutable
	self._popdyn = self._popdyn.bind( state_bindings )
	print 'init popdyn:', self._popdyn
	popstate = pop_initial_conditions 
	if popstate is None:
	    popstate = [ 1 for _ in self._popdyn._vars ]
	t = start_time
	trajectory = dynamicalsystems.Trajectory( self, [] )
	self.append_to_trajectory( trajectory, t, state_bindings )
	while t < end_time:
	    found_equil = False
	    while found_equil is False:
		print 'integrate 2500 from', popstate
	        pop_traj = self._popdyn.solve_gsl( popstate, 0, 2500 )
	        pop_end = pop_traj._timeseries[-1]
	        speed = max( [ pop_end( self._popdyn._flow[x] ) for x in self._popdyn._vars ] )
	        found_equil = (N(speed) < 1e-7)
		popstate = [ pop_end(x) for x in self._popdyn._vars ]
		del(self._popdyn._gsl_system)
	    t += 1
	    ## clear out any extinctions
	    persistent_indices = [ i for i in self._popdyn._population_indices if
	        pop_end( self._popdyn._population_indexer[i] ) > 1e-5 ]
	    print 'final state:', popstate, ', keep', persistent_indices
	    for i in set(self._popdyn._population_indices) - set(persistent_indices):
		self.record_extinction(trajectory, t, i, state_bindings)
	    ## add a new variant
	    import numpy.random
	    pops = [ pop_end( self._popdyn._population_indexer[i] )
		for i in persistent_indices ]
	    total_pop = sum( pops )
	    choose_parent = numpy.random.multinomial( 1,
		[ p/total_pop for p in pops ] )
	    mutant_parent = [ i for i,n in zip( persistent_indices, choose_parent ) if n == 1 ][0]
	    self._popdyn = deepcopy( self._popdyn )
	    self._popdyn.set_population_indices( persistent_indices )
	    mutant_index = self.mutate( self._popdyn, mutant_parent )
	    mb = state_bindings( self.mutation_bindings( mutant_parent, mutant_index ) )
	    self._popdyn.bind_in_place( mb )
	    state_bindings += mb
	    print "mutate from", mutant_parent, "to", mutant_index
	    self.record_mutation( trajectory, t, mutant_parent, mutant_index, state_bindings )
	    self.append_to_trajectory( trajectory, t, state_bindings )
	    print self._popdyn
	    popstate = [
		pop_end( self._popdyn._population_indexer[i] ) -
		    (1e-3 if i is mutant_parent else 0)
		for i in persistent_indices
	    ] + [ 1e-3 ]
	return trajectory
    def mutation_bindings(self, parent, sport):
	return dynamicalsystems.Bindings()
    def record_mutation(self, trajectory, t, mutant_parent, mutant_index, state_bindings):
	pass
    def record_extinction(self, trajectory, t, decedent, sb):
	pass
    def append_to_trajectory( self, trajectory, t, state_bindings ):
	trajectory._timeseries.append( dict(
	    [ (x,state_bindings(x)) for x in self._vars ] +
	    [ (SR.symbol('t'),t) ]
	) )

class AijAdaptiveDynamics(NaiveAdaptiveDynamicsModel):
    def __init__(self, popdyn, delta_a=0.01, delta_r=0, **opts):
	super(AijAdaptiveDynamics,self).__init__( popdyn, [], **opts )
	self._vars = [
	    popdyn._indexers['a'][i][j]
		for i in popdyn._population_indices
		for j in popdyn._population_indices
	] + [
	    popdyn._indexers['r'][i]
		for i in popdyn._population_indices
	]
	self._delta_a = delta_a
	self._delta_r = delta_r
    def mutation_bindings(self, i, iprime):
	import numpy.random
	if self._delta_a > 0:
	    da = lambda : numpy.random.normal()*self._delta_a
	else:
	    da = lambda : 0
	if self._delta_r > 0:
	    dr = lambda : numpy.random.normal()*self._delta_r
	else:
	    dr = lambda : 0
	il = self._popdyn._population_indices
	ax = self._popdyn._indexers['a']
	rx = self._popdyn._indexers['r']
	mb = dynamicalsystems.Bindings( dict( [
		(ax[iprime][j], ax[i][j] + da()) for j in il
	    ] + [
		(ax[j][iprime], ax[j][i] + da()) for j in il
	    ] + [
		(ax[iprime][iprime], ax[i][i] + da())
	    ] + [
		(rx[iprime], rx[i] + dr())
	] ) )
	#print 'mutant bindings', i, '->', iprime, ':', mb
	return mb
    def record_mutation(self, trajectory, t, parent, child, sb):
	super(AijAdaptiveDynamics,self).record_mutation(trajectory,t,parent,child,sb)
	ax = self._popdyn._indexers['a']
	sa = ax._f #SR.symbol( ax._f ) # uniqueness problems pickling symbols?
	rx = self._popdyn._indexers['r']
	sr = rx._f #SR.symbol( rx._f )
	st = 't' #SR.symbol('t')
	il = self._popdyn._population_indices
	for i in il:
	    if child != i:
	        trajectory._tree[ (sa,i,child) ] = [ (t-1,sb(ax[i][parent])) ]
		trajectory._tree[ (sa,child,i) ] = [ (t-1,sb(ax[parent][i])) ]
	trajectory._tree[ (sa,child,child) ] = [ (t-1,sb(ax[parent][parent])) ]
	trajectory._tree[ (sr,child) ] = [ (t-1,sb(rx[parent])) ]
    def append_to_trajectory( self, trajectory, t, sb ):
        ax = self._popdyn._indexers['a']
        sa = ax._f
        rx = self._popdyn._indexers['r']
        sr = rx._f
        st = 't'
        il = self._popdyn._population_indices
	try: trajectory._tree
	except AttributeError:
	    from collections import defaultdict
	    trajectory._tree = defaultdict( list )
        for i in il:
	    for j in il:
	        trajectory._tree[ (sa,i,j) ].append( (t,sb(ax[i][j])) )
            trajectory._tree[ (sr,i) ].append( (t,sb(rx[i])) )
