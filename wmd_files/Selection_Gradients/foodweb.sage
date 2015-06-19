# requires: foodweb.py
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

fb = (
    dynamicalsystems.Bindings( k = 9/10 ) +
    dynamicalsystems.FunctionBindings( { 'f':SR('2 + 4/5*cos( u - v )').function(SR('u'),SR('v')) } )
)

foodweb_pred_prey = foodweb.FoodWebModel(
    DiGraph( { a:[b] } ),
    bindings = dynamicalsystems.Bindings( { 'r':1, 'm':1 } )
);

ltx.write( 'The foodweb model:', foodweb_pred_prey.bind(fb) )

foodweb_pred_prey.plot_tikz( 'foodweb.tikz.tex' )

#ltx.close()
#save_session('foodweb')
#sys.exit( 0r )

equil = foodweb_pred_prey.interior_equilibria()
print equil

foodweb_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    foodweb_pred_prey,
    [ foodweb_pred_prey._u_indexer ],
    early_bindings=fb,
    equilibrium = dynamicalsystems.Bindings( equil[0] )
).bind( { 'gamma':1 } )

ltx.write( 'Adaptive dynamics of model:\n', foodweb_adap )
#ltx.write_environment( 'align*', [ '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(foodweb_adap._S[v])) for v in foodweb_adap._vars ) ] )

pred_prey_init = dynamicalsystems.Bindings( { 'u_0_a':0.1, 'u_0_b':0 } )

ltx.write( 'flow at ', '$%s$'%latex( latex_output.column_vector( [ pred_prey_init( v ) for v in foodweb_adap._vars ] ) ), ': ', 
    '$%s$'%latex( latex_output.column_vector( pred_prey_init( foodweb_adap._flow[v] ) for v in foodweb_adap._vars ) ) )

pred_prey_traj = foodweb_adap.bind( fb ).solve( [ pred_prey_init( v ) for v in foodweb_adap._vars ], end_time=1000 ) #, step=0.003 )

ltx.close()

save_session('foodweb')
