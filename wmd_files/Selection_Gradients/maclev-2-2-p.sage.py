# This file was *autogenerated* from the file maclev-2-2-p.sage
from sage.all_cmdline import *   # import sage library
_sage_const_0p1 = RealNumber('0.1'); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_6 = Integer(6); _sage_const_0p05 = RealNumber('0.05')# requires: $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
# requires: maclev_2_2_defs.py maclev-2-2-adap.sobj
# produces: maclev-2-2-p.sage.out.tex
from maclev_2_2_defs import *

load_session( 'maclev-2-2-adap' )

ltx = latex_output( 'maclev-2-2-p.sage.out.tex' )

p_indexers = [ indexer('b'), indexer('m') ] + [ indexer_2d_reverse('c')[j] for j in maclev._rescomp_model._r_indices ]

maclev_p = maclev.bind( numeric_params )
maclev_adap_p = AdaptiveDynamicsModel(
    maclev_p,
    p_indexers,
    equilibrium=Bindings( maclev_p.interior_equilibria()[_sage_const_0 ] ) )

print 'adaptive dynamics of b, m, c:', maclev_adap_p

if False:
    ltx.write('adaptive dynamics of $b$, $m$, $c$:')
    for i in maclev._population_indices:
        ltx.write_block(
            column_vector( [ pi[i] for pi in p_indexers ] ),
            wrap_latex( r'\to' ),
            column_vector( [ maclev_adap_p._S[pi[i]] for pi in p_indexers ] ) )

def make_arrow( base, vec, scale=_sage_const_1 , **args ):
    #print 'arrow: $%s \\to %s%s$' % (latex(base),latex(scale),latex(vec))
    arr = arrow( (base[_sage_const_0 ], base[_sage_const_1 ]), (base[_sage_const_0 ] + scale*vec[_sage_const_0 ], base[_sage_const_1 ] + scale*vec[_sage_const_1 ]), **args )
    #print [ aa for aa in arr ]
    return arr

# plot c_0 vs c_1, with arrows

# first put in the curves in the c_0-c_1 plane
c_phase_plane = Graphics()
for i in maclev._population_indices:
    ci = [ rescomp._indexers['c'][i][_sage_const_0 ], rescomp._indexers['c'][i][_sage_const_1 ] ]
    c_phase_plane += c_evolution.plot( ci[_sage_const_0 ], ci[_sage_const_1 ], color=[ 'blue', 'red' ][i] )
# then add the arrows at intervals of 0.1 time step
last_t = -oo
maclev_bindings = ad_bindings + numeric_params
for p in c_evolution._timeseries:
    pp = Bindings(p)
    t = N( pp( c_evolution._system._time_variable ) )
    if t >= last_t + _sage_const_0p1 :
        last_t = t
        dudt = maclev_adap_c._bindings( column_vector( maclev_adap_c.compute_flow(
            [ pp( ui ) for ui in maclev_adap_c._vars ],
            t ) ) )
        eq = maclev_adap_c.equilibrium_function( pp )
        for i in maclev._population_indices:
            ci = [ rescomp._indexers['c'][i][_sage_const_0 ], rescomp._indexers['c'][i][_sage_const_1 ] ]
            # the vector S(c)
            c_phase_plane += make_arrow(
                [ pp( maclev_bindings( eq( cij ) ) ) for cij in ci ],
                [ pp( maclev_bindings( eq( maclev_adap_p._S[ cij ] ) ) ) for cij in ci ],
                _sage_const_0p05 , color=[ 'blue', 'red' ][i] )
            # the vector dc/dt
            dci = [ diff( ad_bindings( cij ), u_indexer[i] ) for cij in ci ]
            #print dudt, dci
            #print [ pp( dcij * dudt[i] ) for dcij in dci ]
            c_phase_plane += make_arrow(
                [ pp( ad_bindings( cij ) ) for cij in ci ],
                [ pp( dcij * dudt[i] ) for dcij in dci ],
                _sage_const_0p05 , color='green' )

c_phase_plane.axes_labels( [ '$c_0$', '$c_1$' ] )
c_phase_plane.save( 'maclev-2-2-c-vs-c.png', figsize=(_sage_const_6 ,_sage_const_6 ) )

ltx.close()
save_session( 'maclev-2-2-p' )
