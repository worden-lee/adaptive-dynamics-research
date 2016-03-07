# requires: aij-evol.sobj
# produces: aij-evol-plot.sage.out.tex 
# produces: aij-a-vs-t.svg aij-a-vs-t-0.svg aij-a-vs-a.svg
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import aij
import dynamicalsystems
import lotkavolterra

# create variables with custom latex names because load_session
# creates them wrong: http://trac.sagemath.org/ticket/17559
for x in ('X_0', 'X_i', 'X_1'): dynamicalsystems.hat(SR.symbol(x))
#SR.symbol( 'c_0_0', latex_name='c_{00}' )
#SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("aij-evol")

ltx = dynamicalsystems.latex_output( 'aij-evol-plot.sage.out.tex' )

#ltx.write( 'sm\_traj t:', [ ts('t') for ts in ad_traj._timeseries ], '\n\n' )
#ltx.write( 'starts with:' )
#ltx.write_block( ad_traj._timeseries[0] )
#if 1 in ad_traj._timeseries:
#    ltx.write_block( ad_traj._timeseries[1] )

#ltx.write( 'flow: $%s \mapsto %s$\n\n' % (
#	latex( dynamicalsystems.column_vector( symbolic_adap._vars ) ),
#	latex( dynamicalsystems.column_vector( [ symbolic_adap._flow[v] for v in symbolic_adap._vars ] ) ) ) )

#ltx.write( 'flow at ', '$%s$'%latex( dynamicalsystems.column_vector( ad_init_state ) ), ': ', 
#    '$%s$'%latex( dynamicalsystems.column_vector( ad_init( symbolic_adap._flow[v] ) for v in symbolic_adap._vars ) ),
#    '\n\n' )

#ltx.write( 'a values:' )
#ltx.write_block( matrix( [ [ slv._lv_model._a_indexer[i][j] for j in symbolic_adap._popdyn_model._population_indices ] for i in symbolic_adap._popdyn_model._population_indices ] ) )
#ltx.write_block( matrix( [ [ slv._lv_model._A_bindings( slv._lv_model._a_indexer[i][j] ) for j in symbolic_adap._popdyn_model._population_indices ] for i in symbolic_adap._popdyn_model._population_indices ] ) )
#ltx.write( 'X values at time 0:' )
#ltx.write_block( [ x == ad_traj._timeseries[0]( equil( x ) ) for x in smr.equilibrium_vars() ] )
#ltx.write( 'sensitivity of $\hat{X}$:\n' )
#ltx.write_equality(
#    matrix( [ SR.symbol( 'kdjflkjdf', latex_name=r'\frac{\partial\hat{X}_i}{\partial u_{j0}}' ) ] ),
#    matrix( [ [ ad_traj._timeseries[0]( diff( equil(x), u ) ) for u in symbolic_adap._vars ] for x in smr.equilibrium_vars() ] )
#)

print ad_traj._tree

#atp0 = list_plot( [ (t,aij) for k,l in ad_traj._tree.iteritems() for t,aij in l if str(k[0]) == 'a' ], color='red' )
#atp0.axes_labels( [ '$t$', '$a$' ] )
#atp0.save( 'aij-a-vs-t-0.svg', figsize=(5,5) )

atp0 = sum( ( line( l, color='black' if k[1]==k[2] else (1,0.7,0.7) ) for k,l in ad_traj._tree.iteritems() if str(k[0]) == 'a' ), Graphics() )
atp0.axes_labels( [ '$t$', '$a$' ] )
atp0.save( 'aij-a-vs-t-0.svg', figsize=(5,5) )

atp = sum( ( line( l, color='black' if k[1]==k[2] else (1,0.7,0.7) ) for k,l in ad_traj._tree.iteritems() if str(k[0]) == 'a' and len(l) > 2 ), Graphics() )
atp.axes_labels( [ '$t$', '$a$' ] )
atp.save( 'aij-a-vs-t.svg', figsize=(5,5) )

aap = sum( (
	line( [ (l[1],l[1]) for l in ad_traj._tree[k] ], color='black' )
	    if k[1]==k[2] else
	line( [ (l[1],r[1]) for l,r in zip(ad_traj._tree[k],ad_traj._tree[(k[0],k[2],k[1])]) ], color=(1,0.7,0.7) )
	for k in ad_traj._tree.iterkeys()
	    if str(k[0]) == 'a' and len(ad_traj._tree[k]) > 2# and k[1] <= k[2]
    ),
    Graphics()
)
aap.axes_labels( [ '$a_{ij}$', '$a_{ji}$' ] )
aap.save( 'aij-a-vs-a.svg', figsize=(5,5) )

exit(0r)
atp = Graphics()
aap = Graphics()
for k,ser in ad_traj._tree:
    if str(ann[0]) != 'a': continue
    a,i,j = ann
    if ann in past:
        pij = past[ann]
    else:
        if i in ad_traj._lineage and i >= j:
            ipar = ad_traj._lineage[i]
    	    print ipar, '->', i
        else: ipar = i
        if j in ad_traj._lineage and j >= i:
            jpar = ad_traj._lineage[j]
    	    print jpar, '->', j
        else: jpar = j
        print (ipar,jpar), '->', (i,j)
        print past
        if ('a',ipar,jpar) not in past: # case of initial strain
    	    continue
        pij = past[('a',ipar,jpar)]
        pji = past[('a',jpar,ipar)]
        aap += line( [(pij,pji),(aij,d[('a',j,i)])],
            color = (i == j and 'black' or (1,0.7,0.7)) )
    atp += line( [(tval-1,pij),(tval,aij)],
        color = (i == j and 'black' or (1,0.7,0.7)) )
atp.axes_labels( [ '$t$', '$a$' ] )
atp.save( 'aij-a-vs-t.svg', figsize=(5,5) )
#aap = lotkavolterra.plot_aij_with_arrows( ad_traj, nlv, scale=0.05 )
aap.axes_labels( [ '$a_{ij}$', '$a_{ji}$' ] )
aap.save( 'aij-a-vs-a.svg', figsize=(5,5) )

ltx.close()
exit(0r)

#aij_adap.bind_in_place( fb )

print 'flow at initial conditions:', pred_prey_init( aij_adap._flow )

ppp = Graphics()
for v, c, l in zip( aij_adap._vars, ['blue', 'red'], ['prey $u_0$','predator $u_1$'] ):
    ppp += pred_prey_traj.plot( 't', v, color=c, legend_label=l )
ppp.save( 'aij-pred-prey-adap.png',
    ticks=[100,pi],
    tick_formatter=[None,pi],
    figsize=(5,5)
)
ppp.save( 'aij-pred-prey-adap.svg',
    ticks=[500,pi],
    tick_formatter=[None,pi],
    figsize=(3,3)
)

pred_prey_traj.plot( 't', 'u_0_a - u_0_b', legend_label='$u_0-u_1$' ).save(
    'aij-pred-prey-adap-difference.png',
    ymin=0,
    ymax=3.2,
    ticks=[100,pi/2],
    tick_formatter=[None,pi],
    figsize=(5,5)
)

xs = aij_adap._popdyn_model.equilibrium_vars()
ppx = Graphics()
for xhat in xs:
    ppx += pred_prey_traj.plot( 't', xhat, legend_label='$%s$'%latex(xhat) )
ppx.save( 'aij-pred-prey-x-vs-t.png', figsize=(5,5) )

ltx.close()
