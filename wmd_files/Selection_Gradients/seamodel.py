from sage.all import * 
import dynamicalsystems
from dynamicalsystems import indexer, subscriptedsymbol, Bindings

# Model organized as follows:
#  population index is (type, number), with type either g or H

type_H, type_g = 0, 1
var('H g a t')

## indexing functions for sea model
def Xfn( (t,i) ):
	return subscriptedsymbol( 'N' if t == type_H else 'n', i )
def Rfn( (t,i) ):
	return subscriptedsymbol( 'R' if t == type_H else 'r', i )
def pfn( (t,i) ):
	return indexer( lambda (s,j): subscriptedsymbol( 'p', i, j ) )
def bfn( (t,i) ):
	return indexer( lambda (s,j): subscriptedsymbol( 'b', i, j ) )
def Bfn( (t,i) ):
	return indexer( lambda (s,j): subscriptedsymbol( 'B', i, j ) )
def cgfn( (t,i) ):
	return subscriptedsymbol( 'C' if t == type_H else 'c', g, i )
def cafn( (t,i) ):
	return subscriptedsymbol( 'C' if t == type_H else 'c', a, i )
def ctfn( (s,i) ):
	return subscriptedsymbol( 'C' if s == type_H else 'c', t, i )
def Kfn( (t,i) ):
	return subscriptedsymbol( 'K' if t == type_H else 'k', i )

class SeaSymbiosisModel(dynamicalsystems.PopulationDynamicsSystem):
    def __init__(
	self,
	x_indices=None,
	X = indexer( Xfn ),
	r_indexer = indexer( Rfn ),
	p_indexer = indexer( pfn ),
	b_indexer = indexer( bfn ),
	B_indexer = indexer( Bfn ),
	cg_indexer = indexer( cgfn ),
	ca_indexer = indexer( cafn ),
	ct_indexer = indexer( ctfn ),
	K_indexer = indexer( Kfn ),
	bindings=Bindings()):
	self._indexers = { 'X': X,
		'r':r_indexer, 'p':p_indexer, 'b':b_indexer, 'B':B_indexer,
		'c_g':cg_indexer, 'c_a':ca_indexer, 'c_t':ct_indexer,
		'c_g':cg_indexer, 'c_a':ca_indexer, 'c_t':ct_indexer,
		'K':K_indexer }
	#print 'debug:', t_indexer[(type_H,0)], 'done'; sys.stdout.flush()
	from sage.symbolic.function_factory import function
	self._names = dict( 
		#[ (n, SR.symbol(n)) for n in ('r_0', 'R_0') ] +
		#[ (n, function(n)) for n in ('p', 'c_g', 'c_a', 'c_t', 'b', 'C_g', 'C_a', 'C_t', 'B') ] +
		self._indexers.items()
	)
	super(SeaSymbiosisModel,self).__init__(
	    [], x_indices, X, bindings=bindings
	)
    def flow(self):
	return self.make_flow( **self._names )
    def make_flow(self, X, r, p, c_g, c_a, c_t, b, B, K ):
	return dict(
	    [ (X[g], X[g]*(r[g] - c_g[g] +
		sum( (p[g][h] * (b[g][h] - c_t[g]) - c_a[g])*X[h]
		    for h in self._population_indices if h[0] == type_H ) +
		sum( - K[g1] * X[g1]
		    for g1 in self._population_indices if g1[0] == type_g ) )
	      ) for g in self._population_indices if g[0] == type_g ] +
	    [ (X[h], X[h]*(r[h] - c_g[h] +
		sum( (p[g][h] * (B[g][h] - c_t[h]) - c_a[h])*X[g]
		    for g in self._population_indices if g[0] == type_g ) +
		sum( - K[h1] * X[h1]
		    for h1 in self._population_indices if h1[0] == type_H ) )
	      ) for h in self._population_indices if h[0] == type_H ]
	)
    def mutate(self, resident_index):
	t,i = resident_index
	mutant_index = ( t, 1 + max( j for tt,j in self._population_indices if tt == t ) )
	self.set_population_indices( self._population_indices + [ mutant_index ] )
	return mutant_index
    def fake_population_index(self):
	return ('x','x')

## used in adaptive dynamics
def bcfn( (t,i) ):
	return ( Bfn( (type_g,0) )[(t,i)] if t == type_H
		else bfn( (t,i) )[(type_H,0)] )
def pcfn( (t,i) ):
	return ( pfn( (type_g,0) )[(t,i)] if t == type_H
		else pfn( (t,i) )[(type_H,0)] )

def xmfn( (s,i) ):
	return subscriptedsymbol( 'X' if s == type_H else 'x', t, i)
def xafn( (t,i) ):
	return subscriptedsymbol( 'X' if t == type_H else 'x', a, i)
t_indexer = indexer( xmfn )
a_indexer = indexer( xafn )

def rffn( (t,i) ):
	return function('R' if t == type_H else 'r')(a_indexer[(t,i)],t_indexer[(t,i)])
def cgffn( (t,i) ):
	return function('C_g' if t == type_H else 'c_g')(a_indexer[(t,i)])
def caffn( (t,i) ):
	return function('C_a' if t == type_H else 'c_a')(a_indexer[(t,i)])
def ctffn( (t,i) ):
	return function('C_t' if t == type_H else 'c_t')(t_indexer[(t,i)])
def pffn( ix ):
	return indexer( lambda jx: function('p')(a_indexer[ix],a_indexer[jx]) )
def bffn( ix ):
	return indexer( lambda jx: function('b')(t_indexer[ix],t_indexer[jx]) )
def Bffn( ix ):
	return indexer( lambda jx: function('B')(t_indexer[ix],t_indexer[jx]) )
def Kffn( (t,i) ):
	return SR.symbol( 'K' if t == type_H else 'k' )
def varfix( vartex ):
	for st,lx in vartex.iteritems():
		var( st, latex_name=lx )
