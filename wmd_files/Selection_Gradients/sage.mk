# Makefile to connect the Sage code here with the code in SageDynamics and elsewhere
 
# When we need something from the upstream projects, make it there
$(SageDynamics)/% : /proc/uptime
	$(MAKE) --no-print-directory -C $(SageDynamics) $*
 
$(SageAdaptiveDynamics)/% : /proc/uptime
	$(MAKE) --no-print-directory -C $(SageAdaptiveDynamics) $*
 
# The good makefile stuff is upstream, just reuse it
-include $(SageUtils)/sage.mk
-include $(SageUtils)/step.mk
