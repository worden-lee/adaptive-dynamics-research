# requires: foodweb.sobj
# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py lotkavolterra.py
# produces: foodweb.plot.sage.out.tex foodweb-pred-prey-adap.png
# produces: foodweb-pred-prey-a-vs-t.png foodweb-pred-prey-a-vs-a.png
# produces: foodweb-pred-prey-x-vs-t.png
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics
import lotkavolterra

# create variables with custom latex names because load_session
# creates them wrong: http://trac.sagemath.org/ticket/17559
#for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
#SR.symbol( 'c_0_0', latex_name='c_{00}' )
#SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("foodweb")

ltx = latex_output.latex_output( 'foodweb.plot.sage.out.tex' )

#foodweb_adap.bind_in_place( fb )
pred_prey_traj = foodweb_adap.bind( fb ).solve( [ pred_prey_init( v ) for v in foodweb_adap._vars ], end_time=400 ) #, step=0.003 )

print 'flow at initial conditions:', pred_prey_init( foodweb_adap._flow )

ppp = Graphics()
for v, c in zip( foodweb_adap._vars, ['blue', 'red'] ):
    ppp += pred_prey_traj.plot( 't', v, color=c )
ppp.save( 'foodweb-pred-prey-adap.png', figsize=(5,5) )

xs = foodweb_adap._popdyn_model.equilibrium_vars()
ppx = Graphics()
for xhat in xs:
    ppx += pred_prey_traj.plot( 't', xhat, legend_label='$%s$'%latex(xhat) )
ppx.save( 'foodweb-pred-prey-x-vs-t.png', figsize=(5,5) )

flv = lotkavolterra.LotkaVolterraAdaptiveDynamics( foodweb_adap,
	r_name_indexer=foodweb.vertex_indexer('r'),
        a_name_indexer=foodweb.vertex_indexer_2d('a') )

atp = Graphics()
for i in foodweb_adap._popdyn_model._population_indices:
    for j in foodweb_adap._popdyn_model._population_indices:
	atp += pred_prey_traj.plot( 't', fb( flv._lv_model._A_bindings( flv._lv_model._a_indexer[i][j] ) ),
	    color = (i == j and 'red' or 'green') )
atp.save( 'foodweb-pred-prey-a-vs-t.png', figsize=(5,5) )

lotkavolterra.plot_aij_with_arrows( pred_prey_traj, flv, 'foodweb-pred-prey-a-vs-a.png', bindings=fb, xmin=-1.9955, xmax=-1.9945, ymin=1.795, ymax=1.796 )

ltx.close()
