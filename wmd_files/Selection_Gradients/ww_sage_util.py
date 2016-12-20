from sage.misc.session import *
from sage.symbolic.ring import *
from dynamicalsystems import Bindings
import sys

def ww_load_session( x, into_state=locals() ):
	"""supplemented version of Sage's load_session():
	works around some troubles with pickling and variables"""
	## @@ isn't working --- how to assign to vars in caller's scope
	## without using Cython? only way I've found is for caller to
	## provide locals() explicitly
	## @@ To do: load_session() has provisions for when embedded in
	## a notebook cell.  Not accounted for here.
	D = load( x )
	SS = {}
	for k,l in D['_save_symbols'].iteritems():
		SS[k] = SR.symbol( k, latex_name=l )
	SS = Bindings( **SS )
	for k,x in D.iteritems():
		try:
			print x; sys.stdout.flush()
			into_state[k] = SS( x )
			print '=becomes=>', into_state[k]; sys.stdout.flush()
		except TypeError:
			into_state[k] = x
		except AttributeError:
			into_state[k] = x
		except ValueError:
			into_state[k] = x
