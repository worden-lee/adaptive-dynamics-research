# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# produces: maclev-1-1-d1A-vector-field.png
from dynamicalsystems import *
load_session( 'maclev-1-1-mc-adap-geom' )
fixed_parameter_bindings = Bindings( 
  { SR.var('r_0'): 1, SR.var('w_0'): 1, SR.var('b_0'): 1, SR.var('m_0'): 1,
    SR.var('K_0'): 2, SR.var('gamma'): 1 } )
outer = 3
var( 'a k' )
c = symbolic_expression( '(k + b_0 *m_0) / (b_0 w_0 K_0)' )
print c
# removed 'change to functions' bindings call
# probably need to put it back
vf = [ fixed_parameter_bindings( c00_bindings( e ) ) for e in [ c * symbolic_expression('- b_0 * w_0 / r_0'), symbolic_expression( 'K_0 * b_0 * w_0' ) ] ]
print vf; sys.stdout.flush()
vfp = plot_vector_field( vf, [a,-outer,0], [k,0,outer], color='green', figsize=(4,4), frame=false );
vfp.axes_labels( [ '$a$', '$k$' ] );
vfp.save( 'maclev-1-1-d1A-vector-field.png' );
