<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">

  <xsl:template match="*" mode="process.note.common-processing">
    <xsl:param name="type" select="@type"/>
    <xsl:param name="title">
      <xsl:call-template name="getVariable">
        <xsl:with-param name="id" select="concat(upper-case(substring($type, 1, 1)), substring($type, 2))"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:variable name="note">
      <xsl:next-match>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="title" select="$title"/>
      </xsl:next-match>
    </xsl:variable>
    <xsl:apply-templates select="$note" mode="discard.note.body"/>
  </xsl:template>

  <xsl:template match="node() | @*" mode="discard.note.body">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <!--
    Filter div.note__body to allow single or double line display.
    Chemistry imposes block display if a child block is present.
  -->
  <xsl:template match="*[contains(@class, 'note__body')]" mode="discard.note.body">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
</xsl:stylesheet>