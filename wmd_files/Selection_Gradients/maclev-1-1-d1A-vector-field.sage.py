# This file was *autogenerated* from the file maclev-1-1-d1A-vector-field.sage
from sage.all_cmdline import *   # import sage library
_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_4 = Integer(4)# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# produces: maclev-1-1-d1A-vector-field.png
from dynamicalsystems import *
load_session( 'maclev-1-1-mc-adap-geom' )
fixed_parameter_bindings = Bindings( 
  { SR.var('r_0'): _sage_const_1 , SR.var('w_0'): _sage_const_1 , SR.var('b_0'): _sage_const_1 , SR.var('m_0'): _sage_const_1 ,
    SR.var('K_0'): _sage_const_2 , SR.var('gamma'): _sage_const_1  } )
outer = _sage_const_3 
var( 'a k' )
c = symbolic_expression( '(k + b_0 *m_0) / (b_0 w_0 K_0)' )
print c
# removed 'change to functions' bindings call
# probably need to put it back
vf = [ fixed_parameter_bindings( c00_bindings( e ) ) for e in [ c * symbolic_expression('- b_0 * w_0 / r_0'), symbolic_expression( 'K_0 * b_0 * w_0' ) ] ]
print vf; sys.stdout.flush()
vfp = plot_vector_field( vf, [a,-outer,_sage_const_0 ], [k,_sage_const_0 ,outer], color='green', figsize=(_sage_const_4 ,_sage_const_4 ), frame=false );
vfp.axes_labels( [ '$a$', '$k$' ] );
vfp.save( 'maclev-1-1-d1A-vector-field.png' );
