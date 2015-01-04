# requires: maclevmodels.py $(SageDynamics)/dynamicalsystems.py
from sage.all import *
from sage.misc.latex import _latex_file_

import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )
from dynamicalsystems import *
from adaptivedynamics import *
from latex_output import *
from maclevmodels import *

# Create the generic 2-species, 2-resources MacLev model, with parameters
# b_i, m_i, c_ij

rescomp = ResourceCompetitionModel( x_indices = [0, 1], r_indices = [0, 1] )

maclev = MacArthurLevinsModel( x_indices = [0, 1], r_indices = [0, 1] )

# create global variables for convenience
r_0, r_1, K_0, K_1, w_0, w_1 = SR.var( 'r_0, r_1, K_0, K_1, w_0, w_1' )
X_0, X_1, R_0, R_1 = SR.var( 'X_0, X_1, R_0, R_1' )

numeric_params = Bindings(
  { r_0: 1, r_1: 1,
    w_0: 1, w_1: 1,
    K_0: 2, K_1: 2 } )

# Create variables and bindings for doing adaptive dynamics of this model:
# map b, m, c to functions of phenotype variables u_i

u_indexer = indexer('u')
u_0, u_1 = (u_indexer[0], u_indexer[1])
gamma = SR.var( 'gamma' )

def linear_c_func(i,j):
    return j + (1 - 2*j)*u_indexer[i]

def linear_bindings(indices):
    return Bindings( dict(
        (rescomp._indexers['c'][i][j], linear_c_func(i,j))
        for i in indices for j in (0,1) ) )

def quadratic_c_func(i,j):
    if j == 0:
        return 1/(1 + u_indexer[i]**2*5)
    if j == 1:
        return 1/(1 + (u_indexer[i]-1)**2*5)
    return -inf

def quadratic_bindings(indices):
    return Bindings( dict(
        [ (rescomp._indexers['c'][i][0], quadratic_c_func(i,0))
          for i in indices
        ] +
        [ (rescomp._indexers['c'][i][1], quadratic_c_func(i,1))
          for i in indices
        ] +
        [ (rescomp._indexers['b'][i], 1) for i in indices ] +
        [ (rescomp._indexers['m'][i], 1) for i in indices ]
    ) )

exp_focus = 3 #0.25
def exponential_c_func(i,j):
    if j == 0 or j == 1:
        return exp( -(u_indexer[i] - j)**2 * exp_focus )
    return -oo

def make_bindings( c_func, indices ):
    return Bindings( dict(
        [ (rescomp._indexers['c'][i][0], c_func(i,0))
          for i in indices
        ] +
        [ (rescomp._indexers['c'][i][1], c_func(i,1))
          for i in indices
        ]
    ) )

bm_bindings = Bindings( dict(
    [ (rescomp._indexers['b'][i], 1) for i in (0,1) ] +
    [ (rescomp._indexers['m'][i], 1) for i in (0,1) ]
) )

integrate_popdyn_to = 30
integrate_adapdyn_to = 1
integrate_adapdyn_step = 0.02

which_model = 'exponential'

if which_model == 'linear':
    c_func = linear_c_func
    c_bindings = make_bindings( c_func, (0,1,'i') )
    bmc_bindings = bm_bindings + c_bindings
    initial_conditions = Bindings( {
        # in a .sage file, could just write u_0: 1/3
        # in a .py, fractions need special care
        u_0 : Rational('2/5'),
        u_1 : Rational('4/7')
    } )
    integrate_popdyn_to = 500
elif which_model == 'quadratic':
    c_func = quadratic_c_func
    c_bindings = make_bindings( c_func, (0,1,'i') )
    bmc_bindings = bm_bindings + c_bindings
    initial_conditions = Bindings( {
        u_0 : Rational('1/3'),
        u_1 : Rational('4/9')
    } )
elif which_model == 'exponential':
    c_func = exponential_c_func
    c_bindings = make_bindings( c_func, (0,1,'i') )
    bmc_bindings = bm_bindings + c_bindings
    initial_conditions = Bindings( {
        u_0 : Rational('1/4'),
        u_1 : Rational('3/4'),
    } )
    integrate_adapdyn_to = 5
    integrate_adapdyn_step = 0.1

gamma_bindings = Bindings( { gamma: 1 } )

ad_bindings = bmc_bindings + gamma_bindings

