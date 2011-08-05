#
# Make various stuff from ebooks
#


EBOOKS = $(shell find . -type f -name \*.html -not -name Moby-Dick.html -not -name index.\* -not -name 404.html -printf "%f\n")
FOP = "$(HOME)/lib/fop/fop"


all: pdf epub
.PHONY: all pdf epub clean


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))


%.pdf: %.html tools/fo.xsl tools/fo.conf
	sed -n '2,$$p' "$<" | $(FOP) -xml - -xsl tools/fo.xsl -c tools/fo.conf -pdf "$@"


%.fo: %.html tools/fo.xsl
	sed -n '2,$$p' "$<" | xalan -indent 2 -xsl tools/fo.xsl -out "$@"


epub: $(EBOOKS) tools/epub/*
	python tools/epub/compose.py


%.epub: %.html tools/epub/*
	python tools/epub/compose.py "$<"


clean:
	-rm -f $(patsubst %.html,%.pdf,$(EBOOKS)) $(patsubst %.html,%.epub,$(EBOOKS)) $(patsubst %.html,%.fo,$(EBOOKS))
