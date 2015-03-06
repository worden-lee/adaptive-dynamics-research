# requires: foodweb.sobj
# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb.plot.sage.out.tex foodweb-pred-prey-adap.png
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics

# create variables with custom latex names because load_session
# creates them wrong
# http://trac.sagemath.org/ticket/17559
#for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
#SR.symbol( 'c_0_0', latex_name='c_{00}' )
#SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("foodweb")

ltx = latex_output.latex_output( 'foodweb.plot.sage.out.tex' )

pred_prey_traj = foodweb_adap.solve( [ pred_prey_init( v ) for v in foodweb_adap._vars ], end_time=100 ) #, step=0.003 )

ppp = Graphics()
for v, c in zip( foodweb_adap._vars, ['blue', 'red'] ):
    ppp += pred_prey_traj.plot( 't', v, color=c )
ppp.save( 'foodweb-pred-prey-adap.png', figsize=(5,5) )

ltx.close()
