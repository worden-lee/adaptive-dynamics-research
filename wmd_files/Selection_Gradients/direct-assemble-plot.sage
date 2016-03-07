# requires: direct.py
# requires: direct-assemble.sobj
# produces: direct-assemble.sage.out.tex direct-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import direct
import dynamicalsystems

load_session( 'direct-assemble' )

ltx = dynamicalsystems.latex_output( 'direct-assemble.sage.out.tex' )

ltx.write( comm2 )

ltx.close()

#soln.plot( 't', comm2._vars, ylabel='$X$' ).save( filename='direct-assemble.svg' )
