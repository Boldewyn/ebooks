#
# Make various stuff from ebooks
#


EBOOKS := $(patsubst text/%,%,$(wildcard text/*.html))
NPM := npm
NPM_FLAGS :=


all: css js html pdf epub index mobi
.PHONY: all html pdf epub clean index css js mobi


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))


html: $(EBOOKS) css js


$(EBOOKS): %.html : text/%.html meta/%.json src/template.mustache
	$(info * Compile HTML $@)
	@src/compile_html.py "$(basename $@)"


%.pdf: %.html src/colophon.html static/ebook.css
	$(info * Create PDF $@)
	@prince --input=html5 --output="$@" "$<" src/colophon.html


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
	@-rm -f \
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

static/ebook.css: node_modules/.bin/cssmin \
                  node_modules/normalize.css/normalize.css \
                  src/sass/*
	$(info * Generate CSS)
	@cp node_modules/normalize.css/normalize.css src/sass/_normalize.scss
	@sass src/sass/ebook.scss | node_modules/.bin/cssmin > $@

js: node_modules static/ebook.js static/html5shiv.js


node_modules/.bin/cssmin: node_modules


node_modules: package.json
	@$(NPM) $(NPM_FLAGS) install


static/ebook.js: node_modules/jquery/dist/jquery.js src/js/ebook.js
	$(info * Generate JS)
	@true >$@
	@for js in $^; do <$$js node_modules/.bin/uglifyjs -c -m >> $@; done


static/html5shiv.js: node_modules/html5shiv/dist/html5shiv.min.js
	@cp "$<" "$@"


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
