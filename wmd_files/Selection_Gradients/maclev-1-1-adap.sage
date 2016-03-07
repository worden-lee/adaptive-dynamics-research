# requires: maclevmodels.py maclev-1-1.sobj
# produces: maclev-1-1-adap.sage.out.tex maclev-1-1-adap.sobj
# produces: maclev-1-1-c.png maclev-1-1-X.png maclev-1-1-ak.png
# produces: maclev-1-1-R.png maclev-1-1-a.png maclev-1-1-k.png
# produces: maclev-1-1-R.svg maclev-1-1-a.svg maclev-1-1-k.svg maclev-1-1-c.svg
from sage.all import *
from sage.misc.latex import _latex_file_
from sage.misc.latex import latex
latex.add_to_preamble('\\usepackage{amsmath}')

from maclevmodels import *
from dynamicalsystems import latex_output

# create variables with custom latex names because load_session
# creates them wrong
# http://trac.sagemath.org/ticket/17559
for x in ('X_0', 'X_i', 'R_0'): hat(SR.symbol(x))
SR.symbol( 'c_0_0', latex_name='c_{00}' )
SR.symbol( 'c_i_0', latex_name='c_{i0}' )

load_session('maclev-1-1')

ltx = latex_output( 'maclev-1-1-adap.sage.out.tex' )

u_indexer = indexer('u')
u_0 = u_indexer[0]

evol_c_bindings = Bindings( reduce( operator.add, (
    [ ( rescomp._indexers['c'][i][0], u_indexer[i] ),
      ( rescomp._indexers['b'][i], 1 ),
      ( rescomp._indexers['m'][i], 1 )
    ] for i in (0,1) ) ) )

maclev_adap = AdaptiveDynamicsModel(maclev,
    [ indexer('u') ], early_bindings=evol_c_bindings )

print 'when c_00 == u, the adaptive dynamics is ', maclev_adap

ltx.write( 'Adaptive dynamics of the Mac-Lev model with $b_i=m_i=1$ and $c_{i0} = u_i$:' )
ltx.write_block( maclev_adap )

numeric_params = Bindings(
  { SR.var('r_0'): 1, SR.var('w_0'): 1,
    SR.var('K_0'): 2, SR.var('gamma'): 1 } )
maclev_adap_bound = maclev_adap.bind( numeric_params )

ltx.write( 'and the bound adaptive dynamics is:', latex( maclev_adap_bound ) )

ltx.write( 'its bindings:', latex(maclev_adap_bound._bindings) )
initial_u = 2/3
c_evolution = maclev_adap_bound.solve( [initial_u], end_time=10 )

# and plot. 
t = maclev_adap.time_variable()
c_evolution.plot( t, u_indexer[0], 'maclev-1-1-c.png', ymin=0, ylabel='$c_{00}$', figsize=(4,4) )
c_evolution.plot( t, u_indexer[0], 'maclev-1-1-c.svg', ymin=0, ylabel='$c_{11}$', figsize=(2,2) )
# Xhat increases.
Xhat = hat( maclev_adap_bound._popdyn_model._population_indexer[0] )
c_evolution.plot( t, evol_c_bindings( maclev_adap_bound._bindings( Xhat ) ), "maclev-1-1-X.png", ylabel=Xhat, figsize=(4,4) )
Rhat = hat( maclev_adap_bound._popdyn_model._rescomp_model._indexers['R'][0] )
c_evolution.plot( t, evol_c_bindings( maclev_adap_bound._bindings( Rhat ) ), "maclev-1-1-R.svg", figsize=(2,2), ymin=0, ylabel='$\hat{R}_1$' )
c_evolution.plot( t, evol_c_bindings( maclev_adap_bound._bindings( Rhat ) ), "maclev-1-1-R.png", figsize=(4,4), ymin=0, ylabel=Rhat )
# and let's also plot k_0 vs. a_00.
# these are the coefficients if you rewrite the maclev dynamics
# as dX_0/dt = X_0(k_0 + a_00 X_0)
# and why not get sage to do that, rather than type in the definitions
X_0 = maclev._population_indexer[0]
rhsc = maclev._flow[X_0].collect(X_0)
k_0 = rhsc.coeff(X_0,1)
a_00 = rhsc.coeff(X_0,2)
ltx.write( 'With and without these bindings, the Lotka-Volterra coefficients $k_0$ and $a_{00}$ are:' )
ltx.write_equality( SR.var('k_0'), k_0, numeric_params( maclev_adap_bound._early_bindings(k_0)) )
ltx.write_equality( SR.var('a_0_0', latex_name='a_{00}' ), a_00, numeric_params( maclev_adap_bound._early_bindings(a_00) ) )

ltx.write( 'And the equilibrium values $\\hat X$ and $\\hat R$:',
    '\\begin{align*}\n  \\hat X_0 &\\to ',
    latex( maclev_adap_bound._equilibrium( Xhat ).expand() ), ' = ',
    latex( maclev_adap_bound._bindings( Xhat ).expand() ), '\\\\\n',
    '  \\hat R_0 &\\to ',
    latex( maclev_adap_bound._equilibrium( maclev_adap_bound._popdyn_model._bindings( Rhat ) ).expand() ), ' = ',
    latex( maclev_adap_bound._bindings( Rhat ).expand() ), '\n',
    '\\end{align*}\n' )

c_evolution.plot( t, maclev_adap_bound._early_bindings( k_0 ), "maclev-1-1-k.svg",
  ymin=0, ylabel='$k_1$', figsize=(2,2) )
c_evolution.plot( t, maclev_adap_bound._early_bindings( k_0 ), "maclev-1-1-k.png",
  figsize=(4,4) )

c_evolution.plot( t, maclev_adap_bound._early_bindings( a_00 ), "maclev-1-1-a.svg",
  ymax=0, ylabel='$a_{11}$', figsize=(2,2) )
c_evolution.plot( t, maclev_adap_bound._early_bindings( a_00 ), "maclev-1-1-a.png",
  ymax=0, ylabel='$a_{11}$', figsize=(4,4) )

c_evolution.plot( maclev_adap_bound._early_bindings( a_00 ), maclev_adap_bound._early_bindings( k_0 ), "maclev-1-1-ak.png",
  xlabel = SR.var('a_00'), ylabel = SR.var('k_0'), figsize=(4,4) )

ltx.close()

save_session('maclev-1-1-adap')
