# This file was *autogenerated* from the file maclev-2-2-a-c-p.sage
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_0p06 = RealNumber('0.06'); _sage_const_6 = Integer(6)# requires: maclevmodels.py
# requires: maclev_2_2_defs.py maclev-2-2-a-c-adap.sobj
# produces: maclev-2-2-a-c-p.sage.out.tex
# produces: maclev-2-2-a-c-c-vs-t.sage.out.tex maclev-2-2-a-c-c-vs-c.png
# produces: maclev-2-2-a-c-c-vs-t.png maclev-2-2-a-c-c-vs-t.svg
from maclev_a_c import *

load_session( 'maclev-2-2-a-c-adap' )

ltx = latex_output( 'maclev-2-2-a-c-p.sage.out.tex' )

# plot c vs t

print 'plot c vs t'
sys.stdout.flush()

t = c_evolution._system._time_variable

c_timeseries = Graphics()
for i in maclev._population_indices:
    ci = [ rescomp._indexers['c'][i][_sage_const_0 ], rescomp._indexers['c'][i][_sage_const_1 ] ]
    c_timeseries += c_evolution.plot( t, ci[_sage_const_0 ], color=[ 'blue', 'red' ][i] )
    c_timeseries += c_evolution.plot( t, ci[_sage_const_1 ], color=[ 'blue', 'red' ][i] )

c_timeseries.axes_labels( [ '$t$', '$c$' ] )
c_timeseries.save( 'maclev-2-2-a-c-c-vs-t.png', figsize=(_sage_const_6 ,_sage_const_6 ), xmin=_sage_const_0 , ymin=_sage_const_0  )
c_timeseries.save( 'maclev-2-2-a-c-c-vs-t.svg', figsize=(_sage_const_2 ,_sage_const_2 ), xmin=_sage_const_0 , ymin=_sage_const_0 , ticks=_sage_const_0p06  )

# plot c_1 vs c_0

print 'plot c vs c'
sys.stdout.flush()

c_phase_plane = Graphics()
for i in maclev._population_indices:
    ci = [ rescomp._indexers['c'][i][_sage_const_0 ], rescomp._indexers['c'][i][_sage_const_1 ] ]
    c_phase_plane += c_evolution.plot( ci[_sage_const_0 ], ci[_sage_const_1 ], color=[ 'blue', 'red' ][i] )

c_phase_plane.axes_labels( [ '$c_0$', '$c_1$' ] )
c_phase_plane.save( 'maclev-2-2-a-c-c-vs-c.png', figsize=(_sage_const_6 ,_sage_const_6 ), xmin=_sage_const_0 , ymin=_sage_const_0  )

ltx.close()
save_session( 'maclev-2-2-a-c-p' )
