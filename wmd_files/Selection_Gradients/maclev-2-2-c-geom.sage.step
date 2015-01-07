# requires: $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py 
# requires: lotkavolterra.py
# requires: maclev_2_2_defs.py maclev-2-2-c-adap.sobj
# produces: maclev-2-2-c-geom.sage.out.tex
# produces: maclev-2-2-c-k-vs-t.png maclev-2-2-c-a-vs-t.png
# produces: maclev-2-2-c-Xhat-vs-t.png maclev-2-2-c-Rhat-vs-t.png
# produces: maclev-2-2-c-a-vs-a.png
# produces: maclev-2-2-c-a-vs-k.png maclev-2-2-c-a-arrows.png
from maclev_2_2_defs import *
from lotkavolterra import *

load_session( 'maclev-2-2-c-adap' )

ltx = latex_output( 'maclev-2-2-c-geom.sage.out.tex' )

# I don't trust FunctionBindings any more, but I need to use it briefly
# to get tractable adaptive dynamics here.
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

lv_adap_c = LotkaVolterraAdaptiveDynamics( maclev_adap_c, r_name='k' )

class SeriesOfBindings( Bindings ):
    def __init__( self, *args ):
        # this list of bindings will be applied from right to left
        self._series = args
    def substitute( self, expr ):
        return self.substitute_list( self._series, expr )
    def substitute_list( self, series, expr ):
        if not series: return expr
        return series[0]( self.substitute_list( series[1:], expr ) )
    def _latex_(self):
        from operator import add
        return reduce( add, map( latex, self._series ) )

A_to_u_bindings = SeriesOfBindings(
    bm_bindings + numeric_params + ad_bindings
        + lv_adap_c._lv_model._A_bindings
        + lv_adap_c._adaptivedynamics._late_bindings
        + lv_adap_c._lv_model.interior_equilibrium_bindings(),
    lv_adap_c._phenotypes_from_fn_bindings,
    lv_adap_c.dudt_bindings(),
    lv_adap_c._phenotypes_to_fn_bindings )

print 'printing things in LaTeX'
sys.stdout.flush()

#ltx.write( 'A\_to\_u\_bindings is ' + latex( A_to_u_bindings ) )

ltx.write_equality( SR('A(0)'), lv_adap_c.A(0), A_to_u_bindings( lv_adap_c.A(0) ) )
ltx.write_equality( SR('A(1)'), lv_adap_c.A(1), A_to_u_bindings( lv_adap_c.A(1) ) )
ltx.write_equality( SR('S(A(0))'), lv_adap_c.S( lv_adap_c.A(0) ), lv_adap_c._lv_model.interior_equilibrium_bindings()( lv_adap_c.S( lv_adap_c.A(0) ) ) )
ltx.write_equality( SR('S(A(1))'), lv_adap_c.S( lv_adap_c.A(1) ), lv_adap_c._lv_model.interior_equilibrium_bindings()( lv_adap_c.S( lv_adap_c.A(1) ) ) ) 

ltx.write_equality( wrap_latex( 'D(u_0)' ), lv_adap_c.direct_effect(0)
    #, A_to_u_bindings( lv_adap_c.direct_effect(0) )
)
ltx._output.flush()
ltx.write_equality( wrap_latex( 'I(u_0)' ), lv_adap_c.indirect_effect(0)
    #, A_to_u_bindings( lv_adap_c.indirect_effect(0) )
)
ltx._output.flush()
ltx.write_equality( wrap_latex( r'\frac{dA}{dt}' ), lv_adap_c.dAdt(0)
    #, A_to_u_bindings( lv_adap_c.dAdt(0) )
)
ltx._output.flush()

t = maclev_adap_c._time_variable

print 'plot k vs. t'
sys.stdout.flush()

# plot k values vs. time
k_timeseries = Graphics();
for i in (0, 1):
    print ( str( lv_adap_c._lv_model._indexers['r'][i] ) + ': ' +
        str( A_to_u_bindings( lv_adap_c._lv_model._A_bindings( lv_adap_c._lv_model._indexers['r'][i] ) ) ) )
    k_timeseries += c_evolution.plot( t,
        A_to_u_bindings( lv_adap_c._lv_model._A_bindings( lv_adap_c._lv_model._indexers['r'][i] ) ),
        color=[ 'blue', 'red' ][i], figsize=(4,4) )
k_timeseries.axes_labels( [ '$t$', '$k(\cdot)$' ] )
k_timeseries.save( 'maclev-2-2-c-k-vs-t.png' )

print 'plot a vs. t'
sys.stdout.flush()

# plot interactions vs. time in Xmas colors
a_timeseries = Graphics()
for i in (0, 1):
    for j in (0, 1):
        a_timeseries += c_evolution.plot( t,
            A_to_u_bindings( lv_adap_c._lv_model._A_bindings( lv_adap_c._lv_model._indexers['a'][i][j] ) ), 
            color=(i == j and 'red' or 'lime'), figsize=(4,4) )
a_timeseries.axes_labels( [ '$t$', '$a(\cdot,\cdot)$' ] )
a_timeseries.save( 'maclev-2-2-c-a-vs-t.png' )

print 'plot X vs. t'
sys.stdout.flush()

# population size vs time
X_timeseries = Graphics()
for i in (0, 1):
    #print ( str( hat( lv_adap_c._lv_model._population_indexer[i] ) ) + ': ' +
        #str( A_to_u_bindings( lv_adap_c._lv_model.interior_equilibrium_bindings()( hat( lv_adap_c._lv_model._population_indexer[i] ) ) ) ) )
    X_timeseries += c_evolution.plot( t,
        A_to_u_bindings( lv_adap_c._lv_model.interior_equilibrium_bindings()( hat( lv_adap_c._lv_model._population_indexer[i] ) ) ),
        color=[ 'blue', 'red' ][i], figsize=(4,4) )
