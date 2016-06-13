# requires: masel_model.py
# requires: masel-model.sobj
# produces: masel-adap.tex
from sage.all import *
import masel_model
import dynamicalsystems

load_session( 'masel-model' )

masel_adap = dynamicalsystems.AdaptiveDynamicsModel( masel, [ dynamicalsystems.indexer('r'), dynamicalsystems.indexer('c'), dynamicalsystems.indexer('K') ] )

from dynamicalsystems import latex_output, column_vector, wrap_latex
ltx = latex_output( 'masel-adap.tex' )
Sv = column_vector( [ masel_adap._S[x] for x in masel_adap._vars ] )
ltx.write_equality( wrap_latex( 'S' + latex( column_vector( masel_adap._vars ) ) ), Sv, masel_adap._bindings( Sv ) )
ltx.close()
