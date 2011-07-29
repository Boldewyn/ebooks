#
# Make various stuff from ebooks
#


EBOOKS = $(shell find . -type f -name \*.html -not -name index.\* -not -name 404.html -printf "%f\n")


all: pdf epub
.PHONY: all pdf epub clean


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))


%.pdf: %.html tools/fo.xsl tools/fo.conf
	sed -n '2,$$p' "$<" | fop -xml /proc/self/fd/0 -xsl tools/fo.xsl -c tools/fo.conf -pdf "$@"


epub:


clean:
	-rm -f $(patsubst %.html,%.pdf,$(EBOOKS)) $(patsubst %.html,%.epub,$(EBOOKS))
