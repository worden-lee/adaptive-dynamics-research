# requires: sea-down.sobj
# produces: sea-all.sage.out.tex sea-all-sel.tex
# produces: sea-all-ts.svg sea-all-values.svg
# produces: sea-all-ts2.svg sea-all-values2.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )
for k,l in _save_symbols.iteritems(): SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-all.sage.out.tex' )

sea_all = sea_f.bind( base_b, exp_ass_b, diag_tran_b )

ltx.write( 'To study the incentive structure for transfer, we set', exp_ass_b, diag_tran_b )

ltx.write( 'Dynamics:', sea_f.bind( base_b ) )
ltx.write( 'Or', sea_all )

sea_adap_all_formal = sea_adap_f.bind( base_b )
sea_adap_all = sea_adap_all_formal.bind( exp_ass_b, diag_tran_b )
ltx.write( 'And its adaptive dynamics is' )
ltx.write( sea_adap_all_formal, 'Or ', sea_adap_all )

sea_adap_all.bind_in_place( p=1 )
sea_adap_all_n = sea_adap_all.bind( seaquil[0] )

adap_traj = sea_adap_all_n.solve( starting_comm )
adap_traj.plot( 't', sea_adap_all_n._vars ).save( filename='sea-all-ts.svg', figsize=(4,3) )

adap_traj.plot( 't',
	[ SR('p(x_a_0,X_a_0)'), SR('b(x_t_0,X_t_0)'), SR('B(x_t_0,X_t_0)'),
	  SR('c_t(x_t_0)'), SR('c_a(x_a_0)'), SR('C_t(X_t_0)'), SR('C_a(X_a_0)'),
	]
).save( filename='sea-all-values.svg', figsize=(4,3) )

scomm2 = starting_comm.bind( X_t_0=0.008 )
adap_traj = sea_adap_all_n.solve( scomm2 )
adap_traj.plot( 't', sea_adap_all_n._vars ).save( filename='sea-all-ts2.svg', figsize=(4,3) )

adap_traj.plot( 't',
	[ SR('p(x_a_0,X_a_0)'), SR('b(x_t_0,X_t_0)'), SR('B(x_t_0,X_t_0)'),
	  SR('c_t(x_t_0)'), SR('c_a(x_a_0)'), SR('C_t(X_t_0)'), SR('C_a(X_a_0)'),
	]
).save( filename='sea-all-values2.svg', figsize=(4,3) )

scomm3 = dynamicalsystems.Bindings( x_a_0=0, x_t_0=0, X_a_0=0.001, X_t_0=0.001 )
adap_traj = sea_adap_all_n.solve( scomm3 )
adap_traj.plot( 't', sea_adap_all_n._vars ).save( filename='sea-all-ts3.svg', figsize=(4,3) )

adap_traj.plot( 't',
	[ SR('p(x_a_0,X_a_0)'), SR('b(x_t_0,X_t_0)'), SR('B(x_t_0,X_t_0)'),
	  SR('c_t(x_t_0)'), SR('c_a(x_a_0)'), SR('C_t(X_t_0)'), SR('C_a(X_a_0)'),
	  diff( SR('p(x_a_0,X_a_0)'), SR('x_a_0') ),
	  diff( SR('c_a(x_a_0)'), SR('x_a_0') )
	]
).save( filename='sea-all-values3.svg', legend_loc='right', figsize=(4,3) )

ltx.close()
save_session('sea-all')
