#!/usr/bin/python3


import json
import os
import sys
try:
    from urllib.parse import quote
except ImportError:
    from urllib import quote
import pystache


def main(args):
    """"""
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    for base in args:
        with open("meta/{}.json".format(base)) as _f:
            meta = json.load(_f)
        with open("text/{}.html".format(base)) as _f:
            text = _f.read()
        with open("src/template.mustache") as _f:
            template = _f.read()
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
        for m in meta:
            name = m["key"]
            entry = {
                "name": name,
            }
            if name == "dc.language":
                ctx["lang"] = m["value"]
            if name == "dc.creator":
                ctx["author"] = m["value"]
            if name == "dc.title":
                ctx["book_title"] = m["value"]
                ctx["enctitle"] = quote(m["value"])
            if m.get("scheme", False) == "dc.URI":
                entry["url"] = True
                entry["value"] = m["value"]
                if m.get("label", False):
                    entry["label"] = m["label"]
            elif name == "style":
                ctx["style"] = m["value"]
            elif name == "class":
                ctx["class"] = " {}".format(m["value"])
            else:
                entry["value"] = m["value"]
                if m.get("scheme", False):
                    entry["scheme"] = m["scheme"]
            ctx["metadata"].append(entry)

        result = pystache.render(template.encode("utf-8"), ctx)
        with open("{}.html".format(base), "w") as _f:
            _f.write(result)


if __name__ == "__main__":
    main(sys.argv[1:])
