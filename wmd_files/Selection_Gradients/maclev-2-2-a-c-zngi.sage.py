# This file was *autogenerated* from the file maclev-2-2-a-c-zngi.sage
from sage.all_cmdline import *   # import sage library
_sage_const_2 = Integer(2); _sage_const_0p3 = RealNumber('0.3'); _sage_const_0 = Integer(0); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4)# requires: maclev_2_2_defs.py maclev-2-2-a-c-adap.sobj
# produces: maclev-2-2-a-c-zngi.sage.out.tex maclev-2-2-a-c-zngi-animation.gif
from maclev_a_c import *

load_session( 'maclev-2-2-a-c-adap.sobj' )

ltx = latex_output( 'maclev-2-2-a-c-zngi.sage.out.tex' )

rescomp_abstract = rescomp.bind( numeric_params )
rescomp_initial = rescomp_abstract.bind( ad_bindings, initial_conditions )

def zngi_R1( x ):
    assume( R_0 > _sage_const_0 , R_1 > _sage_const_0  )
    zngi = solve( rescomp_abstract._flow[x] == _sage_const_0 , R_1, solution_dict=True )[_sage_const_0 ][R_1]
    forget()
    return numeric_params( zngi )

zngi_generic_parametric = (bm_bindings + numeric_params)(rescomp_abstract._flow[X_0]/X_0) == _sage_const_0 

zngis_generic = [ zngi_R1( x ) for x in ( X_0, X_1 ) ]

zngis_numeric = [
    [ Bindings(p)( numeric_params( ad_bindings( r ) ) ) for r in zngis_generic ]
    for p in c_evolution._timeseries ]

rmax = [
    [ solve( r1, R_0, solution_dict=True )[_sage_const_0 ][R_0] for r1 in zs ]
    for zs in zngis_numeric ]

plot_line_args = dict( ymin=_sage_const_0 , ymax=_sage_const_4 , xmax=_sage_const_4 , figsize=(_sage_const_5 ,_sage_const_5 ), color='gray' )
plot_fill_args = dict( plot_line_args, fill=True, fillcolor='gray', fillalpha=_sage_const_0p3 , thickness=_sage_const_2  )

ltx.write( 'generic ZNGI curve:' )
ltx.write_block( zngi_generic_parametric )

def main():
    zplot = Graphics()
    anima = []

    print 'create frames'; sys.stdout.flush()
    for zs, r0s in zip(zngis_numeric, rmax):
        frame = Graphics()
        for r1, r0max in zip(zs, r0s):
	    if r0max > _sage_const_0 :
                frame += plot( r1, (R_0, _sage_const_0 , r0max), **plot_fill_args )
                zplot += plot( r1, (R_0, _sage_const_0 , r0max), **plot_line_args )
        frame.axes_labels( [ '$%s$'%latex(r) for r in (R_0, R_1) ] )
        anima += [ frame ]

    print 'create animate gif'; sys.stdout.flush()
    animation = animate( anima, xmin=_sage_const_0 , xmax=_sage_const_4 , ymin=_sage_const_0 , ymax=_sage_const_4 , figsize=(_sage_const_5 ,_sage_const_5 ) )
    animation.save( 'maclev-2-2-a-c-zngi-animation.gif' )
    return _sage_const_0 

if __name__ == '__main__':
    status = main()
else:
    status = _sage_const_0 

ltx.close()
save_session('maclev-2-2-zngi')
sys.exit(int(status))