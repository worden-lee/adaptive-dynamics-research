# requires: maclev_unconstrained_c.py maclev_2_2_defs.py
# requires: $(SageDynamics)/dynamicalsystems.py maclevmodels.py
# produces: maclev-2-2-c-popdyn.sage.out.tex maclev-2-2-c-popdyn.sobj
# produces: maclev-2-2-c-popdyn.png maclev-2-2-c-r-zngis.png
from maclev_unconstrained_c import *

print 'start'
sys.stdout.flush()

ltx = latex_output( 'maclev-2-2-c-popdyn.sage.out.tex' )

ltx.write( 'The Mac-Lev model in generic form: ' )
ltx.write_block( maclev )

print 'apply bindings:', ad_bindings
sys.stdout.flush()

ltx.write( 'The Mac-Lev model with $c$ varying freely:' )
ltx.write_block( maclev.bind( ad_bindings + numeric_params ) )

print 'plot state space'
sys.stdout.flush()

maclev_initial_system = maclev.bind( ad_bindings + numeric_params + initial_conditions )
p = maclev_initial_system.plot_vector_field( (X_0, 0, 2), (X_1, 0, 2), color="gray", figsize=(5,5) )
p += maclev_initial_system.plot_ZNGIs( (X_0, 0, 2), (X_1, 0, 2), color="gray" )
s = maclev_initial_system.solve( [0.02, 0.05], end_time=integrate_popdyn_to )
p += s.plot( X_0, X_1, color='red' )
p.save( 'maclev-2-2-c-popdyn.png' )

rescomp_initial_system = maclev._rescomp_model.bind( ad_bindings + numeric_params + initial_conditions )
rescomp_initial_system.plot_R_ZNGIs( filename='maclev-2-2-c-r-zngis.png', figsize=(4,4), ymin=0, ymax=4, xmin=0, xmax=4 )

ltx.close()

save_session('maclev-2-2-c-popdyn')
