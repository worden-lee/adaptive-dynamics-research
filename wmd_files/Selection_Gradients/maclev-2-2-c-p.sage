# requires: $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
# requires: maclev_2_2_defs.py maclev-2-2-c-adap.sobj
# produces: maclev-2-2-c-p.sage.out.tex maclev-2-2-c-c-vs-c.png
from maclev_2_2_defs import *

load_session( 'maclev-2-2-c-adap' )

ltx = latex_output( 'maclev-2-2-c-p.sage.out.tex' )

# plot c_1 vs c_0, with arrows

print 'plot c vs c'
sys.stdout.flush()

# first put in the curves in the c_0-c_1 plane
c_phase_plane = Graphics()
for i in maclev._population_indices:
    ci = [ rescomp._indexers['c'][i][0], rescomp._indexers['c'][i][1] ]
    c_phase_plane += c_evolution.plot( ci[0], ci[1], color=[ 'blue', 'red' ][i] )

c_phase_plane.axes_labels( [ '$c_0$', '$c_1$' ] )
c_phase_plane.save( 'maclev-2-2-c-c-vs-c.png', figsize=(6,6), xmin=0, ymin=0 )

ltx.close()
save_session( 'maclev-2-2-c-p' )
