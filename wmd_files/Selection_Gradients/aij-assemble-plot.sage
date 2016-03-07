# requires: aij.py
# requires: aij-assemble.sobj
# produces: aij-assemble.sage.out.tex aij-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import aij
import dynamicalsystems

load_session( 'aij-assemble' )

ltx = dynamicalsystems.latex_output( 'aij-assemble.sage.out.tex' )

ltx.write( comm2 )

ltx.close()

#soln.plot( 't', comm2._vars, ylabel='$X$' ).save( filename='aij-assemble.svg' )
