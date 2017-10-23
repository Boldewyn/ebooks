#!/usr/bin/python3
"""
Create the ebook index
"""


from glob import glob
from os import chdir
from os.path import abspath, dirname
import pystache
import json


def main():
    chdir(dirname(dirname(abspath(__file__))))

    books = []
    files = glob('meta/*.json')
    for _file in sorted(files):
        with open(_file) as _f:
            meta = json.load(_f)
            books.append({
                'slug': _file[5:-5],
                'title': 'Unnamed Book',
                'author': 'Anonymous',
            })
            for _meta in meta:
                if _meta['key'] == 'dc.creator':
                    books[-1]['author'] = _meta['value']
                if _meta['key'] == 'dc.title':
                    books[-1]['title'] = _meta['value']
                if _meta['key'] == 'dc.language' and _meta['value'][0:2] == 'de':
                    books[-1]['language'] = 'german'

    # render the template
    with open("src/index.mustache") as _f:
        template = _f.read()
    result = pystache.render(template.encode("utf-8"), {
        'books': books,
    })
    with open("docs/index.html", "w") as _f:
        _f.write(result)


if __name__ == "__main__":
    main()
