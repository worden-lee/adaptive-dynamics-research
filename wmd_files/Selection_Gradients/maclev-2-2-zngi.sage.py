# This file was *autogenerated* from the file maclev-2-2-zngi.sage
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_0 = Integer(0); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4); _sage_const_0p98 = RealNumber('0.98'); _sage_const_0p3 = RealNumber('0.3'); _sage_const_0p02 = RealNumber('0.02')# requires: maclev_2_2_defs.py maclev-2-2-adap.sobj
# produces: maclev-2-2-zngi.sage.out.tex maclev-2-2-zngi-animation.gif
from maclev_2_2_defs import *

load_session( 'maclev-2-2-adap.sobj' )

ltx = latex_output( 'maclev-2-2-zngi.sage.out.tex' )

rescomp_abstract = rescomp.bind( numeric_params )
rescomp_initial = rescomp_abstract.bind( bmc_bindings, initial_conditions )

def zngi_R1( x ):
    assume( R_0 > _sage_const_0 , R_1 > _sage_const_0  )
    zngi = solve( rescomp_abstract._flow[x] == _sage_const_0 , R_1, solution_dict=True )[_sage_const_0 ][R_1]
    forget()
    return numeric_params( zngi )

zngi_generic_parametric = (rescomp_abstract._flow[X_0]/X_0) == _sage_const_0 
u = SR('u')
zngi_generic_parametric = bmc_bindings( zngi_generic_parametric ).subs( { u_0:u } )

zngis_generic = [ zngi_R1( x ) for x in ( X_0, X_1 ) ]
#ltx.write( "zngis:\n" )
#for z in zngis_generic:
#	ltx.write_block( R_1 == z )
#ltx.write( "R intercepts are:\n" )
#for z in zngis_generic:
#	R1int = solve( z, R_0, solution_dict=True )[0][R_0]
#	ltx.write_block( [ (R1int, 0), (0, z.subs( { R_0: 0 } )) ] )

zngis_numeric = [
    [ Bindings(p)( bmc_bindings( r ) ) for r in zngis_generic ]
    for p in c_evolution._timeseries ]

rmax = [
    [ solve( r1, R_0, solution_dict=True )[_sage_const_0 ][R_0] for r1 in zs ]
    for zs in zngis_numeric ]

plot_line_args = dict( ymin=_sage_const_0 , ymax=_sage_const_4 , xmax=_sage_const_4 , figsize=(_sage_const_5 ,_sage_const_5 ), color='gray' )
plot_fill_args = dict( plot_line_args, fill=True, fillcolor='gray', fillalpha=_sage_const_0p3 , thickness=_sage_const_2  )

ltx.write( 'generic ZNGI curve:' )
ltx.write_block( zngi_generic_parametric )

envelope_condition = diff( zngi_generic_parametric, u )
ltx.write( 'envelope condition:' )
ltx.write_block( envelope_condition )

envelope_curves = solve( [ zngi_generic_parametric, envelope_condition ], [ R_0, R_1 ], solution_dict=True )
envelope_curve = [ envelope_curves[_sage_const_0 ][r] for r in (R_0,R_1) ]
#ltx.write_block( envelope_curve )
envelope_plot = parametric_plot( envelope_curve, (u,_sage_const_0p02 ,_sage_const_0p98 ) )

def main():
    zplot = Graphics()
    anima = []

    print 'create frames'; sys.stdout.flush()
    for zs, r0s in zip(zngis_numeric, rmax):
        frame = envelope_plot
        for r1, r0max in zip(zs, r0s):
            frame += plot( r1, (R_0, _sage_const_0 , r0max), **plot_fill_args )
            zplot += plot( r1, (R_0, _sage_const_0 , r0max), **plot_line_args )
        frame.axes_labels( [ '$%s$'%latex(r) for r in (R_0, R_1) ] )
        anima += [ frame ]

    print 'create animate gif'; sys.stdout.flush()
    animation = animate( anima, xmin=_sage_const_0 , xmax=_sage_const_4 , ymin=_sage_const_0 , ymax=_sage_const_4 , figsize=(_sage_const_5 ,_sage_const_5 ) )
    animation.save( 'maclev-2-2-zngi-animation.gif' )
    return _sage_const_0 

if __name__ == '__main__':
    status = main()
else:
    status = _sage_const_0 

ltx.close()
save_session('maclev-2-2-zngi')
sys.exit(int(status))
