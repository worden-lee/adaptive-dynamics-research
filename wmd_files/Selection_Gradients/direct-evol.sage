# requires: direct.py
# requires: $(SageUtils)/latex_output.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: lotkavolterra.py
# requires: direct-assemble.sobj
# produces: direct-evol.sobj
from sage.all import *
from sage.misc.latex import _latex_file_

import direct
import latex_output
import dynamicalsystems
import adaptivedynamics
import lotkavolterra

load_session( 'direct-assemble' )

ltx = latex_output.latex_output( 'direct-evol.sage.out.tex' )

def lv_interior_equilibrium( popdyn ):
    import sympy
    eqns = [ sympy.sympify( popdyn.add_hats()( (popdyn._flow[x]/x).simplify_rational() ) ) for x in popdyn._vars ]
    print eqns; sys.stdout.flush()
    #eqs = solve( eqns, *popdyn.equilibrium_vars(), solution_dict=True )
    eqs = sympy.solve( eqns, *popdyn.equilibrium_vars() )
    return dynamicalsystems.Bindings( { x: eqs[ sympy.sympify(x) ] for x in popdyn.equilibrium_vars() } )

int_equil = dynamicalsystems.Bindings( lv_interior_equilibrium( comm2 ) )

formal_equil = dynamicalsystems.Bindings( { v : dynamicalsystems.hat(v) for v in comm2.population_vars() } )

#u_init = dynamicalsystems.Bindings( { smr._u_indexer[i]:0 for i in smr._population_indices } )

symbolic_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    comm2,
    [ dynamicalsystems.indexer_2d_reverse('u')[i] for i in comm2._population_indices ],
    #early_bindings=fb,
    equilibrium = formal_equil
).bind( { 'gamma':1 } )

ltx.write( 'Adaptive dynamics of model:\n', symbolic_adap )

num_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    comm2,
    [ dynamicalsystems.indexer_2d_reverse('u')[i] for i in comm2._population_indices ],
    equilibrium = int_equil
).bind( { 'gamma':1 } )

ad_init = dynamicalsystems.Bindings( { comm2._u_indexer[i][j]:(-1 if i == j else -0.75 if i < j else -0.7) for i in comm2._population_indices for j in comm2._population_indices } )
ad_init_state = [ ad_init(u) for u in num_adap._vars ]

ad_traj = num_adap.solve( ad_init_state, end_time=10, step=0.01 )

nlv = lotkavolterra.LotkaVolterraAdaptiveDynamics( num_adap )
	#r_name_indexer=direct.vertex_indexer('r'),
        #a_name_indexer=direct.vertex_indexer_2d('a') )

slv = lotkavolterra.LotkaVolterraAdaptiveDynamics( symbolic_adap )
	#r_name_indexer=direct.vertex_indexer('r'),
        #a_name_indexer=direct.vertex_indexer_2d('a') )

ltx.close()

save_session('direct-evol')
