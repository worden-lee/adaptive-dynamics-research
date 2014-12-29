# This file was *autogenerated* from the file maclev-1-1-ak-adap-geom.sage
from sage.all_cmdline import *   # import sage library
_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_7 = Integer(7); _sage_const_4 = Integer(4); _sage_const_8 = Integer(8); _sage_const_0p5 = RealNumber('0.5')# requires: maclevmodels.py maclev-1-1-mc-adap-geom.sobj
# requires: $(SageUtils)/latex_output.py
# produces: maclev-1-1-ak-adap-geom.png maclev-1-1-ak-adap-geom.sage.out.tex
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex

import os
import sys
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
sys.path.append( os.environ['SageAdaptiveDynamics'] )

from maclevmodels import *
from adaptivedynamics import *
from lotkavolterra import *
from latex_output import *

# create variables with custom latex names because load_session
# creates them wrong
# http://trac.sagemath.org/ticket/17559
for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
SR.symbol( 'c_0_0', latex_name='c_{00}' )
SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session("maclev-1-1-mc-adap-geom")

ltx = latex_output( 'maclev-1-1-ak-adap-geom.sage.out.tex' )

# and now: do the same for the A vector.  For this, plot S(A), the projection
# of S(A) onto the curve, the indirect effect of evolution, and the resultant
# motion, which is not generally restricted to the curve because of the
# indirect component.

maclev_adap_lv = LotkaVolterraAdaptiveDynamics( maclev_adap_bound, r_name='k' )

ltx.write( 'As before, the adaptive dynamics of $u$ is' )
ltx.write_equality( wrap_latex('\\mathbf S' + latex( maclev_adap_lv.A(_sage_const_0 ) )),
    maclev_adap_lv.S( maclev_adap_lv.A(_sage_const_0 ) ),
    maclev_adap_lv._lv_model.interior_equilibrium_bindings()( maclev_adap_lv.S( maclev_adap_lv.A(_sage_const_0 ) ) ) )
ltx.write_block( maclev_adap_lv._adaptivedynamics )

save_session( 'maclev-1-1-ak-adap-geom' )
ltx.close()
exit()

# Here is the Lotka-Volterra population model we will use, with one population,
# with simple parameters a_ij, k_i
maclev_lv = GeneralizedLotkaVolterraModel( [_sage_const_0 ], r = indexer('k') )

ltx.write( "Abstract Lotka-Volterra model corresponding to the 1-population Mac-Lev model:" )
ltx.write_block( maclev_adap_lv )

# Here is the adaptive dynamics of the Lotka-Volterra model
# We get the general S(A) using this unparametrized lv system; we'll add
# the dependence on u later
maclev_adap_lv = AdaptiveDynamicsModel( maclev_lv,
  [ indexer('k'), indexer(lambda i: 'a_%s_0'%i) ] )

A = cvector( ( SR.var('a_0_0'), SR.var('k_0') ) )
S_A = A.apply_map( lambda a: maclev_adap_lv._S[a] )

#print 'adaptive dynamics of %s:\n' % A, maclev_adap_lv
#print 'S_A:', S_A

#ltx.write( 'Generating the adaptive dynamics of $a$ and $k$:\n\\begin{quote}\n',
#    maclev_adap_lv._debug_output._output._str, '\n\\end{quote}\n' )

# now we derive the values of the L-V coefficients k_i and a_ij 
# from the mac-lev dynamics.

# this only works for a single variable - it would have to be more
# sophisticated to find the coefficients of multiple X's.  but it works
# fine with just X_0 and X_0^2.

def get_coeff( expr, vars, power ):
    for c, p in expr.coefficients( vars ):
        if p == power:
            return c

# Here is the population dynamics, with parameters as a function of u.
maclev_p_ij = MacArthurLevinsModel( x_indices = ['i','j'], r_indices = [_sage_const_0 ],
  b = indexer(lambda i:'b(u_%s)'%i),
  m = indexer(lambda i:'m(u_%s)'%i),
  c = indexer(lambda i: indexer(lambda l: function('c_%s'%l)(SR('u_%s'%i)) ) ) )

lvi = maclev_p_ij._flow[SR('X_i')].expand()
#ltx.write( 'In the $i,j$ LV system\n\\[ \\frac{dX_i}{dt} = ', latex(lvi), ' \\]\n\n' );

