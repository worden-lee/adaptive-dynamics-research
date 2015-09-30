# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# produces: logistic-1-1-S-and-D-on-curve.png
import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )
from dynamicalsystems import *
from adaptivedynamics import *
from plot_vector_field_along_curve import *
load_session( 'maclev-1-1-mc-adap-geom' )
var( 'b_0 c m_0 w_0 r_0 K_0 gamma' )
fixed_parameter_bindings = Bindings( 
  { r_0: 1, w_0: 1,
    K_0: 2, gamma: 1 } )
curve = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( e ) ) ) for e in [ - b_0 * c * c * w_0 / r_0, K_0 * b_0 * c * w_0 - b_0 * m_0 ] ]
vf_S = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( e ) ) ) for e in [ - curve[1]/curve[0], 1 ] ]
vf_D = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( (K_0 * w_0 - m_0/c) * (b_0**2 * m_0 / c) * e ) ) ) for e in [ - 1, r_0 * K_0 / c ] ]
crange = (c, 0.5, 1.2)
cp = parametric_plot( curve, crange, color='black' )
vfp_S = plot_vector_field_on_curve( vf_S, curve, crange, color='red', frame=false );
vfp_D = plot_vector_field_on_curve( vf_D, curve, crange, color='green', frame=false );
p = cp + vfp_S + vfp_D
p.axes_labels( [ '$a$', '$k$' ] );
p.save( 'logistic-1-1-S-and-D-on-curve.png', figsize=(4,4) );
