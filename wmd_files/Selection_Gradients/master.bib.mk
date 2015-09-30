master.bib :
	wget 'http://lalashan.mcmaster.ca/theobio/worden/index.php?title=Special:GetProjectFile&display=download&make=false&project=User%3AWuLi&filename=master.bib'

get-master.tex-inline get-master.html : master.bib
	echo '' > $@
