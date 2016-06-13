# requires: sea-down.sobj
# produces: sea-down-test.svg
from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings
from seamodel import *

load_session( 'sea-down' )

#test_dyn = starting_comm( sea_down ).solve( starting_pop )
#test_dyn.plot( 't', sea_down._vars ).save( filename='sea-down-test.svg', figsize=(4,3) )

adap_traj = sea_adap_down.solve( starting_comm )

adap_traj.plot( 't', sea_adap_down._vars ).save( filename='sea-down-test.svg', figsize=(4,3) )