X_timeseries.axes_labels( [ '$t$', '$\hat{X}$' ] )
X_timeseries.save( 'maclev-2-2-c-Xhat-vs-t.png' )

print 'plot R vs. t'
sys.stdout.flush()

# population size vs time
R_timeseries = Graphics()
for i in (0, 1):
    ri = A_to_u_bindings( Bindings( { X_0: hat(X_0), X_1: hat(X_1) } )( maclev._bindings( SR('R_%s'%i) ) ) )
    #print ri
    #print Bindings( c_evolution._timeseries[0] )( ri )
    sys.stdout.flush()
    R_timeseries += c_evolution.plot( t, ri,
        color=[ 'blue', 'red' ][i], figsize=(4,4) )
R_timeseries.axes_labels( [ '$t$', '$\hat{R}$' ] )
R_timeseries.save( 'maclev-2-2-c-Rhat-vs-t.png' )

print 'plot a vs. a'
sys.stdout.flush()

# plot interactions in A space
a_phase_plane = Graphics()
#from sage.plot.plot3d.base import Graphics3d
#a_3d = Graphics3d()
for i in (0, 1):
    a_phase_plane += c_evolution.plot(
        A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][0] ),
        A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][1] ),
        color=[ 'blue', 'red' ][i] )
    #a_3d += c_evolution.plot3d(
        #A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][0] ),
        #A_to_u_bindings( lv_adap_c._lv_model._indexers['a'][i][1] ),
        #A_to_u_bindings( lv_adap_c._lv_model._indexers['r'][i] ),
        #color=[ 'blue', 'red' ][i] )
a_phase_plane.axes_labels( [ '$a(u_0,\cdot)$', '$a(u_1,\cdot)$' ] )
a_phase_plane.save( 'maclev-2-2-c-a-vs-a.png', figsize=(4,4), xmax=0, ymax=0 )
##a_3d.axes_labels( [ '$a(u_0,u)$', '$a(u_1,u)$', '$k(u)' ] )
#a_3d.save( 'maclev-2-2-c-a-vs-k.png' )

print 'plot a vs. a with arrows'
sys.stdout.flush()

def a_arrow( base, vec, scale=1, **args ):
    #ltx.write( 'arrow: $%s \\to %s%s$\n\n' % (latex(base),latex(scale),latex(vec)) )
    return arrow( (base[1], base[2]), (base[1] + scale*vec[1], base[2] + scale*vec[2]), **args )

a_phase_plane_annotated = a_phase_plane

#A01 = A_to_u_bindings( lv_adap_c.A(0) )[2] # a(u_0, u_1)
#import numpy
#grid_range = numpy.arange(0,1.01,0.1)
#for u_val in grid_range:
    # hold u_1=u_val and vary u_0
    #a_phase_plane_annotated += parametric_plot(
    #    ( Bindings( { u_1:u_0 } )(A01),                # a(u_0,u_0)
    #      Bindings( { u_1:u_0 } )( Bindings( { u_0:u_val } )(A01) ) ), # a(u_1,u_0)
    #    (u_0,0,1), color=hue( 0, 0, 0.8 ) )
    #a_phase_plane_annotated += parametric_plot(
    #    ( Bindings( { u_1:u_val } )(A01),              # a(u_0,u_1)
    #      Bindings( { u_0:u_val, u_1:u_val } )(A01) ), # a(u_1,u_1)
    #    (u_0,0,1), color=hue( 0, 0, 0.8 ) )
    # hold u_0=u_val and vary u_1
    #a_phase_plane_annotated += parametric_plot(
    #    ( Bindings( { u_0:u_val, u_1:u_val } )(A01),   # a(u_0,u_0)
    #      Bindings( { u_0:u_1 } )( Bindings( { u_1:u_val } )(A01) ) ), # a(u_1,u_0)
    #    (u_1,0,1), color=hue( 0, 0, 0.8 ) )
    #a_phase_plane_annotated += parametric_plot(
    #    ( Bindings( { u_0:u_val } )(A01),              # a(u_0,u_1)
    #      Bindings( { u_0:u_1 } )(A01) ),              # a(u_1,u_1)
    #    (u_1,0,1), color=hue( 0, 0, 0.8 ) )

last_t = -oo
scale = 1/12
vectors = dict()
for p in c_evolution._timeseries:
    next_t = p[t]
    pp = Bindings( p )
    if next_t >= last_t + 0.1:
        last_t = next_t
        for i in (0,1):
            if not i in vectors:
                vectors[i] = ( A_to_u_bindings( lv_adap_c.A(i) ),
                    A_to_u_bindings( lv_adap_c.S(lv_adap_c.A(i)) ),
                    A_to_u_bindings( lv_adap_c.direct_effect(i) ),
                    A_to_u_bindings( lv_adap_c.indirect_effect(i) ),
                    A_to_u_bindings( lv_adap_c.dAdt(i) ) )
            (Ai, SAi, Di, Ii, dAdti) = vectors[i]
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
a_phase_plane_annotated.save( 'maclev-2-2-c-a-arrows.png', figsize=(8,8)
    #, xmin=-0.6, xmax=-0.3, ymin=-0.6, ymax=-0.3
    , xmax=0, ymax=0
)

#stop there for now
ltx.close()
save_session('maclev-2-2-c-geom')
sys.exit()

ltx.close()
