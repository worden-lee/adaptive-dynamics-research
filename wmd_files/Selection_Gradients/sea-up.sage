# requires: sea-down.sobj
# produces: sea-up.sage.out.tex sea-up-sel.tex
# produces: sea-up-ts.svg sea-up-values.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )
for k,l in _save_symbols.iteritems():
	#print k,l
	SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-up.sage.out.tex' )

heavy_k_b = Bindings( k=20, K=20 )
vw_up_b = Bindings( V=15/2, W=1, v=1, w=15/2 )

sea_lin = sea_f.bind( heavy_k_b ).bind( base_b, linear_ass_b )
sea_vw = sea_lin.bind( linear_tran_b )
sea_up = sea_vw.bind( vw_up_b )

sea_adap_up_formal = sea_adap_f.bind( heavy_k_b ).bind( base_b )
sea_adap_lin = sea_adap_up_formal.bind( linear_ass_b )
sea_adap_vw = sea_adap_lin.bind( linear_tran_b )

ltx.write( 'To study the incentive structure for transfer, we set', heavy_k_b, linear_ass_b, linear_tran_b, sea_adap_vw )

from dynamicalsystems import dgroup
ltx.write( 'Equilibrium conditions are\n',
  dgroup( [ [ SR(x) for x in l ] for l in
      [ [ 'W', '2X_t' ],
	[ 'Vx_t', 'X_t^2 - WX_t + 8X_a', '8X_a - X_t^2' ],
	[ 'v', '2x_t' ],
	[ 'wX_t', 'x_t^2 - vx_t + 8x_a', '8x_a - x_t^2' ]
      ]
  ], '=' ),
  'So to have all $x$ values equal to $1/2$, we set\n',
  vw_up_b
)

sea_adap_up = sea_adap_vw.bind( vw_up_b )
ltx.write( 'for ', sea_adap_up )

sea_adap_up_n = sea_adap_up.bind( seaquil[0] )
a_g_H = SR.symbol('a_g_H',latex_name='a_{gH}' )
a_H_g = SR.symbol('a_H_g',latex_name='a_{Hg}' )
sea_adap_up_n.bind(
    a_g_H = SR('(B(x_t_0,X_t_0)-C_t(X_t_0))*p(x_a_0,X_a_0) - C_a(X_a_0)'),
    a_H_g = SR('(b(x_t_0,X_t_0)-c_t(x_t_0))*p(x_a_0,X_a_0) - c_a(x_a_0)')
)

adap_traj = sea_adap_up_n.solve( starting_comm, step=0.002 )
adap_traj.plot( 't', sea_adap_up_n._vars ).save( filename='sea-up-ts.svg', figsize=(4,3) )

adap_traj.plot( 't',
	[ SR('p(x_a_0,X_a_0)'), SR('b(x_t_0,X_t_0)'), SR('B(x_t_0,X_t_0)'),
	  'a_g_H', 'a_H_g'
	] + sea_adap_up._popdyn_model.equilibrium_vars()
).save( filename='sea-up-values.svg', figsize=(4,3) )

adap_traj.plot( 't',
	[ SR('c_t(x_t_0)'), SR('c_a(x_a_0)'), SR('C_t(X_t_0)'), SR('C_a(X_a_0)'),
	]
).save( filename='sea-up-c-values.svg', figsize=(4,3) )

ltx.close()
save_session('sea-up')
