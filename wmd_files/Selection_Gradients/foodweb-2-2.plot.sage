# requires: foodweb-2-2.sobj
# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py lotkavolterra.py
# produces: foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png
# produces: foodweb-2-2-a-vs-a.png foodweb-2-2-a-vs-t.png
# produces: foodweb-2-2-x-vs-t.png
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics
import lotkavolterra

load_session("foodweb-2-2")

ltx = latex_output.latex_output( 'foodweb-2-2.plot.sage.out.tex' )

ppp = Graphics()
for v, c in zip( foodweb_adap._vars, ['blue', 'red', 'purple', 'orange'] ):
    ppp += traj_2_2.plot( 't', v, color=c )
ppp.save( 'foodweb-2-2-adap.png', figsize=(5,5) )

xs = foodweb_adap._popdyn_model.equilibrium_vars()
ppx = Graphics()
for xhat, c in zip(xs, ['blue', 'red', 'purple', 'orange']):
    ppx += traj_2_2.plot( 't', xhat, legend_label='$%s$'%latex(xhat), color=c )
ppx.save( 'foodweb-2-2-x-vs-t.png', figsize=(5,5) )

flv = lotkavolterra.LotkaVolterraAdaptiveDynamics( foodweb_adap,
	r_name_indexer=foodweb.vertex_indexer('r'),
        a_name_indexer=foodweb.vertex_indexer_2d('a') )

atp = Graphics()
for i in foodweb_adap._popdyn_model._population_indices:
    for j in foodweb_adap._popdyn_model._population_indices:
	atp += traj_2_2.plot( 't', flv._lv_model._A_bindings( flv._lv_model._a_indexer[i][j] ),
	    color = (i == j and 'red' or 'green') )
atp.save( 'foodweb-2-2-a-vs-t.png', figsize=(5,5) )

lotkavolterra.plot_aij_with_arrows( traj_2_2, flv, 'foodweb-2-2-a-vs-a.png', xmin=-1.993, xmax=-1.9925, ymin=1.79325, ymax=1.79375 )

ltx.close()
