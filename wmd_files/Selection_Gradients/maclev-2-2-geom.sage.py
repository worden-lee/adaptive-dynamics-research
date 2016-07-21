# This file was *autogenerated* from the file maclev-2-2-geom.sage
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_4 = Integer(4); _sage_const_8 = Integer(8); _sage_const_0p1 = RealNumber('0.1'); _sage_const_12 = Integer(12); _sage_const_1p01 = RealNumber('1.01'); _sage_const_0p8 = RealNumber('0.8')# requires: $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
# requires: lotkavolterra.py
# requires: maclev_2_2_defs.py maclev-2-2-adap.sobj
# produces: maclev-2-2-geom.sage.out.tex
# produces: maclev-2-2-k-vs-t.png maclev-2-2-a-vs-t.png
# produces: maclev-2-2-Xhat-vs-t.png maclev-2-2-Rhat-vs-t.png
# produces: maclev-2-2-a-vs-a.png
# produces: maclev-2-2-a-vs-k.png maclev-2-2-a-arrows.png
from maclev_2_2_defs import *
from lotkavolterra import *

load_session( 'maclev-2-2-adap' )

ltx = latex_output( 'maclev-2-2-geom.sage.out.tex' )

# I don't trust FunctionBindings any more, but I need to use it briefly
# to get tractable adaptive dynamics here.
bmc_to_fn_bindings = Bindings( dict(
    [ ( maclev._rescomp_model._indexers['c'][i][j],
        function( 'c_%s'%j )( u_indexer[i] ) )
      for i in (_sage_const_0 ,_sage_const_1 ,'i') for j in (_sage_const_0 ,_sage_const_1 ) ] +
    [ ( maclev._rescomp_model._indexers['b'][i], function('b')( u_indexer[i] ) ) for i in (_sage_const_0 ,_sage_const_1 ,'i') ] +
    [ ( maclev._rescomp_model._indexers['m'][i], function('m')( u_indexer[i] ) ) for i in (_sage_const_0 ,_sage_const_1 ,'i') ]
    ) )
bmc_from_fn_bindings = Bindings( FunctionBindings( dict(
    [ ( function( 'c_%s'%j ), c_func(_sage_const_0 ,j).function( u_indexer[_sage_const_0 ] ) )
        for j in (_sage_const_0 ,_sage_const_1 ) ] +
    [ ( function( 'b' ), SR(_sage_const_1 ) ), ( function('m'), SR(_sage_const_1 ) ) ]
    ) ) )

lv_adap_c = LotkaVolterraAdaptiveDynamics( maclev_adap_c, r_name='k' )

class SeriesOfBindings( Bindings ):
    def __init__( self, *args ):
        # this list of bindings will be applied from right to left
        self._series = args
    def substitute( self, expr ):
        return self.substitute_list( self._series, expr )
    def substitute_list( self, series, expr ):
        if not series: return expr
        return series[_sage_const_0 ]( self.substitute_list( series[_sage_const_1 :], expr ) )
    def _latex_(self):
        from operator import add
        return reduce( add, map( latex, self._series ) )
    def __repr__(self):
	from operator import add
	return reduce( add, map( repr, self._series ) )

A_to_c_bindings = (bm_bindings + numeric_params + gamma_bindings
        + lv_adap_c._lv_model._A_bindings
        + lv_adap_c._adaptivedynamics._late_bindings
        + lv_adap_c._lv_model.interior_equilibrium_bindings())

A_to_u_bindings = SeriesOfBindings(
    A_to_c_bindings + c_bindings,
    lv_adap_c._phenotypes_from_fn_bindings,
    lv_adap_c.dudt_bindings(),
    lv_adap_c._phenotypes_to_fn_bindings )

print 'printing things in LaTeX'
sys.stdout.flush()

#ltx.write( 'A\_to\_u\_bindings is ' + latex( A_to_u_bindings ) )

