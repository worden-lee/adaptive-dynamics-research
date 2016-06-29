# requires: sealv.py
# requires: sea-ass.sobj
# produces: sea-ass-a.sage.out.tex
# produces: sea-ass-a.svg
from sealv import *
from seamodel import *
from dynamicalsystems import *
import lotkavolterra
from ww_sage_util import ww_load_session

ww_load_session( 'sea-ass', locals() )
#for k,l in _save_symbols.iteritems():
#	SR.symbol( k, latex_name=l ) 

ltx = latex_output( 'sea-ass-a.sage.out.tex' )

lv_ass = lotkavolterra.LotkaVolterraAdaptiveDynamics( sea_adap_ass_formal,
	a_name_indexer=indexer_2d( 'a', inner_class=sea_a_indexer ),
	r_name_indexer=sea_r_indexer('r')
)

lv_ass_n = lotkavolterra.LotkaVolterraAdaptiveDynamics( sea_adap_ass,
	a_name_indexer=indexer_2d( 'a', inner_class=sea_a_indexer ),
	r_name_indexer=sea_r_indexer('r')
)

#uplv_n = lotkavolterra.LotkaVolterraAdaptiveDynamics( sea_adap_up_n,
#	a_name_indexer=indexer_2d( 'a', inner_class=sea_a_indexer ),
#	r_name_indexer=sea_r_indexer('r')
#)

ltx.write(
	"The population dynamics of this version:\n",
	lv_ass._adaptivedynamics._popdyn_model,
	"In this case, all the selection is on the $a$ terms.\n"
)

ltx.write( dgroup(
      [ [ SR('A'),
	  lv_ass._lv_model._A_bindings( lv_ass.A_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) )
	],
	[ SR('S'),
	  lv_ass.S_pair( (seamodel.type_g,0), (seamodel.type_H,0) )
	],
	[ SR('D'),
	  lv_ass.D_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( latex_partials_representation() ),
	  lv_ass._phenotypes_to_fn_bindings( lv_ass.dudt_bindings()( lv_ass.D_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ) ).apply_map( latex_partials_representation() ),
	  #lv_ass_n.D_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( latex_partials_representation() )
	],
	[ SR.symbol('I'),
	  lv_ass.I_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( latex_partials_representation() ),
	  lv_ass._phenotypes_to_fn_bindings( lv_ass.dudt_bindings()( lv_ass.I_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ) ).apply_map( latex_partials_representation() ),
	  #lv_ass_n.I_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( latex_partials_representation() )
	],
	[ SR('dA/dt'),
	  lv_ass.dAdt_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( latex_partials_representation() ),
	  lv_ass._phenotypes_to_fn_bindings( lv_ass.dudt_bindings()( lv_ass.dAdt_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ) ).apply_map( latex_partials_representation() ),
	  lv_ass_n.dAdt_pair( (seamodel.type_g,0), (seamodel.type_H,0) ).apply_map( latex_partials_representation() )
	],
      ], '='
) )

ltx.write( "The dynamics of the character variables are\n" )
ltx.write( dgroup(
      [ [ latex_partials_representation()( diff( lv_ass._phenotypes_to_fn_bindings(x), t ) ),
	  latex_partials_representation()( lv_ass._adaptivedynamics._flow[x] )
	]  for x in lv_ass._adaptivedynamics._vars ], '='
) )
ltx.close()
 
lotkavolterra.plot_single_aij_pair(
	(seamodel.type_g,0), (seamodel.type_H,0), 
	adap_traj._timeseries[0],
	lv_ass_n,
	filename='sea-ass-a.svg'
)
