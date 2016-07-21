# requires: foodweb2-adap-traj.sobj
# produces: foodweb2.plot.sage.out.tex 
# produces: foodweb2-pred-prey-adap.png foodweb2-pred-prey-adap.svg
# produces: foodweb2-pred-prey-adap-difference.png
# produces: foodweb2-pred-prey-a-vs-t.png foodweb2-pred-prey-a-vs-a.png
# produces: foodweb2-pred-prey-x-vs-t.png
from sage.all import *
from sage.misc.latex import latex

import foodweb2, dynamicalsystems, lotkavolterra

# create variables with custom latex names because load_session
# creates them wrong: http://trac.sagemath.org/ticket/17559
#for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
#SR.symbol( 'c_0_0', latex_name='c_{00}' )
#SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("foodweb2-adap-traj")

ltx = dynamicalsystems.latex_output( 'foodweb2.plot.sage.out.tex' )

#foodweb_adap.bind_in_place( fb )

print 'flow at initial conditions:', pred_prey_init( foodweb_adap._flow )

#ppp = Graphics()
#for v, c in zip( foodweb_adap._vars, ['blue', 'red', 'purple','green'] ):
#    ppp += pred_prey_traj.plot( 't', v, color=c, legend_label=l )
#    ppp += pred_prey_traj.plot( 't', v, color=c, legend_label='${}$'.format(latex(v)) )

ppp = pred_prey_traj.plot( 't', foodweb_adap._vars )
ppp.save( 'foodweb2-pred-prey-adap.png',
    #ticks=[100,pi],
    #tick_formatter=[None,pi],
    figsize=(5,5)
)
ppp.save( 'foodweb2-pred-prey-adap.svg',
    #ticks=[500,pi],
    #tick_formatter=[None,pi],
    figsize=(3,3)
)

pred_prey_traj.plot( 't', 'u_a_0 - u_b_0', legend_label='$u_{a0}-u_{b0}$' ).save(
    'foodweb2-pred-prey-adap-difference.png',
    #ymin=0,
    #ymax=3.2,
    #ticks=[100,pi/2],
    #tick_formatter=[None,pi],
    figsize=(5,5)
)

xs = foodweb_adap._popdyn_model.equilibrium_vars()
#ppx = Graphics()
#for xhat in xs:
#    ppx += pred_prey_traj.plot( 't', xhat, legend_label='$%s$'%latex(xhat) )
ppx = pred_prey_traj.plot( 't', xs )
ppx.save( 'foodweb2-pred-prey-x-vs-t.png', figsize=(5,5) )

flv = lotkavolterra.LotkaVolterraAdaptiveDynamics( foodweb_adap,
	r_name_indexer=foodweb2.vertex_indexer('r'),
        a_name_indexer=foodweb2.vertex_indexer_2d('a') )

atp = Graphics()
for i in foodweb_adap._popdyn_model._population_indices:
    for j in foodweb_adap._popdyn_model._population_indices:
	atp += pred_prey_traj.plot( 't', fb( flv._lv_model._A_bindings( flv._lv_model._a_indexer[i][j] ) ),
	    color = (i == j and 'red' or 'green') )
atp.save( 'foodweb2-pred-prey-a-vs-t.png', figsize=(5,5) )

lotkavolterra.plot_aij_with_arrows( pred_prey_traj, flv, 'foodweb2-pred-prey-a-vs-a.png', bindings=fb )

lotkavolterra.plot_aij_with_arrows( pred_prey_traj, flv, 'foodweb2-pred-prey-a-vs-a-detail.png', bindings=fb, xmin=-1.9955, xmax=-1.9945, ymin=1.795, ymax=1.796 )

ltx.close()
