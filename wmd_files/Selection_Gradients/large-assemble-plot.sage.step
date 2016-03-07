# requires: large.py
# requires: large-assemble.sobj
# produces: large-assemble.sage.out.tex large-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import large
import dynamicalsystems

load_session( 'large-assemble' )

ltx = dynamicalsystems.latex_output( 'large-assemble.sage.out.tex' )

ltx.write( smr )

ltx.close()

soln.plot( 't', smr._vars, ylabel='$X$' ).save( filename='large-assemble.svg' )
