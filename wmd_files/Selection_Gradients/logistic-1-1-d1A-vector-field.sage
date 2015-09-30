# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# produces: logistic-1-1-d1A-vector-field.png
import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )
from dynamicalsystems import *
from adaptivedynamics import *
load_session( 'maclev-1-1-mc-adap-geom' )
fixed_parameter_bindings = Bindings( 
  { SR.var('r_0'): 1, SR.var('w_0'): 1,
    SR.var('K_0'): 2, SR.var('gamma'): 1 } )
outer = 3
var( 'a k' )
c = symbolic_expression( '(k + b_0 *m_0) / (b_0 w_0 K_0)' )
vf = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( e ) ) ) for e in [ c * symbolic_expression('- b_0 * w_0 / r_0'), symbolic_expression( 'K_0 * b_0 * w_0' ) ] ]
print vf; sys.stdout.flush()
vfp = plot_vector_field( vf, [a,-outer,0], [k,0,outer], color='green', figsize=(4,4), frame=false );
vfp.axes_labels( [ '$a$', '$k$' ] );
vfp.save( 'logistic-1-1-d1A-vector-field.png' );
