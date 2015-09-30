# requires: large.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageUtils)/latex_output.py
# produces: large-assemble.sobj
from sage.all import *
from sage.misc.latex import _latex_file_

import large
import latex_output
import dynamicalsystems

set_random_seed(0)

N_pop = 1#5

smr = large.LargeNumbersPopulation( 0 )

t = 0
state = dynamicalsystems.Bindings()
soln = dynamicalsystems.Trajectory( smr, [] )
while smr.n_populations() < N_pop:
    ni = smr.add_random_species()
    state[ smr._population_indexer[ni] ] = 1
    smu = smr.bind( { smr._u_indexer[i]:0 for i in smr._population_indices } )
    print 'go', t, 'to', t+100; sys.stdout.flush()
    ni_soln = smu.solve_gsl( [ state(x) for x in smu._vars ], start_time=t, end_time=t+100 )
    if any( abs(x)>1e+7 or math.isnan(x) for x in ni_soln._timeseries[-1].values() ):
	# it caused an explosion, back it out
	print ni, 'caused an explosion'
	smr.remove_population( ni )
	continue
    state = ni_soln._timeseries[-1]
    t = state('t')
    soln += ni_soln
    defunct = set( [ i for i in smr._population_indices if ni_soln._timeseries[-1]( smr._population_indexer[i] ) < 0.001 ] )
    if len(defunct) > 0:
        print 'extinctions:', defunct
        smr.remove_populations( defunct )

del smu
del ni_soln
save_session( 'large-assemble' )
