#!/usr/bin/python3
"""
Take ebook parts and assemble them to XHTML

This script requires /src/template.mustache and files
/meta/<ID>.json and /text/<ID>.html for each processed
book <ID>.
"""


import json
import os
import sys
from urllib.parse import quote as urlquote
import pystache


def main(args):
    """Take parts of an ebook and assemble to a nice HTML format
    args is a list of identifiers, like A_Study_in_Scarlet.
    """
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    for base in args:
        with open("meta/{}.json".format(base)) as _f:
            meta = json.load(_f)
        with open("text/{}.html".format(base)) as _f:
            text = _f.read()
        with open("src/template.mustache") as _f:
            template = _f.read()

        # the context handed to the mustache template
        ctx = {
            "meta": meta,
            "enctitle": "",
            "book_title": "",
            "author": "",
            "text": text,
            "lang": "en",
            "metadata": [],
            "style": False,
            "class": "",
        }

        # extract some information from the meta info and prepare for
        # the template
        for m in meta:
            name = m["key"]
            entry = {
                "name": name,
            }

            # some meta info triggers special handling
            if name == "dc.language":
                ctx["lang"] = m["value"]
            if name == "dc.creator":
                ctx["author"] = m["value"]
            if name == "dc.title":
                ctx["book_title"] = m["value"]
                ctx["enctitle"] = urlquote(m["value"])

            if m.get("scheme", False) == "dc.URI":
                entry["url"] = True
                entry["value"] = m["value"]
                if m.get("label", False):
                    entry["label"] = m["label"]
            elif name == "style":
                ctx["style"] = m["value"]
                continue
            elif name == "class":
                ctx["class"] = " {}".format(m["value"])
                continue
            else:
                entry["value"] = m["value"]
                if m.get("scheme", False):
                    entry["scheme"] = m["scheme"]

            ctx["metadata"].append(entry)

        # render the template
        result = pystache.render(template.encode("utf-8"), ctx)
        with open("{}.html".format(base), "w") as _f:
            _f.write(result)


if __name__ == "__main__":
    main(sys.argv[1:])
