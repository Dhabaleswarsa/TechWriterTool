<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="3.0">
  
  <xsl:import href="plugin:org.lwdita:xsl/map2markdown-cover.xsl"/>
  
  <!-- Copied from org.lwdita/xsl/map2markdownImpl.xsl -->
  <xsl:template match="*[contains(@class, ' map/map ')]" mode="toc">
    <xsl:param name="pathFromMaplist"/>
    <xsl:if test="descendant::*[contains(@class, ' map/topicref ')]
      [not(@toc = 'no')]
      [not(@processing-role = 'resource-only')]">
      <!--<bulletlist>-->
        <xsl:call-template name="commonattributes"/>
        <!-- If there is a shortdesc that can be displayed, process it -->
        <xsl:apply-templates select="descendant::*[contains(@class, ' map/shortdesc ')]
          [not(ancestor::*[contains(@class, ' map/topicref ')])]" mode="toc"/>
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      <!--</bulletlist>-->
    </xsl:if>
  </xsl:template>
  
  <!-- Copied from org.lwdita/xsl/map2markdownImpl.xsl and split to insert H2 headers -->
  <xsl:template match="*[contains(@class, ' map/topicref ')]
    [not(@toc = 'no')]
    [not(@processing-role = 'resource-only')]"
    mode="toc" priority="2">
    <xsl:param name="pathFromMaplist"/>
    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:variable name="level" select="
      count(ancestor::*[contains(@class, ' map/topicref ')]
      [not(@toc = 'no')]
      [not(@processing-role = 'resource-only')])"/>
    <xsl:choose>
      <xsl:when test="$level = 0">
        <xsl:if test="normalize-space($title)">
          <header level="2">
            <xsl:value-of select="normalize-space($title)"/>
          </header>
        </xsl:if>
        <bulletlist>
          <xsl:next-match>
            <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            <xsl:with-param name="title" select="$title"/>
          </xsl:next-match>
        </bulletlist>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match>
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
          <xsl:with-param name="title" select="$title"/>
        </xsl:next-match>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' map/topicref ')]
    [not(@toc = 'no')]
    [not(@processing-role = 'resource-only')]"
    mode="toc">
    <xsl:param name="pathFromMaplist"/>
    <xsl:param name="title"/>
    <xsl:choose>
      <xsl:when test="normalize-space($title)">
        <li>
          <xsl:call-template name="commonattributes"/>
          <xsl:choose>
            <!-- If there is a reference to a DITA or HTML file, and it is not external: -->
            <xsl:when test="normalize-space(@href)">
              <link>
                <xsl:attribute name="href">
                  <xsl:choose>
                    <xsl:when test="@copy-to and not(contains(@chunk, 'to-content')) and 
                      (not(@format) or @format = 'dita' or @format = 'ditamap') ">
                      <xsl:if test="not(@scope = 'external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <xsl:call-template name="replace-extension">
                        <xsl:with-param name="filename" select="@copy-to"/>
                        <xsl:with-param name="extension" select="$OUTEXT"/>
                      </xsl:call-template>
                      <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:when test="not(@scope = 'external') and (not(@format) or @format = 'dita' or @format = 'ditamap')">
                      <xsl:if test="not(@scope = 'external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <xsl:call-template name="replace-extension">
                        <xsl:with-param name="filename" select="@href"/>
                        <xsl:with-param name="extension" select="$OUTEXT"/>
                      </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise><!-- If non-DITA, keep the href as-is -->
                      <xsl:if test="not(@scope = 'external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <!--xsl:if test="@scope = 'external' or not(not(@format) or @format = 'dita' or @format = 'ditamap')">
                  <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:if-->
                <xsl:value-of select="$title"/>
              </link>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$title"/>
            </xsl:otherwise>
          </xsl:choose>
          <!-- If there is a shortdesc that can be displayed, process it -->
          <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' map/shortdesc ')]" mode="toc"/>
          <!-- If there are any children that should be in the TOC, process them -->
          <xsl:if test="descendant::*[contains(@class, ' map/topicref ')]
            [not(@toc = 'no')]
            [not(@processing-role = 'resource-only')]">
            <bulletlist>
              <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
              </xsl:apply-templates>
            </bulletlist>
          </xsl:if>
        </li>
      </xsl:when>
      <xsl:otherwise><!-- if it is an empty topicref -->
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]" mode="toc">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- called shortdesc processing - blockquote after H1 header or text after topic link -->
  <xsl:template match="*[contains(@class, ' map/shortdesc ')]" mode="toc">
    <xsl:choose>
      <xsl:when test="not(ancestor::*[contains(@class, ' map/topicref ')])">
        <blockquote>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates/>
        </blockquote>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="commonattributes"/>
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>