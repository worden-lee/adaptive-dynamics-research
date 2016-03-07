# requires: maclev_1_2_defs.py
# produces: maclev-1-2-popdyn.sage.out.tex maclev-1-2-popdyn.sobj
# produces: maclev-1-2-popdyn.png maclev-1-2-r-zngis.png maclev-1-2-c-vs-u.png 
from maclev_1_2_defs import *

print 'start'
sys.stdout.flush()

ltx = latex_output( 'maclev-1-2-popdyn.sage.out.tex' )

ltx.write( 'The Mac-Lev model in generic form: ' )
ltx.write_block( maclev )

ltx.write( 'The Mac-Lev model with $b, m$, and $c$ bound to functions of $u$:\n' )
ltx.write_block( maclev.bind( ad_bindings ) )

rescomp_initial_system = maclev._rescomp_model.bind( ad_bindings + numeric_params + initial_conditions )
rescomp_initial_system.plot_R_ZNGIs( filename='maclev-1-2-r-zngis.png', figsize=(4,4), ymin=0, ymax=4, xmin=0, xmax=4 )

print 'plot c vs u' 
sys.stdout.flush()

c_curve = plot( c_func( 0, 0 ), (u_0, 0, 1) )
c_curve += plot( c_func( 1, 1 ), (u_1, 0, 1), color="green" )
c_curve += point( initial_conditions( vector( [ u_0, c_func( 0, 0 ) ] ) ), color='blue', size=30 )
c_curve += point( initial_conditions( vector( [ u_0, c_func( 0, 1 ) ] ) ), color='blue', size=30 )
c_curve.axes_labels( [ '$u$', '$c_i(u)$' ] )
c_curve.save( 'maclev-1-2-c-vs-u.png', figsize=(4,4), ymin=0 )

ltx.close()

save_session('maclev-1-2-popdyn')
