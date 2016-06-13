# requires: sea-down.sobj
# produces: sea-col.sage.out.tex
# produces: sea-col-ts.svg sea-col-sel.tex
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )
for k,l in _save_symbols.iteritems(): SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-col.sage.out.tex' )

sea_col = sea_f.bind( base_b, col_b, fixed_exp_b )

ltx.write( 'To study the incentive structure for colonization, we set', col_b )
#ltx.write( 'This is asymmetric in that the probability of association grows when $X_c$ grows positive, and when $x_c$ separates from zero in either direction. ' )

ltx.write( 'Dynamics with colonization only:' )
ltx.write( sea_f.bind( base_b, fixed_exp_b ) )
ltx.write( 'Or', sea_col )

sea_adap_col_formal = sea_adap_f.bind( base_b, fixed_exp_b )
sea_adap_col = sea_adap_col_formal.bind( col_b )
ltx.write( 'And its adaptive dynamics is' )
ltx.write( sea_adap_col_formal, 'Or ', sea_adap_col )

sea_adap_col.bind_in_place( sea_col.interior_equilibria()[0] )
#ltx.write( 'With equilibrium populations is', sea_adap_col )
#ltx.write( 'And at starting point ', vector( [ starting_comm(v) for v in sea_adap_col._vars ] ), ' is', starting_comm(sea_adap_col) )

adap_traj = sea_adap_col.solve( starting_comm )
adap_traj.plot( 't', [ c_indexer[i] for i in sea_adap_col._popdyn_model._population_indices ] ).save( filename='sea-col-ts.svg', figsize=(4,3) )

ltx.close()

ltx = dynamicalsystems.latex_output( 'sea-col-sel.tex' )

ltx.write( 'The selective pressures on investment are' )
ltx.write( dynamicalsystems.Bindings( { c_indexer[i]:sea_adap_col_formal._S[c_indexer[i]] for i in sea_adap_col._popdyn_model._population_indices } ) )

ltx.write( 'So the condition for increase in guest investment is' )
ltx.write_block( sea_adap_col_formal._S[c_indexer[(seamodel.type_g,0)]] > 0 )

ltx.write( 'And for increase in host investment' )
ltx.write_block( sea_adap_col_formal._S[c_indexer[(seamodel.type_H,0)]] > 0 )

ltx.close()
save_session('sea-col')
