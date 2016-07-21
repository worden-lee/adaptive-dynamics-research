# This file was *autogenerated* from the file avec.sage
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_0 = Integer(0)# produces: avec.sage.out.tex
import os
import sys
sys.path.append( os.environ["SageUtils"] )
from latex_output import *
ltx = latex_output( "avec.sage.out.tex" )
from maclevmodels import *
def cvector( *args ):
    return matrix( *args ).transpose()
c_00 = c_var(_sage_const_0 ,_sage_const_0 )
ltx.write_equality( wrap_latex('A'),
    cvector( [ SR.var('a_0_0', latex_name='a_{00}'), SR('k_0') ] ),
    cvector( [ - c_00**_sage_const_2 *SR('b_0 w_0/r_0'), c_00 * SR('K_0 w_0 b_0') - SR('m_0 b_0') ] ) )
ltx.close()