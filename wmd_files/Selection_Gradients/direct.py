from sage.all import * 
import dynamicalsystems

class DirectModel(dynamicalsystems.PopulationDynamicsSystem):
    def __init__(
        self,
        n=10,
        bindings=dynamicalsystems.Bindings()):
        self._u_indexer = dynamicalsystems.indexer_2d('u')
        super(DirectModel,self).__init__(
            [], range(n), dynamicalsystems.indexer('X'), bindings=bindings
        )
    def flow(self):
        flo = {}
        for i in self._population_indices:
            xi = self._population_indexer[i]
            flo[xi] = xi
            for j in self._population_indices:
                xj = self._population_indexer[j]
                flo[xi] += xi * xj * self._u_indexer[i][j]
        return flo

