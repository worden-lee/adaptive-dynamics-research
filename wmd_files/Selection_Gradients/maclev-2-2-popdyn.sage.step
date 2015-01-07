# requires: maclev_2_2_defs.py
# requires: $(SageDynamics)/dynamicalsystems.py maclevmodels.py
# produces: maclev-2-2-popdyn.sage.out.tex maclev-2-2-popdyn.sobj
# produces: maclev-2-2-popdyn.png maclev-2-2-r-zngis.png maclev-2-2-c-vs-u.png 
from maclev_2_2_defs import *

print 'start'
sys.stdout.flush()

ltx = latex_output( 'maclev-2-2-popdyn.sage.out.tex' )

ltx.write( 'The Mac-Lev model in generic form: ' )
ltx.write_block( maclev )

print 'apply bindings:', ad_bindings
sys.stdout.flush()

ltx.write( 'The Mac-Lev model with $b, m$, and $c$ bound to functions of $u$:\n' )
ltx.write_block( maclev.bind( ad_bindings ) )

print 'plot state space'
sys.stdout.flush()

maclev_initial_system = maclev.bind( ad_bindings + numeric_params + initial_conditions )
p = maclev_initial_system.plot_vector_field( (X_0, 0, 2), (X_1, 0, 2), color="gray", figsize=(5,5) )
p += maclev_initial_system.plot_ZNGIs( (X_0, 0, 2), (X_1, 0, 2), color="gray" )
s = maclev_initial_system.solve( [0, 0.02, 0.05], end_points=integrate_popdyn_to )
p += s.plot( X_0, X_1, color='red' )
p.save( 'maclev-2-2-popdyn.png' )

rescomp_initial_system = maclev._rescomp_model.bind( ad_bindings + numeric_params + initial_conditions )
rescomp_initial_system.plot_R_ZNGIs( filename='maclev-2-2-r-zngis.png', figsize=(4,4), ymin=0, ymax=4, xmin=0, xmax=4 )

print 'plot c vs u' 
sys.stdout.flush()

c_curve = plot( c_func( 0, 0 ), (u_0, 0, 1) )
c_curve += plot( c_func( 1, 1 ), (u_1, 0, 1), color="green" )
c_curve += point( initial_conditions( vector( [ u_0, c_func( 0, 0 ) ] ) ), color='blue', size=30 )
c_curve += point( initial_conditions( vector( [ u_0, c_func( 0, 1 ) ] ) ), color='blue', size=30 )
c_curve += point( initial_conditions( vector( [ u_1, c_func( 1, 0 ) ] ) ), color='red', size=30 )
c_curve += point( initial_conditions( vector( [ u_1, c_func( 1, 1 ) ] ) ), color='red', size=30 )
c_curve.axes_labels( [ '$u$', '$c_i(u)$' ] )
c_curve.save( 'maclev-2-2-c-vs-u.png', figsize=(4,4), ymin=0 )

# analysis

def analysis():
    maclev_abstract = maclev.bind( numeric_params )

    interior_eq = maclev_abstract.interior_equilibria()
    if len(interior_eq) == 0:
        ltx.write( "??? No interior equilibria?" )
    elif len(interior_eq) > 1:
        ltx.write( "??? Multiple interior equilibria ", latex(interior_eq) )
    else:
        generic_eq = column_vector( [ hat(X_0), hat(X_1) ] )
        interior_eq = Bindings( interior_eq[0] )( generic_eq )
        print 'interior eq:', interior_eq
        coexistence_criteria = solve( [ x > 0 for x in interior_eq ], [ maclev._rescomp_model._indexers['c'][i][j] for i in (0,1) for j in (0,1) ] )
        print 'coexistence criteria:', coexistence_criteria
        for soln in coexistence_criteria:
            ltx.write( 'One coexistence solution:\n' )
            for crit in soln:
                ltx.write_block(crit)

    ltx.write( "The coexistence criteria depend on the invasion rates at the boundary equilibria.\n\n" )

    for x_inv, x_res in ( (X_0, X_1), (X_1, X_0) ):
        assume( x_res > 0 )
        assume( x_inv == 0 )
        boundary_solutions = solve( maclev_abstract._flow[x_res] == 0, x_res, solution_dict=True )
        forget()
        if ( len( boundary_solutions ) != 1 ):
            raise Exception( 'wrong number of boundary solutions' )
        boundary_solution = boundary_solutions[0]
        #ltx.write_block( x_res.subs( boundary_solution ) )
        ltx.write( "Invasion of $%s$:\n" % latex( x_inv ) )
        inv_rate_abstract = maclev_abstract._flow[x_inv] / x_inv
        #ltx.write_block( inv_rate_abstract > 0 )
        inv_rate = inv_rate_abstract.subs( boundary_solution ).subs( { x_inv: 0 } )
        ltx.write_block( inv_rate.full_simplify() > 0 )

    rescomp_abstract = rescomp.bind( numeric_params )

    ltx.write( "But those invasion criteria are really about the resources.\n" ) # The resource levels are:\n" )
    ltx.write( latex( rescomp_abstract ) )

    for x_inv, x_res in ( (X_0, X_1), (X_1, X_0) ):
        #assume( x_res > 0 )
        #assume( x_inv == 0 )
        assume( R_0 > 0, R_1 > 0 )
        boundary_solutions = solve( [ rescomp_abstract._flow[v] == 0 for v in (x_res, R_0, R_1) ] + [ x_inv == 0 ], [ x_res, x_inv, R_0, R_1 ], solution_dict=True )
        forget()
        #ltx.write( "boundary solutions: $%s$\n" % latex(boundary_solutions) )
        boundary_solutions = [ s for s in boundary_solutions if s[x_res] != 0 ]
        if ( len( boundary_solutions ) != 1 ):
            raise Exception( 'wrong number of boundary solutions' )
        boundary_solution = boundary_solutions[0]
        ltx.write( "Here's a boundary solution: %s\n\n" % latex( Bindings( boundary_solution ) ) )
        #ltx.write_block( x_res.subs( boundary_solution ) )
        ltx.write( "Invasion condition for $%s$:\n" % latex( x_inv ) )
        inv_rate_abstract = rescomp_abstract._flow[x_inv] / x_inv
        #ltx.write_block( inv_rate_abstract > 0 )
        inv_rate = inv_rate_abstract.subs( { x_inv: 0 } )
        ltx.write_block( inv_rate.full_simplify() > 0 )

    ltx.write( "In our initial model, $c$ values are" )
    for i in ( 0, 1 ):
        for j in ( 0, 1 ):
            cij = rescomp_abstract._indexers['c'][i][j]
            ncij = (initial_conditions + bmc_bindings)( cij )
            ltx.write_block( cij, '=', ncij, '=', N(ncij, digits=4) )

# analysis()
ltx.close()

save_session('maclev-2-2-popdyn')
