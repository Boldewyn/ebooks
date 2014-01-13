#
# Make various stuff from ebooks
#


EBOOKS := $(patsubst text/%,%,$(wildcard text/*.html))
FOP := "fop"
XALAN := "/usr/share/java/xalan2.jar"


all: css js html pdf epub index
.PHONY: all html pdf epub clean index css js


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))


html: $(EBOOKS)

$(EBOOKS): %.html : text/%.html meta/%.json src/template.mustache
	src/compile_html.py "$(basename $@)"

%.pdf: %.fo src/fo.xsl src/fo.conf
	$(FOP) -a -fo "$<" -c src/fo.conf -pdf "$@"


%.fo: %.html src/fo.xsl
	java -Djava.protocol.handler.pkgs=dummy_about_handler -cp "$$PWD/src:$(XALAN)" \
	  org.apache.xalan.xslt.Process -indent 2 -xsl src/fo.xsl -in "$<" -out "$@"


epub: $(EBOOKS) src/epub/*
	python src/epub/compose.py


%.epub: %.html src/epub/*
	python src/epub/compose.py "$<"


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

css: static/ebook.css

static/ebook.css: src/sass/*
	compass compile

js: src/vendor static/ebook.js

src/vendor:
	bower install

static/ebook.js: src/vendor/html5shiv/dist/html5shiv.js src/vendor/jquery/jquery.js src/js/ebook.js
	true >$@
	for js in $^; do <$$js uglifyjs >> $@; done

used_classes:
	#ack 'class=(["'"'"']).*?\1' *.html -h -o|sort -u|cut -b 8-|sed 's/"//'|sed 's/ /\n/g'|sort -u
	@ack -i -o -h '<([a-z0-9]+)[^>]+class="(.*?)"' *.html|cut -b 2-|sort -u|sed 's/ .*class="/./'| sed 's/"$$//'|sed 's/ /./g'|sort -u

used_elements:
	@ack -h -o -i '<[a-z0-9]+' *.html|sort -u|cut -b 2-|grep -v -P '^(html|head|meta|link|style|script|noscript|body|title)$$'