ltx.write_equality( SR('A(0)'), lv_adap_c.A(_sage_const_0 ).column(), A_to_c_bindings( lv_adap_c.A(_sage_const_0 ).column() ) )
ltx.write_equality( SR('A(1)'), lv_adap_c.A(_sage_const_1 ).column(), A_to_c_bindings( lv_adap_c.A(_sage_const_1 ).column() ) )
ltx.write_equality( SR('S(A(0))'), lv_adap_c.S( lv_adap_c.A(_sage_const_0 ) ).column(), lv_adap_c._lv_model.interior_equilibrium_bindings()( lv_adap_c.S( lv_adap_c.A(_sage_const_0 ) ) ).column() )
ltx.write_equality( SR('S(A(1))'), lv_adap_c.S( lv_adap_c.A(_sage_const_1 ) ).column(), lv_adap_c._lv_model.interior_equilibrium_bindings()( lv_adap_c.S( lv_adap_c.A(_sage_const_1 ) ) ).column() ) 

ltx.write_equality( wrap_latex( 'D(u_0)' ), lv_adap_c.direct_effect(_sage_const_0 ).column()
    #, A_to_u_bindings( lv_adap_c.direct_effect(0) )
)
ltx._output.flush()
ltx.write_equality( wrap_latex( 'I(u_0)' ), lv_adap_c.indirect_effect(_sage_const_0 ).column()
    #, A_to_u_bindings( lv_adap_c.indirect_effect(0) )
)
ltx._output.flush()
ltx.write_equality( wrap_latex( r'\frac{dA}{dt}' ), lv_adap_c.dAdt(_sage_const_0 ).column()
    #, A_to_u_bindings( lv_adap_c.dAdt(0) )
)
ltx._output.flush()

print 'plot k vs. t'
sys.stdout.flush()

# plot k values vs. time
k_timeseries = Graphics();
for i in (_sage_const_0 , _sage_const_1 ):
    #print ( str( lv_adap_c._lv_model._indexers['r'][i] ) + ': ' +
        #str( A_to_u_bindings( lv_adap_c._lv_model._A_bindings( lv_adap_c._lv_model._indexers['r'][i] ) ) ) )
    k_timeseries += c_evolution.plot( t,
        A_to_u_bindings( lv_adap_c._lv_model._A_bindings( lv_adap_c._lv_model._indexers['r'][i] ) ),
        color=[ 'blue', 'red' ][i], figsize=(_sage_const_4 ,_sage_const_4 ) )
k_timeseries.axes_labels( [ '$t$', '$k(\cdot)$' ] )
k_timeseries.save( 'maclev-2-2-k-vs-t.png' )

print 'plot a vs. t'
sys.stdout.flush()

# plot interactions vs. time in Xmas colors
a_timeseries = Graphics()
for i in (_sage_const_0 , _sage_const_1 ):
    for j in (_sage_const_0 , _sage_const_1 ):
        a_timeseries += c_evolution.plot( t,
            A_to_u_bindings( lv_adap_c._lv_model._A_bindings( lv_adap_c._lv_model._indexers['a'][i][j] ) ), 
            color=(i == j and 'red' or 'lime'), figsize=(_sage_const_4 ,_sage_const_4 ) )
a_timeseries.axes_labels( [ '$t$', '$a(\cdot,\cdot)$' ] )
a_timeseries.save( 'maclev-2-2-a-vs-t.png' )

print 'plot X vs. t'
sys.stdout.flush()

# population size vs time
X_timeseries = Graphics()
for i in (_sage_const_0 , _sage_const_1 ):
    #print ( str( hat( lv_adap_c._lv_model._population_indexer[i] ) ) + ': ' +
        #str( A_to_u_bindings( lv_adap_c._lv_model.interior_equilibrium_bindings()( hat( lv_adap_c._lv_model._population_indexer[i] ) ) ) ) )
    X_timeseries += c_evolution.plot( t,
        A_to_u_bindings( lv_adap_c._lv_model.interior_equilibrium_bindings()( hat( lv_adap_c._lv_model._population_indexer[i] ) ) ),
        color=[ 'blue', 'red' ][i], figsize=(_sage_const_4 ,_sage_const_4 ) )
