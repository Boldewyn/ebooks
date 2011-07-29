<xsl:stylesheet version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="font-size" select="'10pt'" />
  <xsl:param name="line-height" select="'1.3'" />
  <xsl:param name="leading" select="'13pt'" />

  <xsl:template match="/">
    <xsl:apply-templates select="h:html/h:body//h:article[@class='book']" />
  </xsl:template>

  <xsl:template match="h:article">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="first"
          page-height="29.7cm" page-width="21cm"
          margin-right="72pt" margin-left="72pt"
          margin-bottom="36pt" margin-top="72pt">
          <fo:region-body margin-top="1.5cm"
            margin-bottom="1.5cm"/>
          <fo:region-after region-name="ra-right"
            extent="1cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="left"
          page-height="29.7cm" page-width="21cm"
          margin-right="72pt" margin-left="72pt"
          margin-bottom="36pt" margin-top="36pt">
          <fo:region-body margin-top="1.5cm"
            margin-bottom="1.5cm"/>
          <fo:region-before region-name="rb-left"
            extent="3cm"/>
          <fo:region-after region-name="ra-left"
            extent="1cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="right"
          page-height="29.7cm" page-width="21cm"
          margin-right="72pt" margin-left="72pt"
          margin-bottom="36pt" margin-top="36pt">
          <fo:region-body margin-top="1.5cm"
            margin-bottom="1.5cm"/>
          <fo:region-before region-name="rb-right"
            extent="3cm"/>
          <fo:region-after region-name="ra-right"
            extent="1cm"/>
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
        font-family="'Crimson Text',Crimson,Georgia,serif" color="#222"
        font-size="{$font-size}" line-height="{$line-height}">
        <fo:static-content flow-name="rb-right">
          <fo:block font-size="9pt" text-align="center">
            <xsl:value-of select="/h:html/h:head/h:title" />
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="ra-right">
          <fo:block font-size="9pt" text-align="right"
            font-style="italic">
            <fo:page-number/>
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="rb-left">
          <fo:block font-size="9pt" text-align="center">
            <xsl:value-of select="/h:html/h:head/h:title" />
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="ra-left">
          <fo:block font-size="9pt" text-align="left"
            font-style="italic">
            <fo:page-number/>
          </fo:block>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
          <xsl:apply-templates select="*|text()"/>
        </fo:flow>
      </fo:page-sequence>
    </fo:root>
  </xsl:template>

  <xsl:template match="h:header">
    <fo:block break-after="odd-page">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:section[@id='Table_of_Contents']" />

  <xsl:template match="h:section">
    <fo:block break-after="odd-page">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h1">
    <fo:block font-size="5em" font-weight="bold">
      <xsl:attribute name="margin-bottom">
        <xsl:value-of select="number($line-height)*2" />
      </xsl:attribute>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h2">
    <fo:block font-size="3em" font-weight="bold"
      margin-bottom="{$leading}">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h3">
    <fo:block font-size="2.5em" font-style="italic"
      margin-bottom="{$leading}">
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
    <fo:block margin-top="{$leading}" text-align="justify">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:blockquote">
    <fo:block margin="{$leading}" font-size="9pt">
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

  <xsl:template match="h:hr">
    <fo:block text-align="center" margin-top="{$leading}" margin-bottom="{$leading}">
      <fo:leader leader-pattern="rule" leader-length="61.8%"
        color="#666"
        rule-style="solid" rule-thickness="1pt" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:pre">
    <fo:block white-space-collapse="false" wrap-option="no-wrap">
      <xsl:apply-templates select="*|text()"/>
    </fo:block>
  </xsl:template>

  <xsl:template match="h:br">
    <fo:block />
  </xsl:template>

</xsl:stylesheet>
