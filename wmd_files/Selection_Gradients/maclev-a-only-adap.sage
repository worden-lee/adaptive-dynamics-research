# requires: maclevmodels.py
# requires: maclev-a-only-popdyn.sobj maclev_a_only_defs.py
# produces: maclev-a-only-adap.sage.out.tex maclev-a-only-adap.sobj
# produces: maclev-a-only-u-vs-t.png
# produces: maclev-a-only-u-vs-u.png
from maclev_a_only_defs import *

load_session( 'maclev-a-only-popdyn' )

ltx = latex_output( 'maclev-a-only-adap.sage.out.tex' )

ltx.write( 'maclev anyone? ' )
ltx.write_block( maclev )

ltx.write( 'and with the functional and numeric bindings: ' )
ltx.write_block( maclev.bind( ad_bindings + numeric_params ) )

try:
    maclev_adap_c = NumericalAdaptiveDynamicsModel( maclev,
        [ indexer_2d_reverse('c')[j] for j in (0,1) ],
        early_bindings=bm_bindings,
        late_bindings=ad_bindings + numeric_params,
        equilibrium_function = find_interior_equilibrium )
    ltx.write( 'adaptive dynamics of $c$:\n' )
    ltx.write_block( maclev_adap_c )

    print 'solve'
    sys.stdout.flush()

    try:
        c_evolution = maclev_adap_c.solve( [ initial_conditions( c ) for c in maclev_adap_c._vars ], end_time=integrate_adapdyn_to, step=integrate_adapdyn_step )

        print 'plot u vs t'
        sys.stdout.flush()

        # and plot u vs t
        t = maclev_adap_c.time_variable()
        u_timeseries = c_evolution.plot( t, u_0 )
        u_timeseries.axes_labels( [ '$t$', '$u$' ] )
        u_timeseries.save( 'maclev-a-only-u-vs-t.png', figsize=(4,4) )
    except AdaptiveDynamicsException, e:
        print( 'AdaptiveDynamicsException: %s' % e )
        print 'Failed to integrate adaptive dynamics'
        sys.stdout.flush()
        ltx.write( e._latex_str or '', r'\\Exception: %s\\' % e )
except AdaptiveDynamicsException, e:
    print( 'AdaptiveDynamicsException: %s' % e )
    print 'Failed to construct adaptive dynamics'
    sys.stdout.flush()
    ltx.write( e._latex_str or '', r'\\Exception: %s\\' % e )

ltx.close()
save_session( 'maclev-a-only-adap' )
try:
    c_evolution
except NameError:
    sys.exit( int(1) )
print 'done'
sys.exit()