<?xml version="1.0" encoding="UTF-8"?>
<!-- 

  This stylesheet changes the lists layout.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">

  <!-- Process @outputclass="start-x" as start="x" HTML attribute. -->
  <xsl:template match="*[contains(@class, ' topic/ol ')]" mode="set-output-class">
    <xsl:if test="contains(@outputclass, 'start-')">
      <xsl:attribute name="start" select="replace(@outputclass, '^.*start-(\d+).*$', '$1')"/>
    </xsl:if>
    <xsl:next-match/>
  </xsl:template>

</xsl:stylesheet>