# requires: maclevmodels.py $(SageAdaptiveDynamics)/adaptivedynamics.py maclev-1-1-adap.sobj
# requires: $(SageUtils)/latex_output.py
# produces: maclev-1-1-mc-adap-geom.sobj maclev-1-1-mc.png maclev-1-1-mc-adap-geom.sage.out.tex
from sage.all import *

import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )

from maclevmodels import *
from adaptivedynamics import *
from latex_output import *

from sage.symbolic.function_factory import function

load_session("maclev-1-1-adap")

# Notes: whoo, boy, I need to abstract out more of this and make this
# file simpler!

ltx = latex_output( 'maclev-1-1-mc-adap-geom.sage.out.tex' )

# Now: project the p vector into two dimensions, for the 1-species
# model (e.g. plot b_1 and c_11).  Plot the curve defined by p(u) (for
# one-dimensional u), together with S(p) and the projection of S(p) onto
# the curve.

# This is the adaptive dynamics of unconstrained p, and its rhs is gamma X S(p)
maclev_p = MacArthurLevinsModel( x_indices = [0], r_indices = [0] )

maclev_adap_p = AdaptiveDynamicsModel( maclev_p,
    [ indexer('b'), indexer('m'), indexer(lambda i:'c_%s_0'%i) ])

b_0, m_0, c_0_0 = SR.var('b_0 m_0 c_0_0')
p = vector( (b_0, m_0, c_0_0) )

p_symb = SR.var( 'p', latex_name='\mathbf p' )
S_symb = function( 'S', print_latex_func=lambda f, v : r'\mathbf S(%s)' % latex(v) )

# now we recast b_0, m_0, c_0_0 to be functions of u_0, the phenotype

change_p_to_functions = Bindings( { 'c_0_0':function('c_0')(u_0), 'm_0':function('m')(u_0), 'b_0':function('b')(u_0) } )

flow_p_func = vector( change_p_to_functions(maclev_adap_p._flow[v]) for v in p )
p_func = vector( change_p_to_functions(v) for v in p )
#dp_du = diff(p_func, u_0)
#print 'dp/du =', dp_du

pf_symb = function( 'p', print_latex_func=lambda f, v : r'\mathbf p(%s)' % latex(v) )
#ltx.write( 'Now we change these 3 characters to be functions of $u$:\n\\[ ',
#  latex( pf_symb( u_0 ) ), ' = ',
#  latex( column_vector( p_func ) ), ', \\]\n',
#  '\\[ ', latex( S_symb( pf_symb( u_0 ) ) ), ' = ',
#  latex( column_vector( flow_p_func ) ), ' \\]\n' )

#print 'S(u) =', (S_p_func.dot_product(dp_du))

# Now the version with p constrained to (0, 0, u)
#identity(x) = x
#const_one(x) = 1
maclev_c00 = MacArthurLevinsModel( x_indices = [0], r_indices = [0],
       b = indexer(lambda i: 1),
       m = indexer(lambda i: 1),
       c = indexer(lambda i: indexer(lambda l: 'u_%s'%i)) )

#ltx.write( 'maclev_c00:' )
#ltx.write_block( maclev_c00 )

maclev_adap_c00 = AdaptiveDynamicsModel(maclev_c00, 
    [ indexer('u') ])

#ltx.write( 'Returning to the adaptive dynamics, with $c_0(u_0)=u_0$, $b(u_0) = m(u_0) = 1$:' )
#ltx.write_block( maclev_adap_c00 )

maclev_adap_c00_bound = maclev_adap_c00.bind( Bindings( 
  { SR.var('r_0'): 1, SR.var('w_0'): 1,
    SR.var('K_0'): 2, SR.var('gamma'): 1 } ) )

#ltx.write( 'And with parameters bound:' )
#ltx.write_block( maclev_adap_c00_bound )

c00_evolution = maclev_adap_c00_bound.solve( [2] )

c00_bindings = c00_evolution._system._bindings.merge( FunctionBindings( {
    function('c_0'):u_0.function(u_0), function('m'):SR('1').function(u_0), function('b'):SR('1').function(u_0) } ) )

flow_p_bound = vector( (c00_bindings(s_i) for s_i in flow_p_func) )

S_p = vector( maclev_adap_p._S[ pi ] for pi in p )

#ltx.write( 'c00_bindings is ', latex( c00_bindings ) )

ltx.write( 'With $c_{00}=u_0$, the vector $\mathbf p$ is ' )
ltx.write_equality(  p_symb, column_vector( p ),
  column_vector( c00_bindings( change_p_to_functions( pi ) ) for pi in p ) )
ltx.write( 'And the selection gradient of $\mathbf p$ is ' )
ltx.write_equality( S_symb( p_symb ),
  column_vector( S_p ),
  column_vector( c00_bindings( change_p_to_functions( si ) ) for si in S_p ) )

#ltx.write( 'And with these bindings,\n\\[ ',
#  latex( S_symb( pf_symb( u_0 ) ) ),
#  ' = ', latex( column_vector( flow_p_bound ) ), ' \\]\n' )

