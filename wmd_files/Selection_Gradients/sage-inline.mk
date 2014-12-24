%.sage.step : %.sage-inline sage-inline.mk
	echo '# produces: $*.sage.out.tex' > $@
	echo 'import os' >> $@
	echo 'import sys' >> $@
	echo 'sys.path.append( os.environ["SageUtils"] )' >> $@
	echo 'from latex_output import *' >> $@
	echo 'ltx = latex_output( "$*.sage.out.tex" )' >> $@
	cat $< >> $@
	echo 'ltx.close()' >> $@

WW_SI_SOURCE_FILES = $(filter %.sage-inline,$(WW_THIS_PROJECT_SOURCE_FILES))
WW_SI_MK_FILES = $(patsubst %.sage-inline,%.sage.mk,$(WW_SI_SOURCE_FILES))
$(info Including .mk files from .sage-inline files: $(WW_SI_MK_FILES))
include $(WW_SI_MK_FILES)
