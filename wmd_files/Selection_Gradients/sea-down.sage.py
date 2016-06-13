# This file was *autogenerated* from the file sea-down.sage
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_4 = Integer(4); _sage_const_0p008 = RealNumber('0.008'); _sage_const_0p01 = RealNumber('0.01')# requires: sea-adap.sobj
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
	R = SR(_sage_const_1 ).function(x,y),
	r = SR(_sage_const_1 ).function(x,y),
    ),
    K = _sage_const_1 , k=_sage_const_1 
)

## bindings for no ability to invest in association
zero_ass_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## prob of association
	p = SR(_sage_const_0 ).function(x,y),
	## density independent investment in association
	C_g = SR(_sage_const_0 ).function(x),
	c_g = SR(_sage_const_0 ).function(x),
	## investment in association per interaction
	C_a = SR(_sage_const_0 ).function(x),
	c_a = SR(_sage_const_0 ).function(x),
    )
)

## fixed association
fixed_ass_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## prob of association
	p = SR('p').function(x,y),
	## density independent investment in association
	C_g = SR(_sage_const_0 ).function(x),
	c_g = SR(_sage_const_0 ).function(x),
	## investment in association per interaction
	C_a = SR(_sage_const_0 ).function(x),
	c_a = SR(_sage_const_0 ).function(x),
    )
)

## variable investment in association
base_ass_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## cost re association per interaction
	C_a = (x**_sage_const_2 ).function(x),
	c_a = (x**_sage_const_2 ).function(x),
	## density independent investment in association
	C_g = SR(_sage_const_0 ).function(x),
	c_g = SR(_sage_const_0 ).function(x),
	## prob of association
	# not defined here in base bindings
    )
)

## variable association, with logistic-shaped p function
exp_ass_b = Bindings( base_ass_b,
    dynamicalsystems.FunctionBindings(
	## prob of association
	#p = (1 / (1 + exp(-(x**2+y)))).function(x,y),
	p = (_sage_const_1  / (_sage_const_1  + exp(-(x+y)))).function(x,y),
    )
)

## variable association, with linear p function
## requires x_a, X_a stay in [-1,1]
linear_ass_b = Bindings( base_ass_b,
    dynamicalsystems.FunctionBindings(
	## prob of association
	p = (_sage_const_1 /_sage_const_2  + (x+y)/_sage_const_4 ).function(x,y)
    )
)

## bindings for no ability to invest in transfer
zero_tran_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## benefit to guest of transfer
	b = SR(_sage_const_0 ).function(x,y),
	## benefit to host of transfer
	B = SR(_sage_const_0 ).function(x,y),
	## investment in transfer per interaction
	C_t = SR(_sage_const_0 ).function(x),
	c_t = SR(_sage_const_0 ).function(x)
    )
)

## for fixed nonzero transfer
fixed_tran_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## benefit to guest of transfer
	b = SR(_sage_const_1 ).function(x,y),
	## benefit to host of transfer
	B = SR(_sage_const_1 ).function(x,y),
	## investment in transfer per interaction
	C_t = SR(_sage_const_0 ).function(x),
	c_t = SR(_sage_const_0 ).function(x)
    )
)

## variable investment in transfer
base_tran_b = Bindings(
    dynamicalsystems.FunctionBindings(
	## cost re transfer per interaction
	C_t = (x**_sage_const_2 ).function(x),
	c_t = (x**_sage_const_2 ).function(x),
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

starting_comm = Bindings( **{ x:_sage_const_0  for x in ('x_a_0', 'x_t_0', 'X_a_0','X_t_0') } )
starting_comm.bind_in_place( x_a_0=_sage_const_0p01 , X_t_0=-_sage_const_0p008  )

starting_pop = Bindings( N_0=0.1 , n_0=0.2  )

sea_adap_down = down_b(sea_adap_f)
ltx.write( 'And pessimistic adaptive dynamics is' )
ltx.write( sea_adap_down )

sea_adap_down.bind_in_place( seaquil[_sage_const_0 ] )
#ltx.write( 'With equilibrium populations is', sea_adap_down )
ltx.write( 'And at starting point ', vector( [ starting_comm(v) for v in sea_adap_down._vars ] ), ' is', starting_comm(sea_adap_down) )

ltx.close()
_save_symbols = { sv:lv for sv,lv in ( (str(v), latex(v)) for v in sage.symbolic.ring.pynac_symbol_registry.values() ) if sv != lv }
save_session('sea-down')
