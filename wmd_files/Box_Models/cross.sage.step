# requires: boxmodel.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# produces: cross.sage.out.tex classes.boxes.tex cross.boxes.tex
# produces: cross.trajectory.png
import sys
print 'init'; sys.stdout.flush()
import os
sys.path.append( os.environ['SageUtils'] )
from latex_output import *
from boxmodel import *

print 'make SIR model'
sys.stdout.flush()

S, I, R, mu, alpha = SR.var( 'S I R mu alpha' )
SIRgraph = DiGraph( { S:{ I:alpha*S*I }, I:{ R:mu*I } } )
SIR = BoxModel( SIRgraph, [S,I,R] )

print 'make classes model'
sys.stdout.flush()

a, b, rho, sigma = SR.var( 'a b rho sigma' )
classes = BoxModel( DiGraph( { a:{ b:rho*a }, b:{ a:sigma*b } } ), [a,b] )

print 'write latex'
sys.stdout.flush()

ltx = latex_output( "cross.sage.out.tex" )

ltx.write( 'SIR model:\n', SIR )

ltx.write( 'classes:\n', classes ) 

SIR2 = cross( SIR, classes )

ltx.write( 'cross:\n', SIR2 )

ltx.close()

print 'write tikz boxes'
sys.stdout.flush()

classes.plot_boxes( 'classes.boxes.tex', figsize=(5,5) )

SIR2.plot_boxes( 'cross.boxes.tex', figsize=(5,5) )

print 'solve numerically'; sys.stdout.flush()

parameters = Bindings( {
    'mu_a'    : 0.1, 'mu_b'    : 0.1,
    'alpha_a' : 1,   'alpha_b' : 1,
    'sigma_S' : 1,   'sigma_I' : 1,   'sigma_R': 1,
    'rho_S'   : 1,   'rho_I'   : 1,   'rho_R': 1
} )
epsilon = 0.01 # initial infectious pop
initial_condition = Bindings( {
    'S_a' : 2/3-epsilon/2, 'S_b' : 1/3-epsilon/2,
    'I_a' : epsilon/2,     'I_b' : epsilon/2,
    'R_a' : 0,             'R_b' : 0
} )
trajectory = SIR2.bind( parameters ).solve( [ initial_condition(v) for v in SIR2._vars ], end_time=75 )

print 'plot timeseries'; sys.stdout.flush()

print 'trajectory has got', trajectory._timeseries[0]
print 'and', trajectory._system._bindings; sys.stdout.flush()

P = ( trajectory.plot( 't', S, color='blue', legend_label='$S$' )
    + trajectory.plot( 't', 'S_a', color='blue', linestyle='--' )
    + trajectory.plot( 't', 'S_b', color='blue', linestyle=':' )
    + trajectory.plot( 't', I, color='red', legend_label='$I$' )
    + trajectory.plot( 't', 'I_a', color='red', linestyle='--' )
    + trajectory.plot( 't', 'I_b', color='red', linestyle=':' )
    + trajectory.plot( 't', R, color='green', legend_label='$R$' )
    + trajectory.plot( 't', 'R_a', color='green', linestyle='--' )
    + trajectory.plot( 't', 'R_b', color='green', linestyle=':' )
    + trajectory.plot( 't', 'a', color='gray', linestyle='--' )
    + trajectory.plot( 't', 'b', color='gray', linestyle=':' )
)
P.save( filename='cross.trajectory.png', figsize=(5,4), legend_loc='upper right' )

