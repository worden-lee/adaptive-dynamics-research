# requires: direct.py
# produces: direct-assemble.sobj
from sage.all import *
from sage.misc.latex import _latex_file_

import direct
import dynamicalsystems

set_random_seed(0)

N_pop = 1#5

comm2 = direct.DirectModel( 2 )

save_session( 'direct-assemble' )
