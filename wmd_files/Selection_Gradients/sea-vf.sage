# requires: sea-down.sobj
# produces: sea-vf-X.svg sea-vf-x.svg sea-vf-c.svg sea-vf-m.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

xydiu

load_session( 'sea-down' )

sdx = sea_adap_down.limit( X_a_0=0, X_t_0=0 )
vfp = sdx.plot_vector_field( (SR('x_a_0'),-1,1), (SR('x_t_0'),-1,1) )
#vfp += sdx.plot_isoclines( (SR('x_a_0'),-1,1), (SR('x_t_0'),-1,1) )
vfp.save( filename='sea-vf-x.svg', figsize=(4,4) )

sdx = sea_adap_down.limit( x_a_0=0, x_t_0=0 )
vfp = sdx.plot_vector_field( (SR('X_a_0'),-1,1), (SR('X_t_0'),-1,1) )
vfp.save( filename='sea-vf-X.svg', figsize=(4,4) )

sdx = sea_adap_down.limit( X_t_0=0, x_t_0=0 )
vfp = sdx.plot_vector_field( (SR('x_a_0'),-1,0.9), (SR('X_a_0'),-1,0.9) )
vfp.save( filename='sea-vf-c.svg', figsize=(4,4) )
