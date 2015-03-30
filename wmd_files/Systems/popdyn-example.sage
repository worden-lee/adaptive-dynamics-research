# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageUtils)/latex_output.py
# produces: popdyn-example.cd.tex popdyn-example.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
 
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
import dynamicalsystems
import latex_output

ltx = latex_output.latex_output( 'popdyn-example.cd.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('X_1 X_2')
sys = dynamicalsystems.ODESystem(
	{ X_1: X_1 - 1/5*X_1^2 - 1/10*X_1*X_2, X_2: X_2 - 1/5*X_1*X_2 - 1/3*X_2^2 },
	[ X_1, X_2 ]
)

ltx.write( sys )

soln = sys.solve( [ 1, 9 ], end_time=15 )
ts = Graphics()
ts += soln.plot( 't', X_1, color='red', legend_label='$X_1$' )
ts += soln.plot( 't', X_2, color='blue', legend_label='$X_2$' )
ts.set_legend_options( back_color='white' )
ts.axes_labels( [ "$t$", "$X$" ] )
ts.save( 'popdyn-example.svg', figsize=(4,3) )

save_session('popdyn-example')

ltx.close()
#save_session('foodweb')
#sys.exit( 0r )
