<xsl:stylesheet version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
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
        <fo:page-sequence-master master-name="standard">
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
      <fo:page-sequence master-reference="standard"
        font-family="'Crimson Text',Crimson,Georgia,serif" color="{$font-color}"
        font-size="{$font-size}" line-height="{$line-height}">
        <fo:static-content flow-name="rb-right">
          <fo:block font-size="{$small-font-size}" text-align="center">
            <fo:retrieve-marker retrieve-class-name="chapter" />
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
          <fo:block-container font-size="{$small-font-size}" font-style="italic">
            <fo:block>
              Thank you for reading this eBook.
            </fo:block>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="h:header">
    <fo:block break-after="odd-page">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:section[@id='Table_of_Contents']"
    priority="1.1">
    <fo:block break-after="odd-page">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:section">
    <fo:block break-after="odd-page" margin-top="3.27cm">
      <xsl:copy-of select="@id" />
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h1">
    <fo:block font-size="3.2em">
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
    <fo:block font-size="2.4em"
      margin-bottom="{$leading}">
      <xsl:attribute name="line-height">
        <xsl:value-of select="$line-height*20" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <fo:marker marker-class-name="chapter">
        <xsl:value-of select="."/>
      </fo:marker>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h3">
    <fo:block font-size="2.0em" font-style="italic"
      margin-bottom="{$leading}">
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
      margin-bottom="{$leading}">
      <xsl:attribute name="line-height">
        <xsl:value-of select="$line-height*20" />
        <xsl:text>pt</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:p">
    <fo:block text-align="justify">
      <xsl:if test="local-name(./preceding-sibling::*[1]) = 'p'">
        <xsl:attribute name="text-indent">
          <xsl:value-of select="$leading" />
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:p[contains(@class, 'separation')]">
    <fo:block space-before="{$leading}" text-align="justify">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:blockquote">
    <fo:block margin="{$leading}" font-size="{$small-font-size}">
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
</xsl:stylesheet>
