###############################################################################
# Default LaTeX makefile
# Samuel Jero <sj323707@ohio.edu>
###############################################################################
TEXFILE:=template
OUTPUT:=template.pdf


all: pdf
	
pdf: 	
	pdflatex ${TEXFILE}.tex
	#bibtex ${TEXFILE}.aux
	#pdflatex ${TEXFILE}.tex
	#pdflatex ${TEXFILE}.tex
	#mv ${TEXFILE}.pdf ${OUTPUT}

clean:
	rm -f *~ *.aux *.dvi *.log *.blg *.bbl *.toc *.lof *.lot *.out *.synctex.gz
