<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:toc="http://www.oxygenxml.com/ns/webhelp/toc"
    xmlns:oxygen="http://www.oxygenxml.com/functions"
    xmlns="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="sidetoc.xsl"/>
    <xsl:import href="menu.xsl"/>
    <xsl:import href="navJson.xsl"/>
    <xsl:import href="breadcrumb.xsl"/>
    <xsl:import href="linkToParent.xsl"/>
    <xsl:import href="../util/dita-utilities.xsl"/>
    <xsl:import href="../util/functions.xsl"/>
    
    <xsl:param name="TEMP_DIR_URL"/>
    <xsl:param name="MENU_TEMP_FILE_URI"/>
    <xsl:param name="WEBHELP_PUBLICATION_TOC_LINKS" select="'chapter'"/>
    <xsl:param name="WEBHELP_SIDE_TOC_LINKS"/>
    <xsl:param name="WEBHELP_PUBLICATION_TOC_HIDE_CHUNKED_TOPICS" select="'yes'"/>
    <xsl:param name="JSON_OUTPUT_DIR_URI"/>
    <xsl:param name="WEBHELP_TOP_MENU_DEPTH"/>
    <xsl:param name="WEBHELP_PARAMETERS_URL"/>
    <xsl:param name="DEFAULTLANG"/>
    
    <xsl:variable name="VOID_HREF" select="'javascript:void(0)'"/>
    
    <xsl:variable name="webhelp_language" select="oxygen:getParameter('webhelp.language')"/>
    
    <xsl:variable name="i18n_context">
        <!-- EXM-36308 - Generate the lang attributes in a temporary element -->
        <i18n_context>
            <xsl:attribute name="xml:lang" select="$webhelp_language"/>
            <xsl:attribute name="lang" select="$webhelp_language"/>
            <xsl:attribute name="dir" select="oxygen:getParameter('webhelp.page.direction')"/>
        </i18n_context>
    </xsl:variable>
    
    <xsl:output name="html" method="xhtml" html-version="5.0" media-type="text/html" omit-xml-declaration="yes" indent="no"/>
    
    <xsl:key name="tocHrefs" match="toc:topic[@href][not(@href=$VOID_HREF)][not(@format) or @format = 'dita']" use="tokenize(@href, '#')[1]"/>
    
    <xsl:template match="/toc:toc">
        <xsl:apply-templates mode="side-toc" select=".">
            <!-- EXM-36737 - Context node used for messages localization -->
            <xsl:with-param name="i18n_context" select="$i18n_context/*" tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:apply-templates mode="menu" select=".">
            <!-- EXM-36737 - Context node used for messages localization -->
            <xsl:with-param name="i18n_context" select="$i18n_context/*" tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:apply-templates mode="breadcrumb" select=".">
            <!-- EXM-36737 - Context node used for messages localization -->
            <xsl:with-param name="i18n_context" select="$i18n_context/*" tunnel="yes"/>
        </xsl:apply-templates>
        <xsl:apply-templates mode="nav-json" select="."/>
        <xsl:apply-templates mode="linkToParent" select="."/>
    </xsl:template>
    
    
</xsl:stylesheet>