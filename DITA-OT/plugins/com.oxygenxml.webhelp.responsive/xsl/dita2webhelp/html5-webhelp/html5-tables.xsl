<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:table="http://dita-ot.sourceforge.net/ns/201007/dita-ot/table"
  xmlns:simpletable="http://dita-ot.sourceforge.net/ns/201007/dita-ot/simpletable"
  exclude-result-prefixes="xs dita-ot table simpletable"
  version="3.0">

  <!-- Add a tooltip on table cells -->
  <xsl:template match="*[table:is-tbody-entry(.)]" mode="headers">
    <xsl:if test="$WEBHELP_DISPLAY_TABLE_CELL_TOOLTIP = 'yes'">
      <xsl:if test="not(xs:integer(@dita-ot:x) eq 1)">
        <!-- The row label is the content of the first row cell. -->
        <xsl:variable name="targetRow" select="
            if (ancestor::*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')][@dita-ot:x = '1']) then
              ancestor::*[contains(@class, ' topic/row ')]
            else
              ancestor::*[contains(@class, ' topic/row ')]/preceding-sibling::*[contains(@class, ' topic/row ')][1][*[contains(@class, ' topic/entry ')][@dita-ot:x = '1']]"/>
        <xsl:variable name="rowHeader">
          <xsl:apply-templates select="$targetRow/*[contains(@class, ' topic/entry ')][@dita-ot:x = '1']" mode="text-only"/>
        </xsl:variable>
        <!-- The column label is the content of the current cell corresponding header cell(s). -->
        <xsl:variable name="ids" select="table:get-matching-thead-headers(.)"/>
        <xsl:variable name="targetHeaders" select="
            table:get-current-table(.)//*[contains(@class, 'topic/thead')][1]//*[some $id in table:get-matching-thead-headers(current())
              satisfies dita-ot:generate-html-id(.) = $id]"/>
        <xsl:variable name="colHeader" as="xs:string*">
          <xsl:apply-templates select="$targetHeaders" mode="text-only"/>
        </xsl:variable>
        <xsl:variable name="rowLabel" select="normalize-space(string-join($rowHeader))"/>
        <xsl:variable name="colLabel" select="normalize-space(string-join($colHeader, ' · '))"/>
        <xsl:choose>
          <xsl:when test="string-length($rowLabel) > 0 and string-length($colLabel) > 0">
            <xsl:attribute name="title" select="concat($rowLabel, ' | ', $colLabel)"/>
          </xsl:when>
          <xsl:when test="string-length($rowLabel) > 0">
            <xsl:attribute name="title" select="$rowLabel"/>
          </xsl:when>
          <xsl:when test="string-length($colLabel) > 0">
            <xsl:attribute name="title" select="$colLabel"/>
          </xsl:when>
        </xsl:choose>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- Add a tooltip on simpletable cells -->
  <xsl:template match="*[simpletable:is-body-entry(.)]" mode="simpletable:headers">
    <xsl:if test="$WEBHELP_DISPLAY_TABLE_CELL_TOOLTIP = 'yes'">
      <xsl:variable name="keycol" select="simpletable:get-current-table(.)/@keycol"/>
      <xsl:variable name="rowHeader">
        <xsl:choose>
          <xsl:when test="$keycol and not(simpletable:is-keycol-entry(.))">
            <!-- The row label is the content of the row cell marked as keycol. -->
            <xsl:apply-templates select="ancestor::*[contains(@class, ' topic/strow ')]/*[contains(@class, ' topic/stentry ')][@dita-ot:x = $keycol]" mode="text-only"/>
          </xsl:when>
          <xsl:when test="not($keycol or xs:integer(@dita-ot:x) eq 1)">
            <!-- The row label is the content of the first row cell. -->
            <xsl:apply-templates select="ancestor::*[contains(@class, ' topic/strow ')]/*[contains(@class, ' topic/stentry ')][@dita-ot:x = '1']" mode="text-only"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <!-- The column label is the content of the current cell corresponding header cell(s). -->
      <xsl:variable name="colHeader">
        <xsl:apply-templates select="simpletable:get-current-table(.)//*[contains(@class, ' topic/sthead ')][1]//*[contains(@class, ' topic/stentry ')][@dita-ot:x = current()/@dita-ot:x]" mode="text-only"/>
      </xsl:variable>
      <xsl:variable name="rowLabel" select="normalize-space(string-join($rowHeader))"/>
      <xsl:variable name="colLabel" select="normalize-space(string-join($colHeader))"/>
      <xsl:choose>
        <xsl:when test="string-length($rowLabel) > 0 and string-length($colLabel) > 0">
          <xsl:attribute name="title" select="concat($rowLabel, ' | ', $colLabel)"/>
        </xsl:when>
        <xsl:when test="string-length($rowLabel) > 0">
          <xsl:attribute name="title" select="$rowLabel"/>
        </xsl:when>
        <xsl:when test="string-length($colLabel) > 0">
          <xsl:attribute name="title" select="$colLabel"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>