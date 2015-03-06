# requires: foodweb.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb-2-2.sobj foodweb-2-2.sage.out.tex foodweb-2-2.tikz.tex
from sage.all import * 
from sage.misc.latex import _latex_file_

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics

ltx = latex_output.latex_output( 'foodweb-2-2.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('R_0 R_1 P_0 P_1')
foodweb = foodweb.FoodWebModel(
    DiGraph( { R_0:[P_0,P_1], R_1:[P_0,P_1] } ),
    bindings = dynamicalsystems.Bindings( { 'r':1, 'k':1/3, 'm':1 } ) + dynamicalsystems.FunctionBindings( { 'a':SR('1 + cos( u - v )').function(SR('u'),SR('v')) } )
);

ltx.write( 'The foodweb model:' )
ltx.write_block( foodweb )

foodweb.plot_tikz( 'foodweb-2-2.tikz.tex' )

#ltx.close()
#save_session('foodweb-2-2')
#sys.exit( 0r )

equil = foodweb.interior_equilibria()
print equil

foodweb_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    foodweb,
    [ foodweb._u_indexer ],
    equilibrium = dynamicalsystems.Bindings( equil[0] )
).bind( { 'gamma':1 } )

ltx.write( 'Adaptive dynamics of model:\n', foodweb_adap )
#ltx.write_environment( 'align*', [ '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(foodweb_adap._S[v])) for v in foodweb_adap._vars ) ] )

init_2_2 = dynamicalsystems.Bindings( { 'u_R_0_0':0.1, 'u_R_1_0':0, 'u_P_0_0':-0.1, 'u_P_1_0':-0.2 } ) 

ltx.write( 'flow at ', '$%s$'%latex( latex_output.column_vector( [ init_2_2( v ) for v in foodweb_adap._vars ] ) ), ': ',
    '$%s$'%latex( latex_output.column_vector( init_2_2( foodweb_adap._flow[v] ) for v in foodweb_adap._vars ) ) )

ltx.close()

save_session('foodweb-2-2')
