# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
from sage.all import *
import os
import sys
 
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
from dynamicalsystems import *
sys.path.append( os.environ['SageAdaptiveDynamics'] )
from adaptivedynamics import *

from sage.symbolic.relation import solve
#from sage.symbolic.function_factory import function

class GeneralizedLotkaVolterraModel(PopulationDynamicsSystem):
    """The GLV model is dX_i/dt = (r_i + sum_j a_i_j X_j) X_i"""
    def __init__(self, x_indices = [], X = indexer('X'), r = indexer('r'),
      a = indexer_2d('a'),
      bindings = Bindings()):
        self._indexers = {'r': r, 'a': a, 'X': X}
        super(GeneralizedLotkaVolterraModel,self).__init__(
            [ ], x_indices, X, bindings=bindings )
    def flow(self):
        return self.make_flow(**self._indexers)
    def make_flow(self, X, r, a):
        return dict( (X[i],
          X[i]*(r[i] + sum( a[i][j]*X[j] for j in self._population_indices )))
          for i in self._population_indices)
    def interior_equilibrium_bindings( self, phenotype_bindings=Bindings() ):
	eq = self.bind( phenotype_bindings ).interior_equilibria()[0]
	eb = Bindings( { vhat:eq[vhat] for vhat in self.equilibrium_vars() } )
	#print 'equilibrium bindings:', eb
	return eb

class LotkaVolterraException(Exception):
    def __init__(self, message):
	self.value = message
    def __str__(self):
	return repr(self.value)

def get_coeff( expr, vars, power ):
    for c, p in expr.coefficients( vars ):
        if p == power:
	    return c

class DerivedLotkaVolterraModel( GeneralizedLotkaVolterraModel ):
    """This is a LotkaVolterraModel made by decomposing the dynamics of
    some other population dynamics model into linear and quadratic terms.
    It has the attributes of a GeneralizedLotkaVolterraModel, plus some
    additional information about the original model."""
    def __init__(self, model, a_name='a', r_name='r'):
	self._original_model = model
	self._a_name = a_name
	self._r_name = r_name
	r_indexer = indexer(r_name)
	a_indexer = indexer_2d(a_name)
        x_indexer = model._population_indexer
        aij_dict = {}
        vars = {v:1 for v in model._vars}
        for i in model._population_indices:
            xi = x_indexer[i]
	    lvi = model._flow[xi].expand()
            print 'Inferring LV coefficients from', xi, 'equation:', lvi
	    ri = xic = get_coeff( lvi, xi, 1 )
	    aij = aij_dict[a_indexer[i][i]] = get_coeff( lvi, xi, 2 )
            lvi -= aij * xi**2
	    for j in model._population_indices:
	        if j != i:
                    xj = x_indexer[j]
		    ri = get_coeff( ri, xj, 0 )
		    aij = aij_dict[a_indexer[i][j]] = get_coeff( xic, xj, 1 )
                    print a_indexer[i][j], ':', aij
                    lvi -= aij * xi * xj
            print r_indexer[i], ':', ri
	    aij_dict[r_indexer[i]] = ri
            lvi -= ri * xi
            if lvi != 0:
                raise LotkaVolterraException( "Population dynamics has excess terms in " + str(i) + "'th component: " + str(lvi) )
            del vars[xi]
        if len(vars) > 0:
            raise LotkaVolterraException( "Population dynamics has extra variables: " + ', '.join(vars.keys()) )
	self._A_bindings = Bindings( aij_dict ) 
        super(DerivedLotkaVolterraModel,self).__init__(
            model._population_indices,
            r = r_indexer,
            a = a_indexer
	)

