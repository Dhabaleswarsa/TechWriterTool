<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:oxy="http://www.oxygenxml.com/extensions/author"
  exclude-result-prefixes="#all"
  version="3.0">

  <!-- 
    Filter oxy:elements except oxy:delete added as list-items. They are processed inside them.
  -->
  <xsl:template match="*[contains(@class, ' topic/ol ')] | *[contains(@class, ' topic/ul ')]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="* | processing-instruction('oxy_delete') except oxy:*"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/li ')]">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      
      <!-- Process preceding tracked changes inside list-items. -->
      <xsl:if test="oxy:has-preceding-change-tracking(.)">
        <xsl:apply-templates select="
          preceding-sibling::processing-instruction('oxy_comment_start') |
          preceding-sibling::processing-instruction('oxy_insert_start') |
          preceding-sibling::processing-instruction('oxy_custom_start')" mode="processOxygenPIs"/>
      </xsl:if>
      
      <xsl:apply-templates/>
      
      <!-- Process following tracked changes inside list-items. -->
      <xsl:if test="oxy:has-following-change-tracking(.)">
        <xsl:apply-templates select="
          following-sibling::processing-instruction('oxy_comment_end') |
          following-sibling::processing-instruction('oxy_insert_end') |
          following-sibling::processing-instruction('oxy_custom_end')" mode="processOxygenPIs"/>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>