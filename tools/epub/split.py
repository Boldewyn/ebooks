

import re
import sys
from BeautifulSoup import BeautifulSoup


def fetch(name):
    """"""
    fh = open("%s.html" % name)
    html = fh.read()
    fh.close()
    return html


def split(html):
    """"""
    soup = BeautifulSoup(html)
    lang = soup.html["xml:lang"]
    article = soup.find("article", {"class": "book"})
    meta = soup.html.head.findAll(["meta", "link"])
    header = article.find("header")
    sections = []
    toc = None
    for s in article.findAll("section", recursive=False):
        if s.get("id", "") != "Table_of_Contents":
            sections.append(s)
        else:
            toc = s
    statics = []
    for s in article.findAll(src=re.compile(r"^[a-zA-Z0-9_-].*")):
        statics.append(s["src"])
    for s in article.findAll(href=re.compile(r"^[a-zA-Z0-9_-].*")):
        statics.append(s["href"])
    return [header, meta, toc, sections, lang, list(set(statics))]


def get_meta(soup):
    """"""
    r = {}
    for node in soup:
        if node.name == "meta":
            if node.get("name", "").startswith("dc."):
                r[node["name"].split(".")[1]] = node.get("content")
                continue
        if node.name == "link":
            if node.get("rel", "").startswith("dc."):
                r[node["rel"].split(".")[1]] = node.get("href")
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

