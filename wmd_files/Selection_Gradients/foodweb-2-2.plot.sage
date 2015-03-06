# requires: foodweb-2-2.sobj
# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb-2-2.plot.sage.out.tex foodweb-2-2-adap.png
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics

load_session("foodweb-2-2")

ltx = latex_output.latex_output( 'foodweb-2-2.plot.sage.out.tex' )

traj_2_2 = foodweb_adap.solve( [ init_2_2( v ) for v in foodweb_adap._vars ], end_time=100 ) #, step=0.003 )

ppp = Graphics()
for v, c in zip( foodweb_adap._vars, ['blue', 'red', 'purple', 'orange'] ):
    ppp += traj_2_2.plot( 't', v, color=c )
ppp.save( 'foodweb-2-2-adap.png', figsize=(5,5) )

ltx.close()
