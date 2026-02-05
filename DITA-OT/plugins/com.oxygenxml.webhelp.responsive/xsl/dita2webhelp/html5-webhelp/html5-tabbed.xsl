<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">

  <xsl:template match="
      *[contains(@class, ' topic/ol ')][@outputclass = 'wh-tabbed'] |
      *[contains(@class, ' topic/ul ')][@outputclass = 'wh-tabbed'] |
      *[contains(@class, ' topic/dl ')][@outputclass = 'wh-tabbed'] |
      *[contains(@class, ' task/choicetable ')][@outputclass = 'wh-tabbed']">
    <!-- Add specific classes to list -->
    <xsl:variable name="list">
      <xsl:next-match/>
    </xsl:variable>
    <ul class="nav nav-tabs" role="tablist">
      <xsl:copy-of select="$list/*/(@* except @class, @role)"/>
      <xsl:attribute name="aria-labelledby" select="concat('tablist-', generate-id(.))"/>
      <!-- Create the navigation tabs -->
      <xsl:for-each select="
          child::*[contains(@class, ' topic/li ')] |
          child::*[contains(@class, ' topic/dlentry ')] |
          child::*[contains(@class, ' task/chrow ')]">
        <xsl:call-template name="createNavItem">
          <xsl:with-param name="position" select="position()"/>
          <xsl:with-param name="context" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    </ul>
    <!-- Create the tabs content -->
    <div class="tab-content">
      <xsl:for-each select="
          child::*[contains(@class, ' topic/li ')] |
          child::*[contains(@class, ' topic/dlentry ')] |
          child::*[contains(@class, ' task/chrow ')]">
        <div role="tabpanel">
          <xsl:call-template name="createTabPanelAttrs">
            <xsl:with-param name="position" select="position()"/>
          </xsl:call-template>
          <div class="tab-pane-wrapper">
            <xsl:apply-templates select="* except *[contains(@class, ' topic/ph ') or contains(@class, ' topic/dt ') or contains(@class, ' task/choption ')][1]"/>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template name="createNavItem">
    <xsl:param name="context"/>
    <xsl:param name="position"/>
    <xsl:variable name="uniqueID" select="generate-id(.)"/>
    <li class="nav-item">
      <span class="nav-link" data-bs-toggle="tab" role="tab">
        <xsl:attribute name="class" select="
          if ($position = 1) then
            'nav-link active'
          else
            'nav-link'"/>
        <xsl:attribute name="aria-selected" select="
          if ($position = 1) then
            'true'
          else
            'false'"/>
        <xsl:attribute name="id" select="concat('tab-', $uniqueID)"/>
        <xsl:attribute name="href" select="concat('#', $uniqueID, '-', $position)"/>
        <xsl:attribute name="aria-controls" select="concat($uniqueID, '-', $position)"/>
        <xsl:value-of select="$context/*[contains(@class, ' topic/ph ') or contains(@class, ' topic/dt ') or contains(@class, ' task/choption ')][1]"/>
      </span>
    </li>
  </xsl:template>

  <xsl:template name="createTabPanelAttrs">
    <xsl:param name="position"/>
    <xsl:variable name="uniqueID" select="generate-id(.)"/>
    <xsl:attribute name="class" select="
      if ($position = 1) then
        'tab-pane fade show active'
      else
        'tab-pane fade'"/>
    <xsl:attribute name="id" select="concat($uniqueID, '-', position())"/>
    <xsl:attribute name="aria-labelledby" select="concat('tab-', $uniqueID)"/>
  </xsl:template>

</xsl:stylesheet>
