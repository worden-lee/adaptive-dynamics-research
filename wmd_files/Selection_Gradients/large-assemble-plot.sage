# requires: large.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageUtils)/latex_output.py
# requires: large-assemble.sobj
# produces: large-assemble.sage.out.tex large-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import large
import latex_output
import dynamicalsystems

load_session( 'large-assemble' )

ltx = latex_output.latex_output( 'large-assemble.sage.out.tex' )

ltx.write( smr )

ltx.close()

soln.plot( 't', smr._vars, ylabel='$X$' ).save( filename='large-assemble.svg' )
