#
# Make various stuff from ebooks
#


EBOOKS := $(patsubst text/%,%,$(wildcard text/*.html))
NPM := npm
NPM_FLAGS :=
SHELL := /bin/bash


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


css: static/ebook.css static/tools.css


static/ebook.css: node_modules/.bin/cssmin \
                  node_modules/normalize.css/normalize.css \
                  src/sass/ebook.scss src/sass/_*.scss
	$(info * generate CSS)
	@cp node_modules/normalize.css/normalize.css src/sass/_normalize.scss
	@sass src/sass/ebook.scss | node_modules/.bin/cssmin > $@


static/tools.css: node_modules/.bin/cssmin \
                  src/sass/_ui/jquery.ui.core.scss \
                  src/sass/_ui/jquery.ui.button.scss \
                  src/sass/_ui/jquery.ui.dialog.scss \
                  src/sass/_ui/jquery.ui.resizable.scss \
                  src/sass/_ui_theme.scss \
                  src/sass/tools.scss
	$(info * generate tools CSS)
	@sass src/sass/tools.scss | node_modules/.bin/cssmin > $@


src/sass/_ui/%.scss: node_modules/jquery-ui/themes/base/%.css
	mkdir -p src/sass/_ui
	cp "$<" "$@"


ui-icons:
	$(info * download icons from jqueryui.com)
	@for COLOR in fafafa cd0a0a 2e83ff 454545 888888; do \
		curl -sS "http://download.jqueryui.com/themeroller/images/ui-icons_$${COLOR}_256x240.png" > static/images/ui-icons_$$COLOR.png; \
		optipng -quiet -o7 static/images/ui-icons_$$COLOR.png; \
	done



js: package.json static/ebook.js static/html5shiv.js


node_modules/html5shiv/dist/html5shiv.min.js \
node_modules/jquery/dist/jquery.js \
node_modules/.bin/cssmin \
node_modules/normalize.css/normalize.css:
	$(info * install node packages)
	@$(NPM) $(NPM_FLAGS) install


src/js/%.d:
	$(info * generate $@)
	@cat <(echo -n '$(patsubst %.d,%.js,$@) $@ : ') \
	    <(browserify --list $(patsubst %.d,%.js,$@) | tr $$'\n' ' ') \
	    <(echo) \
	    <(browserify --list $(patsubst %.d,%.js,$@) | sed 's/$$/:/') \
	  > $@


static/ebook.js: src/js/ebook.d
	$(info * generate JS)
	$(MAKE) test-js
	@browserify src/js/ebook.js | node_modules/.bin/uglifyjs -c warnings=false -m > $@
-include src/js/ebook.d


static/html5shiv.js: node_modules/html5shiv/dist/html5shiv.min.js
	@cp "$<" "$@"


test-js: src/jshintrc src/js/*.js
	$(info * run JS tests)
	@jshint --config src/jshintrc src/js
.PHONY: test-js


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
