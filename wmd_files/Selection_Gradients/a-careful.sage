# produces: a-careful.sage.out.tex
import os
import sys
sys.path.append( os.environ["SageUtils"] )
from latex_output import *
ltx = latex_output( "a-careful.sage.out.tex" )
from maclevmodels import *
def cvector( *args ):
    return matrix( *args ).transpose()
ltx.write_equality( wrap_latex( 'A_i' ),
    cvector( [ - c_var('i','0')*c_var('j',0)*SR('b_i w_0/r_0'),
    c_var('i',0) * SR('K_0 w_0 b_i') - SR('m_i b_i') ] ) )
ltx.close()