dp_du_bound = vector( (diff(c00_bindings(p_i),u_0) for p_i in p_func) )

ltx.write( 'The derivative of $\mathbf p$ is \n\\[\n  ',
  '\\frac{d%s}{d%s}' % ( latex( p_symb ), latex( u_0 ) ), ' = ',
  latex( column_vector( dp_du_bound ) ), ', \\]\n' )
ltx.write( 'and we can recover the motion of $u_0$: \n\\[ ',
  latex( S_symb( u_0 ) ),
  ' = \\frac{d%s}{d%s}^\mathrm{T} %s = ' % ( latex(p_symb), latex(u_0), latex( S_symb( pf_symb( u_0 ) ) ) ),
  latex( c00_bindings( change_p_to_functions( dp_du_bound.dot_product( S_p ) ) ) ), ' \\]\n' )
ltx.write_equality( wrap_latex( '\\frac{du_0}{dt}' ),
  wrap_latex( '\\gamma\\hat X_0 %s' %  latex( S_symb( u_0 ) ) ),
  latex( c00_bindings( change_p_to_functions( SR('gamma') * X_0 * dp_du_bound.dot_product( S_p ) ) ) ) )

ltx.write( 'and the motion of $\\mathbf p(u_0)$:' )
ltx.write_equality( wrap_latex( '\\frac{d\\mathbf p(u_0)}{dt}' ),
  wrap_latex( '\\gamma\\hat X_0 \\frac{d\\mathbf p}{du_0} \\frac{d\\mathbf p}{du_0}^\\mathrm{T} %s' %  latex( S_symb( pf_symb( u_0 ) ) ) ),
  latex( column_vector( c00_bindings( change_p_to_functions( z ) ) for z in SR('gamma') * X_0 * dp_du_bound * dp_du_bound.dot_product( S_p ) ) ) );

# OK, so that seems to be right, so we ought to be able to plot S(p)
# and the actual motion of p on the constraint curve defined by p(u),
# on the b-c plane (letting m be fixed).
 
#mc_points = c00_evolution.plot( c00_bindings(p_func[1]), c00_bindings(p_func[2]),
#  xlabel='m_0', ylabel='c_{00}' )
initcond_bindings = Bindings( {u_0: initial_u} )
p_0 = vector( (initcond_bindings(c00_bindings(p_i)) for p_i in p_func) )
flow_p_0 = vector( (initcond_bindings(f_i) for f_i in flow_p_bound) )

ltx.write( 'So now we can get a look at the geometry of $%s$.' % latex( p_symb ),
  '  At $u_0=', latex(initial_u), '$,\n\\[ ',
  latex( p_symb ), ' = ', latex( column_vector( p_0 ) ), ', \\]\n\\[ ',
  latex( S_symb( p_symb ) ), ' = ', latex( column_vector( initcond_bindings( c00_bindings( change_p_to_functions( si ) ) ) for si in S_p ) ), ' \\]\n' )

if 1:
    flow_p_arrow = arrow( (p_0[1], p_0[2]), (p_0[1]+flow_p_0[1], p_0[2]+flow_p_0[2]),
      color=(1,0,0), width=1 )
    p_func_bound = vector( (c00_bindings(f) for f in p_func) )
    ltx.write( 'The constraint curve for $%s$:' % latex( pf_symb( u_0 ) ),
      ' is \n\\[ ', latex( column_vector( p_func ) ), ' = ',
       latex( column_vector( p_func_bound ) ), ' \\]\n' )
    mc_constraint = parametric_plot( (p_func_bound[1], p_func_bound[2]),
      (u_0, initial_u - 0.25, initial_u + 1.5) )
    dp_du_0 = vector( (initcond_bindings(d_i) for d_i in dp_du_bound) )
    du_dt_0 = initcond_bindings(c00_bindings( maclev_adap_c00._flow[u_0] ) )
    dp_dt_0 = vector( (initcond_bindings(c00_bindings(
      d_i*du_dt_0 )) for d_i in dp_du_0) )
    ltx.write( 'And on that curve, \n\\[ ',
      '\\left.\\frac{d%s}{dt}\\right|_{u_0=%s} = ' % ( latex( pf_symb( u_0 ) ), latex( initial_u ) ),
      latex( column_vector( dp_dt_0 ) ), ' \\]\n' )
    dp_dt_arrow = arrow( (p_0[1], p_0[2]), (p_0[1]+dp_dt_0[1], p_0[2]+dp_dt_0[2]),
      width=1 )
    # The arrow heads may not look like they're at the same y position but they are
    mc_geom = flow_p_arrow + mc_constraint + dp_dt_arrow # + mc_points
    mc_geom.set_axes_range( 0, 2, initial_u - 0.25, initial_u + 1.75 )
    mc_geom.axes_labels( ['$m_0$', '$c_{00}$'] )
    save(mc_geom, filename="maclev-1-1-mc.png", figsize=(4,4))

ltx.close()

save_session("maclev-1-1-mc-adap-geom")
