# requires: maclev_1_2_defs.py maclev-1-2-adap.sobj
# produces: maclev-1-2-zngi.sage.out.tex maclev-1-2-zngi-animation.gif
from maclev_1_2_defs import *

load_session( 'maclev-1-2-adap.sobj' )

ltx = latex_output( 'maclev-1-2-zngi.sage.out.tex' )

rescomp_abstract = rescomp.bind( numeric_params )
rescomp_initial = rescomp_abstract.bind( bmc_bindings, initial_conditions )

def zngi_R1( x ):
    assume( R_0 > 0, R_1 > 0 )
    zngi = solve( rescomp_abstract._flow[x] == 0, R_1, solution_dict=True )[0][R_1]
    forget()
    return numeric_params( zngi )

zngi_generic_parametric = (rescomp_abstract._flow[X_0]/X_0) == 0
u = SR('u')
zngi_generic_parametric = bmc_bindings( zngi_generic_parametric ).subs( { u_0:u } )

zngis_generic = [ zngi_R1( x ) for x in rescomp_abstract.population_vars() ]

zngis_numeric = [
    [ Bindings(p)( bmc_bindings( r ) ) for r in zngis_generic ]
    for p in c_evolution._timeseries ]

rmax = [
    [ solve( r1, R_0, solution_dict=True )[0][R_0] for r1 in zs ]
    for zs in zngis_numeric ]

plot_line_args = dict( ymin=0, ymax=4, xmax=4, figsize=(5,5), color='gray' )
plot_fill_args = dict( plot_line_args, fill=True, fillcolor='gray', fillalpha=0.3, thickness=2 )

ltx.write( 'generic ZNGI curve:' )
ltx.write_block( zngi_generic_parametric )

envelope_condition = diff( zngi_generic_parametric, u )
ltx.write( 'envelope condition:' )
ltx.write_block( envelope_condition )

envelope_curves = solve( [ zngi_generic_parametric, envelope_condition ], [ R_0, R_1 ], solution_dict=True )
envelope_curve = [ envelope_curves[0][r] for r in (R_0,R_1) ]
envelope_plot = parametric_plot( envelope_curve, (u,0.02,0.98) )

ltx.write( 'And the $(R_0,R_1)$ solution of those together is the envelope curve:' )
ltx.write_block( envelope_curve )

rstar_plotter = deepcopy( rescomp_abstract )
zngi_plotter = deepcopy( rescomp_abstract )
zngi_plotter.set_population_indices( [0] )
zngi_plotter.bind_in_place( bmc_bindings, numeric_params )
print 'zngi_plotter is\n', zngi_plotter
print 'rstar plotter is\n', rstar_plotter
def main():
    zplot = Graphics()
    anima = []

    print 'create frames'; sys.stdout.flush()
    for p in c_evolution._timeseries:
        frame = envelope_plot
        for u,value in p.items():
            if u != c_evolution._system._time_variable:
                rb = zngi_plotter.bind( Bindings( {u_0:value} ) )
                frame += rb.plot_R_ZNGIs( with_perpendicular=False )
        rstar_plotter.set_population_indices( range( len(p) - 1 ) )
        rsb = rstar_plotter.bind( bmc_bindings, numeric_params ).bind( p )
	eq = rsb.interior_equilibria()[0]
	frame += point( [ eq[rstar] for rstar in ( hat(R_0), hat(R_1) ) ], color='gray', size=30 )
        frame.axes_labels( [ '$%s$'%latex(r) for r in (R_0, R_1) ] )
        anima += [ frame ]

    print 'create animate gif'; sys.stdout.flush()
    animation = animate( anima, xmin=0, xmax=4, ymin=0, ymax=4, figsize=(5,5) )
    animation.save( 'maclev-1-2-zngi-animation.gif' )
    return 0r

if __name__ == '__main__':
    status = main()
else:
    status = 0r

ltx.close()
save_session('maclev-1-2-zngi')
sys.exit(status)
