# requires: foodweb.py
# produces: foodweb-2-2.sobj foodweb-2-2.sage.out.tex foodweb-2-2.tikz.tex
from sage.all import * 
from sage.misc.latex import _latex_file_

import foodweb
import dynamicalsystems
import lotkavolterra

ltx = dynamicalsystems.latex_output( 'foodweb-2-2.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('R_0 R_1 P_0 P_1')
foodweb_2_2 = foodweb.FoodWebModel(
    DiGraph( { R_0:[P_0,P_1], R_1:[P_0,P_1] } ),
    bindings = dynamicalsystems.Bindings( { 'r':1, 'm':1 } )
);

fb = ( dynamicalsystems.FunctionBindings( { 'f':SR('1 + cos( u - v )').function(SR('u'),SR('v')) } )
    + dynamicalsystems.Bindings( k=9/10 ) )

fb_2_2 = foodweb_2_2.bind(fb)

ltx.write( 'The foodweb model:', fb_2_2 )

foodweb_2_2.plot_tikz( 'foodweb-2-2.tikz.tex' )

#ltx.close()
#save_session('foodweb-2-2')
#sys.exit( 0r )

equil = fb_2_2.interior_equilibria()
print equil

init_2_2 = dynamicalsystems.Bindings( { 'u_0_R_0':-0.1, 'u_0_R_1':0, 'u_0_P_0':-0.07, 'u_0_P_1':0.02 } ) 

#print init_2_2( dynamicalsystems.Bindings( equil[0] ) )

foodweb_adap = dynamicalsystems.AdaptiveDynamicsModel( 
    foodweb_2_2,
    [ foodweb_2_2._u_indexer ],
    equilibrium = dynamicalsystems.Bindings()
    #equilibrium = dynamicalsystems.Bindings( equil[0] )
).bind( { 'gamma':1 } )

ltx.write( 'Adaptive dynamics of model:\n', foodweb_adap )
#ltx.write_environment( 'align*', [ '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(foodweb_adap._S[v])) for v in foodweb_adap._vars ) ] )

#ltx.write( 'flow at ', '$%s$'%latex( dynamicalsystems.column_vector( [ init_2_2( v ) for v in foodweb_adap._vars ] ) ), ': ',
#    '$%s$'%latex( dynamicalsystems.column_vector( init_2_2( foodweb_adap._flow[v] ) for v in foodweb_adap._vars ) ) )

fb_adap = foodweb_adap.bind( fb + dynamicalsystems.Bindings( equil[0] ) )

#ltx.write( 'Bound adaptive dynamics:\n', fb_adap )

traj_2_2 = fb_adap.solve( [ init_2_2( v ) for v in foodweb_adap._vars ], end_time=30 ) #, step=0.003 )

print traj_2_2._timeseries

ltx.close()

save_session('foodweb-2-2')
