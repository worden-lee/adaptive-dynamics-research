# requires: foodweb.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# requires: $(SageUtils)/latex_output.py
# produces: foodweb.sobj foodweb.sage.out.tex foodweb.tikz.tex
from sage.all import * 
from sage.misc.latex import _latex_file_

import foodweb
import latex_output
import dynamicalsystems
import adaptivedynamics

ltx = latex_output.latex_output( 'foodweb.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('a b')

fb = (
    dynamicalsystems.Bindings( k = 9/10 ) +
    dynamicalsystems.FunctionBindings( { 'f':SR('2 + 4/5*cos( u - v )').function(SR('u'),SR('v')) } )
)

foodweb_pred_prey = foodweb.FoodWebModel(
    DiGraph( { a:[b] } ),
    bindings = dynamicalsystems.Bindings( { 'r':1, 'm':1 } )
);

ltx.write( 'The foodweb model:', foodweb_pred_prey.bind(fb) )

foodweb_pred_prey.plot_tikz( 'foodweb.tikz.tex' )

ltx.close()
save_session('foodweb')
#sys.exit( 0r )
