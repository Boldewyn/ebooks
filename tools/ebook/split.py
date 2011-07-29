

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
    return [header, meta, toc, sections]


def get_meta(soup):
    """"""
    r = {}
    for node in soup:
        if node.name == "meta":
            if node.get("name", "") == "dc.title":
                r["title"] = node.get("content")
                continue
            if node.get("name", "") == "dc.creator":
                r["creator"] = node.get("content")
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

