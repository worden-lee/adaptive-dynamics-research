# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
# requires: maclev-2-2-c-popdyn.sobj maclev_2_2_defs.py
# produces: maclev-2-2-c-adap.sage.out.tex maclev-2-2-c-adap.sobj
from maclev_2_2_defs import *

load_session( 'maclev-2-2-c-popdyn' )

ltx = latex_output( 'maclev-2-2-c-adap.sage.out.tex' )

#ltx.write_block( maclev )

#ltx.write( 'and with the functional and numeric bindings: ' )
ltx.write_block( maclev.bind( ad_bindings + numeric_params ) )

try:
    maclev_adap_c = NumericalAdaptiveDynamicsModel( maclev,
        [ indexer_2d_reverse('c')[j] for j in (0,1) ],
        late_bindings = ad_bindings + numeric_params,
        equilibrium_function = find_interior_equilibrium )
    ltx.write( 'adaptive dynamics of $c$ in that model:' )
    ltx.write_block( maclev_adap_c )
    print maclev_adap_c

    print '(bindings: ', ad_bindings + numeric_params, ')'

    #print ( 'find adaptive dynamics equilibria' )
    #sys.stdout.flush()

    #ltx.write( 'equilibria:' )
    #adap_equilibria = maclev_adap_c.equilibria( ranges={ u_0:(0.1,0.4,0.6,0.9), u_1:(0.1,0.4,0.6,0.9) } )
    #for eq in adap_equilibria:
    #    ltx.write_block( eq )

    print 'solve'
    sys.stdout.flush()

    try:
        c_evolution = maclev_adap_c.solve( [0] + [ initial_conditions( c ) for c in maclev_adap_c._vars ], end_points=integrate_adapdyn_to, step=integrate_adapdyn_step )
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
save_session( 'maclev-2-2-c-adap' )
try:
    c_evolution
except NameError:
    sys.exit( int(1) )
print 'done'
sys.exit()
