import os
import re
import zipfile
from codecs import open
from mako.template import Template
from split import fetch, split, get_meta


work_path = os.path.abspath(os.path.dirname(__file__))+"/"


def compose_epub(name):
    """Create an EPUB file from an ebook"""
    parts = split(fetch(name))
    lang = parts[4]
    meta = get_meta(parts[1])
    target = name + ".epub"
    epub = zipfile.ZipFile(target, 'w')
    epub.write(work_path+"templates/mimetype", "mimetype")
    epub.write(work_path+"templates/META-INF", "META-INF")
    epub.write(work_path+"templates/META-INF/container.xml",
               "META-INF/container.xml")
    epub.write(work_path+"templates/OEBPS", "OEBPS")
    for style in ["Roman", "Italic", "Bold", "BoldItalic", "Semibold",
                  "SemiboldItalic"]:
        epub.write(work_path+'../../static/CrimsonText-%s.ttf' % style,
                   'OEBPS/CrimsonText-%s.ttf' % style)
    epub.write(work_path+'../../static/ebook.css', 'OEBPS/ebook.css')

    chapters = parts[3]
    ch_titles = []
    for i, chapter in enumerate(chapters):
        html = u'''<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="%s">
  <head>
    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="ebook.css" />
    <title>Chapter %s</title>
  </head>
  <body><div class="book"><div class="section" id="chapter_%s">''' % (lang, i+1, i+1)
        content = unicode(chapter)
        ch_titles.append(re.sub(re.compile(r'^.*<h2>(.*?)</h2>.*$', re.S),
                                r'\1', content))
        html += content
        html += u'</div></div></body></html>'
        epub.writestr('OEBPS/chapter_%s.html' % (i+1),
                      html.encode('UTF-8'))

    folder = name
    chapters = ch_titles
    epub.writestr('OEBPS/Content.opf',
        Template(filename=work_path +
            'templates/OEBPS/Content.opf').render(**locals()))
    epub.writestr('OEBPS/toc.ncx',
        Template(filename=work_path +
            'templates/OEBPS/toc.ncx').render(**locals()))

    ixml = u'''<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
  <head>
    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="ebook.css" />
    <title>%s by %s, Fanfiction story #%s</title>
  </head>
  <body>
    <div class="book" id="index">
      <div class="header">
        %s
      </div>
      <div class="index" id="Table_of_Contents">
        %s
      </div>
    </div>
  </body>
</html>''' % (meta.get("title"), meta.get("creator"), name,
        unicode(parts[0]), unicode(parts[2]))
    epub.writestr('OEBPS/index.html', ixml.encode('UTF-8'))
    epub.close()
    return target


def compose_all():
    for f in os.listdir(workdir+"../.."):
        if f.endswith(".html"):
            if f not in ["index.html", "index.de.html", "404.html"]:
                compose_epub(f.replace(".html", ""))


if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        compose_epub(sys.argv[1].replace(".html", ""))
    else:
        compose_all()


