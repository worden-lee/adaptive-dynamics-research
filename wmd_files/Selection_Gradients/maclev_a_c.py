# requires: maclev_2_2_defs.py
from maclev_2_2_defs import *

c = rescomp._indexers['c']

# special choice of m to make k unevolvable
m_const = -1
bm_bindings = Bindings( dict(
    [ (rescomp._indexers['b'][i], 1) for i in (0,1,2,3) ] +
    [ (rescomp._indexers['m'][i], K_0*c[i][0] + K_1*c[i][1] + m_const) for i in (0,1,2,3) ]
) )

ad_bindings = bm_bindings + gamma_bindings
initial_conditions = Bindings( {
    rescomp._indexers['c'][0][0] : Rational('3/5'),
    rescomp._indexers['c'][0][1] : Rational('2/5'),
    rescomp._indexers['c'][1][0] : Rational('2/5'),
    rescomp._indexers['c'][1][1] : Rational('3/5')
} )
