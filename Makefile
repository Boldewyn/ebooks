#
# Make various stuff from ebooks
#


EBOOKS := $(patsubst text/%,%,$(wildcard text/*.html))
FOP := fop
XALAN := /usr/share/java/xalan2.jar
NPM := npm
NPM_FLAGS :=


all: css js html pdf epub index mobi
.PHONY: all html pdf epub clean index css js mobi


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))


html: $(EBOOKS) css js

$(EBOOKS): %.html : text/%.html meta/%.json src/template.mustache
	$(info * Compile HTML $@)
	@src/compile_html.py "$(basename $@)"

%.pdf: %.fo src/fo.xsl src/fo.conf
	$(info * Create PDF $@)
	@$(FOP) -a -fo "$<" -c src/fo.conf -pdf "$@"


%.fo: %.html src/fo.xsl
	$(info * Create XSL-FO $@)
	@java -Djava.protocol.handler.pkgs=dummy_about_handler \
	      -cp "$$PWD/src:$(XALAN)" \
	      org.apache.xalan.xslt.Process -indent 2 \
	      -xsl src/fo.xsl -in "$<" -out "$@"


epub: $(EBOOKS) src/epub/*
	$(info * Create all EPUBs)
	@python src/epub/compose.py


%.epub: %.html src/epub/*
	$(info * Create EPUB $@)
	@python src/epub/compose.py "$<"


.SECONDARY: $(patsubst %.html,%.epub,$(EBOOKS))


mobi: $(patsubst %.html,%.mobi,$(EBOOKS))


%.mobi: %.epub
	$(info * Create Mobi $@)
	@ebook-convert "$<" "$@"


clean:
	$(info * Clean generated content)
	@-rm -f $(patsubst %.html,%.pdf,$(EBOOKS)) \
	  $(patsubst %.html,%.fo,$(EBOOKS)) \
	  $(patsubst %.html,%.pdf,$(EBOOKS)) \
	  $(patsubst %.html,%.epub,$(EBOOKS)) \
	  $(patsubst %.html,%.mobi,$(EBOOKS)) \
	  $(EBOOKS)


index: index.json index.js index.xml


index.json: $(EBOOKS)
	@echo -n '["' > "$@"
	@echo -n $(patsubst %.html,%,$(EBOOKS)) | sed 's/ /","/g' >> "$@"
	@echo -n '"]' >> "$@"


index.js: $(EBOOKS)
	@echo "var ebooks=[" > "$@"
	@for b in $(patsubst %.html,%,$(EBOOKS)); do \
	    echo '"'"$$b"'",' >> "$@" ; \
	done
	@echo "];" >> "$@"


index.xml: $(EBOOKS)
	@echo "<ebooks>" > "$@"
	@for b in $(patsubst %.html,%,$(EBOOKS)); do \
	    echo "  <book>$$b</book>" >> "$@"; \
	done
	@echo "</ebooks>" >> "$@"

css: static/ebook.css

static/ebook.css: node_modules src/sass/*
	sass src/sass/ebook.scss | node_modules/.bin/cssmin > $@

js: dependencies static/ebook.js

dependencies: node_modules src/vendor

node_modules: package.json
	$(NPM) $(NPM_FLAGS) install

src/vendor: node_modules
	node_modules/.bin/bower install

static/ebook.js: src/vendor/html5shiv/dist/html5shiv.js src/vendor/jquery/dist/jquery.js src/js/ebook.js
	true >$@
	for js in $^; do <$$js node_modules/.bin/uglifyjs -c -m >> $@; done

fonts:
	$(info * Fetch current fonts from GitHub)
	@for x in static/fonts/*; do \
	    curl -sS "https://raw.githubusercontent.com/skosch/Crimson/master/Web%20Fonts/$$(basename $$x)" > $$x; \
	done
.PHONY: fonts

used_classes:
	#ack 'class=(["'"'"']).*?\1' *.html -h -o|sort -u|cut -b 8-|sed 's/"//'|sed 's/ /\n/g'|sort -u
	@ack -i -o -h '<([a-z0-9]+)[^>]+class="(.*?)"' *.html|cut -b 2-|sort -u|sed 's/ .*class="/./'| sed 's/"$$//'|sed 's/ /./g'|sort -u

used_elements:
	@ack -h -o -i '<[a-z0-9]+' text/*.html|sort -u|cut -b 2-
