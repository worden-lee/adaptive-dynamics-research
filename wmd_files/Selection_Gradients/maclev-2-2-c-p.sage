# requires: maclevmodels.py
# requires: maclev_2_2_defs.py maclev-2-2-c-adap.sobj
# produces: maclev-2-2-c-p.sage.out.tex maclev-2-2-c-c-vs-c.png
# produces: maclev-2-2-c-c-vs-t.png maclev-2-2-c-R-vs-t.png
# produces: maclev-2-2-c-c-vs-t.svg maclev-2-2-c-R-vs-t.svg
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

c_timeseries = Graphics()
colors = rainbow( len(maclev._population_indices) * len(rescomp._r_indices) )
for i in maclev._population_indices:
    for l in rescomp._r_indices:
	c_timeseries += c_evolution.plot( 't', rescomp._indexers['c'][i][l],
	   color=colors.pop(), legend_label='$c_{%d%d}$'%(i+1,l+1) )
c_timeseries.save( 'maclev-2-2-c-c-vs-t.png', figsize=(4,4), ymin=0 )
c_timeseries.save( 'maclev-2-2-c-c-vs-t.svg', figsize=(2,2), ymin=0 )

r_timeseries = Graphics()
colors = ['blue','red']
for l in rescomp._r_indices:
    r_timeseries += c_evolution.plot( 't',
	maclev._bindings( rescomp.add_hats()( rescomp._indexers['R'][l] ) ),
	color=colors.pop(),
	legend_label=latex( rescomp.add_hats()( rescomp._indexers['R'][l+1] ) ) )
r_timeseries.axes_labels( [ '$t$', '$\hat R$' ] )
r_timeseries.save( 'maclev-2-2-c-R-vs-t.png', figsize=(4,4), ymin=0 )
r_timeseries.save( 'maclev-2-2-c-R-vs-t.svg', figsize=(2,2), ymin=0 )

ltx.close()
save_session( 'maclev-2-2-c-p' )
