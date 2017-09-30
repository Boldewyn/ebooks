#
# Make various stuff from ebooks
#

SHELL := /bin/bash

EBOOKS := $(patsubst text/%,docs/%,$(wildcard text/*.html))

BROWSERIFY := node_modules/.bin/browserify

POSTCSS := node_modules/.bin/postcss
POSTCSS_ARGS := --use postcss-import --use autoprefixer --use cssnano --no-map


all: css js html pdf epub mobi index
.PHONY: all


html: $(EBOOKS) css js
.PHONY: html

$(EBOOKS): docs/%.html : text/%.html meta/%.json src/template.mustache
	$(info * Compile HTML $@)
	@src/compile_html.py "$(shell basename $@ .html)"
.SECONDARY: $(EBOOKS)


pdf: $(patsubst %.html,%.pdf,$(EBOOKS))
.PHONY: pdf

docs/%.pdf: docs/%.html src/colophon.html docs/static/ebook.css
	$(info * Create PDF $@)
	@prince --input=html5 --output="$@" "$<" src/colophon.html
.SECONDARY: $(patsubst %.html,%.pdf,$(EBOOKS))


epub: $(EBOOKS) src/epub/*
	$(info * Create all EPUBs)
	@python src/epub/compose.py
.PHONY: epub

docs/%.epub: docs/%.html src/epub/*
	$(info * Create EPUB $@)
	@python src/epub/compose.py "$<"
.SECONDARY: $(patsubst %.html,%.epub,$(EBOOKS))


mobi: $(patsubst %.html,%.mobi,$(EBOOKS))
.PHONY: mobi


docs/%.mobi: docs/%.epub
	$(info * Create Mobi $@)
	@ebook-convert "$<" "$@"
.SECONDARY: $(patsubst %.html,%.mobi,$(EBOOKS))


clean:
.PHONY: clean


index: docs/index.json docs/index.html
.PHONY: index

docs/index.json: $(EBOOKS)
	@echo -n '["' > "$@"
	@echo -n $(patsubst docs/%.html,%,$(EBOOKS)) | sed 's/ /","/g' >> "$@"
	@echo -n '"]' >> "$@"

docs/index.html: $(EBOOKS)
	@echo "var ebooks=[" > "$@"
	@for b in $(patsubst docs/%.html,%,$(EBOOKS)); do \
	    echo '"'"$$b"'",' >> "$@" ; \
	done
	@echo "];" >> "$@"


css: fonts docs/static/ebook.css
.PHONY: css

docs/static/ebook.css: src/css/ebook.css src/css/_*.css
	@cd src/css && <"$(notdir $<)" ../../$(POSTCSS) $(POSTCSS_ARGS) >"../../$@"
.SECONDARY: docs/static/ebook.css


js: # docs/static/ebook.js
.PHONY: js

#src/js/%.d: node_modules/jquery/dist/jquery.js
#	$(info * generate $@)
#	@cat <(echo -n '$(patsubst %.d,%.js,$@) $@ : ') \
#	    <($(BROWSERIFY) --list $(patsubst %.d,%.js,$@) | sed '/^'$$(echo "$(patsubst %.d,%.js,$@)" | sed 's#/#\\/#g')'$$/d' | tr $$'\n' ' ') \
#	    <(echo) \
#	    <($(BROWSERIFY) --list $(patsubst %.d,%.js,$@) | sed 's/$$/:/') \
#	  > $@

#docs/static/ebook.js: src/js/ebook.d
#	$(info * generate JS)
#	$(MAKE) test-js
#	@$(BROWSERIFY) -t browserify-hogan src/js/ebook.js | \
#	    node_modules/.bin/uglifyjs -c warnings=false -m > $@
#-include src/js/ebook.d


docs/static/fonts/%.woff2:
	@mkdir -p '$(dir $@)'
	@curl -sSL 'https://github.com/huertatipografica/Alegreya/raw/master/fonts/webfonts/$(notdir $@)' > '$@'

fonts: \
	docs/static/fonts/Alegreya-Black.woff2 \
	docs/static/fonts/Alegreya-BlackItalic.woff2 \
	docs/static/fonts/Alegreya-Bold.woff2 \
	docs/static/fonts/Alegreya-BoldItalic.woff2 \
	docs/static/fonts/Alegreya-ExtraBold.woff2 \
	docs/static/fonts/Alegreya-ExtraBoldItalic.woff2 \
	docs/static/fonts/Alegreya-Italic.woff2 \
	docs/static/fonts/Alegreya-Medium.woff2 \
	docs/static/fonts/Alegreya-MediumItalic.woff2 \
	docs/static/fonts/Alegreya-Regular.woff2 \
	docs/static/fonts/AlegreyaSC-Black.woff2 \
	docs/static/fonts/AlegreyaSC-BlackItalic.woff2 \
	docs/static/fonts/AlegreyaSC-Bold.woff2 \
	docs/static/fonts/AlegreyaSC-BoldItalic.woff2 \
	docs/static/fonts/AlegreyaSC-ExtraBold.woff2 \
	docs/static/fonts/AlegreyaSC-ExtraBoldItalic.woff2 \
	docs/static/fonts/AlegreyaSC-Italic.woff2 \
	docs/static/fonts/AlegreyaSC-Medium.woff2 \
	docs/static/fonts/AlegreyaSC-MediumItalic.woff2 \
	docs/static/fonts/AlegreyaSC-Regular.woff2
.PHONY: fonts


test-js: src/jshintrc src/js/*.js
	$(info * run JS tests)
	@jshint --config src/jshintrc src/js
.PHONY: test-js


used_classes:
	#ack 'class=(["'"'"']).*?\1' *.html -h -o|sort -u|cut -b 8-|sed 's/"//'|sed 's/ /\n/g'|sort -u
	@ack -i -o -h '<([a-z0-9]+)[^>]+class="(.*?)"' *.html|cut -b 2-|sort -u|sed 's/ .*class="/./'| sed 's/"$$//'|sed 's/ /./g'|sort -u


used_elements:
	@ack -h -o -i '<[a-z0-9]+' text/*.html|sort -u|cut -b 2-
