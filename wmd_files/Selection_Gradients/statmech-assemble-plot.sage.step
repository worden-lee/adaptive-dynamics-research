# requires: statmech.py
# requires: statmech-assemble.sobj
# produces: statmech-assemble.sage.out.tex statmech-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import statmech
import dynamicalsystems

load_session( 'statmech-assemble' )

ltx = dynamicalsystems.latex_output( 'statmech-assemble.sage.out.tex' )

ltx.write( smr )

ltx.close()

soln.plot( 't', smr._vars, ylabel='$X$' ).save( filename='statmech-assemble.svg' )
