<!-- 
    This stylesheet identifies the "chapters" and book "parts" from the map (can be a bookmap or ordinary map) both
    in the TOC and the content.
    
    The identified chapters are marked with the attribute @is-chapter='true'.
    The identified parts are marked with the attribute @is-part='true'.         
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:oxy="http://www.oxygenxml.com/extensions/author"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" version="3.0">
    
    <!-- 
        Mark the chapters, so their titles can be presented differently in the TOC. 
    
        Details:
        
        We are using the @class attribute as a "hook" to inject the new attributes. We use this 
        technique to avoid writing a template that generates a new element and would override the fixes from
        the "post-process-toc.xsl".
    -->
    <xsl:template match="opentopic:map//*[oxy:is-chapter(/, .)]/@class">
        <xsl:attribute name="is-chapter">true</xsl:attribute>
        <xsl:if test="oxy:is-part(/,..)">
            <xsl:attribute name="is-part">true</xsl:attribute>
        </xsl:if>
        <!-- Process the @class -->
        <xsl:next-match/>
    </xsl:template>    
    
    <!-- 
        Matches all topics from the merged content.
        
        Marks the ones referred from the TOC chapter entries. 
        
        Details:
        
        We use an optimisation, since we cannot have chapters on a level greater that 3 (the first 
        is the root, the second are the chapter topics for normal maps, the third are the chapters from the bookmaps with parts.)
        
        We are using the @class attribute as a "hook" to inject the new attributes. We use this 
        technique to avoid writing a template that generates a new element and would override the fixes from
        the "post-process-toc.xsl".
    -->
    <xsl:template match="*[contains(@class, ' topic/topic')][count(ancestor::*) &lt; 4]/@class">
            
        <xsl:variable name="possible-id" select="../@id"/>
        <xsl:if test="$possible-id">
        
            <xsl:variable name="topic-ref" select="oxy:get-topicref-for-topic(/, $possible-id)" as="node()*"/>
            <xsl:variable name="is-chapter" select="oxy:is-chapter(/, $topic-ref)" as="xs:boolean"/>
            <xsl:variable name="is-part" select="oxy:is-part(/, $topic-ref)"  as="xs:boolean"/>
            
            <xsl:if test="$is-chapter">
                <!-- The topic was referred from the map  by a topic reference marked as chapter. -->
                <xsl:attribute name="break-before">true</xsl:attribute>
                <xsl:attribute name="is-chapter">true</xsl:attribute>
                
                <xsl:if test="$is-part">
                    <!-- The topic was referred from the map  by a topic reference marked as a part. -->
                    <xsl:attribute name="is-part">true</xsl:attribute>
                </xsl:if>
                
            </xsl:if>
        </xsl:if>
        
        <!-- Process the @class -->
        <xsl:next-match/>            
    </xsl:template>

</xsl:stylesheet>