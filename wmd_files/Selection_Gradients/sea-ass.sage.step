# requires: sea-down.sobj
# produces: sea-ass.sage.out.tex
# produces: sea-ass-ts.svg sea-ass-sel.tex
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )
for k,l in _save_symbols.iteritems(): SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-ass.sage.out.tex' )

sea_ass = sea_f.bind( base_b, exp_ass_b, fixed_tran_b )

ltx.write( 'To study the incentive structure for association, we set', exp_ass_b )

ltx.write( 'Dynamics with association only:', sea_f.bind( base_b, fixed_tran_b ) )
ltx.write( 'Or', sea_ass )

sea_adap_ass_formal = sea_adap_f.bind( base_b, fixed_tran_b )
sea_adap_ass = sea_adap_ass_formal.bind( exp_ass_b )
ltx.write( 'And its adaptive dynamics is' )
ltx.write( sea_adap_ass_formal, 'Or ', sea_adap_ass )

sea_adap_ass.bind_in_place( seaquil[0] )
#ltx.write( 'With equilibrium populations is', sea_adap_ass )
#ltx.write( 'And at starting point ', vector( [ starting_comm(v) for v in sea_adap_ass._vars ] ), ' is', starting_comm(sea_adap_ass) )

adap_traj = sea_adap_ass.solve( starting_comm )
adap_traj.plot( 't', [ a_indexer[i] for i in sea_adap_ass._popdyn_model._population_indices ] ).save( filename='sea-ass-ts.svg', figsize=(4,3) )

ltx.close()

ltx = dynamicalsystems.latex_output( 'sea-ass-sel.tex' )

ltx.write( 'The selective pressures on investment are' )
ltx.write( dynamicalsystems.dgroup( [ [ a_indexer[i], sea_adap_ass_formal._S[a_indexer[i]] ] for i in sea_adap_ass._popdyn_model._population_indices ], op=r'\to' ) )

ltx.write( 'So the condition for increase in guest investment is' )
ltx.write_block( sea_adap_ass_formal._S[a_indexer[(seamodel.type_g,0)]] > 0 )

ltx.write( 'And for increase in host investment' )
ltx.write_block( sea_adap_ass_formal._S[a_indexer[(seamodel.type_H,0)]] > 0 )

ltx.close()
save_session('sea-ass')
