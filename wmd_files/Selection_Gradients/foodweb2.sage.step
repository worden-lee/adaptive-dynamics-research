# requires: foodweb2.py
# produces: foodweb2.sobj foodweb2.sage.out.tex foodweb2.tikz.tex
from sage.all import * 

import foodweb2
import dynamicalsystems

ltx = dynamicalsystems.latex_output( 'foodweb2.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('a b')

fb = (
    dynamicalsystems.Bindings( k = 9/10, slow=1/50 ) +
    dynamicalsystems.FunctionBindings( { 'f':SR('2 + 4/5*cos( u - v )').function(SR('u'),SR('v')) } )
)

foodweb_pred_prey = foodweb2.FoodWebModel(
    DiGraph( { a:[b] } ),
    bindings = dynamicalsystems.Bindings( { 'r':1, 'm':1 } )
);

ltx.write( 'The foodweb model:', foodweb_pred_prey.bind(fb) )

foodweb_pred_prey.plot_tikz( 'foodweb2.tikz.tex' )

ltx.close()
save_session('foodweb2')
#sys.exit( 0r )
