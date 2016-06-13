# requires: seamodel.py
# produces: sea.sobj sea.sage.out.tex
from sage.all import * 
from sage.misc.latex import _latex_file_
import seamodel, dynamicalsystems

# now that I've defined the general resource-competition model, let's
# create a 1-resource, 1-population instantiation to work with
sea = seamodel.SeaSymbiosisModel(
    x_indices=[(seamodel.type_H,0),(seamodel.type_g,0)]
)

ltx = dynamicalsystems.latex_output( 'sea.sage.out.tex' )
ltx.write( 'The dynamics:' )
ltx.write( sea )

ltx.close()
save_session( 'sea' )
