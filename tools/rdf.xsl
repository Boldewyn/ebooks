<xsl:stylesheet version="1.0"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/terms/"
  xmlns:h="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <rdf:RDF>
      <xsl:apply-templates select="ebooks/book" />
    </rdf:RDF>
  </xsl:template>

  <xsl:template match="book">
    <rdf:Description>
      <xsl:attribute namespace="http://www.w3.org/1999/02/22-rdf-syntax-ns#" name="about">
        <xsl:value-of select="concat('http://boldewyn.github.com/ebooks/', ., '.html')" />
      </xsl:attribute>
      <dc:title>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.title']/@content" />
      </dc:title>
      <dc:description>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.description']/@content" />
      </dc:description>
      <dc:creator>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.creator']/@content" />
      </dc:creator>
      <dc:publisher>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.publisher']/@content" />
      </dc:publisher>
      <dc:date>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.date']/@content" />
      </dc:date>
      <dc:issued>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.issued']/@content" />
      </dc:issued>
      <dc:language>
        <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:meta[@name='dc.language']/@content" />
      </dc:language>
      <dc:source>
        <xsl:attribute namespace="http://www.w3.org/1999/02/22-rdf-syntax-ns#" name="resource">
          <xsl:value-of select="document(concat('../', ., '.html'))/h:html/h:head/h:link[@rel='dc.source']/@href" />
        </xsl:attribute>
      </dc:source>
    </rdf:Description>
  </xsl:template>

</xsl:stylesheet>
