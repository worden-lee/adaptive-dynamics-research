# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# requires: S-A-vf.sobj
# produces: maclev-S-A-curve.png
# produces: maclev-S-A-more-curve.png
from dynamicalsystems import *

load_session( 'S-A-vf.sobj' )
#load_session( 'maclev-1-1-mc-adap-geom' )
#var( 'b c m w r K gamma' )
#maclev_curve = fixed_parameter_bindings( c00_bindings(
#    vector( [ K_0 * b_0 * c * w_0 - b_0 * m_0, - b_0 * c * c * w_0 / r_0 ] )
#) )
#maclev_d1a = fixed_parameter_bindings( c00_bindings(
#    vector( [ K_0 * b_0 * w_0, - c * b_0 * w_0 / r_0 ] )
#) )

var( 'a k u u_1 r K w' )
idu = u.function(u)
u1 = SR(1).function(u)
def_bindings = Bindings( r=1, K=2, w=1, gamma=1 ) + FunctionBindings( { (v,(u,)):SR(1) for v in ('b','c','m') } )
b = function('b',u).function(u)
m = function('m',u).function(u)
c = function('c',u).function(u)
maclev_AK_bindings = Bindings( k=b(u)*(K*c(u)*w - m(u)), a=-b(u)*c(u)*c(u_1)*w/r )
uu_bindings = Bindings( u_1=u )
maclev_raw_ak = maclev_AK_bindings( vector( [k, a] ) )
maclev_curve_form = uu_bindings( maclev_raw_ak )
maclev_d1a_form = uu_bindings( diff( maclev_raw_ak, u ) )
maclev_d1a_vf = maclev_d1a_form * sign(maclev_d1a_form*uu_bindings(maclev_AK_bindings(SA))) / maclev_d1a_form.norm(2)

print 'maclev curve', maclev_curve_form
print 'maclev_d1a:', maclev_d1a_form
print 'd1a vf:', maclev_d1a_vf

def plot_v_curve( _bindings, urange ):
    bindings = def_bindings + _bindings
    print 'bindings:', bindings
    return (
	plot( bindings(maclev_curve_form), urange, color='black', parametric=True ) + 
	plot_vector_field_on_curve( bindings(maclev_d1a_vf), bindings(maclev_curve_form), urange, color='green', frame=False )
    )

print 'try curve:', (def_bindings + FunctionBindings( c=u.function(u) ))( maclev_curve_form )

maclev_SA = SAvf
maclev_SA += plot_v_curve( FunctionBindings( c=u.function(u) ), (u,0.55,2) )
maclev_SA += plot_v_curve( FunctionBindings( { ('c',(u,)):u, ('m',(u,)):SR(2) } ), (u,1.05,2) )
maclev_SA += plot_v_curve( FunctionBindings( { ('c',(u,)):u, ('m',(u,)):SR(1/2) } ), (u,0.3,2) )

evc = FunctionBindings( c=u.function(u), b=SR('b'), m=SR('m') )
print 'd1a on c(u):', evc( maclev_d1a_form )

# pity about the labels
# wouldn't want anything to happen to them
maclev_SA.axes_labels( [ '$k$', '$a$' ] );
maclev_SA.save( 'maclev-S-A-curve.png', figsize=(5,5) )

# again with some other functions
maclev_SA = SAvf
maclev_SA += plot_v_curve( FunctionBindings( { ('c',(u,)):SR(1), ('m',(u,)):u } ), (u,0.85,2) )
maclev_SA += plot_v_curve( FunctionBindings( { ('c',(u,)):u, ('m',(u,)):1/u } ), (u,0.8,2) )
# pity about the labels
# wouldn't want anything to happen to them
maclev_SA.axes_labels( [ '$k$', '$a$' ] );
maclev_SA.save( 'maclev-S-A-more-curve.png', figsize=(5,5) )
