#
# Make various stuff from ebooks
#


EBOOKS = $(shell git ls-files *.html | grep -v '^[4i]' | grep -v '^Narrative')
FOP = "$(HOME)/lib/fop/fop"


all: pdf epub index
.PHONY: all pdf epub clean index


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))


%.pdf: %.html tools/fo.xsl tools/fo.conf
	$(FOP) -a -xml "$<" -xsl tools/fo.xsl -c tools/fo.conf -pdf "$@"


%.fo: %.html tools/fo.xsl
	xalan -indent 2 -in "$<" -xsl tools/fo.xsl -out "$@"


epub: $(EBOOKS) tools/epub/*
	python tools/epub/compose.py


%.epub: %.html tools/epub/*
	python tools/epub/compose.py "$<"


clean:
	-rm -f $(patsubst %.html,%.pdf,$(EBOOKS)) $(patsubst %.html,%.epub,$(EBOOKS)) $(patsubst %.html,%.fo,$(EBOOKS))


index: index.js index.xml


index.js: $(EBOOKS)
	echo "var ebooks=[" > index.js
	for b in $(patsubst %.html,%,$(EBOOKS)); do echo '"'"$$b"'",' >> index.js ; done
	echo "];" >> index.js


index.xml: $(EBOOKS)
	echo "<ebooks>" > index.xml
	for b in $(patsubst %.html,%,$(EBOOKS)); do echo "  <book>$$b</book>" >> index.xml ; done
	echo "</ebooks>" >> index.xml
