# requires: sea-down.sobj
# produces: sea-tran.sage.out.tex
# produces: sea-tran-ts.svg sea-tran-sel.tex
from sage.all import * 
from sage.misc.latex import _latex_file_
from dynamicalsystems import *
from seamodel import *

load_session( 'sea-down' )
for k,l in _save_symbols.iteritems(): SR.symbol( k, latex_name=l ) 

ltx = latex_output( 'sea-tran.sage.out.tex' )

sea_tran = sea_f.bind( base_b, fixed_ass_b, diag_tran_b )

ltx.write( 'To study the incentive structure for transfer, we set', diag_tran_b, fixed_ass_b )

ltx.write( 'Dynamics with transfer only:', sea_f.bind( base_b, fixed_ass_b ) )
ltx.write( 'Or', sea_tran )

sea_adap_tran_formal = sea_adap_f.bind( base_b, fixed_ass_b )
sea_adap_tran = sea_adap_tran_formal.bind( diag_tran_b )
ltx.write( 'And its adaptive dynamics is' )
ltx.write(
	dgroup( [ [ dot(v), latex_partials_representation()( sea_adap_tran_formal._flow[v] ) ] for v in sea_adap_tran_formal._vars ], op='=' ),
	'Or ', sea_adap_tran )

sea_adap_tran.bind_in_place( seaquil[0], p=1 )
#ltx.write( 'With equilibrium populations is', sea_adap_tran )
#ltx.write( 'And at starting point ', vector( [ starting_comm(v) for v in sea_adap_tran._vars ] ), ' is', starting_comm(sea_adap_tran) )

adap_traj = sea_adap_tran.solve( starting_comm )
adap_traj.plot( 't', [ t_indexer[i] for i in sea_adap_tran._popdyn_model._population_indices ] ).save( filename='sea-tran-ts.svg', figsize=(4,3) )

ltx.close()

ltx = latex_output( 'sea-tran-sel.tex' )

ltx.write( 'The selective pressures on investment are' )
ltx.write( dgroup( [ [ t_indexer[i], latex_partials_representation()( sea_adap_tran_formal._S[t_indexer[i]] ) ] for i in sea_adap_tran._popdyn_model._population_indices ], op=r'\to' ) )

ltx.write( 'So the condition for increase in guest investment is' )
ltx.write_block( latex_partials_representation()( sea_adap_tran_formal._S[t_indexer[(seamodel.type_g,0)]] ) > 0 )

ltx.write( 'And for increase in host investment' )
ltx.write_block( latex_partials_representation()( sea_adap_tran_formal._S[t_indexer[(seamodel.type_H,0)]] ) > 0 )

ltx.close()
save_session('sea-tran')
