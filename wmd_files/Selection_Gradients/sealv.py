from sage.all import * 
from sage.misc.latex import _latex_file_
import dynamicalsystems, seamodel

type_letters = [ 0, 0 ]
type_letters[seamodel.type_H] = SR.symbol('H')
type_letters[seamodel.type_g] = SR.symbol('g')
class sea_a_indexer(dynamicalsystems.indexer_2d_inner):
    def __getitem__(self, j):
    	return dynamicalsystems.subscriptedsymbol(self._f, type_letters[self._i[0]], self._i[1], type_letters[j[0]], j[1])

class sea_r_indexer(dynamicalsystems.indexer):
    def __getitem__(self, i):
    	return dynamicalsystems.subscriptedsymbol(self._f, type_letters[i[0]], i[1])
