# requires: maclev_2_2_defs.py maclev-2-2-adap.sobj $(SageUtils)/latex_output.py
# produces: maclev-2-2-zngi-invasion.sage.out.tex maclev-2-2-zngi-invasion.png
from maclev_2_2_defs import *

load_session( 'maclev-2-2-zngi' )

ltx = latex_output( 'maclev-2-2-zngi-invasion.sage.out.tex' )

# invasion criteria for (c_i_0, c_i_1)

# make a 3-species model where X_0, X_1 are resident, X_2 is potential guest

rescomp_3 = ResourceCompetitionModel( r_indices=[0,1], x_indices=[0,1,2], bindings=numeric_params )

ltx.write_block( rescomp_3 )

X_2 = rescomp_3._population_indexer[2]
resident_vars = [ v for v in rescomp_3._vars if v != X_2 ]

# find the resident equilibrium - the one where all vars are nonzero except X_2

resident_equil_eqns = [ rescomp_3._flow[v] == 0 for v in resident_vars ] + [ X_2 == 0 ]
resident_equils = solve( resident_equil_eqns, rescomp_3._vars, solution_dict=True )
for v in rescomp_3._vars:
    if v is not X_2:
        resident_equils = filter( lambda eq: eq[v] != 0, resident_equils )
resident_equil = resident_equils[0]

ltx.write_block( resident_equil )

# so now the invasion speed of X_2 is _flow[X_2]/X_2

X_2_invasion_speed = rescomp_3._flow[X_2] / X_2

# make that somehow appear as a region on R_0-R_1 plane??

# each species' ZNGI is a line of the form a R_0 + b R_1 = k
# and the invasion criterion is a c_0 + b c_1 > k
# not sure how to draw that, but basically, a pair (c_0,c_1)
# corresponds to a ZNGI line, and the pairs that can invade are
# those for which the equilibrium point (R_0, R_1) is above the
# line.  The equilibrium point is the intersection of the two
# resident species' ZNGI lines.

invasion_criterion = bmc_bindings( X_2_invasion_speed.subs( resident_equil ) )

ltx.write_equality( r'\mathcal{I}(X_2)', invasion_criterion )

zplot = anima[0]
#zplot += region_plot( X_2_invasion_speed

status = 0
ltx.close()
save_session('maclev-2-2-zngi-invasion')
sys.exit(int(status))
