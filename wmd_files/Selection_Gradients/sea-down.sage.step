# requires: sea-adap.sobj
# produces: sea-down.sobj sea-down.sage.out.tex
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-adap' )
for k,l in _save_symbols.iteritems(): SR.symbol( k, latex_name=l ) 
ltx = dynamicalsystems.latex_output( 'sea-down.sage.out.tex' )

## baseline bindings for selection on investments x_a, x_t, X_a, X_t
var('y')
base_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## R_0 maximized at x_a == x_t == 0
	R = SR(1).function(x,y),
	r = SR(1).function(x,y),
    ),
    K = 1, k=1
)

## bindings for no ability to invest in association
zero_ass_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## prob of association
	p = SR(0).function(x,y),
	## density independent investment in association
	C_g = SR(0).function(x),
	c_g = SR(0).function(x),
	## investment in association per interaction
	C_a = SR(0).function(x),
	c_a = SR(0).function(x),
    )
)

## fixed association
fixed_ass_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## prob of association
	p = SR('p').function(x,y),
	## density independent investment in association
	C_g = SR(0).function(x),
	c_g = SR(0).function(x),
	## investment in association per interaction
	C_a = SR(0).function(x),
	c_a = SR(0).function(x),
    )
)

## variable investment in association
ass_only_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## density independent investment in association
	C_g = SR(0).function(x),
	c_g = SR(0).function(x),
	## investment in association
	# not defined here in base bindings
	## prob of association
	# not defined here in base bindings
    )
)

base_ass_b = Bindings( ass_only_b,
    dynamicalsystems.FunctionBindings(
	## cost re association per interaction
	C_a = (x^2).function(x),
	c_a = (x^2).function(x),
    )
)

## variable association, with logistic-shaped p function
exp_ass_b = Bindings( base_ass_b,
    dynamicalsystems.FunctionBindings(
	## prob of association
	#p = (1 / (1 + exp(-(x**2+y)))).function(x,y),
	p = (1 / (1 + exp(-(x+y)))).function(x,y),
    )
)

## variable association, with linear p function
## requires x_a, X_a stay in [-1,1]
linear_ass_b = Bindings( base_ass_b,
    dynamicalsystems.FunctionBindings(
	## prob of association
	p = (1/2 + (x+y)/4).function(x,y)
    )
)

## bindings for no ability to invest in transfer
zero_tran_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## benefit to guest of transfer
	b = SR(0).function(x,y),
	## benefit to host of transfer
	B = SR(0).function(x,y),
	## investment in transfer per interaction
	C_t = SR(0).function(x),
	c_t = SR(0).function(x)
    )
)

## for fixed nonzero transfer
fixed_tran_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## benefit to guest of transfer
	b = SR(1).function(x,y),
	## benefit to host of transfer
	B = SR(1).function(x,y),
	## investment in transfer per interaction
	C_t = SR(0).function(x),
	c_t = SR(0).function(x)
    )
)

## variable investment in transfer
base_tran_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## cost re transfer per interaction
	C_t = (x^2).function(x),
	c_t = (x^2).function(x),
    )
)

## variable transfer, with equal and opposite benefits
diag_tran_b = Bindings( base_tran_b,
    dynamicalsystems.FunctionBindings(
	## benefit to guest of transfer
	b = (x+y).function(x,y), #x.function(x,y),
	## benefit to host of transfer
	B = (-(x+y)).function(x,y), #y.function(x,y)
    )
)

## variable transfer, with generic linear benefit functions
linear_tran_b = Bindings( base_tran_b,
    dynamicalsystems.FunctionBindings(
	## benefit to guest of transfer
	b = SR('v*x+w*y').function(x,y),
	## benefit to host of transfer
	B = SR('V*x+W*y').function(x,y),
	## bind v,w,V,W yourself
    )
)

## down_b was once intended to be a setting where investments go down.
## name persists.
down_b = base_b + exp_ass_b + diag_tran_b

ltx.write( 'Here are some pessimistic bindings:', down_b )
sea_down = down_b(sea_f)

ltx.write( 'Dynamics with pessimistic functions:' )
ltx.write( sea_down )

starting_comm = Bindings( **{ x:0 for x in ('x_a_0', 'x_t_0', 'X_a_0','X_t_0') } )
starting_comm.bind_in_place( x_a_0=0.04, X_t_0=-0.08 )

starting_pop = Bindings( N_0=0.1r, n_0=0.2r )

sea_adap_down = down_b(sea_adap_f)
ltx.write( 'And pessimistic adaptive dynamics is' )
ltx.write( sea_adap_down )

sea_adap_down.bind_in_place( seaquil[0] )
#ltx.write( 'With equilibrium populations is', sea_adap_down )
ltx.write( 'And at starting point ', vector( [ starting_comm(v) for v in sea_adap_down._vars ] ), ' is', starting_comm(sea_adap_down) )

ltx.close()
_save_symbols = { sv:lv for sv,lv in ( (str(v), latex(v)) for v in sage.symbolic.ring.pynac_symbol_registry.values() ) if sv != lv }

save_session('sea-down')
