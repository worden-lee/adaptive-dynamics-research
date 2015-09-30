# requires: statmech.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: statmech.sobj statmech.sage.out.tex statmech.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import statmech
import latex_output
import dynamicalsystems
import adaptivedynamics

ltx = latex_output.latex_output( 'statmech.sage.out.tex' )

N_pop = 5

smr = statmech.StatMechPopulation( 0 )

t = 0
state = dynamicalsystems.Bindings()
soln = dynamicalsystems.ODETrajectory( smr, [] )
while smr.n_populations() < N_pop:
    ni = smr.add_random_species()
    state[ smr._population_indexer[ni] ] = 1
    smu = smr.bind( { smr._u_indexer[i]:0 for i in smr._population_indices } )
    print 'go', t, 'to', t+100; sys.stdout.flush()
    ni_soln = smu.solve( [ state(x) for x in smu._vars ], start_time=t, end_time=t+100 )
    if any( abs(x)>1e+7 or math.isnan(x) for x in ni_soln._timeseries[-1].values() ):
	# it caused an explosion, back it out
	print ni, 'caused an explosion'
	smr.remove_population( ni )
	continue
    state = ni_soln._timeseries[-1]
    t = state('t')
    soln += ni_soln
    defunct = set( [ i for i in smr._population_indices if abs( ni_soln._timeseries[-1]( smr._population_indexer[i] ) ) < 0.001 ] )
    if len(defunct) > 0:
        print 'extinctions:', defunct
        smr.remove_populations( defunct )

ltx.write( smr )

soln.plot( 't', smr._vars, ylabel='$X$' ).save( filename='statmech.svg' )

ltx.close()
exit(0r)

statmech_adap = adaptivedynamics.AdaptiveDynamicsModel( 
    statmech_pred_prey,
    [ statmech_pred_prey._u_indexer ],
    early_bindings=fb,
    equilibrium = dynamicalsystems.Bindings( equil[0] )
).bind( { 'gamma':1 } )

ltx.write( 'Adaptive dynamics of model:\n', statmech_adap )
#ltx.write_environment( 'align*', [ '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(statmech_adap._S[v])) for v in statmech_adap._vars ) ] )

pred_prey_init = dynamicalsystems.Bindings( { 'u_0_a':0.1, 'u_0_b':0 } )

ltx.write( 'flow at ', '$%s$'%latex( latex_output.column_vector( [ pred_prey_init( v ) for v in statmech_adap._vars ] ) ), ': ', 
    '$%s$'%latex( latex_output.column_vector( pred_prey_init( statmech_adap._flow[v] ) for v in statmech_adap._vars ) ) )

pred_prey_traj = statmech_adap.bind( fb ).solve( [ pred_prey_init( v ) for v in statmech_adap._vars ], end_time=1000 ) #, step=0.003 )

ltx.close()

save_session('statmech')
