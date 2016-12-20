# requires: sea.sobj
# produces: sea-adap.sobj sea-adap.sage.out.tex
from sage.all import * 
from sage.misc.latex import _latex_file_
from dynamicalsystems import *
from seamodel import *

load_session( 'sea' )
ltx = dynamicalsystems.latex_output( 'sea-adap.sage.out.tex' )

sea_adap_c = AdaptiveDynamicsModel( 
    sea,
    [ sea._indexers[s] for s in ('r', 'c_g','c_a','c_t') ] +
    [ indexer( bcfn ), indexer( pcfn ) ],
    equilibrium=sea.symbolic_equilibria()
)

ltx.write( 'Whence the selective pressure on the ecological quantities is' )
ltx.write( dgroup( [ [ v, sea_adap_c._S[v] ] for v in sea_adap_c._vars ], op=r'\to' ) )
#ltx.write_environment( 'align*', '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex_math(v), latex_math(sea_adap_c._S[v])) for v in sea_adap_c._vars ) )

## phenotype indexers for sea correlation

from sage.symbolic.function_factory import function
sea_f = SeaSymbiosisModel(
	x_indices=[(type_H,0),(type_g,0)],
	r_indexer =indexer( rffn ),
	cg_indexer=indexer( cgffn ),
	ca_indexer=indexer( caffn ),
	ct_indexer=indexer( ctffn ),
	p_indexer =indexer( pffn ),
	b_indexer =indexer( bffn ),
	B_indexer =indexer( Bffn ),
	K_indexer =indexer( Kffn )
)

ltx.write( 'Dynamics with constraints:' )
ltx.write( sea_f )

sea_adap_f = AdaptiveDynamicsModel( 
    sea_f,
    [ a_indexer, t_indexer ],
    equilibrium=sea_f.symbolic_equilibria(),
    workaround_limits=True,
    late_bindings = Bindings( gamma=1 )
)

seaquil = sea_f.interior_equilibria()

ltx.write( 'And selective pressure on constraining characters is' )
ltx.write( dgroup( [ [ dot(v), latex_partials_representation()( sea_adap_f._S[v] ) ] for v in sea_adap_f._vars ], op=r'\propto' ) )

ltx.close()

_save_symbols = { sv:lv for sv,lv in ( (str(v), latex(v)) for v in sage.symbolic.ring.pynac_symbol_registry.values() ) if sv != lv }

save_session('sea-adap')
