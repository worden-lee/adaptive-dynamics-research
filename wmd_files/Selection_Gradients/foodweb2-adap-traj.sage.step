# requires: foodweb2-adap.sobj
# produces: foodweb2-adap-traj.sobj
from sage.all import *

import foodweb2, dynamicalsystems, lotkavolterra

load_session("foodweb2-adap")

pred_prey_init = dynamicalsystems.Bindings( { 'u_a_0':0.1, 'u_b_0':0, 'gamma_a_0':0, 'gamma_b_0':0, 'sigma_a_0':1, 'sigma_b_0':1 } )

#ltx.write( 'flow at ', '$%s$'%latex( dynamicalsystems.column_vector( [ pred_prey_init( v ) for v in foodweb_adap._vars ] ) ), ': ', 
#    '$%s$'%latex( dynamicalsystems.column_vector( pred_prey_init( foodweb_adap._flow[v] ) for v in foodweb_adap._vars ) ) )

pred_prey_traj = foodweb_adap.solve( [ pred_prey_init( v ) for v in foodweb_adap._vars ], end_time=1000 ) #, step=0.003 )

save_session('foodweb2-adap-traj')
