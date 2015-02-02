# requires: maclev_unconstrained_c.py maclev_2_2_defs.py
# requires: maclevmodels.py $(SageDynamics)/dynamicalsystems.py
from sage.all import *
from sage.misc.latex import _latex_file_
from maclev_unconstrained_c import *

rescomp = ResourceCompetitionModel( x_indices = [0], r_indices = [0, 1] )
maclev = MacArthurLevinsModel( x_indices = [0], r_indices = [0, 1] )

m_const = SR(-1)

bm_bindings = Bindings( dict(
    [ (rescomp._indexers['b'][i], 1) for i in (0,1,'i') ] +
    [ (rescomp._indexers['m'][i], K_0*c_func(i,0) + K_1*c_func(i,1) + m_const) for i in (0,1,'i') ]
) )

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
    integrate_adapdyn_step = 0.025

ad_bindings = bmc_bindings + gamma_bindings

