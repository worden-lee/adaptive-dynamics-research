# This file was *autogenerated* from the file direct-assemble-plot.sage
from sage.all_cmdline import *   # import sage library
# requires: direct.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageUtils)/latex_output.py
# requires: direct-assemble.sobj
# produces: direct-assemble.sage.out.tex direct-assemble.svg
from sage.all import *
from sage.misc.latex import _latex_file_

import direct
import latex_output
import dynamicalsystems

load_session( 'direct-assemble' )

ltx = latex_output.latex_output( 'direct-assemble.sage.out.tex' )

ltx.write( comm2 )

ltx.close()

#soln.plot( 't', comm2._vars, ylabel='$X$' ).save( filename='direct-assemble.svg' )
