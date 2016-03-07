# produces: phase_portraits.sobj SI.sage.out.tex SI.png
# produces: competition.sage.out.tex competition.png
from sage.all import * 
from sage.misc.latex import _latex_file_

import dynamicalsystems

ltx = dynamicalsystems.latex_output( 'SI.sage.out.tex' )

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

SI_phase_plane = SI.plot_vector_field( (I,0,1), (S,0,1), color='gray' )

equil = SI.equilibria()
ltx.write( 'equilibria: ', latex(equil) )

SI_phase_plane.save( 'SI.png', figsize=(5,5) )

ltx = dynamicalsystems.latex_output( 'competition.sage.out.tex' )

var('X_2 X_1 c_0 c_1')
competition = dynamicalsystems.ODESystem(
	{ X_2: X_2 - X_2^2 - c_0*X_2*X_1, X_1: X_1 - X_1^2 - c_1*X_2*X_1 },
	[X_2, X_1],
	bindings = dynamicalsystems.Bindings( { 'c_0':0.4, 'c_1':0.5 } )
)

ltx.write( 'The competition model:' )
ltx.write_block( competition )

competition_phase_plane = competition.plot_vector_field( (X_1,0,1.1), (X_2,0,1.1), color='gray' )

equil = competition.equilibria()
ltx.write( 'equilibria: ', latex(equil) )
competition_phase_plane += point( [ ( dynamicalsystems.Bindings(eq)( 'Xhat_1' ), dynamicalsystems.Bindings(eq)( 'Xhat_2' ) ) for eq in equil ], size=40 )

competition_phase_plane.axes_labels( [ '$X_1$', '$X_2$' ] )
competition_phase_plane.save( 'competition.png', figsize=(5,5) )

ltx.close()

save_session('phase_portraits')

#ltx.close()
#save_session('foodweb')
#sys.exit( 0r )
