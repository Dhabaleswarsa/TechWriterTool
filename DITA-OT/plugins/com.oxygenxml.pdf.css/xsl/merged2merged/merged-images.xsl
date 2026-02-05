<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:oxy="http://www.oxygenxml.com/extensions/author"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:ImageInfo="java:com.oxygenxml.dita.xsltextensions.ImageInfo"
    exclude-result-prefixes="#all" version="3.0">
    <!-- 
        
        Images.
        
    -->
    <!-- The temporary directory -->
    <xsl:param name="dita.temp.dir"/>
    
    <!-- The list of job images by URI, we can use them directly to convert images relative to absolute paths. -->
    <xsl:key name="jobImagesByUri" match="//file[@format='image'][not(@resource-only='true')]" use="@uri"/>
    
    <!-- Convert the href from relative (to the DITA map original file - as it is processed by the DITA-OT 
        previous ant targets) to absolute. -->
    <xsl:template match="*[contains(@class, ' topic/image ')]/@href">
        <xsl:attribute name="href">
            <xsl:value-of select="oxy:toAbsolute(..)"/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- Checks the width/height values and warns if percent unit is used or if the unit contains uppercase letters. -->
    <xsl:template match="*[contains(@class, ' topic/image ')]/@width | *[contains(@class, ' topic/image ')]/@height">
        <xsl:choose>
            <xsl:when test="matches(., '[%]')">
                <xsl:message terminate="no">[OXYIM01W][WARNING] Cannot process image <xsl:value-of select="local-name()"/> with value: <xsl:value-of select="."/>. The percent sign has been ignored.</xsl:message>
                <xsl:attribute name="{local-name()}" select="replace(., '[%]', '')"/>
            </xsl:when>
            <xsl:when test="matches(., '[A-Z]+')">
                <xsl:message terminate="no">[OXYIM02W][WARNING] Cannot process image <xsl:value-of select="local-name()"/> with value: <xsl:value-of select="."/>. The unit has been modified to lowercase.</xsl:message>
                <xsl:attribute name="{local-name()}" select="lower-case(.)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Checks the scale value and warns if a unit is present. -->
    <xsl:template match="*[contains(@class, ' topic/image ')]/@scale">
        <xsl:choose>
            <xsl:when test="matches(., '[%|a-zA-Z]+')">
                <xsl:message terminate="no">[OXYIM03W][WARNING] Cannot process image <xsl:value-of select="local-name()"/> with value: <xsl:value-of select="."/>. The unit has been discarded.</xsl:message>
                <xsl:attribute name="{local-name()}" select="replace(., '[%|a-zA-Z]', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:next-match/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Deals with images not having width nor height specified in the document. -->
    <xsl:template match="*[contains(@class, ' topic/image ')][not(@width)][not(@height)]/@href" priority="2">
        
        <xsl:variable name="href" select="oxy:toAbsolute(..)"/>
        <xsl:variable name="image-size" select="ImageInfo:getImageSize($href)"/>
        
        <xsl:if test="not($image-size = '-1,-1')">
            <xsl:variable name="width-in-pixel">
                <xsl:call-template name="length-to-pixels">
                    <xsl:with-param name="dimen" select="substring-before($image-size, ',')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="height-in-pixel">
                <xsl:call-template name="length-to-pixels">
                    <xsl:with-param name="dimen" select="substring-after($image-size, ',')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:attribute name="dita-ot:image-width" select="floor(number($width-in-pixel))"/>
            <xsl:attribute name="dita-ot:image-height" select="floor(number($height-in-pixel))"/>
        </xsl:if>
        
        <xsl:next-match/>
    </xsl:template>

</xsl:stylesheet>