class LotkaVolterraAdaptiveDynamics( object ):
    '''Not an AdaptiveDynamicsModel class, but a helper that works with one.'''
    def __init__( self, ad, lv_model=None, r_name='r', a_name='a' ):
        self._adaptivedynamics = ad

	print 'ad bindings:', self._adaptivedynamics._bindings
	print 'model bindings:', self._adaptivedynamics._popdyn_model._bindings
	print '_early_bindings:', self._adaptivedynamics._early_bindings
	print '_late_bindings:', self._adaptivedynamics._late_bindings

	# make LV model here
	print 'make LV model'
	self._lv_model = DerivedLotkaVolterraModel( ad._popdyn_model, r_name=r_name, a_name=a_name )

	print '_A_bindings:', self._lv_model._A_bindings

	# for now, this only supports AD with a single phenotype variable
	u_indexers = self._adaptivedynamics._phenotype_indexers

	# sanity check the a values' functional form
	# using extended system, in case it's only 1-d otherwise
	extended_system = deepcopy( ad._popdyn_model )
	# TODO: mutate all populations, not just the first one
	mutant_index = extended_system.mutate( extended_system._population_indices[0] )
	extended_lv_model = DerivedLotkaVolterraModel( extended_system, r_name=r_name, a_name=a_name )
	a_to_u_bindings = self._adaptivedynamics._bindings + self._adaptivedynamics._late_bindings + extended_lv_model._A_bindings
	print 'a_to_u_bindings:', a_to_u_bindings
        u0s = column_vector( [ u_indexer[0] for u_indexer in u_indexers ] )
        uqis = column_vector( [ u_indexer[mutant_index] for u_indexer in u_indexers ] )
        a_func = a_to_u_bindings( extended_lv_model._indexers['a'][0][mutant_index] ).function( *(list(u0s) + list(uqis)) )
	print 'a_func:', a_func
	r_func = a_to_u_bindings( extended_lv_model._indexers['r'][0] ).function( *u0s )
	print 'r_func:', r_func
	for i in ad._popdyn_model._population_indices:
            uis = column_vector( u[i] for u in u_indexers )
	    for j in ad._popdyn_model._population_indices:
                ujs = column_vector( u[j] for u in u_indexers )
	        if a_to_u_bindings( extended_lv_model._indexers['a'][i][j] ) != a_func( *(list(uis)+list(ujs)) ):
		    raise LotkaVolterraException(
			'Model does not have consistent form a(u_i,u_j): ' +
			str( a_to_u_bindings( extended_lv_model._indexers['a'][i][j] ) ) +
			' does not have the form of ' +
                        'a(%s, %s) = ' % (''.join(str(u[i]) for u in u_indexers), ''.join(str(u[j]) for u in u_indexers)) +
			str( a_func( *(list(uis) + list(ujs)) ) ) )
		if a_to_u_bindings( extended_lv_model._indexers['r'][i] ) != r_func( *uis ):
		    raise LotkaVolterraException(
			'Model does not have consistent form r(u_i): ' +
			str( a_to_u_bindings( extended_lv_model._indexers['r'][i] ) ) +
			' does not have the form of ' +
			str( r_func( *uis ) ) )
	        for k in ad._popdyn_model._population_indices:
		    if len( extended_lv_model._A_bindings( extended_lv_model._indexers['a'][i][j] ).coefficients( extended_lv_model._population_indexer[k] ) ) > 1:
		        raise LotkaVolterraException( 'Model has super-quadratic terms in population variables' )
	self._A_function_expansion_bindings = Bindings( FunctionBindings( { a_name: a_func, r_name: r_func } ) )

	print 'make LV adaptive dynamics'
        formal_equilibrium = Bindings( { v : hat(v) for v in self._lv_model.population_vars() } )
	self._lv_adap = AdaptiveDynamicsModel(
	    self._lv_model,
	    [ self._lv_model._indexers['r'] ] + [ indexer_2d_reverse('a')[j] for j in self._lv_model._population_indices ],
            equilibrium = formal_equilibrium )
	# todo: what to do with multiple phenotype indexers?
	print 'make LV evolution bindings'
	#ui = self._adaptivedynamics._phenotype_indexers[0]
        us = self._adaptivedynamics._phenotype_indexers
	# _A_to_function_bindings expands the LV equations
	# into functions of u_i, e.g. from a_i_j to a(u_i,u_j)
	# very necessary so that partial derivatives can be taken
	self._A_to_function_bindings = Bindings( dict( [
	  ( self._lv_model._indexers['a'][i][j], 
	    self._lv_model._A_bindings( function( a_name )( *([u[i] for u in us] + [u[j] for u in us] ) ) ) )
	  for i in self._lv_model._population_indices
	  for j in self._lv_model._population_indices ] + [
	  ( self._lv_model._indexers['r'][i],
	    self._lv_model._A_bindings( function( r_name )( *(u[i] for u in us) ) ) )
	  for i in self._lv_model._population_indices ] ) )
	#print '_A_to_function_bindings:', self._A_to_function_bindings
	#print '_A_function_expansion_bindings:', self._A_function_expansion_bindings
	# _phenotypes_to_fn_bindings: changes u_i to u_i(t)
	# is used in all the below methods, so that du_i(t)/dt works
	self._phenotypes_to_fn_bindings = Bindings( dict(
	    ( u[i], function( str(u[i]), self._adaptivedynamics._time_variable, latex_name=latex(u[i]) ) )
	    for i in self._lv_model._population_indices
	    for u in self._adaptivedynamics._phenotype_indexers ) )
	# _phenotypes_from_fn_bindings: the inverse, change u_i(t) to u_i
	self._phenotypes_from_fn_bindings = Bindings(
	    { v:k for k, v in self._phenotypes_to_fn_bindings.items() } )
	#print '_phenotypes_from_fn_bindings:', self._phenotypes_from_fn_bindings
    def A( self, i ):
        '''The 'interaction phenotype' vector of Lotka-Volterra coefficients
        that are affected by selection on population i.  These are r_i and a_ij
        for all j.'''
        # this is a vector, intended to be treated as a column vector.
        return vector(
            [ self._lv_model._indexers['r'][i] ] +
            [ self._lv_model._indexers['a'][i][j] for j in self._lv_model._population_indices ] )
    def S( self, A ):
        '''The selection gradient corresponding to the 'interaction phenotype'
        A.'''
        # This is a vector, intended to be treated as a column vector.
        return vector( [ self._lv_adap._S[a] for a in A ] )
    def d1A( self, i ):
	'''"Direct effect": derivative of A(u_i) wrt u_i with u_i in the "patient"
        position, as the first argument of a(.,.).'''
        # this is a matrix, with row indices the same as in A and column
        # indices indexing the entries of the u phenotype vector.
        A_ij = self._A_to_function_bindings( self.A(i) )
	uis = column_vector( [ u[i] for u in self._adaptivedynamics._phenotype_indexers ] )
	uxs = column_vector( [ u['x'] for u in self._adaptivedynamics._phenotype_indexers ] )
	#print 'hack A_ij: from', A_ij
        A_ij_hacked = A_ij.apply_map( lambda x: x.subs_expr( function( self._lv_model._a_name )(*(list(uis)+list(uis))) == function( self._lv_model._a_name )(*(list(uis)+list(uxs))) ) )
	#print 'to', A_ij_hacked
	#print 'd1A: derivative of $%s$ wrt $%s$' % (latex(A_ij_hacked), latex(uis))
        d1a = matrix( [ [ aij.derivative( u ) for u in uis ] for aij in A_ij_hacked ] )
        #if d1a.nrows() == 1:
        #   d1a = d1a.row(0)
        #elif d1a.ncols() == 1:
        #   d1a = column_vector( d1a.column(0) )
	#print 'is $%s$' % latex( d1a )
        d = d1a
        for ux, ui in zip( uxs, uis ):
	    d = d.subs( ux == ui )
	d = self._A_function_expansion_bindings( d )
	#print ': $%s$' % latex( d )
	return d
    def direct_effect( self, i ):
        # the component of change in A due to direct selection on population i
        # a vector
	return ( self._phenotypes_to_fn_bindings( self.d1A(i) ) * derivative(
	        self._phenotypes_to_fn_bindings( vector( [ u[i] for u in self._adaptivedynamics._phenotype_indexers ] ) ),
	        self._adaptivedynamics._time_variable
	    ) )
    def d2A_component( self, i, j ):
        '''Component of "Indirect effects" on "patient" u_i, due to "agent" u_j.
        When j is i, this includes only the "agent" role of u_i, which is where
        it appears as the second argument of a().'''
        # this is a matrix, with row indices the same as in A and column
        # indices indexing the entries of the u phenotype vector.
        A_ij = self._A_to_function_bindings( self.A(i) )
	u = self._adaptivedynamics._phenotype_indexers[0]
        if j == i:
	    uis = [ u[i] for u in self._adaptivedynamics._phenotype_indexers ]
	    uxs = [ u['x'] for u in self._adaptivedynamics._phenotype_indexers ]
            A_ij_hacked = A_ij.apply_map( lambda x: x.subs_expr( function( self._lv_model._a_name )( *(uis+uis) ) == function( self._lv_model._a_name )( *(uis+uxs) ) ) )
            #print A_ij,', with', function( self._lv_model._a_name )( *(uis+uis) ), ' => ', function( self._lv_model._a_name )( *(uis+uxs) ), ' == ', A_ij_hacked
	    #print 'd2A: derivative of $%s$ wrt $%s$' %(latex(A_ij_hacked), latex(uxs))
            d2A_hacked = matrix( [ [ aij.derivative( uxi ) for uxi in uxs ] for aij in A_ij_hacked ] )
	    #print 'is $%s$' % latex(d2A_hacked)
            d2A = Bindings( { uxi:uii for uxi, uii in zip(uxs, uis) } )( d2A_hacked )
            #print 'on diagonal: $\partial_2 A = %s$\n\n' % latex( d2A )
        else:
	    #print 'd2A: derivative of $%s$ wrt $%s$' %(latex(A_ij), latex(u[j]))
            d2A = matrix( [ [ aij.derivative( u[j] ) for u in self._adaptivedynamics._phenotype_indexers ] for aij in A_ij ] )
	    #print 'is $%s$'% latex( d2A )
            #ltx.write( 'off diagonal: $\partial_2 A = %s$\n\n' % latex( d2A ) )
	return self._A_function_expansion_bindings( d2A )
    def indirect_effect( self, i ):
        # component of the motion of A_i due to selection on all "agents" that
        # act on population i
        # a vector
	components = [ self._phenotypes_to_fn_bindings( self.d2A_component( i, j ) ) * derivative(
	        self._phenotypes_to_fn_bindings( vector( [ u[j] for u in self._adaptivedynamics._phenotype_indexers ] ) ),
	        self._adaptivedynamics._time_variable
	    ) for j in self._lv_model._population_indices ]
	#import operator
	return reduce( operator.add, components )
    def dudt_bindings( self ):
	# TODO: AD class should provide one of these, and
	# use it internally as well
        # TODO: make matrix * column_vector work
	dudts = {
            i:( SR('gamma') * hat( self._lv_model._population_indexer[i] ) *
	        self.d1A(i).transpose() * self.S( self.A(i) ) )
              for i in self._lv_model._population_indices
        }
        print 'dudts:', dudts
	return Bindings( {
	    derivative(
                self._phenotypes_to_fn_bindings( us[i] ),
                self._adaptivedynamics._time_variable
            ): dudts[i][j]
	      for i in self._lv_model._population_indices
              for j,us in enumerate(self._adaptivedynamics._phenotype_indexers)
        } )
    def dAdt( self, i ):
        # the motion of the 'interaction phenotype' A_i.  This is not computed
        # using the above components, but by using the chain rule with the
        # derivative of the constraint phenotype u_i.
        # A vector.
        Ai = self.A(i)
	Au = self._adaptivedynamics._bindings( self._lv_model._A_bindings( Ai ) )
	#import operator
        dAdus = [ self._phenotypes_to_fn_bindings( diff( Au, u[j] ) ) for u in self._adaptivedynamics._phenotype_indexers for j in self._lv_model._population_indices ]
        dudts = [ diff( self._phenotypes_to_fn_bindings( u[j] ), self._adaptivedynamics._time_variable ) for u in self._adaptivedynamics._phenotype_indexers for j in self._lv_model._population_indices ]
        dAdts = [ vector( dAiduj * dujdt for dAiduj in dAduj ) for dAduj, dujdt in zip( dAdus, dudts ) ]
	d = reduce( operator.add, dAdts )
	#print 'dAdt: diff of Au is $%s$' % latex( d )
        sys.stdout.flush()
	return d
