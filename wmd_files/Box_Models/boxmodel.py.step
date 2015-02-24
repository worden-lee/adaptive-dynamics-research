# requires: $(SageDynamics)/dynamicalsystems.py $(SageAdaptiveDynamics)/adaptivedynamics.py
from sage.all import *
import os
import sys
 
sys.path.append( os.environ['SageUtils'] )
sys.path.append( os.environ['SageDynamics'] )
from dynamicalsystems import *

from sage.misc.latex import _latex_file_
#from sage.symbolic.relation import solve
from sage.symbolic.function_factory import function

class BoxModel(ODESystem):
    """Parent class for all kinds of box models.
    Note that since this gets its variables from a graph's vertices,
    rather than from indexers, it can't be used in adaptive dynamics.
    Subclasses that generate their boxes, maybe can.
    """
    def __init__(self, graph,
	vars=None,
	population_vars=None,
	time_variable=SR.symbol('t'),
	parameters=None,
	vertex_func=None,
	edge_func=None,
        bindings=Bindings()):
	self._graph = graph
	if vars is None:
	    vars = graph.vertices()
	if vertex_func is None:
	    vertex_func = lambda x:x
	if edge_func is None:
	    edge_func = lambda x:x
	flow = { v:0 for v in vars }
	#print flow
	self._flow_graph = DiGraph( {
	    vertex_func(v):{
		vertex_func(w):edge_func(e)
		for vv,w,e in self._graph.outgoing_edges(v)
	    } for v in self._graph.vertices()
	} )
	self._flow_graph.set_latex_options( edge_labels=True )
	for source,sink,edge_label in self._graph.edges():
	    rate = edge_func(edge_label)
	    #print vertex_func(source), '-$%s$->'%latex(rate), vertex_func(sink)
	    flow[vertex_func(source)] -= rate
	    flow[vertex_func(sink)]   += rate
	if parameters is None:
	    parameters = set( reduce( union, (f.variables() for f in flow.values()) ) ).difference( vars )
	self._parameters = parameters
        super(BoxModel, self).__init__(
	    flow,
            vars,
	    time_variable,
            bindings = bindings )
    def tikz_boxes( self ):
	return _latex_file_( self._flow_graph, title='' )
    def plot_boxes( self, filename=None, **options ):
	# new Tikz/SVG code
        LF = open( filename, 'w' )
	LT = self.tikz_boxes()
	LF.write( LT )
        LF.close()
	return LT
	# old PNG code
	P = self._graph.plot( edge_labels=True, **options )
	if filename is not None:
	    P.save( filename )
	return P

def cross_product_with_edges( *graphs ):
    """similar to DiGraph.cartesian_product(), but handles edge labels."""
    adj_dict = {}
    import itertools
    for vs in itertools.product( *(g.vertices() for g in graphs) ):
	adj_dict[vs] = {}
	for i in range(len(vs)):
	    for v,w,rate in graphs[i].outgoing_edges(vs[i]):
		ws = list(vs)
		ws[i] = w
		erate = [rate, i] + [ vs[j] for j in range(len(vs)) if j != i ]
		adj_dict[vs][tuple(ws)] = tuple(erate)
    return DiGraph( adj_dict )

def cross( *models ):
    cross_graph = cross_product_with_edges( *(m._graph for m in models) )
    # cross_graph has (v,v,...) tuples for vertices, and
    # (rate,i,v,...) tuples for edges
    # how to relabel?
    # vertices are formally (v1, v2, ...) where vi is the vertex label in
    # the ith graph. They get relabeled v1_{v2v3...}.
    # edges are formally (rate, i, v1, v2, ...) where i is the index of
    # which graph the edge comes from, and the vs don't include vi.
    # the edge's rate expression gets relabeled by recursively adding
    # subscripts to all of that models state variables and parameters.
    def vfunc( vtuple ):
	return SR.symbol( '_'.join( str(v) for v in vtuple ),
	    latex_name='%s_{%s}'%(latex(vtuple[0]),''.join( latex(v) for v in vtuple[1:] )) )
    def efunc( etuple ):
	"""the input is (rate, i, v, v, ...) where rate is an expression, and the
	vs are the pre-cross vertex labels not involved in the edge."""
	i = etuple[1]
	params_rename = Bindings( {
	    p : vfunc( [p] + list(etuple[2:]) )
	    for p in models[i]._parameters
	} )
	vert_rename = Bindings( {
	    v : vfunc( list(etuple[2:2+i]) + [v] + list(etuple[2+i:]) )
	    for v in models[i]._vars
	} )
	# note those bindings are independent of 'rate' and could be memoized
	e = vert_rename( params_rename( etuple[0] ) )
	return e
    # TODO: add bindings for the old variables, e.g. S |-> S_a + S_b, etc.
    venn_bindings = {}
    for i in range(len(models)):
	for V in models[i]._vars:
	    venn_bindings[V] = 0
	    import itertools
	    for subdivisions in itertools.product( *(m._vars for m in models[:i]+models[i+1:]) ):
		venn_bindings[V] += vfunc( list(subdivisions[:i]) + [V] + list(subdivisions[i:]) )
    return BoxModel( cross_graph,
	[ vfunc(tp) for tp in cross_graph.vertices() ],
	vertex_func=vfunc, edge_func=efunc, bindings=Bindings(venn_bindings) )

