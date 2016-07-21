# requires: aij.py
# requires: lotkavolterra.py
# requires: aij-assemble.sobj
# produces: aij-evol.sobj
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import aij
import dynamicalsystems
import lotkavolterra

load_session( 'aij-assemble' )

ltx = dynamicalsystems.latex_output( 'aij-evol.sage.out.tex' )

adap = aij.AijAdaptiveDynamics( comm2 )

ad_init = dynamicalsystems.Bindings( { comm2._indexers['a'][i][j]:-1 for i in comm2._population_indices for j in comm2._population_indices } ) + dynamicalsystems.Bindings( { comm2._indexers['r'][i]:1 for i in comm2._population_indices } )
#ad_init = dynamicalsystems.Bindings( { comm2._indexers['a'][i][j]:(-1 if i == j else -0.75 if i < j else -0.7) for i in comm2._population_indices for j in comm2._population_indices } ) + dynamicalsystems.Bindings( { comm2._indexers['r'][i]:1 for i in comm2._population_indices } )
ad_init_state = [ ad_init(u) for u in adap._vars ]

ad_traj = adap.solve( ad_init_state, end_time=1 ) #10 )

ltx.close()
save_session('aij-evol')
