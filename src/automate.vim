"
" Semi-automatic Gutenberg-to-great-markup conversion
"
" Use on raw content HTML only! No <head>, or else the meta tag
" attributes get clobbered.
"


" normalize markup
:g/^$/d
:%s/<\(\/\?[A-Z]\+\)/<\L\1/g
:%s/<p> *\n */<p>/g
:%s# *\n *</p>#</p>#g
:%s/\(>\)\@<!\n */ /g
:%s/<h\([1-6]\)>[ \t\n]\+/<h\1>/g
:%s/[ \t\n]\+<\/h\([1-6]\)>/<\/h\1>/g

" replace "1st", "2nd" and so on with raised ordinals
" Danger: Attribute content may not be changed!
:%s/\([0-9]\)\(st\|nd\|rd\|th\)/\1<sup>\2<\/sup>/g

" Replace quotes at tag start
:%s/<\(p\|pre\)>"/<\1>“/g

" Replace quotes at tag end
:%s/"<\/\(p\|pre\)>/”<\/\1>/g

" Replace some HTML entities
:%s/&mdash;/—/g
:%s/&ndash;/–/g
:%s/&nbsp;/ /g

" apostrophes
:%s/\([a-zA-Z]\)'\([a-zA-Z ]\)/\1’\2/g
:%s/\<'\(twas\|tis|ome\)/’\1/g

" Replace straight quotes
" 66
:%s/<p>"/<p>“/g
:%s/\([ \-–—]\)"\([A-Za-z0-9']\)/\1“\2/g

" 99
:%s#"</p>#”</p>#g
:%s/\([a-zA-Z0-9,.:;?!\-–—%']\)"\([ ]\)/\1”\2/g
:%s/\([a-zA-Z0-9']\)"\([,.:;?!\-–—]\)/\1”\2/g
:%s/\([,.:;?!]\)"\([\-–—]\)/\1”\2/g

" 6
:%s/<p>'/<p>‘/g
:%s/\([ \-–—"“]\)'\([A-Za-z0-9]\)/\1‘\2/g

" 9
:%s#'</p>#’</p>#g
:%s/\([a-zA-Z0-9,.:;?!\-–—%]\)'\([ "”]\)/\1’\2/g
:%s/\([a-zA-Z0-9]\)'\([,.:;?!\-–—"”]\)/\1’\2/g
:%s/\([,.:;?!]\)'\([\-–—]\)/\1’\2/g

" typographic fine tuning
" small spaces between adjacent quotes
:%s/“‘/“ ‘/g
:%s/’”/’ ”/g
" smaller space between initials
:%s/\([A-Z]\.\) \([A-Z]\)\@=/\1 /g
" some space between some stuff
:%s/e\.g\./e. g./g
:%s/i\.e\./i. e./g

" UPPERCASE should be <strong>, but we can't predict, if this
" is true in every case (abbreviations, for example). Hence we must ask.
:s/\<[[:upper:]]\{2,}\>/<strong>\L&<\/strong>/gc
