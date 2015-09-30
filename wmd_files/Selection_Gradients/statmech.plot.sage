# requires: statmech.sobj
# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py lotkavolterra.py
# produces: statmech.plot.sage.out.tex 
# produces: statmech-pred-prey-adap.png statmech-pred-prey-adap.svg
# produces: statmech-pred-prey-adap-difference.png
# produces: statmech-pred-prey-a-vs-t.png statmech-pred-prey-a-vs-a.png
# produces: statmech-pred-prey-x-vs-t.png
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import statmech
import latex_output
import dynamicalsystems
import adaptivedynamics
import lotkavolterra

# create variables with custom latex names because load_session
# creates them wrong: http://trac.sagemath.org/ticket/17559
#for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
#SR.symbol( 'c_0_0', latex_name='c_{00}' )
#SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("statmech")

ltx = latex_output.latex_output( 'statmech.plot.sage.out.tex' )

#statmech_adap.bind_in_place( fb )

print 'flow at initial conditions:', pred_prey_init( statmech_adap._flow )

ppp = Graphics()
for v, c, l in zip( statmech_adap._vars, ['blue', 'red'], ['prey $u_0$','predator $u_1$'] ):
    ppp += pred_prey_traj.plot( 't', v, color=c, legend_label=l )
ppp.save( 'statmech-pred-prey-adap.png',
    ticks=[100,pi],
    tick_formatter=[None,pi],
    figsize=(5,5)
)
ppp.save( 'statmech-pred-prey-adap.svg',
    ticks=[500,pi],
    tick_formatter=[None,pi],
    figsize=(3,3)
)

pred_prey_traj.plot( 't', 'u_0_a - u_0_b', legend_label='$u_0-u_1$' ).save(
    'statmech-pred-prey-adap-difference.png',
    ymin=0,
    ymax=3.2,
    ticks=[100,pi/2],
    tick_formatter=[None,pi],
    figsize=(5,5)
)

xs = statmech_adap._popdyn_model.equilibrium_vars()
ppx = Graphics()
for xhat in xs:
    ppx += pred_prey_traj.plot( 't', xhat, legend_label='$%s$'%latex(xhat) )
ppx.save( 'statmech-pred-prey-x-vs-t.png', figsize=(5,5) )

flv = lotkavolterra.LotkaVolterraAdaptiveDynamics( statmech_adap,
	r_name_indexer=statmech.vertex_indexer('r'),
        a_name_indexer=statmech.vertex_indexer_2d('a') )

atp = Graphics()
for i in statmech_adap._popdyn_model._population_indices:
    for j in statmech_adap._popdyn_model._population_indices:
	atp += pred_prey_traj.plot( 't', fb( flv._lv_model._A_bindings( flv._lv_model._a_indexer[i][j] ) ),
	    color = (i == j and 'red' or 'green') )
atp.save( 'statmech-pred-prey-a-vs-t.png', figsize=(5,5) )

lotkavolterra.plot_aij_with_arrows( pred_prey_traj, flv, 'statmech-pred-prey-a-vs-a.png', bindings=fb )

lotkavolterra.plot_aij_with_arrows( pred_prey_traj, flv, 'statmech-pred-prey-a-vs-a-detail.png', bindings=fb, xmin=-1.9955, xmax=-1.9945, ymin=1.795, ymax=1.796 )

ltx.close()
