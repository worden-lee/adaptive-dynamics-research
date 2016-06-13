# requires: sea-up.sobj
# produces: sea-up-a.sage.out.tex
# produces: sea-up-a.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems, lotkavolterra
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-up' )
for k,l in _save_symbols.iteritems():
	#print k,l
	SR.symbol( k, latex_name=l ) 

ltx = dynamicalsystems.latex_output( 'sea-up-a.sage.out.tex' )

type_letters = [ 0, 0 ]
type_letters[seamodel.type_H] = H
type_letters[seamodel.type_g] = g
class sea_a_indexer(dynamicalsystems.indexer_2d_inner):
	def __getitem__(self, j):
		return subscriptedsymbol(self._f, type_letters[self._i[0]], self._i[1], type_letters[j[0]], j[1])

class sea_r_indexer(dynamicalsystems.indexer):
	def __getitem__(self, i):
		return subscriptedsymbol(self._f, type_letters[i[0]], i[1])

uplv = lotkavolterra.LotkaVolterraAdaptiveDynamics( sea_adap_up_n,
	a_name_indexer=dynamicalsystems.indexer_2d( 'a', inner_class=sea_a_indexer ),
	r_name_indexer=sea_r_indexer('r')
)

aap = lotkavolterra.plot_aij_with_arrows( adap_traj, uplv )
aap.axes_labels( [ '$a_{ij}$', '$a_{ji}$' ] )
aap.save( 'sea-up-a.svg', figsize=(5,5) )

ltx.write( 'For $a_{Gh}$,\n' )
ltx.write( dynamicalsystems.dgroup(
      [ [ SR('A'), uplv.A_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ],
	[ SR('S'), uplv.S_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ],
	[ SR('D'), uplv.D_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ],
	[ SR('I'), uplv.I_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ],
	[ SR('dA/dt'), uplv.dAdt_pair( (seamodel.type_g,0), (seamodel.type_H,0) ) ],
      ], '='
) )

ltx.close()
