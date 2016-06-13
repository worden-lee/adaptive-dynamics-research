# requires: masel_model.py
# produces: masel-model.tex masel-2-model.tex
# produces: masel-model.sobj
from sage.all import *
import masel_model
from dynamicalsystems import latex_output

masel = masel_model.MaselModel(1)
masel2 = masel_model.Masel2Model(1)

ltx = latex_output( 'masel-model.tex' )
ltx.write( masel )
ltx.close()

ltx = latex_output( 'masel-2-model.tex' )
ltx.write( masel2 )
ltx.close()

save_session('masel-model')
