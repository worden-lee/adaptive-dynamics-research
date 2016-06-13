# requires: sea-down.sobj
# produces: sea-zero.sage.out.tex
# produces: sea-zero-ts.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )
for k,l in _save_symbols.iteritems(): SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-zero.sage.out.tex' )

sea_zero = (zero_col_b + zero_exp_b)(sea_f)

ltx.write( 'Dynamics with no symbiosis:' )
ltx.write( sea_zero )

ltx.write( 'With', base_b )
sea_zero.bind_in_place( base_b )
ltx.write( sea_zero )

sea_adap_zero = sea_adap_f.bind( base_b, zero_col_b, zero_exp_b )
ltx.write( 'And its adaptive dynamics is' )
ltx.write( sea_adap_zero )

sea_adap_zero.bind_in_place( sea_zero.interior_equilibria()[0] )
#ltx.write( 'With equilibrium populations is', sea_adap_down )
#ltx.write( 'And at starting point ', vector( [ starting_comm(v) for v in sea_adap_zero._vars ] ), ' is', starting_comm(sea_adap_zero) )

adap_traj = sea_adap_zero.solve( starting_comm )
adap_traj.plot( 't', sea_adap_zero._vars ).save( filename='sea-zero-ts.svg', figsize=(4,3) )

ltx.close()
save_session('sea-zero')