X_timeseries.axes_labels( [ '$t$', '$\hat{X}$' ] )
X_timeseries.save( 'maclev-2-2-Xhat-vs-t.png' )

print 'plot R vs. t'
sys.stdout.flush()

# population size vs time
R_timeseries = Graphics()
for i in (_sage_const_0 , _sage_const_1 ):
    ri = A_to_u_bindings( Bindings( { X_0: hat(X_0), X_1: hat(X_1) } )( maclev._bindings( SR('R_%s'%i) ) ) )
    #print ri
    #print Bindings( c_evolution._timeseries[0] )( ri )
    sys.stdout.flush()
    R_timeseries += c_evolution.plot( t, ri,
        color=[ 'blue', 'red' ][i], figsize=(_sage_const_4 ,_sage_const_4 ) )
R_timeseries.axes_labels( [ '$t$', '$\hat{R}$' ] )
R_timeseries.save( 'maclev-2-2-Rhat-vs-t.png' )

print 'plot a vs. a'
sys.stdout.flush()

# plot interactions in A space
a_phase_plane = Graphics()
#from sage.plot.plot3d.base import Graphics3d
#a_3d = Graphics3d()
for i in (_sage_const_0 , _sage_const_1 ):
    a_phase_plane += c_evolution.plot(
        A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][_sage_const_0 ] ),
        A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][_sage_const_1 ] ),
        color=[ 'blue', 'red' ][i] )
    #a_3d += c_evolution.plot3d(
        #A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][0] ),
        #A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][1] ),
        #A_to_u_bindings( lv_adap_c._lv_model._indexers['r'][i] ),
        #color=[ 'blue', 'red' ][i] )
a_phase_plane.axes_labels( [ '$a(u_0,\cdot)$', '$a(u_1,\cdot)$' ] )
a_phase_plane.save( 'maclev-2-2-a-vs-a.png', figsize=(_sage_const_4 ,_sage_const_4 ), xmax=_sage_const_0 , ymax=_sage_const_0  )
##a_3d.axes_labels( [ '$a(u_0,u)$', '$a(u_1,u)$', '$k(u)' ] )
#a_3d.save( 'maclev-2-2-a-vs-k.png' )

print 'plot a vs. a with arrows'
sys.stdout.flush()

def a_arrow( base, vec, scale=_sage_const_1 , **args ):
    #ltx.write( 'arrow: $%s \\to %s%s$\n\n' % (latex(base),latex(scale),latex(vec)) )
    return arrow( (base[_sage_const_1 ], base[_sage_const_2 ]), (base[_sage_const_1 ] + scale*vec[_sage_const_1 ], base[_sage_const_2 ] + scale*vec[_sage_const_2 ]), **args )

a_phase_plane_annotated = a_phase_plane

