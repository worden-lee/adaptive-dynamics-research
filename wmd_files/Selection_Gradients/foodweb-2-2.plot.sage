# requires: foodweb-2-2.sobj
# produces: foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png
# produces: foodweb-2-2-a-vs-a.png foodweb-2-2-a-vs-t.png
# produces: foodweb-2-2-x-vs-t.png
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import foodweb
import dynamicalsystems
import lotkavolterra

load_session("foodweb-2-2")

ltx = dynamicalsystems.latex_output( 'foodweb-2-2.plot.sage.out.tex' )

# doesn't pickle?
sym_lv = lotkavolterra.LotkaVolterraAdaptiveDynamics( foodweb_adap,
	r_name_indexer=foodweb.vertex_indexer('r'),
        a_name_indexer=foodweb.vertex_indexer_2d('a') )

x0 = dynamicalsystems.hat( sym_lv._lv_model._vars[0] )
x1 = dynamicalsystems.hat( sym_lv._lv_model._vars[1] )
i0 = sym_lv._lv_model._population_indices[0] 
i1 = sym_lv._lv_model._population_indices[1] 
from sage.symbolic.function_factory import function

def expand_vector( v ): return vector( [ expand(x) for x in v ] )

ltx.write_equality_aligned(
    function('A')( x0, x1 ),
    #sym_lv.A_pair( i0, i1 ),
    sym_lv.dudt_bindings()( sym_lv.A_pair( i0, i1 ) )
)

ltx.write_equality_aligned(
    function('S')( x0, x1 ),
    #sym_lv.S_pair( i0, i1 ),
    sym_lv.dudt_bindings()( sym_lv.S_pair( i0, i1 ) )
)

ltx.write_equality_aligned(
    function('D')( x0, x1 ),
    sym_lv.D_pair( i0, i1 ),
    expand_vector( sym_lv.dudt_bindings()( sym_lv.D_pair( i0, i1 ) ) )
)

ltx.write_equality_aligned(
    function('I')( x0, x1 ),
    sym_lv.I_pair( i0, i1 ),
    expand_vector( sym_lv.dudt_bindings()( sym_lv.I_pair( i0, i1 ) ) )
)

ltx.write_equality_aligned(
    function('dAdt', latex_name=r'\frac{dA}{dt}')( x0, x1 ),
    sym_lv.dAdt_pair( i0, i1 ),
    expand_vector( sym_lv.dudt_bindings()( sym_lv.dAdt_pair( i0, i1 ) ) )
)

ppp = Graphics()
for v, c in zip( fb_adap._vars, ['blue', 'red', 'purple', 'orange'] ):
    ppp += traj_2_2.plot( 't', v, color=c )
ppp.save( 'foodweb-2-2-adap.png', figsize=(5,5) )

xs = fb_adap._popdyn_model.equilibrium_vars()
ppx = Graphics()
for xhat, c in zip(xs, ['blue', 'red', 'purple', 'orange']):
    ppx += traj_2_2.plot( 't', xhat, legend_label='$%s$'%latex(xhat), color=c )
ppx.save( 'foodweb-2-2-x-vs-t.png', figsize=(5,5) )

flv = lotkavolterra.LotkaVolterraAdaptiveDynamics( fb_adap,
	r_name_indexer=foodweb.vertex_indexer('r'),
        a_name_indexer=foodweb.vertex_indexer_2d('a') )

atp = Graphics()
for i in fb_adap._popdyn_model._population_indices:
    for j in fb_adap._popdyn_model._population_indices:
	atp += traj_2_2.plot( 't', flv._lv_model._A_bindings( flv._lv_model._a_indexer[i][j] ),
	    color = (i == j and 'red' or 'green') )
atp.save( 'foodweb-2-2-a-vs-t.png', figsize=(5,5) )

lotkavolterra.plot_aij_with_arrows( traj_2_2, flv, 'foodweb-2-2-a-vs-a.png' )

lotkavolterra.plot_aij_with_arrows( traj_2_2, flv, 'foodweb-2-2-a-vs-a-detail.png', xmin=-1.993, xmax=-1.9925, ymin=1.79325, ymax=1.79375 )

ltx.close()
