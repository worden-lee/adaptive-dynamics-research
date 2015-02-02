# requires: maclev_2_2_defs.py
from maclev_2_2_defs import *

ad_bindings = bm_bindings + gamma_bindings
initial_conditions = Bindings( {
    rescomp._indexers['c'][0][0] : Rational('1/2'),
    rescomp._indexers['c'][0][1] : Rational('1/4'),
    rescomp._indexers['c'][1][0] : Rational('1/4'),
    rescomp._indexers['c'][1][1] : Rational('1/2'),
} )
