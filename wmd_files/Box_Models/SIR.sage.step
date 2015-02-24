# requires: boxmodel.py
# requires: $(SageDynamics)/dynamicalsystems.py
# requires: $(SageAdaptiveDynamics)/adaptivedynamics.py
# produces: SIR.sage.out.tex SIR.boxes.tex SIR.trajectory.png
print 'init'; sys.stdout.flush()
import os
import sys
sys.path.append( os.environ['SageUtils'] )
from latex_output import *
from boxmodel import *

print 'create SIR model'; sys.stdout.flush()

S, I, R, mu, alpha = SR.var( 'S I R mu alpha' )

SIR = BoxModel( DiGraph( { S:{ I:alpha*S*I }, I:{ R:mu*I } } ), [S,I,R] )

print 'write latex'; sys.stdout.flush()

ltx = latex_output( "SIR.sage.out.tex" )

ltx.write( 'SIR model:\n', SIR )

ltx.close()

print 'plot boxes'; sys.stdout.flush()

SIR.plot_boxes( 'SIR.boxes.tex', figsize=(5,5) )

print 'solve numerically'; sys.stdout.flush()

epsilon = 0.01 # initial infectious pop
trajectory = SIR.bind( { mu:0.1, alpha:1 } ).solve( [1-epsilon,epsilon,0], end_time=75 )

print 'plot timeseries'; sys.stdout.flush()

#trajectory.plot( 't', [S,I,R], filename='SIR.trajectory.png', figsize=(5,5) )
P = ( trajectory.plot( 't', S, color='blue', legend_label='$S$' )
    + trajectory.plot( 't', I, color='red', legend_label='$I$' )
    + trajectory.plot( 't', R, color='green', legend_label='$R$' )
)
P.save( filename='SIR.trajectory.png', figsize=(5,4), legend_loc='upper right' )

sys.exit(0r)
