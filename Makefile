# to make a single target, you can use make wmd_files/Project/target
# or more usefully, make sync wmd_files/Project/target
# using the rule below.
# that puts the output of make on stdout.  To get the output in the
# .make.log file, do make wmd_files/Project/target.make.log
# using this rule.  Note sync is redundant because this includes the
# sync operation.
# note a downside of this pattern is that interrupting the job with
# ^C causes make to remove the log file
%.make.log : /proc/uptime
	php $(WW_DIR)/wmd/wmd.php --post --cache-dir=wmd_files --default-project-name=$(subst /,,$(subst wmd_files/,,$(dir $*))) --make-single-file=$(notdir $*)

# make working files in their directories.
# Note a file in a subdirectory of a working directory won't be made right,
# you'll have to construct a make -C command yourself.
wmd_files/% : /proc/uptime
	$(MAKE) -C $(dir $@) $(notdir $@)

# make them using .tex output format rules, which is slightly different
# in how .tex-inline files are made and maybe some other things
export WW_OUTPUTFORMAT=tex

# special target 'make sync':
# rebuild the site without any WMD make operations.  This has several useful
# side effects, including
# * sync all WMD source files into their working directories
# * update all WMD project files (as they are currently) into the website
# It's very useful to run
# $ make sync wmd_files/Directory/target.file
# $ make sync
# to rebuild and view a single project file only
sync :
	jekyll build --config=_config.yml,_wmd_sync.yml

# to rebuild a single page, i.e. rebuild the site while only doing make
# operations on a single page
# $ make _site/page.html
_site/%.html : /proc/uptime
	echo wmd_make_page: $*.md > _make_page.yml
	jekyll build --config=_config.yml,_make_page.yml
	$(RM) _make_page.yml

# generate CSS from WW CSS
WW_DIR = /usr/local/src/workingwiki

WW_CSS_TO_USE = $(patsubst %,$(WW_DIR)/resources/%,ext.workingwiki.latexml.css ext.workingwiki.latexml.customization.css)

css/auto-generated-from-ww.css : $(WW_CSS_TO_USE)
	cat $(WW_CSS_TO_USE) > $@

# experimental pandoc pipeline
# TODO: need to get the project name and title right from the YAML
# ideally the rest of the YAML too, though we can parasitize it from
# .wmd.data if we don't mind being kind of low-quality (this requires
# .wmd.data to be left over from a jekyll build operation, and all the
# source files from other pages to be freshly synced, because jekyll
# and pandoc disagree on locations within the page text, with and without
# the YAML header included).
WW = /usr/local/src/workingwiki
_pandoc/%.md : %.md.wmd wmd_files/.workingwiki/.wmd.data
	php $(WW)/wmd/wmd.php --pre --title=$(TITLE) --default-project-name=$(PROJECT) --cache-dir=wmd_files --data-store=.wmd.data --modification-time=`date +%Y%m%d%H%M%s` --process-inline-math=1 --output-format=tex < $< > $@

PROJECT = Selection_Gradients
TITLE = "Evolution in a Food Web"
_pandoc/constraint.md : TITLE="Constraints"
#_pandoc/AijModel.pdf : WMD_ARGS=--enable-make=0
#_pandoc/paper.tex : WMD_ARGS=--enable-make=0
_pandoc/Masel.md _pandoc/Masel.tex: TITLE="'Notes on Masel Model'"

_pandoc/%.md : Selection_Gradients/%.md.wmd wmd_files/.workingwiki/.wmd.data
	php $(WW)/wmd/wmd.php --pre --title=$(TITLE) --default-project-name=$(PROJECT) --cache-dir=wmd_files --data-store=.wmd.data --modification-time=`date +%Y%m%d%H%M%s` --process-inline-math=1 --output-format=tex < $< > $@

_pandoc/%.intermediate.tex : _pandoc/%.md
	pandoc -f markdown -t latex -s --listings --include-in-header=_assets/latex-header-additions.tex -S --filter pandoc-citeproc $< -o $@

_pandoc/%.tex : _pandoc/%.intermediate.tex
	php $(WW)/wmd/wmd.php --post --title=$(TITLE) --default-project-name=$(PROJECT) --cache-dir=wmd_files --data-store=.wmd.data --persistent-data-store --modification-time=`date +%Y%m%d%H%M%s` --output-format=tex $(WMD_ARGS) < $< > $@

_pandoc/%.pdf : _pandoc/%.tex
	cd _pandoc && pdflatex $* && pdflatex $*

%.pdf : _pandoc/%.pdf
	mv _pandoc/$*.pdf $@

#_pandoc/paper.pdf : _pandoc/%.pdf : _pandoc/%.tex
#	cd _pandoc && pdflatex $* && bibtex $* && pdflatex $* && pdflatex $*

_pandoc/paper.intermediate.tex : master.bib

master.bib :
	wget 'http://lalashan.mcmaster.ca/theobio/worden/index.php?title=Special:GetProjectFile&display=download&make=false&project=User%3AWuLi&filename=master.bib' -O $@

wmd_files/.workingwiki/.wmd.data : *.md.wmd */*.md.wmd
	$(MAKE) sync

.PRECIOUS: _pandoc/%.md _pandoc/%.tex

.PHONY: sync
