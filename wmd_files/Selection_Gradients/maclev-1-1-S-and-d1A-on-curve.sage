# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# produces: maclev-1-1-S-and-d1A-on-curve.png
from dynamicalsystems import *
from plot_vector_field_along_curve import *
load_session( 'maclev-1-1-mc-adap-geom' )
var( 'b_0 c m_0 w_0 r_0 K_0 gamma' )
fixed_parameter_bindings = Bindings( 
  { r_0: 1, w_0: 1,
    K_0: 2, gamma: 1 } )

curve = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( e ) ) ) for e in [ - b_0 * c * c * w_0 / r_0, K_0 * b_0 * c * w_0 - b_0 * m_0 ] ]
vf_S = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( e ) ) ) for e in [ - curve[1]/curve[0], 1 ] ]
vf_d = [ fixed_parameter_bindings( c00_bindings( change_p_to_functions( e ) ) ) for e in [ - c * b_0 * w_0 / r_0, K_0 * b_0 * w_0 ] ]
crange = (c, 0.5, 1.2)
print curve; sys.stdout.flush()
cp = parametric_plot( curve, crange, color='black' )
vfp_S = plot_vector_field_on_curve( vf_S, curve, crange, color='red', frame=false );
vfp_d = plot_vector_field_on_curve( vf_d, curve, crange, color='green', frame=false );
p = cp + vfp_S + vfp_d
p.axes_labels( [ '$a$', '$k$' ] );
p.save( 'maclev-1-1-S-and-d1A-on-curve.png', figsize=(4,4) );
