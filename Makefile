DIRS= `find -maxdepth 1  -type d ! -wholename \*.svn\* | grep /`
PDF = $(addsuffix .pdf, $(basename $(wildcard *.eps)))
INKSCAPE = $(addsuffix .pdf, $(basename $(wildcard *.svg)))


show: all

all: $(PDF) $(GNUPLOT) $(INKSCAPE) 
	pdflatex --halt-on-error --output-directory=./tmp ./document.tex
	bibtex ./tmp/document
	pdflatex --halt-on-error --output-directory=./tmp ./document.tex
	pdflatex --halt-on-error --output-directory=./tmp ./document.tex
	mv ./tmp/document.pdf .
	evince ./document.pdf 2> /dev/null &


evince:
	pdflatex --halt-on-error --output-directory=./tmp ./document.tex
	pdflatex --halt-on-error --output-directory=./tmp ./document.tex
	mv ./tmp/document.pdf .
	evince document.pdf &> /dev/null


prepare:
	mkdir tmp

img/%.pdf: pictures%.eps
	epstopdf $(basename $@).eps

img/%.pdf: %.svg
	inkscape $(basename $@).svg --export-eps=$(basename $@).eps
	epstopdf $(basename $@).eps



clean:
	-rm -f ./tmp/*~ ./tmp/*.bak ./tmp/*.aux ./tmp/*.log ./tmp/*.toc ./tmp/*.out ./tmp/*.nav ./tmp/*.snm ./tmp/*.bbl ./tmp/*.blg
	-rm -f ./tmp/*.pdf
#	-rm -f *.pdf

all-evince: show
