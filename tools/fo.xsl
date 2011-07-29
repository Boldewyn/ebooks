<xsl:stylesheet version="1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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
          <fo:region-before region-name="rb-left"
            extent="3cm"/>
          <fo:region-body margin-top="1.5cm"
            margin-bottom="1.5cm"/>
          <fo:region-after region-name="ra-left"
            extent="1cm"/>
        </fo:simple-page-master>
        <fo:simple-page-master master-name="right"
          page-height="29.7cm" page-width="21cm"
          margin-right="72pt" margin-left="72pt"
          margin-bottom="36pt" margin-top="36pt">
          <fo:region-before region-name="rb-right"
            extent="3cm"/>
          <fo:region-body margin-top="1.5cm"
            margin-bottom="1.5cm"/>
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
      <fo:page-sequence master-reference="standard"><!-- font-family="'Crimson Text',Crimson"-->
        <fo:static-content flow-name="rb-right">
          <fo:block font-size="10pt" text-align="center">
            <xsl:value-of select="/h:html/h:head/h:title" />
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="ra-right">
          <fo:block font-size="10pt" text-align="right"
            font-style="italic">
            <fo:page-number/>
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="rb-left">
          <fo:block font-size="10pt" text-align="center">
            <xsl:value-of select="/h:html/h:head/h:title" />
          </fo:block>
        </fo:static-content>
        <fo:static-content flow-name="ra-left">
          <fo:block font-size="10pt" text-align="left"
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
    <fo:block page-break-after="odd">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:section[@id='Table_of_Contents']" />

  <xsl:template match="h:section">
    <fo:block page-break-after="odd">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h2">
    <fo:block font-size="3em" font-weight="bold">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:h3">
    <fo:block font-size="2.5em" font-style="italic">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:p">
    <fo:block>
      <xsl:if test="local-name(./preceding-sibling::*[1]) = 'p'">
        <xsl:attribute name="start-indent">1.2em</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:p[contains(@class, 'separation)]">
    <fo:block margin-top="1.3em">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:blockquote">
    <fo:block margin="1.2em" font-size=".91em">
      <xsl:apply-templates select="*|text()" />
    </fo:block>
  </xsl:template>

  <xsl:template match="h:i|h:em">
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
    <fo:block>
      <fo:leader leader-pattern="rule"/>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>
