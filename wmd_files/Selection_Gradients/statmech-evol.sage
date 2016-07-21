# requires: statmech.py
# requires: lotkavolterra.py
# requires: statmech-assemble.sobj
# produces: statmech-evol.sobj
from sage.all import *
from sage.misc.latex import _latex_file_

import statmech
import dynamicalsystems
import lotkavolterra

load_session( 'statmech-assemble' )

ltx = dynamicalsystems.latex_output( 'statmech-evol.sage.out.tex' )

def lv_interior_equilibrium( popdyn ):
    import sympy
    eqns = [ sympy.sympify( popdyn.add_hats()( (popdyn._flow[x]/x).simplify_rational() ) ) for x in popdyn._vars ]
    print eqns; sys.stdout.flush()
    #eqs = solve( eqns, *popdyn.equilibrium_vars(), solution_dict=True )
    eqs = sympy.solve( eqns, *popdyn.equilibrium_vars() )
    return dynamicalsystems.Bindings( { x: eqs[ sympy.sympify(x) ] for x in popdyn.equilibrium_vars() } )

u_init = dynamicalsystems.Bindings( { smr._u_indexer[i]:0 for i in smr._population_indices } )

equil = lv_interior_equilibrium( smr )
eq0 = dynamicalsystems.Bindings( equil )
#equil = smr.interior_equilibria()
print 'equil:', eq0
print 'equil at u=0:', u_init( eq0 )

sm_adap = dynamicalsystems.AdaptiveDynamicsModel( 
    smr,
    [ smr._u_indexer ],
    #early_bindings=fb,
    equilibrium = eq0
).bind( { 'gamma':1 } )

ltx.write( 'Adaptive dynamics of model:\n', sm_adap )

ad_init = dynamicalsystems.Bindings( { u:0 for u in sm_adap._vars } )
ad_init_state = [ ad_init(u) for u in sm_adap._vars ]

sm_traj = sm_adap.solve( ad_init_state, end_time=10, step=0.01 )

slv = lotkavolterra.LotkaVolterraAdaptiveDynamics( sm_adap,
	r_name_indexer=statmech.vertex_indexer('r'),
        a_name_indexer=statmech.vertex_indexer_2d('a') )

ltx.close()

save_session('statmech-evol')