A01 = A_to_u_bindings( lv_adap_c.A(_sage_const_0 ) )[_sage_const_2 ] # a(u_0, u_1)
import numpy
grid_range = numpy.arange(_sage_const_0 ,_sage_const_1p01 ,_sage_const_0p1 )
for u_val in grid_range:
    # hold u_1=u_val and vary u_0
    a_phase_plane_annotated += parametric_plot(
        ( Bindings( { u_1:u_0 } )(A01),                # a(u_0,u_0)
          Bindings( { u_1:u_0 } )( Bindings( { u_0:u_val } )(A01) ) ), # a(u_1,u_0)
        (u_0,_sage_const_0 ,_sage_const_1 ), color=hue( _sage_const_0 , _sage_const_0 , _sage_const_0p8  ) )
    a_phase_plane_annotated += parametric_plot(
        ( Bindings( { u_1:u_val } )(A01),              # a(u_0,u_1)
          Bindings( { u_0:u_val, u_1:u_val } )(A01) ), # a(u_1,u_1)
        (u_0,_sage_const_0 ,_sage_const_1 ), color=hue( _sage_const_0 , _sage_const_0 , _sage_const_0p8  ) )
    # hold u_0=u_val and vary u_1
    a_phase_plane_annotated += parametric_plot(
        ( Bindings( { u_0:u_val, u_1:u_val } )(A01),   # a(u_0,u_0)
          Bindings( { u_0:u_1 } )( Bindings( { u_1:u_val } )(A01) ) ), # a(u_1,u_0)
        (u_1,_sage_const_0 ,_sage_const_1 ), color=hue( _sage_const_0 , _sage_const_0 , _sage_const_0p8  ) )
    a_phase_plane_annotated += parametric_plot(
        ( Bindings( { u_0:u_val } )(A01),              # a(u_0,u_1)
          Bindings( { u_0:u_1 } )(A01) ),              # a(u_1,u_1)
        (u_1,_sage_const_0 ,_sage_const_1 ), color=hue( _sage_const_0 , _sage_const_0 , _sage_const_0p8  ) )

last_t = -oo
scale = _sage_const_1 /_sage_const_12 
vectors = dict()
for p in c_evolution._timeseries:
    next_t = N(p[t]) # why need N()?
    pp = Bindings( p )
    #print next_t, '>=?', last_t + 0.1, ':', (next_t >= last_t + 0.1)
    if next_t >= last_t + _sage_const_0p1 :
        last_t = next_t
        for i in (_sage_const_0 ,_sage_const_1 ):
            if not i in vectors:
                vectors[i] = ( A_to_u_bindings( lv_adap_c.A(i) ),
                    A_to_u_bindings( lv_adap_c.S(lv_adap_c.A(i)) ),
                    A_to_u_bindings( lv_adap_c.direct_effect(i) ),
                    A_to_u_bindings( lv_adap_c.indirect_effect(i) ),
                    A_to_u_bindings( lv_adap_c.dAdt(i) ) )
            (Ai, SAi, Di, Ii, dAdti) = vectors[i]
	    #print '(Ai, SAi, Di, Ii, dAdti) =', vectors[i]
            # check equality
            #print ( '$D(%s) + I(%s) = %s \\overset{?}{=} \\frac{dA(u)}{du} = %s$\n\n' % (
            #        latex(i), latex(i), latex(
            #          pp( A_to_u_bindings( Di ) ) +
            #          pp( A_to_u_bindings( Ii ) )
            #        ), latex(
            #          pp( A_to_u_bindings( dAdti ) )
            #        ) ) )
            S_A_arrow = a_arrow(
                pp( Ai ),
                pp( SAi ),
                scale=scale, color='red' )
            D_arrow = a_arrow(
                pp( Ai ),
                pp( Di ),
                scale=scale, color='green' )
            I_arrow = a_arrow(
                pp( Ai + Di.apply_map( lambda x:x*scale ) ),
                pp( Ii ),
                scale=scale, color='purple' )
            dA_du_arrow = a_arrow(
                pp( Ai ),
                pp( dAdti ),
                scale=scale, color='blue' )
            a_phase_plane_annotated += S_A_arrow + D_arrow + I_arrow + dA_du_arrow

a_phase_plane_annotated.axes_labels( [ '$a(u_0,\cdot)$', '$a(u_1,\cdot)$' ] )
a_phase_plane_annotated.save( 'maclev-2-2-a-arrows.png', figsize=(_sage_const_8 ,_sage_const_8 )
    #, xmin=-0.6, xmax=-0.3, ymin=-0.6, ymax=-0.3
    , xmax=_sage_const_0 , ymax=_sage_const_0 
)

#stop there for now
ltx.close()
save_session('maclev-2-2-geom')
sys.exit()

#ltx.close() 