from sage.symbolic.function_factory import function
af = function('a')
kf = function ('k')
A_bindings = FunctionBindings(
  { af: get_coeff( get_coeff( lvi, SR('X_i'), _sage_const_1 ), SR('X_j'), _sage_const_1 ).function(SR('u_i'), SR('u_j')),
    kf: get_coeff( get_coeff( lvi, SR('X_i'), _sage_const_1 ), SR('X_j'), _sage_const_0 ).function(SR('u_i')) } )

# now do the adaptive dynamics with a, k bound to
# specific functions of u

# first make a L.V. model with a, k as functions of u
maclev_lv_u = GeneralizedLotkaVolterraModel( [_sage_const_0 ],
  r = indexer(lambda i: kf(SR('u_%s'%i))),
  a = indexer(lambda i: indexer(lambda j: af(SR('u_%s'%i),SR('u_%s'%j)))) )

#ltx.write( 'now with $a$ and $k$ as functions of $u$:' )
#ltx.write_block( maclev_lv_u )

#ltx.write( 'with coefficients:' )
#ltx.write_block( A_bindings )

# then bind a, k to specific functions of u, to be precise, with
# c_0i = u_i, b_i = m_1 = 1
maclev_lv = maclev_lv_u.bind( A_bindings )
#ltx.write( 'becomes:' )
#ltx.write_block( maclev_lv )

#ltx.write( '(a 2-variable system would be ' )
#ltx.write_block( GeneralizedLotkaVolterraModel( [0, 1],
#  k = indexer(lambda i:'k(u_%s)'%i),
#  a = indexer(lambda i: indexer(lambda j: 'a(u_%s,u_%s)'%(i,j))),
#  bindings = A_bindings ) )
#ltx.write( ')... ' )

maclev_lv_c00 = maclev_lv.bind( FunctionBindings( {
    function('c_0'): u_0.function(u_0),
    function('b'): symbolic_expression('1').function(u_0),
    function('m'): symbolic_expression('1').function(u_0) } ) )

ltx.write( 'Now we bind $c, m, b$:' )
ltx.write_block( maclev_lv_c00 )
ltx.write( 'maclev_lv_c00._bindings:' )
ltx.write_block( maclev_lv_c00._bindings )

# assign constant values to the rest of the parameters
maclev_lv_c00_bound = maclev_lv_c00.bind( Bindings( 
  { SR.var('r_0'): _sage_const_1 , SR.var('w_0'): _sage_const_1 ,
    SR.var('K_0'): _sage_const_2 , SR.var('gamma'): _sage_const_1  } ) )

ltx.write( 'With all the bindings works out to:' )
ltx.write_block( maclev_lv_c00_bound )

# and derive the adaptive dynamics of u_0 under those assumptions,
# i.e. the adaptive dynamics of c_00 with all else held fixed.
maclev_adap_lv_c00_bound = AdaptiveDynamicsModel( maclev_lv_c00_bound,
  [ indexer('u') ], bindings = Bindings( gamma=_sage_const_1  ) )

#ltx.write( 'Generating the adaptive dynamics of $u$:\n\\begin{quote}\n',
#    maclev_adap_lv_c00_bound._debug_output._output._str, '\n\\end{quote}\n' )

ltx.write( 'As before, the adaptive dynamics of $u$ is' )
ltx.write_equality( wrap_latex('\\mathbf S' + latex( cvector( [ u_j for u_j in maclev_adap_lv_c00_bound._S.keys() ] ) ) ),
            cvector( [ dI_duj for dI_duj in maclev_adap_lv_c00_bound._S.values() ] ) )
ltx.write_block( maclev_adap_lv_c00_bound )

ltx.write( 'and' )
ltx.write_equality( X_0, maclev_adap_lv_c00_bound._bindings( X_0 ) )

# Initial condition for the adaptive dynamics of u_0
initcond_bindings = Bindings({u_0: initial_u})

# integrate the adaptive dynamics and get a numeric trajectory
lv_c00_evolution = maclev_adap_lv_c00_bound.solve( [_sage_const_0 ,initcond_bindings(u_0)] )

c00_bindings = maclev_adap_lv_c00_bound._bindings
#print 'c00_bindings:', c00_bindings

A_u = cvector( [ symbolic_expression('a(u_0,u_0)'), symbolic_expression('k(u_0)') ] )
A_u_binding = Bindings( a_0_0 = 'a(u_0,u_0)', k_0 = 'k(u_0)' )
S_A_u = S_A.apply_map( lambda s : A_u_binding(s) )
A_bound = A_u.apply_map( lambda a : c00_bindings(a) )
S_A_bound = S_A_u.apply_map( lambda s : c00_bindings(s) )
ltx.write( 'And now we can compare the different vector derivatives...' )
ltx.write_equality( SR('A'), A_u, A_bound )
ltx.write_equality( SR('S(A)'), S_A_u, S_A_bound )

