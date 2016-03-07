# produces: logistic-S-A-curves.png S-A-vf.sobj
var('a k')
outer = 3
SA = vector( [ 1, -a/k ] )
SAvf = plot_vector_field( [1, -a/k], [k,0,outer], [a,-outer,0], color='red', figsize=(5,5), frame=false );
# invasion-neutral curves are perpendicular to the gradient:
# (slope) da/dk = k/a
# a da = k dk
# a^2 = k^2 + C
# a = \pm \sqrt(k^2 + C)
var('s')
from numpy import arange
for k,a in sum( ( [ (s,0), (0,-s) ] for s in arange(0.5,3,0.25) ), [ (0,0) ] ):
    C = a^2 - k^2
    SAvf += plot( (s, -sqrt(s^2+C)), (s, 0, outer), parametric=True, color='gray', thickness=0.1, ymin=-outer )
SAvf.axes_labels( [ '$k$', '$a$' ] );
SAvf.save( 'logistic-S-A-curves.png' );

save_session( 'S-A-vf' )
