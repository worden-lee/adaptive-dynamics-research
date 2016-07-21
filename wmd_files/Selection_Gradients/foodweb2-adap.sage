# requires: foodweb2.py foodweb2.sobj
# produces: foodweb2-adap.sage.out.tex foodweb2-adap.sobj
from sage.all import * 

import foodweb2, dynamicalsystems

load_session("foodweb2")

ltx = dynamicalsystems.latex_output( 'foodweb2-adap.sage.out.tex' )

foodweb_adap_formal = dynamicalsystems.AdaptiveDynamicsModel( 
    foodweb_pred_prey,
    [ foodweb_pred_prey._u_indexer, foodweb_pred_prey._gamma_indexer, foodweb_pred_prey._sigma_indexer  ],
    early_bindings=fb,
    equilibrium = foodweb_pred_prey.symbolic_equilibria()
).bind( { 'gamma':1 } )

ltx.write( 'The foodweb adaptive dynamics:', foodweb_adap_formal.bind(fb) )

equil = foodweb_pred_prey.interior_equilibria()
print equil

#foodweb_adap = dynamicalsystems.AdaptiveDynamicsModel( 
#    foodweb_pred_prey,
#    [ foodweb_pred_prey._u_indexer, foodweb_pred_prey._gamma_indexer ],
#    early_bindings=fb,
#    equilibrium = dynamicalsystems.Bindings( equil[0] )
#).bind( { 'gamma':1 } )
foodweb_adap = foodweb_adap_formal.bind( equil[0] )

#ltx.write( 'Adaptive dynamics of model:\n', foodweb_adap )
#ltx.write_environment( 'align*', [ '\\\\\n  '.join( r'\frac{d%s}{dt} &\propto %s' % (latex(v), latex(foodweb_adap._S[v])) for v in foodweb_adap._vars ) ] )

ltx.close()

save_session('foodweb2-adap')
