# requires: S-A-vf.sobj
# produces: logistic-S-A-curve.png
from dynamicalsystems import *
from sage.symbolic.function_factory import function

load_session( 'S-A-vf.sobj' )
var( 'a k u' )
r = function('r', u)
K = function('K', u)
verhulst_AK_bindings = Bindings( k=r, a=-r/K )
verhulst_curve_form = verhulst_AK_bindings( vector( [k, a] ) )
verhulst_d1a_form = diff( verhulst_curve_form, u ) #vector( [ diff(r), diff(-r/K) ] )
verhulst_d1a_vf = verhulst_d1a_form * sign(verhulst_d1a_form*verhulst_AK_bindings(SA)) / verhulst_d1a_form.norm(2)

def plot_v_curve( bindings, urange ):
    return (
	plot( bindings(verhulst_curve_form), urange, color='black', parametric=True ) + 
	plot_vector_field_on_curve( bindings(verhulst_d1a_vf), bindings(verhulst_curve_form), urange, color='blue', frame=False )
    )

verhulst_SA = SAvf
verhulst_SA += plot_v_curve( FunctionBindings( r=SR(1), K=u ), (u,1/3,5) )
verhulst_SA += plot_v_curve( FunctionBindings( r=u, K=u ), (u,0,3) )
verhulst_SA += plot_v_curve( FunctionBindings( r=1/u+1, K=u ), (u,1/sqrt(3),3) )
verhulst_SA += plot_v_curve( FunctionBindings( r=1/u, K=u ), (u,1/sqrt(3),3) )

# pity about the labels
# wouldn't want anything to happen to them
verhulst_SA.axes_labels( [ '$k$', '$a$' ] );
verhulst_SA.save( 'logistic-S-A-curve.png', figsize=(5,5) )

