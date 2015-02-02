# requires: $(SageDynamics)/dynamicalsystems.py $(SageUtils)/latex_output.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py maclevmodels.py
# requires: maclev_2_2_defs.py maclev-2-2-a-c-adap.sobj
# produces: maclev-2-2-a-c-p.sage.out.tex
# produces: maclev-2-2-a-c-c-vs-t.sage.out.tex maclev-2-2-a-c-c-vs-c.png
from maclev_a_c import *

load_session( 'maclev-2-2-a-c-adap' )

ltx = latex_output( 'maclev-2-2-a-c-p.sage.out.tex' )

# plot c vs t

print 'plot c vs t'
sys.stdout.flush()

t = c_evolution._system._time_variable

c_timeseries = Graphics()
for i in maclev._population_indices:
    ci = [ rescomp._indexers['c'][i][0], rescomp._indexers['c'][i][1] ]
    c_timeseries += c_evolution.plot( t, ci[0], color=[ 'blue', 'red' ][i] )
    c_timeseries += c_evolution.plot( t, ci[1], color=[ 'blue', 'red' ][i] )

c_timeseries.axes_labels( [ '$t$', '$c$' ] )
c_timeseries.save( 'maclev-2-2-a-c-c-vs-t.png', figsize=(6,6), xmin=0, ymin=0 )

# plot c_1 vs c_0

print 'plot c vs c'
sys.stdout.flush()

c_phase_plane = Graphics()
for i in maclev._population_indices:
    ci = [ rescomp._indexers['c'][i][0], rescomp._indexers['c'][i][1] ]
    c_phase_plane += c_evolution.plot( ci[0], ci[1], color=[ 'blue', 'red' ][i] )

c_phase_plane.axes_labels( [ '$c_0$', '$c_1$' ] )
c_phase_plane.save( 'maclev-2-2-a-c-c-vs-c.png', figsize=(6,6), xmin=0, ymin=0 )

ltx.close()
save_session( 'maclev-2-2-a-c-p' )
