# This file was *autogenerated* from the file foodweb.sage
from sage.all_cmdline import *   # import sage library
_sage_const_0p1 = RealNumber('0.1'); _sage_const_1 = Integer(1); _sage_const_10 = Integer(10); _sage_const_0 = Integer(0); _sage_const_9 = Integer(9)# requires: foodweb.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb.sobj foodweb.sage.out.tex foodweb.tikz.tex
from sage.all import * 
from sage.misc.latex import _latex_file_

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics

ltx = latex_output.latex_output( 'foodweb.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('a b')
foodweb_pred_prey = foodweb.FoodWebModel(
    DiGraph( { a:[b] } ),
    bindings = dynamicalsystems.Bindings( { 'r':_sage_const_1 , 'k':_sage_const_9 /_sage_const_10 , 'm':_sage_const_1  } ) + dynamicalsystems.FunctionBindings( { 'a':SR('1 + cos( u - v )').function(SR('u'),SR('v')) } )
);

ltx.write( 'The foodweb model:' )
ltx.write_block( foodweb_pred_prey )

foodweb_pred_prey.plot_tikz( 'foodweb.tikz.tex' )

#ltx.close()
#save_session('foodweb')
#sys.exit( 0r )

equil = foodweb_pred_prey.interior_equilibria()
print equil

foodweb_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    foodweb_pred_prey,
    [ foodweb_pred_prey._u_indexer ],
    equilibrium = dynamicalsystems.Bindings( equil[_sage_const_0 ] )
).bind( { 'gamma':_sage_const_1  } )

ltx.write( 'Adaptive dynamics of model:\n', foodweb_adap )
#ltx.write_environment( 'align*', [ '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(foodweb_adap._S[v])) for v in foodweb_adap._vars ) ] )

pred_prey_init = dynamicalsystems.Bindings( { 'u_0_a':_sage_const_0p1 , 'u_0_b':_sage_const_0  } ) 

ltx.write( 'flow at ', '$%s$'%latex( latex_output.column_vector( [ pred_prey_init( v ) for v in foodweb_adap._vars ] ) ), ': ',
    '$%s$'%latex( latex_output.column_vector( pred_prey_init( foodweb_adap._flow[v] ) for v in foodweb_adap._vars ) ) )

ltx.close()

save_session('foodweb')
