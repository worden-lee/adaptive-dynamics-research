# Makefile to connect the Sage code here with the code in SageDynamics

# the three upstream projects are all bundled into one git repo
#export SageUtils            = $(realpath $(SageDynamicsRepo)/SageUtils)
#export SageDynamics         = $(realpath $(SageDynamicsRepo)/SageDynamics)
#export SageAdaptiveDynamics = $(realpath $(SageDynamicsRepo)/SageAdaptiveDynamics)
export SageDynamics         = $(realpath $(SageDynamicsRepo))
 
# When we need something from the upstream projects, make it there
$(SageDynamics)/% : /proc/uptime
	$(MAKE) --no-print-directory -C $(SageDynamics) $*
 
#$(SageAdaptiveDynamics)/% : /proc/uptime
#	$(MAKE) --no-print-directory -C $(SageAdaptiveDynamics) $*
 
# The good makefile stuff is upstream, just reuse it
-include $(SageDynamicsRepo)/sage.mk
-include $(SageDynamicsRepo)/step.mk
