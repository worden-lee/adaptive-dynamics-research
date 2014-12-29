# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
from sage.all import *
import os
import sys
 
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
from dynamicalsystems import *
sys.path.append( os.environ['SageAdaptiveDynamics'] )
from adaptivedynamics import *

from sage.symbolic.relation import solve
from sage.symbolic.function_factory import function

# functional forms used in the definitions of ResourceCompetitionModel
# and MacArthurLevinsModel

def c_var(i, l):
    return SR.var( 'c_%s_%s'%(i,l), latex_name='c_{%s%s}'%(i,l) )

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

