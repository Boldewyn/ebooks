<xsl:stylesheet version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="font-size" select="'10pt'" />
  <xsl:param name="small-font-size" select="'8pt'" />
  <xsl:param name="line-height" select="1.3" />
  <xsl:param name="leading" select="'13pt'" />
  <xsl:param name="leading-2-3rd" select="'8.667pt'" />
  <xsl:param name="font-color" select="'#222'" />
  <xsl:param name="light-color" select="'#777'" />
  <xsl:param name="highlight-color" select="'#922'" />

  <xsl:variable name="language" select="substring-before(/h:html/@xml:lang, '-')" />

  <xsl:template match="/">
    <xsl:apply-templates select="h:html/h:body//h:article[@class='book']" />
  </xsl:template>

  <xsl:template match="h:article">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="first"
          page-height="22.8cm" page-width="15.5cm"
          margin-right="2.668cm" margin-left="2.668cm"
          margin-bottom="3.062cm" margin-top="2.534cm">
          <fo:region-body margin-top="1cm"
            margin-bottom="1cm"/>
          <fo:region-after region-name="ra-right"
            margin-top=".3cm" extent=".7cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="left"
          page-height="22.8cm" page-width="15.5cm"
          margin-right="1.941cm" margin-left="3.395cm"
          margin-bottom="4.062cm" margin-top="1.934cm">
          <!--margin-bottom="5.062cm" margin-top="2.534cm"-->
          <fo:region-body margin-top=".6cm"
            margin-bottom="1cm"/>
          <fo:region-before region-name="rb-left"
            extent=".6cm"/>
          <fo:region-after region-name="ra-left"
            margin-top=".3cm" extent=".7cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="right"
          page-height="22.8cm" page-width="15.5cm"
          margin-right="3.395cm" margin-left="1.941cm"
          margin-bottom="4.062cm" margin-top="1.934cm">
          <fo:region-body margin-top=".6cm"
            margin-bottom="1cm"/>
          <fo:region-before region-name="rb-right"
            extent=".6cm"/>
          <fo:region-after region-name="ra-right"
            margin-top=".3cm" extent=".7cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="plain-left"
          page-height="22.8cm" page-width="15.5cm"
          margin-right="1.941cm" margin-left="3.395cm"
          margin-bottom="5.062cm" margin-top="2.534cm">
          <fo:region-body />
        </fo:simple-page-master>
        <fo:simple-page-master master-name="plain-right"
          page-height="22.8cm" page-width="15.5cm"
          margin-right="3.395cm" margin-left="1.941cm"
          margin-bottom="5.062cm" margin-top="2.534cm">
          <fo:region-body />
        </fo:simple-page-master>
        <fo:page-sequence-master master-name="standard">
          <fo:single-page-master-reference master-reference="first" />
          <fo:single-page-master-reference master-reference="plain-left" />
          <fo:single-page-master-reference master-reference="plain-right" />
          <fo:single-page-master-reference master-reference="plain-left" />
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference
              master-reference="first"
              page-position="first"/>
            <fo:conditional-page-master-reference
              master-reference="left"
              odd-or-even="even"/>
            <fo:conditional-page-master-reference
              master-reference="right"
              odd-or-even="odd"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </fo:layout-master-set>
      <xsl:call-template name="generate-declarations" />
      <xsl:call-template name="generate-bookmarks" />
      <fo:page-sequence master-reference="standard"
        language="{$language}"
        font-family="'Crimson Text',Crimson,Georgia,serif" color="{$font-color}"
        font-size="{$font-size}" line-height="{$line-height}">
        <fo:static-content flow-name="rb-right">
          <fo:block font-size="{$small-font-size}" text-align="center">
            <fo:retrieve-marker retrieve-class-name="chapter"
              retrieve-position="first-starting-within-page" />
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="ra-right">
          <fo:block font-size="{$small-font-size}" text-align="right"
            font-style="italic">
            <fo:page-number/>
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="rb-left">
          <fo:block font-size="{$small-font-size}" text-align="center">
            <xsl:value-of select="/h:html/h:head/h:title" />
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="ra-left">
          <fo:block font-size="{$small-font-size}" text-align="left"
            font-style="italic">
            <fo:page-number/>
          </fo:block>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="*|text()"/>
          <fo:block margin-top="3.27em" break-after="odd-page"
            font-size="4em" text-align="center" color="#cccccc">
            <fo:instream-foreign-object width="2cm" height="2cm"
              fox:alt-text="&#x2766;">
              <xsl:copy-of select="document('static/Aldus_leaf_unicode2766.svg', /h:html)/*" />
            </fo:instream-foreign-object>
          </fo:block>
          <xsl:call-template name="colophon" />
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="h:header">
    <fo:block break-after="odd-page">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
    <xsl:call-template name="front-matter" />
  </xsl:template>

  <xsl:template match="h:section[@id='Table_of_Contents']"
    priority="1.1">
    <fo:block break-after="odd-page" role="TOC">
      <xsl:copy-of select="@id" />
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:section">
    <fo:block margin-top="3.27cm">
      <xsl:if test="not(ancestor::h:section)">
        <xsl:attribute name="break-after">
          <xsl:text>odd-page</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="@id" />
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h1">
    <fo:block font-size="3.2em" role="H1">
      <xsl:attribute name="line-height">
        <xsl:value-of select="$line-height*30" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="margin-bottom">
        <xsl:value-of select="$line-height*30" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h2">
    <fo:block keep-with-next="always">
      <fo:marker marker-class-name="chapter">
        <xsl:text>&#xA0;</xsl:text>
      </fo:marker>
    </fo:block>
    <fo:block font-size="2.4em"
      margin-bottom="{$leading}" role="H2">
      <xsl:attribute name="line-height">
        <xsl:value-of select="$line-height*20" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <xsl:if test="not(ancestor::h:header)">
        <fo:marker marker-class-name="chapter">
          <xsl:value-of select="."/>
        </fo:marker>
      </xsl:if>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h3">
    <fo:block keep-with-next="always"
      font-size="2.0em" font-style="italic"
      margin-bottom="{$leading}" role="H3">
      <xsl:attribute name="line-height">
        <xsl:value-of select="$line-height*20" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <xsl:if test="not(./preceding-sibling::*[local-name()='h2'])">
        <fo:marker marker-class-name="subchapter">
          <xsl:value-of select="."/>
        </fo:marker>
      </xsl:if>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h4">
    <fo:block font-size="1.6em" letter-spacing=".12em"
      margin-bottom="{$leading}" keep-with-next="always"
      role="H4">
      <xsl:attribute name="line-height">
        <xsl:value-of select="$line-height*20" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h5">
    <fo:block font-size="1.2em" letter-spacing=".12em"
      font-variant="small-caps" line-height="{$leading}"
      margin-bottom="{$leading}" keep-with-next="always"
      role="H5">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:p">
    <fo:block text-align="justify" hyphenate="true">
      <xsl:if test="local-name(./preceding-sibling::*[1]) = 'p'">
        <xsl:attribute name="text-indent">
          <xsl:value-of select="$leading" />
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:p[contains(@class, 'separation')]">
    <fo:block space-before="{$leading}" text-align="justify"
      hyphenate="true">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:blockquote">
    <fo:block margin="{$leading}" font-size="{$small-font-size}"
      role="BlockQuote">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:i|h:em|h:var">
    <fo:inline font-style="italic">
      <xsl:apply-templates select="*|text()" />
    </fo:inline>
  </xsl:template>

  <xsl:template match="h:b|h:strong|h:span[contains(@class, 'proper-name')]">
    <fo:inline font-variant="small-caps" letter-spacing=".05em">
      <xsl:apply-templates select="*|text()" />
    </fo:inline>
  </xsl:template>

  <xsl:template match="sub">
    <fo:inline vertical-align="sub" font-size="{$small-font-size}">
      <xsl:apply-templates select="*|text()"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="sup">
    <fo:inline vertical-align="super" font-size="{$small-font-size}">
      <xsl:apply-templates select="*|text()"/>
    </fo:inline>
  </xsl:template>

  <xsl:template match="h:hr">
    <fo:block text-align="center" space-before="{$leading}" space-after="{$leading}">
      <fo:leader leader-pattern="rule" leader-length="61.8%"
        color="{$light-color}"
        rule-style="solid" rule-thickness="1pt" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:pre">
    <fo:block white-space-collapse="false" white-space-treatment="preserve"
      linefeed-treatment="preserve">
      <fo:block>
        <xsl:apply-templates select="*|text()"/>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="h:br">
    <fo:block />
  </xsl:template>

  <xsl:template match="h:ol|h:ul">
    <fo:list-block provisional-distance-between-starts="1cm"
      provisional-label-separation="0.5cm">
      <xsl:attribute name="space-after">
        <xsl:choose>
          <xsl:when test="ancestor::h:ul or ancestor::h:ol">
            <xsl:text>0</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$leading" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:attribute name="start-indent">
        <xsl:variable name="ancestors">
          <xsl:choose>
            <xsl:when test="count(ancestor::h:ol) or count(ancestor::h:ul)">
              <xsl:value-of select="(count(ancestor::h:ol) + 
                                     count(ancestor::h:ul)) * 
                                    $line-height"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>-1</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat($ancestors, 'cm')"/>
      </xsl:attribute>
      <xsl:apply-templates select="*"/>
    </fo:list-block>
  </xsl:template>

  <xsl:template match="h:ol/h:li">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="right">
          <xsl:variable name="value-attr">
            <xsl:choose>
              <xsl:when test="../@start">
                <xsl:number value="position() + ../@start - 1"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:number value="position()"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="../@type='i'">
              <xsl:number value="$value-attr" format="i."/>
            </xsl:when>
            <xsl:when test="../@type='I'">
              <xsl:number value="$value-attr" format="I."/>
            </xsl:when>
            <xsl:when test="../@type='a'">
              <xsl:number value="$value-attr" format="a."/>
            </xsl:when>
            <xsl:when test="../@type='A'">
              <xsl:number value="$value-attr" format="A."/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:number value="$value-attr" format="1."/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates select="*|text()"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="h:ul/h:li">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block>&#x2013;</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates select="*|text()"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="h:span[@class='footnote']">
    <fo:footnote>
      <fo:inline font-size="{$small-font-size}" baseline-shift="super">
        <xsl:number level="any"
          count="h:span[@class='footnote']" format="1)"/>
      </fo:inline>
      <fo:footnote-body>
        <fo:list-block provisional-distance-between-starts=".5cm"
          provisional-label-separation=".15cm"
          margin-top="{$leading}">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block font-size="{$small-font-size}"
                line-height="{$leading}"
                text-indent="0">
                <xsl:number level="any"
                  count="h:span[@class='footnote']" format="1)"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block font-size="{$small-font-size}"
                line-height="{$leading}"
                text-indent="0">
                <xsl:apply-templates/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:footnote-body>
    </fo:footnote>
  </xsl:template>

  <xsl:template match="h:span[@class='footnote-body']">
    <xsl:apply-templates select="*|text()"/>
  </xsl:template>

  <xsl:template match="h:a">
    <xsl:choose>
      <xsl:when test="@href">
        <fo:basic-link color="{$highlight-color}">
          <xsl:choose>
            <xsl:when test="starts-with(@href, '#')">
              <xsl:attribute name="internal-destination">
                <xsl:value-of select="substring(@href, 2)"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="external-destination">
                <xsl:value-of select="@href"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="*|text()"/>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="*|text()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="h:figure">
    <fo:block margin-top="{$leading}"
      keep-together="always" role="Figure"
      margin-bottom="{$leading}" text-align="center">
      <xsl:copy-of select="@id" />
      <xsl:apply-templates select="*"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="h:img">
    <fo:block>
      <fo:external-graphic src="{@src}" max-width="10cm"
        fox:alt-text="{@alt}" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:figcaption">
    <fo:block margin-top="{$leading}"
      font-size="{$small-font-size}" font-style="italic"
      role="Caption">
      <xsl:apply-templates select="*|text()"/>
    </fo:block>
  </xsl:template>

  <xsl:template name="front-matter">
    <fo:block-container font-size="{$small-font-size}"
      text-align="justify"
      break-after="odd-page">
      <fo:block text-align="center">
        <xsl:value-of select="/h:html/h:head/h:title" />
      </fo:block>
      <fo:block space-before="2cm">
        About this book:
      </fo:block>
      <fo:block font-style="italic">
        <xsl:value-of select="/h:html/h:head/h:meta[@name='dc.description']/@content" />
      </fo:block>
      <fo:block space-before="4cm"
        font-weight="bold">
        Bibliographic data:
      </fo:block>
      <xsl:for-each select="/h:html/h:head/h:meta[substring(@name, 1, 3) = 'dc.']">
        <fo:block text-indent="-{$leading}" start-indent="{$leading}">
          <fo:inline>
            <xsl:value-of select="translate(substring(@name, 4, 1),
              'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')" />
            <xsl:value-of select="substring(@name, 5)" />
            <xsl:text>: </xsl:text>
          </fo:inline>
          <fo:inline font-style="italic">
            <xsl:value-of select="@content" />
          </fo:inline>
        </fo:block>
      </xsl:for-each>
    </fo:block-container>
  </xsl:template>

  <xsl:template name="colophon">
    <fo:block-container font-size="{$small-font-size}"
      text-align="justify" font-style="italic">
      <fo:block margin-top="2cm">
        <fo:marker marker-class-name="chapter">&#xA0;</fo:marker>
        Thank you for reading this eBook.
        <xsl:if test="/h:html/h:head/h:meta[@name='dc.publisher'] and
                      /h:html/h:head/h:meta[@name='dc.issued']">
          It was first published in
          <xsl:value-of select="substring(/h:html/h:head/h:meta[@name='dc.issued']/@content, 1, 4)" />
          by
          <xsl:value-of select="/h:html/h:head/h:meta[@name='dc.publisher']/@content" />.
          Since then it had a long journey.
        </xsl:if>
        The current version was scanned by volunteers and published
        under
        <fo:basic-link color="{$highlight-color}">
          <xsl:attribute name="external-destination">
            <xsl:value-of select="/h:html/h:head/h:link[@rel='dc.source']/@href"/>
          </xsl:attribute>
          <xsl:value-of select="/h:html/h:head/h:link[@rel='dc.source']/@href"/>
        </fo:basic-link>. From there it was converted to HTML5 and
        this file by
        <fo:basic-link color="{$highlight-color}" external-destination="http://www.manuel-strehl.de/">Manuel Strehl</fo:basic-link>.
      </fo:block>
      <fo:block space-before="{$leading}" text-align="center">
        <fo:leader leader-pattern="rule" leader-length="61.8%"
          color="{$light-color}"
          rule-style="solid" rule-thickness="1pt" />
      </fo:block>
      <fo:block space-before="{$leading}">
        Other books in the same fashion:
      </fo:block>
      <fo:table space-before="{$leading}" table-layout="fixed" width="100%">
        <fo:table-body>
          <xsl:call-template name="fetch-others" />
        </fo:table-body>
      </fo:table>
      <fo:block space-before="{$leading}">
        (If you read this electronically, click on the description to
        directly load the book.)
      </fo:block>
    </fo:block-container>
  </xsl:template>

  <xsl:template name="fetch-others">
    <xsl:param name="root" select="/h:html" />
    <xsl:for-each select="document('index.xml', /h:html)/ebooks/book">
      <xsl:if test="position() mod 2">
        <xsl:value-of select="substring-before(., '.html')" />
        <fo:table-row>
          <fo:table-cell padding-right=".5cm" padding-bottom=".5cm">
            <xsl:call-template name="one-other">
              <xsl:with-param name="root" select="$root" />
            </xsl:call-template>
          </fo:table-cell>
          <fo:table-cell padding-left=".5cm" padding-bottom=".5cm">
            <xsl:choose>
              <xsl:when test="./following-sibling::book[1]">
                <xsl:call-template name="one-other">
                  <xsl:with-param name="title" select="./following-sibling::book[1]" />
                  <xsl:with-param name="root" select="$root" />
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <fo:block />
              </xsl:otherwise>
            </xsl:choose>
          </fo:table-cell>
        </fo:table-row>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="one-other">
    <xsl:param name="title" select="." />
    <xsl:param name="root" select="/h:html" />
    <xsl:variable name="link"
      select="concat('http://www.boldewyn.de/ebooks/', $title, '.pdf')" />
    <fo:block>
      <fo:block font-weight="bold" font-size="{$font-size}"
        font-style="normal" text-align="center"
        keep-with-next="always">
        <fo:basic-link external-destination="{$link}">
          <xsl:value-of
            select="document(concat($title, '.html'),
                    $root)/h:html/h:head/h:meta[@name='dc.title']/@content" />
        </fo:basic-link>
      </fo:block>
      <fo:block font-style="normal" text-align="center"
        keep-with-next="always">
        <fo:basic-link external-destination="{$link}">
          <xsl:text>by </xsl:text>
          <xsl:value-of
            select="document(concat($title, '.html'),
                    $root)/h:html/h:head/h:meta[@name='dc.creator']/@content" />
        </fo:basic-link>
      </fo:block>
      <fo:block>
        <fo:basic-link external-destination="{$link}">
          <xsl:value-of
            select="document(concat($title, '.html'),
                    $root)/h:html/h:head/h:meta[@name='dc.description']/@content" />
        </fo:basic-link>
      </fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template name="generate-bookmarks">
    <fo:bookmark-tree>
      <xsl:for-each select="./h:section">
        <xsl:call-template name="one-bookmark">
          <xsl:with-param name="level" select="2" />
        </xsl:call-template>
      </xsl:for-each>
    </fo:bookmark-tree>
  </xsl:template>

  <xsl:template name="one-bookmark">
    <xsl:param name="level" select="2" />
    <xsl:if test="@id and ./h:*[local-name()=concat('h', string($level))]">
      <fo:bookmark>
        <xsl:attribute name="internal-destination">
          <xsl:value-of select="@id" />
        </xsl:attribute>
        <fo:bookmark-title>
          <xsl:value-of select="./h:*[local-name()=concat('h', string($level))]" />
        </fo:bookmark-title>
        <xsl:for-each select="./h:section">
          <xsl:call-template name="one-bookmark">
            <xsl:with-param name="level" select="$level+1" />
          </xsl:call-template>
        </xsl:for-each>
      </fo:bookmark>
    </xsl:if>
  </xsl:template>

  <xsl:template name="generate-declarations">
    <fo:declarations>
      <x:xmpmeta xmlns:x="adobe:ns:meta/">
        <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
          <rdf:Description rdf:about=""
            xmlns:dc="http://purl.org/dc/elements/1.1/">
            <xsl:for-each select="/h:html/h:head/h:meta[substring(@name, 1, 3) = 'dc.']">
              <xsl:element name="{substring(@name, 4)}" namespace="http://purl.org/dc/elements/1.1/">
                <xsl:value-of select="@content" />
              </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="/h:html/h:head/h:link[substring(@rel, 1, 3) = 'dc.']">
              <xsl:element name="{substring(@rel, 4)}" namespace="http://purl.org/dc/elements/1.1/">
                <xsl:attribute namespace="http://www.w3.org/1999/02/22-rdf-syntax-ns#" name="resource">
                  <xsl:value-of select="@href" />
                </xsl:attribute>
              </xsl:element>
            </xsl:for-each>
          </rdf:Description>
          <rdf:Description rdf:about=""
            xmlns:xmp="http://ns.adobe.com/xap/1.0/">
            <xmp:CreatorTool>Ebook generator; http://www.boldewyn.de/ebooks/</xmp:CreatorTool>
          </rdf:Description>
        </rdf:RDF>
      </x:xmpmeta>
    </fo:declarations>
  </xsl:template>

</xsl:stylesheet>