A_0 = A_u.apply_map( lambda a : initcond_bindings(c00_bindings(a)) )
S_A_0 = S_A_u.apply_map( lambda s : initcond_bindings(c00_bindings(s)) )

A_c00 = c00_bindings(A_u)
#ltx.write_equality( SR('A(u_0,u_0)'), A_c00 )

# dA/du is different from the projection of S(A) into the first variable.
dA_du_bound = diff(A_c00,u_0)
dA_du_0 = initcond_bindings(dA_du_bound)

# now the direct and indirect parts.
# until I improve the AdaptiveDynamicsModel class, I have to redo some of
# what it does here.
maclev_u_ij = MacArthurLevinsModel(
  x_indices=['i','j'], r_indices=[_sage_const_0 ],
  b = indexer(lambda i:'b(u_%s)'%i),
  m = indexer(lambda i:'m(u_%s)'%i),
  c = indexer(lambda i: indexer(lambda l: function('c_%s'%l)(SR('u_%s'%i)))) )
X_i = SR.var('X_i')
X_j = SR.var('X_j')
f_j = maclev_u_ij._flow[X_j].collect(X_i)
#print 'f_i:', f_i
# there are better ways to do this, involving multivariate coefficients
f_over = limit((f_j/X_j).collect(X_i), X_j=_sage_const_0 )
#print 'f_i/X_i:', f_over
A_j = cvector( [ f_over.coeff(X_i,_sage_const_1 ), f_over.coeff(X_i,_sage_const_0 ) ] )
A_j = c00_bindings( A_j )
#v = SR.var('v')
#A_i = A_i.apply_map( lambda a : a.substitute( { SR.var('u_i') : v } ) )
u_0 = SR.var('u_0')
u_i = SR.var('u_i')
u_j = SR.var('u_j')

ltx.write_equality( SR('A_j(u_i,u_j)'), A_j )

#ltx.write_equality( SR('A_0(u_0,u_0)'), A_j.substitute( { u_i: u_0, u_j: u_0 } ) )

# So that's A.  Now we can plot its derivatives.

# first d1A = first partial of A
d1A = diff(A_j,u_j).substitute( { u_i: u_0, u_j: u_0 } )
ltx.write( 'So' )
ltx.write_equality( wrap_latex('\\partial_1\mathbf A(u_i,u_j)'), d1A )

# now d2A = second partial
d2A = diff(A_j,u_i).substitute( { u_i: u_0, u_j: u_0 } )
ltx.write_equality( wrap_latex('\\partial_2\mathbf A(u_i,u_j)'), d2A )

#ltx.write_equality( wrap_latex('\\partial_1\mathbf A \\partial_1\mathbf A^T'), (dAdv * dAdv.transpose()) )

d1ATS = ( d1A.transpose() * S_A_bound ).apply_map( lambda i : i.rational_simplify() )
ltx.write_equality( wrap_latex('\\partial_1\mathbf A^T S(A)'), d1ATS )

ltx.write( 'so' )

ltx.write_equality( wrap_latex('\\partial_1\mathbf A\\partial_1\mathbf A^T S(\mathbf A)'), d1A * d1ATS )

d1A_curve = A_j.substitute( { u_j : initial_u } )
#ltx.write( 'and the mysterious curve (for $v\in[%s,%s]$) is' %(initial_u-2,initial_u+2) )
#ltx.write_block( d1A_curve )
 
d1A_constraint = parametric_plot( (d1A_curve[_sage_const_0 ], d1A_curve[_sage_const_1 ]),
  (u_i, initial_u-_sage_const_2 , initial_u+_sage_const_2 ), color='green' )
#dAdv   = dAdv.substitute({u_0: initial_u, v: initial_u})
#dAdu_0 = dAdu_0.substitute({u_0: initial_u, v: initial_u})

#ltx.write( 'dA(v,u_0)/dv:\n' )
#ltx.write_block( dAdv )
#ltx.write( 'dA(v,u_0)/du_0:\n' )
#ltx.write_block( dAdu_0 )

dAdt_unconstrained = A.apply_map( lambda a :  c00_bindings(maclev_adap_lv._flow[a].substitute({SR.var('a_0_0'):A_0[_sage_const_0 ][_sage_const_0 ], SR.var('k_0'):A_0[_sage_const_1 ][_sage_const_0 ]})) )

gX = c00_bindings(SR('gamma * X_0'))
D = gX * d1A * d1ATS
D = D.apply_map( lambda d : d.rational_simplify() )

