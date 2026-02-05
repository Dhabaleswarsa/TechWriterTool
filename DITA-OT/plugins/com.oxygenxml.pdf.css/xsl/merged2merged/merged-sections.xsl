<!-- 
  
  This stylesheet processes the sections from the main content.
  
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs" version="3.0">

  <!-- 
    Process only sections, not their specializations!
  -->
  <xsl:template match="*[@class = '- topic/section ']">
    <xsl:choose>
      <xsl:when test="$numbering-sections">
        <xsl:variable name="nm">
          <xsl:next-match/>
        </xsl:variable>
        <xsl:apply-templates select="$nm" mode="numbering-sections">
          <xsl:with-param name="id" select="if(@id) then @id else generate-id(.)" />
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
    Generates additional @id and @outputclass attributes.
  -->
  <xsl:template match="*[@class = '- topic/section ']" mode="numbering-sections">
    <xsl:param name="id"/>
    <xsl:copy>
      <xsl:copy-of select="@* except @outputclass"/>
      <xsl:if test="not(@id)">
        <!-- Add an @id so that links from the TOC are working. -->
        <xsl:attribute name="id" select="$id"/>
      </xsl:if>
      <xsl:choose>
        <!-- Add an @outputclass for the CSS selectors. -->
        <xsl:when test="@outputclass">
          <xsl:attribute name="outputclass" select="concat(@outputclass, ' numbering-sections')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="outputclass" select="'numbering-sections'"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:copy-of select="node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
