# requires: sealv.py
# requires: sea-up.sobj
# produces: sea-up-a.sage.out.tex
# produces: sea-up-a.svg
from sealv import *
from seamodel import *
import dynamicalsystems, lotkavolterra

load_session( 'sea-up' )
for k,l in _save_symbols.iteritems():
	SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-up-a.sage.out.tex' )

uplv = lotkavolterra.LotkaVolterraAdaptiveDynamics( sea_adap_c,
	a_name_indexer=dynamicalsystems.indexer_2d( 'a', inner_class=sea_a_indexer ),
	r_name_indexer=sea_r_indexer('r')
)

uplv_n = lotkavolterra.LotkaVolterraAdaptiveDynamics( sea_adap_up_n,
	a_name_indexer=dynamicalsystems.indexer_2d( 'a', inner_class=sea_a_indexer ),
	r_name_indexer=sea_r_indexer('r')
)

ltx.write( 'For $a_{gH}$,\n' )
ltx.write( dynamicalsystems.dgroup(
      [ [ SR('A'),
	  uplv._lv_model._A_bindings( uplv.A_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) )
	],
	[ SR('S'),
	  uplv.S_pair( (seamodel.type_g,0), (seamodel.type_H,0) )
	],
	[ SR('D'),
	  uplv.D_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( dynamicalsystems.latex_partials_representation() ),
	  uplv_n.D_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( dynamicalsystems.latex_partials_representation() )
	],
	[ SR.symbol('I'),
	  uplv.I_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( dynamicalsystems.latex_partials_representation() ),
	  uplv_n.I_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( dynamicalsystems.latex_partials_representation() )
	],
	[ SR('dA/dt'),
	  uplv.dAdt_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( dynamicalsystems.latex_partials_representation() ),
	  uplv_n.dAdt_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( dynamicalsystems.latex_partials_representation() )
	],
      ], '='
) )

ltx.close()

aap = lotkavolterra.plot_aij_with_arrows( adap_traj, uplv_n, filename='sea-up-a.svg' )
