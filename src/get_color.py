#!/usr/bin/python
"""
Generate a (hopefully) unique color fo reach ebook. Use case: cover colors.
"""


from bs4 import BeautifulSoup
import nltk
from os.path import dirname
import re
import sys
from colour import Color
from glob import glob


def circ_ave(a0, a1):
    """see http://stackoverflow.com/a/1416826/113195"""
    r = (a0+a1)/2., ((a0+a1+360)/2.)%360
    if min(abs(a1-r[0]), abs(a0-r[0])) < min(abs(a0-r[1]), abs(a1-r[1])):
        return r[0]
    else:
        return r[1]


stopwords = nltk.corpus.stopwords.words('english')
wnl = nltk.WordNetLemmatizer()
punctrm = re.compile(ur'[!-/:-@\[-`{-~\u2212\u201C\u201D]', re.UNICODE)


for fn in glob('../text/*.html'):
    with open(fn, 'r') as ebook:
        text = ebook.read()


    text = BeautifulSoup(text).get_text()
    tokens = \
        [wnl.lemmatize(t) for t in
            set(
                filter(lambda w: re.sub(punctrm, '', w) != '',
                    [w for w
                        in map(lambda s: s.lower(),
                            nltk.word_tokenize(text))
                        if w not in stopwords]
                )
            )
        ]

    hue = None
    sat = None
    lum = None
    num = 0
    for color in [
        "aliceblue", "antiquewhite", "aqua", "aquamarine", "azure", "beige",
        "bisque", "black", "blanchedalmond", "blue", "blueviolet", "brown",
        "burlywood", "cadetblue", "chartreuse", "chocolate", "coral",
        "cornflowerblue", "cornsilk", "crimson", "cyan", "darkblue", "darkcyan",
        "darkgoldenrod", "darkgray", "darkgreen", "darkgrey", "darkkhaki",
        "darkmagenta", "darkolivegreen", "darkorange", "darkorchid", "darkred",
        "darksalmon", "darkseagreen", "darkslateblue", "darkslategray",
        "darkslategrey", "darkturquoise", "darkviolet", "deeppink", "deepskyblue",
        "dimgray", "dimgrey", "dodgerblue", "firebrick", "floralwhite",
        "forestgreen", "fuchsia", "gainsboro", "ghostwhite", "gold", "goldenrod",
        "gray", "green", "greenyellow", "grey", "honeydew", "hotpink",
        "indianred", "indigo", "ivory", "khaki", "lavender", "lavenderblush",
        "lawngreen", "lemonchiffon", "lightblue", "lightcoral", "lightcyan",
        "lightgoldenrodyellow", "lightgray", "lightgreen", "lightgrey",
        "lightpink", "lightsalmon", "lightseagreen", "lightskyblue",
        "lightslategray", "lightslategrey", "lightsteelblue", "lightyellow",
        "lime", "limegreen", "linen", "magenta", "maroon", "mediumaquamarine",
        "mediumblue", "mediumorchid", "mediumpurple", "mediumseagreen",
        "mediumslateblue", "mediumspringgreen", "mediumturquoise",
        "mediumvioletred", "midnightblue", "mintcream", "mistyrose", "moccasin",
        "navajowhite", "navy", "oldlace", "olive", "olivedrab", "orange",
        "orangered", "orchid", "palegoldenrod", "palegreen", "paleturquoise",
        "palevioletred", "papayawhip", "peachpuff", "peru", "pink", "plum",
        "powderblue", "purple", "red", "rosybrown", "royalblue", "saddlebrown",
        "salmon", "sandybrown", "seagreen", "seashell", "sienna", "silver",
        "skyblue", "slateblue", "slategray", "slategrey", "snow", "springgreen",
        "steelblue", "tan", "teal", "thistle", "tomato", "turquoise", "violet",
        "wheat", "white", "whitesmoke", "yellow", "yellowgreen",

        "night", "blood", "love", "sea", "sky", "dawn", "morning", "grass",
        "bright", "rain", "pale", "smoke", "fire", "misty", "cool", "tree",
    ]:
        c = tokens.count(color)
        if c:
            #print "{:>15s}: {}".format(color, c)
            num += c
            if color == 'teal':
                xcolor = Color('#006D5B')
            elif color == 'night':
                xcolor = Color('#030126')
            elif color == 'blood':
                xcolor = Color('#9C0003')
            elif color == 'love':
                xcolor = Color('#E41F17')
            elif color == 'sea':
                xcolor = Color('#006994')
            elif color == 'sky':
                xcolor = Color('skyblue')
            elif color == 'grass':
                xcolor = Color('#73972A')
            elif color == 'cool':
                xcolor = Color('lightsteelblue')
            elif color == 'bright':
                xcolor = Color('#7DDFF3')
            elif color == 'rain':
                xcolor = Color('#95B7D2')
            elif color == 'pale':
                xcolor = Color('#cccccc')
            elif color == 'smoke':
                xcolor = Color('whitesmoke')
            elif color == 'fire':
                xcolor = Color('orange')
            elif color == 'misty':
                xcolor = Color('mistyrose')
            elif color == 'tree':
                xcolor = Color('springgreen')
            elif color == 'dawn' or color == 'morning':
                xcolor = Color('#FE5454')
            else:
                xcolor = Color(color)
            #hue += xcolor.hue * c
            if hue is None:
                hue = xcolor.hue*360
                sat = xcolor.saturation * c
                lum = xcolor.luminance * c
            else:
                if xcolor.hue > 0.0 or color in ("red", "brown", "dawn", "morning", "maroon", "darkred"):
                    for _c in range(c):
                        hue = circ_ave(hue, xcolor.hue*360)
                sat += xcolor.saturation * c
                lum += xcolor.luminance * c

    if num:
        print '<div style="background:hsl({}, {}%, {}%)">{}</div>'.format(
                hue, sat/num*100, lum/num*100, fn)
