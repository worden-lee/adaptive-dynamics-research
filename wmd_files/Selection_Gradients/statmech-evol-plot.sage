# requires: statmech-evol.sobj
# produces: statmech-evol-plot.sage.out.tex 
# produces: statmech-a-vs-t.svg statmech-a-vs-a.svg
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import statmech
import dynamicalsystems
import lotkavolterra

# create variables with custom latex names because load_session
# creates them wrong: http://trac.sagemath.org/ticket/17559
#for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
#SR.symbol( 'c_0_0', latex_name='c_{00}' )
#SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("statmech-evol")

ltx = dynamicalsystems.latex_output( 'statmech-evol-plot.sage.out.tex' )

#ltx.write( 'sm\_traj t:', [ ts('t') for ts in sm_traj._timeseries ], '\n\n' )
#ltx.write( 'starts with:' )
#ltx.write_block( sm_traj._timeseries[0] )
#if 1 in sm_traj._timeseries:
#    ltx.write_block( sm_traj._timeseries[1] )

ltx.write( 'flow: $%s$\n\n' % latex( dynamicalsystems.column_vector( [ sm_adap._flow[v] for v in sm_adap._vars ] ) ) )

ltx.write( 'flow at ', '$%s$'%latex( dynamicalsystems.column_vector( ad_init_state ) ), ': ', 
    '$%s$'%latex( dynamicalsystems.column_vector( ad_init( sm_adap._flow[v] ) for v in sm_adap._vars ) ),
    '\n\n' )

ltx.write( 'a values:' )
ltx.write_block( matrix( [ [ slv._lv_model._a_indexer[i][j] for j in sm_adap._popdyn_model._population_indices ] for i in sm_adap._popdyn_model._population_indices ] ) )
ltx.write_block( matrix( [ [ slv._lv_model._A_bindings( slv._lv_model._a_indexer[i][j] ) for j in sm_adap._popdyn_model._population_indices ] for i in sm_adap._popdyn_model._population_indices ] ) )
ltx.write( 'X values at time 0:' )
ltx.write_block( [ x == sm_traj._timeseries[0]( equil( x ) ) for x in smr.equilibrium_vars() ] )
ltx.write( 'sensitivity of $\hat{X}$:\n' )
ltx.write_equality(
    matrix( [ SR.symbol( 'kdjflkjdf', latex_name=r'\frac{\partial\hat{X}_i}{\partial u_{j0}}' ) ] ),
    matrix( [ [ sm_traj._timeseries[0]( diff( equil(x), u ) ) for u in sm_adap._vars ] for x in smr.equilibrium_vars() ] )
)

atp = Graphics()
for i in sm_adap._popdyn_model._population_indices:
    for j in sm_adap._popdyn_model._population_indices:
	atp += sm_traj.plot( 't', slv._lv_model._A_bindings( slv._lv_model._a_indexer[i][j] ),
	    color = (i == j and 'red' or 'green') )
atp.axes_labels( [ '$t$', '$a$' ] )
atp.save( 'statmech-a-vs-t.svg', figsize=(5,5) )

aap = lotkavolterra.plot_aij_with_arrows( sm_traj, slv, scale=0.05 )
aap.axes_labels( [ '$a_{ij}$', '$a_{ji}$' ] )
aap.save( 'statmech-a-vs-a.svg', figsize=(5,5) )

ltx.close()
exit(0r)

#statmech_adap.bind_in_place( fb )

print 'flow at initial conditions:', pred_prey_init( statmech_adap._flow )

ppp = Graphics()
for v, c, l in zip( statmech_adap._vars, ['blue', 'red'], ['prey $u_0$','predator $u_1$'] ):
    ppp += pred_prey_traj.plot( 't', v, color=c, legend_label=l )
ppp.save( 'statmech-pred-prey-adap.png',
    ticks=[100,pi],
    tick_formatter=[None,pi],
    figsize=(5,5)
)
ppp.save( 'statmech-pred-prey-adap.svg',
    ticks=[500,pi],
    tick_formatter=[None,pi],
    figsize=(3,3)
)

pred_prey_traj.plot( 't', 'u_0_a - u_0_b', legend_label='$u_0-u_1$' ).save(
    'statmech-pred-prey-adap-difference.png',
    ymin=0,
    ymax=3.2,
    ticks=[100,pi/2],
    tick_formatter=[None,pi],
    figsize=(5,5)
)

xs = statmech_adap._popdyn_model.equilibrium_vars()
ppx = Graphics()
for xhat in xs:
    ppx += pred_prey_traj.plot( 't', xhat, legend_label='$%s$'%latex(xhat) )
ppx.save( 'statmech-pred-prey-x-vs-t.png', figsize=(5,5) )

ltx.close()