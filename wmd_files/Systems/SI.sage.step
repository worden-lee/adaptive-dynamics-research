# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageUtils)/latex_output.py
# produces: SI.sobj SI.sage.out.tex SI.png
from sage.all import * 
from sage.misc.latex import _latex_file_
 
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )

import latex_output
import dynamicalsystems

ltx = latex_output.latex_output( 'SI.sage.out.tex' )

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
var('S I r')
SI = dynamicalsystems.ODESystem(
	{ S: - r*S*I, I: r*S*I },
	[S, I],
	bindings = dynamicalsystems.Bindings( { 'r':1 } )
)

ltx.write( 'The SI model:' )
ltx.write_block( SI )

SI_phase_plane = SI.plot_vector_field( (I,0,2), (S,0,2), color='gray' )

#ltx.close()
#save_session('foodweb')
#sys.exit( 0r )

equil = SI.equilibria()
ltx.write( 'equilibria: ', latex(equil) )

SI_phase_plane.save( 'SI.png', figsize=(5,5) )

ltx.close()

save_session('SI')
