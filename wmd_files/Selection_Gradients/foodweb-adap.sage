# requires: foodweb.py foodweb.sobj
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb-adap.sage.out.tex foodweb-adap.sobj
from sage.all import * 
from sage.misc.latex import _latex_file_

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics

load_session("foodweb")

ltx = latex_output.latex_output( 'foodweb-adap.sage.out.tex' )

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

save_session('foodweb-adap')