ltx.write( 'thus' )
ltx.write_equality( wrap_latex('\\gamma \hat X_0'), gX )
ltx.write_equality( SR('D'), wrap_latex('\\gamma X_0 \\partial_1 \mathbf A \\partial_1 \mathbf A^T S(\mathbf A)'), D )

#I_circle = gX * dAdv * dAdu_0.transpose() * S_A_bound

#ltx.write( 'I_circle(%g) ='%initial_u )
#ltx.write_equality( wrap_latex('I^\circ'), wrap_latex('\\gamma X_0 \\frac{\\partial A}{\\partial v}\\frac{\\partial A}{\\partial u_0}^T S(A)'), I_circle )

I = gX * d2A * d1ATS
I = I.apply_map( lambda i : i.rational_simplify() )

ltx.write_equality( SR.var('I'), wrap_latex('\\gamma X_0 \\partial_2 \mathbf A \\partial_1 \mathbf A^T S(\\mathbf A)'), I )

ltx.write_equality( wrap_latex('D + I'), (D+I).apply_map( lambda di : di.rational_simplify() ) )
ltx.write( "and to check, " )
ltx.write( 'the total derivative of $A$ is ' )
ltx.write_equality( wrap_latex('\\frac{dA(u_0,u_0)}{du_0}'), dA_du_bound )

dudt = maclev_adap_c00_bound._flow[u_0]

ltx.write( 'and' )
ltx.write_equality( wrap_latex('\\frac{du_0}{dt}'), dudt )
ltx.write( 'so that' )
ltx.write_equality( wrap_latex('\\frac{dA}{dt}'),
  wrap_latex('\\frac{dA(u_0,u_0)}{du_0}\\frac{du_0}{dt}'),
  dA_du_bound * dudt )

dudt_0 = initcond_bindings(maclev_adap_c00_bound._flow[u_0])
dA_du_0c = dA_du_0.transpose()
#ltx.write( 'dudt_0 =' )
#ltx.write_block( dudt_0 )
#ltx.write( 'dA_du_0 =' )
#ltx.write_block( dA_du_0c )

dAdt_constrained = dA_du_0c * dudt_0
#ltx.write( 'and dAdt_constrained =' )
#ltx.write_block( dAdt_constrained )

def arrow_from_cvectors(tail, length, **kargs):
    return arrow( (tail[_sage_const_0 ][_sage_const_0 ], tail[_sage_const_1 ][_sage_const_0 ]),
        (tail[_sage_const_0 ][_sage_const_0 ] + length[_sage_const_0 ][_sage_const_0 ], tail[_sage_const_1 ][_sage_const_0 ] + length[_sage_const_1 ][_sage_const_0 ]), **kargs)

if _sage_const_1 :
    ak_points = lv_c00_evolution.plot( c00_bindings(A_u[_sage_const_0 ][_sage_const_0 ]), c00_bindings(A_u[_sage_const_1 ][_sage_const_0 ]),
      xlabel='a_{00}', ylabel='k_0', color='black' )
    S_A_arrow = arrow_from_cvectors( A_0, dAdt_unconstrained,
      color='red', width=_sage_const_1  )
    ak_constraint = plot( (A_c00[_sage_const_0 ][_sage_const_0 ], A_c00[_sage_const_1 ][_sage_const_0 ]),
      (u_0,initial_u-_sage_const_0p5 ,initial_u+_sage_const_0p5 ), color='light blue' )
    D_arrow = arrow_from_cvectors( initcond_bindings( c00_bindings( A_0 ) ), initcond_bindings( c00_bindings( D ) ), color='green', width=_sage_const_1  )
    I_arrow = arrow_from_cvectors( initcond_bindings( c00_bindings( A_0 + D ) ), initcond_bindings( c00_bindings( I ) ), color='purple', width=_sage_const_1  )
    dA_du_arrow = arrow_from_cvectors( A_0, initcond_bindings( c00_bindings( dA_du_bound * dudt ) ), color='blue', width=_sage_const_1  )
    ak_geom = ak_points + dA_du_arrow + S_A_arrow + d1A_constraint + D_arrow + I_arrow
    # + ak_constraint
    ak_geom.set_axes_range( -_sage_const_8 , _sage_const_3 , -_sage_const_2 , _sage_const_7  )
    ak_geom.axes_labels( ['$a_{00}$', '$k_0$'] )
    save(ak_geom, filename="maclev-1-1-ak-adap-geom.png", figsize=(_sage_const_4 ,_sage_const_4 ))

ltx.close()

