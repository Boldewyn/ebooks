

import re
import sys
from bs4 import BeautifulSoup


_cache = {}


def fetch(name):
    """"""
    if name not in _cache or "html" not in _cache[name]:
        _cache[name] = _cache.get(name, {})
        with open("%s.html" % name) as fh:
            _cache[name]["html"] = fh.read()
    return _cache[name]["html"]


def split(name):
    """"""
    if name not in _cache or "cont" not in _cache[name]:
        _cache[name] = _cache.get(name, {})
        soup = BeautifulSoup(fetch(name))
        lang = soup.html["lang"]
        article = soup.find("article")
        meta = soup.html.head.find_all(["meta", "link"])
        header = article.find("header")
        sections = []
        toc = None
        for s in article.find_all("section", recursive=False):
            if s.get("id", "") != "Table_of_Contents":
                sections.append(s)
            else:
                toc = s
        statics = []
        for s in article.find_all(src=re.compile(r"^[a-zA-Z0-9_-].*")):
            statics.append(s["src"])
        for s in article.find_all(href=re.compile(r"^[a-zA-Z0-9_-].*")):
            statics.append(s["href"])
        _cache[name]["cont"] = [header, meta, toc, sections, lang, list(set(statics))]
    return _cache[name]["cont"]


def get_meta(soup):
    """"""
    r = {}
    for node in soup:
        if node.name == "meta":
            if node.get("name", "").startswith("dc."):
                r[node["name"].split(".")[1]] = node.get("content")
                continue
        if node.name == "link":
            rel = node.get("rel", "")
            if isinstance(rel, list):
                rel = rel[0]
            if rel.startswith("dc.") and \
               rel.split(".")[1] not in r:
                r[rel.split(".")[1]] = node.get("href")
                continue
    return r


def main():
    """"""
    parts = split(fetch(sys.argv[1]))
    meta = get_meta(parts[1])
    print meta
    print len(parts[3])


if __name__ == "__main__":
    main()

