<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:oxy="http://www.oxygenxml.com/extensions/author"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  exclude-result-prefixes="#all"
  version="3.0">

  <xsl:function name="oxy:get-lang">
    <xsl:param name="doc"/>    
    <xsl:value-of select="if ($doc/*/@xml:lang) then $doc/*/@xml:lang else 'en-US'"/>    
  </xsl:function>

  <!-- 
    CHAPTERS FUNCTIONS
  -->

  <xsl:function name="oxy:get-topicref-for-topic" as="node()*">
    <xsl:param name="doc"/>
    <xsl:param name="possible-id"/>
    
    <xsl:variable name="possible-href" select="concat('#', $possible-id)" />
    <xsl:sequence select="($doc//opentopic:map//*[contains(@class, ' map/topicref ')][@href = $possible-href or @id = $possible-id])[1]"/>
  </xsl:function>

  <!-- 
        Function that checks that an item from the TOC is a chapter 
        (book parts are also considered to be chapters).
        
        @param doc The document
        @param toc-item The element from the TOC.
        @return true if the item is a chapter.
    -->    
  <xsl:function name="oxy:is-chapter" as="xs:boolean">
    <xsl:param name="doc"/>
    <xsl:param name="toc-item"/>
    
    <xsl:choose>
      <xsl:when test="contains($toc-item/@class,' mapgroup-d/topicgroup ')">
        <!-- The <topicgroup> element is for creating groups of <topicref> elements without affecting the hierarchy -->
        <xsl:value-of select="false()"/>
      </xsl:when>
      
      <xsl:when test="$doc/*[contains(@class, ' bookmap/bookmap ')]">
        
        <!-- For the bookmaps, the chapters are the "chapter" elements, and all the first level children of a "part", and the parts themselves.. -->
        <xsl:choose>
          <xsl:when test="contains($toc-item/@class,' bookmap/chapter ')">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:when test="contains($toc-item/@class,' bookmap/part ')">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:when test="contains($toc-item/@class,' map/topicref ') and  oxy:has-parent($toc-item, ' bookmap/part ') or
            contains($toc-item/@class,' map/topicref ') and  oxy:has-parent-opentopic-map($toc-item) ">
            <xsl:value-of select="not(contains($toc-item/@class,' bookmap/frontmatter ') or 
              contains($toc-item/@class,' bookmap/backmatter'))"/>
          </xsl:when>                    
          <xsl:when test="contains($toc-item/@class,' bookmap/appendices ')">
            <xsl:value-of select="true()"/>
          </xsl:when>
          <xsl:when test="contains($toc-item/@class,' bookmap/appendix ') and oxy:has-parent($toc-item, ' bookmap/appendices ') and oxy:exists-parts($doc)">
            <xsl:value-of select="true()"/>
          </xsl:when>                    
          <xsl:otherwise>
            <xsl:value-of select="false()"/>                        
          </xsl:otherwise>
        </xsl:choose>        
      </xsl:when>
      <xsl:otherwise>
        <!-- For a normal map, consider the first level topics of the TOC to be chapters. Except the glossary references. -->
        <xsl:choose>
          <xsl:when test="oxy:has-parent-opentopic-map($toc-item)  and contains($toc-item/@class, ' map/topicref ') and not(contains($toc-item/@class, ' glossref-d/glossref '))">
            <xsl:value-of select="true()"/>
          </xsl:when>        
          <xsl:otherwise>
            <xsl:value-of select="false()"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!-- 
        Function that checks if the parent of the toc item has a specific class.
        The mapgroup-d/topicgroup is transparent. 
        
        @param toc-item The element from the TOC.
        @return true if the item has a parent with the specified class.
    -->
  <xsl:function name="oxy:has-parent" as="xs:boolean">
    <xsl:param name="toc-item"/>
    <xsl:param name="parent-class"/>
    
    <xsl:sequence select="
      $toc-item and
      (
      $toc-item/parent::*[contains(@class, $parent-class)]           
      or             
      oxy:has-parent($toc-item/parent::*[contains(@class, ' mapgroup-d/topicgroup ')], $parent-class)
      )
      "/>
  </xsl:function>

  <!-- 
        Function that checks if the parent of the toc item is the opentopic:map.
        The mapgroup-d/topicgroup is transparent. 
        
        @param toc-item The element from the TOC.
        @return true if the item has an opentopic:map parent.
    -->
  <xsl:function name="oxy:has-parent-opentopic-map" as="xs:boolean">
    <xsl:param name="toc-item"/>
    
    
    <xsl:sequence select="
      $toc-item and
      (
      $toc-item/parent::opentopic:map            
      or             
      oxy:has-parent-opentopic-map($toc-item/parent::*[contains(@class, ' mapgroup-d/topicgroup ')])
      )
      "/>
    
  </xsl:function>

  <!-- 
        Function that checks that an item from the TOC is a book part.
        
        @param doc The document
        @param toc-item The element from the TOC.
        @return true if the item is a chapter.
    -->
  <xsl:function name="oxy:is-part" as="xs:boolean">
    <xsl:param name="doc"/>
    <xsl:param name="toc-item"/>
    
    <xsl:choose>
      <xsl:when test="contains($toc-item/@class,' bookmap/part ')">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="contains($toc-item/@class,' bookmap/appendices ') and oxy:exists-parts($doc)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:when test="contains($toc-item/@class,' bookmap/appendix ') and oxy:has-parent-opentopic-map($toc-item) and oxy:exists-parts($doc)">
        <xsl:value-of select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="false()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <!--
        Function that checks if the bookmap contains part elements
        
        @param doc The document
        @return true if the document contains part elements
    -->
  <xsl:function name="oxy:exists-parts" as="xs:boolean">
    <xsl:param name="doc"/>
    
    <xsl:sequence select="count($doc/*[contains(@class, ' bookmap/bookmap ')]/opentopic:map/*[contains(@class, ' bookmap/part ')]) &gt; 0"/>
  </xsl:function>

  <!-- 
    IMAGES FUNCTIONS
  -->

  <!-- Fixes the href, converting it from relative (to the DITA map original file) to absolute. -->
  <xsl:function name="oxy:toAbsolute" as="xs:string">
    <xsl:param name="elem" as="node()"/>
    <xsl:value-of select="oxy:toAbsolute($elem, 'href')"/>
  </xsl:function>
  
  <!-- Fixes the attributes, converting it from relative (to the DITA map original file) to absolute. -->
  <xsl:function name="oxy:toAbsolute" as="xs:string">
    <xsl:param name="elem" as="node()"/>
    <xsl:param name="attrName" as="xs:string"/>
    
    <xsl:variable name="job.file" select="resolve-uri('.job.xml', oxy:makeURL(concat($dita.temp.dir, '/')))"/>
    
    <xsl:choose>
      <xsl:when test="$elem/@scope = 'external' or oxy:isAbsolute($elem/@*[local-name() = $attrName])">
        <!-- The attribute is already absolute, return it directly. -->
        <xsl:value-of select="$elem/@*[local-name() = $attrName]"/>
      </xsl:when>
      <xsl:when test="not(doc-available($job.file))">
        <!-- 
                    There's no .job.xml file available, we use the input directory to absolutize the attribute.
                    This case is encountered when debugging the stylesheet or during tests.
                -->
        <xsl:value-of select="concat($input.dir.url, $elem/@*[local-name() = $attrName])"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- 
                    There's a .job.xml file, we need it as context to match attribute uri.
                    This is necessary when using preprocess2, as the filenames are altered.
                -->
        <xsl:variable name="job" select="document($job.file)" as="document-node()?"/>
        
        <xsl:variable name="result">
          <xsl:variable name="job-result" select="$job/key('jobImagesByUri', $elem/@*[local-name() = $attrName])/@result"/>
          <xsl:variable name="job-result-contains" select="
            if (empty($job-result)) then
            $job//file[contains(@uri, $elem/@*[local-name() = $attrName])]/@result
            else
            $job-result"/>
          
          <xsl:value-of select="
            if (empty($job-result-contains)) then
            resolve-uri($elem/@*[local-name() = $attrName],($elem/ancestor-or-self::*[@xtrf]/@xtrf)[last()])
            else
            $job-result-contains"/>
        </xsl:variable>
        
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Test whether URI is absolute -->
  <xsl:function name="oxy:isAbsolute" as="xs:boolean">
    <xsl:param name="uri" as="xs:anyURI"/>
    <xsl:sequence select="some $prefix in ('/', 'file:') satisfies starts-with($uri, $prefix) or contains($uri, '://')"/>
  </xsl:function>
  
  <!-- Change a filepath into an URI starting with file: -->
  <xsl:function name="oxy:makeURL" as="item()">
    <xsl:param name="filepath"/>
    <xsl:variable name="correctedPath" select="replace($filepath, '\\', '/')"/>
    <xsl:variable name="url">
      <xsl:choose>
        <!-- Mac / Linux paths start with / -->
        <xsl:when test="starts-with($correctedPath, '/')">
          <xsl:value-of select="concat('file://', $correctedPath)"/>
        </xsl:when>
        <!-- Windows paths not start with / -->
        <xsl:otherwise>
          <xsl:value-of select="concat('file:///', $correctedPath)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="iri-to-uri($url)"/>
  </xsl:function>

  <!-- 
    LISTS AND TABLES FUNCTIONS
  -->

  <!-- Checks if the current element (table cell or list item) is preceded by a start change tracking. -->
  <xsl:function name="oxy:has-preceding-change-tracking">
    <xsl:param name="current-element"/>
    
    <xsl:choose>
      <xsl:when test="contains($current-element/@class, 'topic/li')">
        <xsl:sequence select="deep-equal($current-element, 
          ($current-element/preceding-sibling::processing-instruction('oxy_comment_start') |
          $current-element/preceding-sibling::processing-instruction('oxy_insert_start') |
          $current-element/preceding-sibling::processing-instruction('oxy_custom_start'))
          /following-sibling::*[contains(@class, 'topic/li')][1])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="deep-equal($current-element, 
          ($current-element/preceding-sibling::processing-instruction('oxy_comment_start') |
          $current-element/preceding-sibling::processing-instruction('oxy_insert_start') |
          $current-element/preceding-sibling::processing-instruction('oxy_custom_start'))
          /(following-sibling::entry[1] | following-sibling::stentry[1]))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <!-- Checks if the current element (table cell or list item) is followed by an end change tracking. -->
  <xsl:function name="oxy:has-following-change-tracking">
    <xsl:param name="current-element"/>
    
    <xsl:choose>
      <xsl:when test="contains($current-element/@class, 'topic/li')">
        <xsl:sequence select="deep-equal($current-element, 
          ($current-element/following-sibling::processing-instruction('oxy_comment_end') |
          $current-element/following-sibling::processing-instruction('oxy_insert_end') |
          $current-element/following-sibling::processing-instruction('oxy_custom_end'))
          /preceding-sibling::*[contains(@class, 'topic/li')][1])"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="deep-equal($current-element, 
          ($current-element/following-sibling::processing-instruction('oxy_comment_end') |
          $current-element/following-sibling::processing-instruction('oxy_insert_end') |
          $current-element/following-sibling::processing-instruction('oxy_custom_end'))
          /(preceding-sibling::entry[1] | preceding-sibling::stentry[1]))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
</xsl:stylesheet>