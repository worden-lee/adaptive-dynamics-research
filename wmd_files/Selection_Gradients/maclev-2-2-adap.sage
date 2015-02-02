# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
# requires: maclev-2-2-popdyn.sobj maclev_2_2_defs.py
# produces: maclev-2-2-adap.sage.out.tex maclev-2-2-adap.sobj
# produces: maclev-2-2-u-vs-t.png
# produces: maclev-2-2-u-vs-u.png
from maclev_2_2_defs import *

load_session( 'maclev-2-2-popdyn' )

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

#ltx.write( 'Coexistence criteria in $u$:\n' )

#for soln in coexistence_criteria:
#    ltx.write( 'One coexistence solution:\n' )
#    for crit in soln:
#        ltx.write_block( bmc_to_fn_bindings( crit ) )

#coexistence_criteria_u = (bmc_to_fn_bindings + bmc_from_fn_bindings)( coexistence_criteria )
#print 'u criteria:', coexistence_criteria_u

#print "construct adaptive dynamics"
#sys.stdout.flush()

try:
    maclev_adap_c = NumericalAdaptiveDynamicsModel( maclev,
        [ u_indexer ],
        early_bindings=bmc_to_fn_bindings,
        late_bindings=bmc_from_fn_bindings + ad_bindings + numeric_params,
        equilibrium_function = find_interior_equilibrium )
    #ltx.write( maclev_adap_c._debug_output._output._str )
    ltx.write( 'adaptive dynamics of $u_\cdot$ in that model:' )
    ltx.write_block( maclev_adap_c )

    print ( 'find adaptive dynamics equilibria' )
    sys.stdout.flush()

    #ltx.write( 'equilibria:' )
    #adap_equilibria = maclev_adap_c.equilibria( ranges={ u_0:(0.1,0.4,0.6,0.9), u_1:(0.1,0.4,0.6,0.9) } )
    #for eq in adap_equilibria:
        #ltx.write_block( eq )

    print 'construct u vector field plot'
    sys.stdout.flush()

    # plot phase plane of u vs u
    u_phase_plane = maclev_adap_c.plot_vector_field( (u_0,0,1), (u_1,0,1), color='gray', plot_points=(19,20) )
    #for eq in adap_equilibria:
        #print 'eq',eq
        #print 'eq u_0', Bindings( eq )( hat(u_0) )
        #u_phase_plane += point( Bindings( eq )( vector( [ hat(u_0), hat(u_1) ] ) ), color='black', size=30 )

    print 'solve'
    sys.stdout.flush()

    try:
        c_evolution = maclev_adap_c.solve( [ initial_conditions( u_0 ), initial_conditions( u_1 ) ], end_time=integrate_adapdyn_to, step=integrate_adapdyn_step )

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
        u_phase_plane += c_evolution.plot( u_0, u_1 )
    except AdaptiveDynamicsException, e:
        print( 'AdaptiveDynamicsException: %s' % e )
        print 'Failed to integrate adaptive dynamics'
        sys.stdout.flush()
        ltx.write( e._latex_str or '', r'\\Exception: %s\\' % e )

    u_phase_plane.axes_labels( [ '$u_0$', '$u_1$' ] )
    u_phase_plane.save( 'maclev-2-2-u-vs-u.png', xmin=0, xmax=1, ymin=0, ymax=1,
        figsize=(4,4) )
except AdaptiveDynamicsException, e:
    print( 'AdaptiveDynamicsException: %s' % e )
    print 'Failed to construct adaptive dynamics'
    sys.stdout.flush()
    ltx.write( e._latex_str or '', r'\\Exception: %s\\' % e )

ltx.close()
save_session( 'maclev-2-2-adap' )
try:
    c_evolution
except NameError:
    sys.exit( int(1) )
print 'done'
sys.exit()
