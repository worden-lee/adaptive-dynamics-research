# requires: maclevmodels.py $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: maclev-1-1.sobj maclev-1-1.sage.out.tex
from sage.all import * 
from sage.misc.latex import _latex_file_

import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
from maclevmodels import *
from latex_output import *

ltx = latex_output( 'maclev-1-1.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
rescomp = ResourceCompetitionModel(x_indices=[0], r_indices=[0])

ltx.write( 'The original resource competition system:' )
ltx.write_block( rescomp )

#print 'rescomp bindings:', rescomp._bindings

# now, we make the reduced system by putting the resources on a fast timescale
maclev = MacArthurLevinsModel(rescomp)

ltx.write( "And the Mac-Lev system derived from it: " )
ltx.write_block( maclev )

ltx.close()

save_session('maclev-1-1')
