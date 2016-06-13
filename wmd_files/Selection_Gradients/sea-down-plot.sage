# requires: sea-down.sobj
# produces: sea-down-test.svg
# produces: sea-vf-X.svg sea-vf-x.svg sea-vf-c.svg sea-vf-m.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )
#test_dyn = starting_comm( sea_down ).solve( starting_pop )
#test_dyn.plot( 't', sea_down._vars ).save( filename='sea-down-test.svg', figsize=(4,3) )

adap_traj.plot( 't', sea_adap_down._vars ).save( filename='sea-down-test.svg', figsize=(4,3) )

sdx = sea_adap_down.limit( X_c_0=0, X_m_0=0 )
vfp = sdx.plot_vector_field( (SR('x_c_0'),-1,1), (SR('x_m_0'),-1,1) )
vfp += sdx.plot_isoclines( (SR('x_c_0'),-1,1), (SR('x_m_0'),-1,1) )
vfp.save( filename='sea-vf-x.svg', figsize=(4,4) )

sdx = sea_adap_down.limit( x_c_0=0, x_m_0=0 )
vfp = sdx.plot_vector_field( (SR('X_c_0'),-1,1), (SR('X_m_0'),-1,1) )
vfp.save( filename='sea-vf-X.svg', figsize=(4,4) )

sdx = sea_adap_down.limit( X_m_0=0, x_m_0=0 )
vfp = sdx.plot_vector_field( (SR('x_c_0'),-1,0.9), (SR('X_c_0'),-1,0.9) )
vfp.save( filename='sea-vf-c.svg', figsize=(4,4) )
