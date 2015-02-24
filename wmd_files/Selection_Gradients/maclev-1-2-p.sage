# requires: $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
# requires: maclev_1_2_defs.py maclev-1-2-adap.sobj
# produces: maclev-1-2-p.sage.out.tex maclev-1-2-c-vs-t.png
# produces: maclev-1-2-c-vs-c.png maclev-1-2-total-c-vs-u.png
from maclev_1_2_defs import *

load_session( 'maclev-1-2-adap' )

ltx = latex_output( 'maclev-1-2-p.sage.out.tex' )

p_indexers = [ indexer('b'), indexer('m') ] + [ indexer_2d_reverse('c')[j] for j in maclev._rescomp_model._r_indices ]

maclev_p = maclev.bind( numeric_params )
maclev_adap_p = AdaptiveDynamicsModel(
    maclev_p,
    p_indexers,
    equilibrium=Bindings( maclev_p.interior_equilibria()[0] ) )

print 'adaptive dynamics of b, m, c:', maclev_adap_p

if True:
    ltx.write('adaptive dynamics of $b$, $m$, $c$:')
    for i in maclev._population_indices:
        ltx.write_block(
            column_vector( [ pi[i] for pi in p_indexers ] ),
            wrap_latex( r'\to' ),
            maclev_p._bindings( column_vector( [ maclev_adap_p._S[pi[i]] for pi in p_indexers ] ) ) )
    ltx.write( 'and note\n' )
    rhats = column_vector( [ hat( maclev_p._rescomp_model._indexers['R'][i] ) for i in maclev_p._rescomp_model._r_indices ] )
    ltx.write_equality( rhats, maclev_p._bindings( rhats ) )
    ltx.write( 'so that when $b_0=b_1=1$, $S(\mathbf{c}_0)=S(\mathbf{c}_1)=\hat{\mathbf{R}}$.\n\n' )
    ltx.write( '(Also, ' ) 
    #xhats = column_vector( maclev_p.equilibrium_vars() )
    #ltx.write_equality( xhats, maclev_adap_p._equilibrium( xhats ) )
    ltx.write( 'the selection gradient on $b_i$ is directly from the '
        '$\\frac{dX_i}{dt}$ equation, and can be seen to be equal to 0.)\n' )

def make_arrow( base, vec, scale=1, **args ):
    #print 'arrow: $%s \\to %s%s$' % (latex(base),latex(scale),latex(vec))
    arr = arrow( (base[0], base[1]), (base[0] + scale*vec[0], base[1] + scale*vec[1]), **args )
    #print [ aa for aa in arr ]
    return arr

print 'plot c vs t'
sys.stdout.flush()

c_timeseries = Graphics()
c = rescomp._indexers['c']
for i in maclev_adap_c._popdyn_model._population_indices:
    c_timeseries += c_evolution.plot( 't', c[i][0], color=[ 'blue', 'red' ][i] )
    c_timeseries += c_evolution.plot( 't', c[i][1], color=[ 'blue', 'red' ][i] )

c_timeseries.axes_labels( [ '$t$', '$c$' ] )
c_timeseries.save( 'maclev-1-2-c-vs-t.png', figsize=(4,4) )

# plot c_1 vs c_0, with arrows

print 'plot c vs c'
sys.stdout.flush()

# first put in the curves in the c_0-c_1 plane
c_phase_plane = Graphics()
c_phase_plane += parametric_plot( (c_func( 0, 0 ), c_func( 0, 1 )), (u_0, 0, 1), color='gray' )
for i in maclev_adap_c._popdyn_model._population_indices:
    c_phase_plane += c_evolution.plot( c[i][0], c[i][1], color=[ 'blue', 'red' ][i] )

print 'with arrows'
sys.stdout.flush()

# then add the arrows at intervals of 0.1 time step
last_t = -oo
maclev_bindings = ad_bindings + numeric_params
for p in c_evolution._timeseries:
    pp = Bindings(p)
    t = N( pp( c_evolution._system._time_variable ) )
    if t >= last_t + 0.1:
        last_t = t
	try:
            dudt = maclev_adap_c._bindings( column_vector( maclev_adap_c.compute_flow(
                [ N( pp( ui ) ) for ui in maclev_adap_c._vars ],
                t ) ) )
            eq = maclev_adap_c.equilibrium_function( pp )
            for i in maclev._population_indices:
                ci = [ rescomp._indexers['c'][i][0], rescomp._indexers['c'][i][1] ]
                # the vector S(c)
                c_phase_plane += make_arrow(
                    [ pp( maclev_bindings( eq( cij ) ) ) for cij in ci ],
                    [ pp( maclev_bindings( eq( maclev_adap_p._S[ cij ] ) ) ) for cij in ci ],
                    0.05, color=[ 'blue', 'red' ][i] )
                # the vector dc/dt
                dci = [ diff( ad_bindings( cij ), u_indexer[i] ) for cij in ci ]
                #print dudt, dci
                #print [ pp( dcij * dudt[i] ) for dcij in dci ]
                c_phase_plane += make_arrow(
                    [ pp( ad_bindings( cij ) ) for cij in ci ],
                    [ pp( dcij * dudt[i] ) for dcij in dci ],
                    0.05, color='green' )
        except TypeError: pass

c_phase_plane.axes_labels( [ '$c_0$', '$c_1$' ] )
c_phase_plane.save( 'maclev-1-2-c-vs-c.png', figsize=(4,4) )

print 'plot total c vs u' 
sys.stdout.flush()

c_curve = plot( c_func( 0, 0 ) + c_func( 0, 1 ), (u_0, 0, 1) )
c_curve += point( initial_conditions( vector( [ u_0, c_func( 0, 0 ) + c_func( 0, 1 ) ] ) ), color='blue', size=30 )
c_curve.axes_labels( [ '$u$', '$c_0(u) + c_1(u)$' ] )
c_curve.save( 'maclev-1-2-total-c-vs-u.png', figsize=(4,4), ymin=0 )

ltx.close()
save_session( 'maclev-1-2-p' )
