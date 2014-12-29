# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py maclev_2_2_defs.py
# produces: maclev-2-2-adap.sage.out.tex maclev-2-2-adap.sobj
# produces: maclev-2-2-c-vs-u.png maclev-2-2-u-vs-t.png 
# produces: maclev-2-2-u-vs-u.png maclev-2-2-c-vs-c.png
from maclev_2_2_defs import *

ltx = latex_output( 'maclev-2-2-adap.sage.out.tex' )

ltx.write( 'maclev anyone? ' )
ltx.write_block( maclev )

ltx.write( 'and with the functional and numeric bindings: ' )
ltx.write_block( maclev.bind( ad_bindings + numeric_params ) )

# I don't trust FunctionBindings any more, but I need to use it briefly
# to get tractable adaptive dynamics here.
# (see http://trac.sagemath.org/ticket/17503 and
# http://trac.sagemath.org/ticket/17504)
bmc_to_fn_bindings = Bindings( dict(
    [ ( maclev._rescomp_model._indexers['c'][i][j],
        function( 'c_%s'%j )( u_indexer[i] ) )
      for i in (0,1,'i') for j in (0,1) ] +
    [ ( maclev._rescomp_model._indexers['b'][i], function('b')( u_indexer[i] ) ) for i in (0,1,'i') ] +
    [ ( maclev._rescomp_model._indexers['m'][i], function('m')( u_indexer[i] ) ) for i in (0,1,'i') ]
    ) )
bmc_from_fn_bindings = Bindings( FunctionBindings( dict(
    [ ( function( 'c_%s'%j ), c_func(0,j).function( u_indexer[0] ) )
        for j in (0,1) ] +
    [ ( function( 'b' ), SR(1) ), ( function('m'), SR(1) ) ]
    ) ) )

#print 'bmc_to_fn_bindings:', bmc_to_fn_bindings
#print 'bmc_from_fn_bindings:', bmc_from_fn_bindings

print 'plot c vs u'
sys.stdout.flush()

# and plot c vs u
u_timeseries = plot( c_func( 0, 0 ), (u_0, 0, 1) )
u_timeseries += plot( c_func( 1, 1 ), (u_1, 0, 1), color="green" )
u_timeseries.axes_labels( [ '$u$', '$c_i(u)$' ] )
u_timeseries.save( 'maclev-2-2-c-vs-u.png', figsize=(4,4) )

print "starting adaptive dynamics"
sys.stdout.flush()

try:
    maclev_adap_c = NumericalAdaptiveDynamicsModel( maclev,
        [ u_indexer ],
        early_bindings=bmc_to_fn_bindings,
        late_bindings=bmc_from_fn_bindings + ad_bindings + numeric_params,
        equilibrium_function = find_interior_equilibrium )
    #ltx.write( maclev_adap_c._debug_output._output._str )
    ltx.write( 'adaptive dynamics of $u_\cdot$ in that model:' )
    ltx.write_block( maclev_adap_c )
except AdaptiveDynamicsException, e:
    print( r'%s\\Exception: %s' % (e._latex_str, e) )
    sys.stdout.flush()
    ltx.write( e._latex_str, r'\\Exception: %s\\' % e )

print "did adaptive dynamics"
sys.stdout.flush()

#ltx.write( '\\texttt{initial\\_conditions} = %s' % latex( initial_conditions ) )
#ltx.write( 'initial conditions: $%s$\n\n' % latex( [ 0, initial_conditions( u_0 ), initial_conditions( u_1 ) ] ) )

print 'solve'
sys.stdout.flush()

c_evolution = maclev_adap_c.solve( [0, initial_conditions( u_0 ), initial_conditions( u_1 ) ], end_points=1, step=0.02 )

print 'plot u vs t'
sys.stdout.flush()

# and plot u vs t
t = maclev_adap_c.time_variable()
u_timeseries = c_evolution.plot( t, u_0 )
u_timeseries += c_evolution.plot( t, u_1, color='red' )
u_timeseries.axes_labels( [ '$t$', '$u$' ] )
u_timeseries.save( 'maclev-2-2-u-vs-t.png', figsize=(4,4) )

print 'plot u vs u'
sys.stdout.flush()

# plot phase plane of u vs u
u_phase_plane = c_evolution.plot( u_0, u_1 )
u_phase_plane += maclev_adap_c.plot_vector_field( (u_0,0,1), (u_1,0,1), color='gray', plot_points=(19,20) )
u_phase_plane.axes_labels( [ '$u_0$', '$u_1$' ] )
u_phase_plane.save( 'maclev-2-2-u-vs-u.png', xmin=0, xmax=1, ymin=0, ymax=1,
    figsize=(4,4) )

print 'done'
sys.stdout.flush()

#stop there for now
ltx.close()
save_session( 'maclev-2-2-adap' )
sys.exit()
