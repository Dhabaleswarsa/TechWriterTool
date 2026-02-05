<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen WebHelp Plugin
Copyright (c) 1998-2025 Syncro Soft SRL, Romania.  All rights reserved.

-->

<!--
  Generates a label component for each <keyword> that has 
  the @outputclass='label'. 
-->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns:oxygen="http://www.oxygenxml.com/functions"
  exclude-result-prefixes="xs xhtml" version="3.0">
  
  <!-- Create a <div> with all <keyword> having @outputclass='label' -->
  <xsl:template match="*[contains(@class, ' topic/prolog ')][oxygen:getParameter('webhelp.labels.generation.mode') = 'keywords-label']">
    <xsl:if test="descendant::*[contains(@class, ' topic/keyword ')][@outputclass = 'label']">
      <div class="wh-label-container" role="group" aria-label="Labels">
        <xsl:apply-templates select="descendant::*[contains(@class, ' topic/keyword ')][@outputclass = 'label']" mode="labels-support" />
      </div>
    </xsl:if>
  </xsl:template>
  
  <!-- Create a <div> with all <keyword> or <keyword> having @outputclass='label'. -->
  <xsl:template match="*[contains(@class, ' topic/prolog ')][oxygen:getParameter('webhelp.labels.generation.mode') = 'keywords']">
    <xsl:if test="descendant::*[contains(@class, ' topic/keyword ')]">
      <div class="wh-label-container" role="group" aria-label="Labels">
        <xsl:choose>
          <xsl:when test="descendant::*[contains(@class, ' topic/keyword ')][@outputclass = 'label']">
            <xsl:apply-templates select="descendant::*[contains(@class, ' topic/keyword ')][@outputclass = 'label']" mode="labels-support" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="descendant::*[contains(@class, ' topic/keyword ')]" mode="labels-support" />
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
  </xsl:template>

  <!-- Matches the keyword that will be displayed as a label -->
  <xsl:template match="*[contains(@class, ' topic/keyword ')]" mode="labels-support">
    <xsl:variable name="labelContent" select="normalize-space(string-join(descendant-or-self::text()))"/>
    <a class="wh-label"
      href="{concat($PATH2PROJ, 'search.html?searchQuery=label:', encode-for-uri($labelContent))}">
      <span>
        <xsl:value-of select="$labelContent" />
      </span>
    </a>
  </xsl:template>

</xsl:stylesheet>
