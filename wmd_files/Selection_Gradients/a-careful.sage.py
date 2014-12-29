# This file was *autogenerated* from the file a-careful.sage
from sage.all_cmdline import *   # import sage library
_sage_const_0 = Integer(0)# produces: a-careful.sage.out.tex
import os
import sys
sys.path.append( os.environ["SageUtils"] )
from latex_output import *
ltx = latex_output( "a-careful.sage.out.tex" )
from maclevmodels import *
def cvector( *args ):
    return matrix( *args ).transpose()
ltx.write_equality( wrap_latex( 'A_i' ),
    cvector( [ - c_var('i','0')*c_var('j',_sage_const_0 )*SR('b_i w_0/r_0'),
    c_var('i',_sage_const_0 ) * SR('K_0 w_0 b_i') - SR('m_i b_i') ] ) )
ltx.close()
