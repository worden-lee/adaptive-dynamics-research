# requires: statmech.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageUtils)/latex_output.py
# requires: statmech-assemble.sobj
# produces: statmech-assemble.sage.out.tex statmech-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import statmech
import latex_output
import dynamicalsystems

load_session( 'statmech-assemble' )

ltx = latex_output.latex_output( 'statmech-assemble.sage.out.tex' )

ltx.write( smr )

ltx.close()

soln.plot( 't', smr._vars, ylabel='$X$' ).save( filename='statmech-assemble.svg' )
