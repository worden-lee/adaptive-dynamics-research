# requires: masel_model.py
# requires: masel-model.sobj
# produces: masel-2-adap.tex
from sage.all import *
import masel_model
import dynamicalsystems

load_session( 'masel-model' )

masel2_adap = dynamicalsystems.AdaptiveDynamicsModel( masel2, [ dynamicalsystems.indexer('r'), dynamicalsystems.indexer('s'), dynamicalsystems.indexer('c'), dynamicalsystems.indexer('K') ] )

from dynamicalsystems import latex_output, column_vector, wrap_latex
ltx = latex_output( 'masel-2-adap.tex' )
Sv = column_vector( [ masel2_adap._S[x] for x in masel2_adap._vars ] )
ltx.write_equality( wrap_latex( 'S' + latex( column_vector( masel2_adap._vars ) ) ), Sv, masel2_adap._bindings( Sv ) )
ltx.close()

from dynamicalsystems import indexer
rf = SR('r(x)').operator()
sf = SR('s(x)').operator()
u = indexer('u')
m2u = masel_model.Masel2Model( 1, r=indexer( lambda i:rf(u[i]) ), s=indexer( lambda i:sf(u[i]) ) )

m2u_adap = dynamicalsystems.AdaptiveDynamicsModel( m2u, [ u, dynamicalsystems.indexer('c'), dynamicalsystems.indexer('K') ] )

ltx = latex_output( 'm2u-adap.tex' )
Sv = column_vector( [ m2u_adap._S[x] for x in m2u_adap._vars ] )
ltx.write_equality( wrap_latex( 'S' + latex( column_vector( m2u_adap._vars ) ) ), Sv, column_vector( [ s.collect_common_factors() for s in m2u_adap._bindings( Sv ) ] ) )
ltx.close()
