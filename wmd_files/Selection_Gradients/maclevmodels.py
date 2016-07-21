from sage.all import *
 
from dynamicalsystems import *

from sage.symbolic.relation import solve
from sage.symbolic.function_factory import function

# functional forms used in the definitions of ResourceCompetitionModel
# and MacArthurLevinsModel

def c_var(i, l):
    return SR.var( 'c_%s_%s'%(i,l), latex_name='c_{''%s%s}'%(i,l) )

def b_var(i):
    return SR.var( 'b_%s'%i )

def m_var(i):
    return SR.var( 'm_%s'%i )

class ResourceCompetitionModel(PopulationDynamicsSystem):
    """The general resource competition model, with some number of
    populations and some number of resources.  The various parameters
    b_i, c_i_l, etc. may or may not be bound to numerical values.
    """
    def __init__(self, x_indices=None, r_indices=None,
        X = indexer('X'),
        R = indexer('R'),
        b = indexer(b_var),
        m = indexer(m_var),
        w = indexer('w'),
        r = indexer('r'),
        K = indexer('K'),
        c = indexer_2d('c'),
        bindings=Bindings()):
        """How to specify an instance of this model?

        x_indices: might, for instance, be [1, 2, 3], or might not.
        r_indices: likewise.
        X, R, b, etc: some kind of things that can implement operations
            such as, for example, X[i] where i is in x_indices.  These
            should return variables, functions, numbers, or other
            things that can be used in an expression.
        """
        self._r_indices = r_indices
        self._indexers = dict( X=X, R=R, b=b, m=m, c=c, w=w, r=r, K=K )
        super(ResourceCompetitionModel, self).__init__(
            [R[l] for l in r_indices], x_indices, X,
            bindings = bindings )
    def flow(self):
        return self.make_flow(**self._indexers)
    def make_flow(self, X, R, b, c, m, r, w, K):
        X_flows = [ (X[i],
            b[i]*X[i]*(sum(c[i][l]*w[l]*R[l] for l in self._r_indices) - m[i]))
            for i in self._population_indices ]
        R_flows = [ (R[l],
            r[l]*(K[l] - R[l]) -
              sum(c[i][l]*X[i] for i in self._population_indices))
            for l in self._r_indices ]
        return dict(X_flows + R_flows)
    def plot_R_ZNGIs( self, with_perpendicular=True, **options ):
        """This probably doesn't do anything helpful when the number of
        resources or populations isn't 2"""
        R_0, R_1 = ( self._indexers['R'][i] for i in (0,1) )
        X_0, X_1 = ( self._population_indexer[i] for i in (0,1) )
        P = Graphics()
        if with_perpendicular:
            P += point( self._bindings( vector( [ self._indexers['K'][i] for i in (0,1) ] ) ), color='gray', size=30 )
        # aux. line crossing R*
        for x_in in self.population_vars():
            zngi = solve( self._flow[x_in]/x_in == 0, R_1, solution_dict=True )[0][R_1]
            zngi_options = dict( options, color='gray', thickness=2, fill=True, fillcolor='gray', fillalpha=0.3, filename=None )
            del zngi_options['filename']
            r0max = solve( zngi, R_0, solution_dict=True )[0][R_0]
            #print 'plot zngi:', zngi
            #sys.stdout.flush()
            P += plot( zngi, (R_0, 0, r0max), **zngi_options )
            if with_perpendicular:
                elim_x = Bindings( { x_out: 0 for x_out in self.population_vars() if x_out != x_in } )
                # todo: plot parametrized by x_in, if needed for vertical case
                zri_soln = solve( [
                    elim_x( self._flow[R_0] == 0 ),
                    elim_x( self._flow[R_1] == 0 ) ],
                    [ x_in, R_1 ], solution_dict=True )[0]
                zri_r1 = zri_soln[R_1]
                #print 'plot zri:', zri_r1
                #sys.stdout.flush()
                zri_options = dict( options, thickness=1,
                   color = { X_0:'blue', X_1:'red' }[x_in] )
                del zri_options['filename']
                P += plot( zri_r1, (R_0,0,4), **zri_options )
                rstar_soln = solve( [ R_1 == zri_r1, R_1 == zngi ], [ R_0, R_1 ], solution_dict=True )[0]
                rstar = Bindings( rstar_soln )( vector( [ R_0, R_1 ] ) )
                P += point( rstar, color='gray', size=30 )
        if 'filename' in options:
            P.save( **options )
        return P

class MacArthurLevinsModel(PopulationDynamicsSystem):
    """The MacArthur-Levins model is constructed by separating timescales
    to remove the R_l variables from the dynamics"""
    def __init__(self, rescomp_model=None, **named_args):
        """Give me a ResourceCompetitionModel with nx populations and
        nr resources, I will crunch it down into a MacArthurLevinsModel
        with nx populations."""
        #print 'MacArthurLevinsModel', (rescomp_model, named_args)
        if rescomp_model is None:
            rescomp_model = ResourceCompetitionModel(**named_args)
        self._rescomp_model = rescomp_model
        self._r_indices = rescomp_model._r_indices
        super(MacArthurLevinsModel, self).__init__(
          [],
          rescomp_model._population_indices,
          rescomp_model._population_indexer,
          bindings = rescomp_model._bindings )
    def flow(self):
        # find the equilibrium values of R_l given the current values X_i
        R = [self._rescomp_model._indexers['R'][l] for l in self._r_indices]
        Rsolns = { R_l:self.solve_for_R(R_l) for R_l in R }
        #print 'R solns:', Rsolns
        # now substitute those values of R into the X equations
        reduced_flow = dict( (X_i,
              self._rescomp_model._flow[X_i].substitute_expression(Rsolns) )
            for X_i in self.population_vars() )
        # that's the Macarthur-Levins model.
        return reduced_flow
    def solve_for_R(self, R_l):
        """solve for the equilibrium value of one R_l given the X_i values"""
        Rhat_soln = solve( 0 == self._rescomp_model._flow[R_l], R_l, solution_dict=True )
	#print 'solve for', R_l, 'in', [ 0 == self._rescomp_model._flow[R_l] ], ' => ', Rhat_soln
        # there should be just one solution
        assert len(Rhat_soln) == 1
        #print "R-hat: %s" % Rhat_soln[0][R_l]
        # put it in the bindings in case we want to plot R_l or something
        self._bindings[R_l] = Rhat_soln[0][R_l]
        # it's also its own equilibrium
        self._bindings[hat(R_l)] = self._rescomp_model.add_hats( Rhat_soln[0][R_l] )
        return Rhat_soln[0][R_l]
    def set_population_indices(self,xi):
        # need to pass this through to the res-comp system
        self._rescomp_model.set_population_indices(xi)
        super(MacArthurLevinsModel, self).set_population_indices(xi)

