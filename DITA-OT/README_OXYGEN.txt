DITA Open Toolkit bundled with Oxygen 28.0, build 2026013010

Differences between the DITA Open Toolkit bundled with Oxygen and a regular DITA Open Toolkit distribution
downloaded from the DITA-OT project:

http://www.dita-ot.org/


/bin/
- The launchers dita.bat and dita.sh use now other Java class that is capable of expanding wildcard plugin references to jar files.
- The "-Dsun.io.useCanonCaches=true" system property was set in the "dita.bat" for faster processing with Java 12 and newer.

--------ADDITIONAL INSTALLED PLUGINS---------------

Oxygen plugins used for publishing to WebHelp and PDF (CSS based).

com.oxygenxml.common
com.oxygenxml.dita.metrics.report
com.oxygenxml.dost.patches
com.oxygenxml.editlink
com.oxygenxml.export.map
com.oxygenxml.gsd
com.oxygenxml.highlight
com.oxygenxml.html.embed
com.oxygenxml.image.float
com.oxygenxml.media
com.oxygenxml.merged
com.oxygenxml.pdf.css
com.oxygenxml.pdf.custom - deprecated, will be removed in future versions
com.oxygenxml.pdf.review
com.oxygenxml.specialization.qa
com.oxygenxml.webhelp.responsive
mathml
com.oxygenxml.dynamic.resources.converter

Oxygen publishing integrations

com.oxygenxml.zendesk


DITA plugins not distributed by default:
org.dita.troff


Other third party plugins are distributed under the Apache 2.0 License:

com.elovirta.ooxml https://github.com/jelovirt/com.elovirta.ooxml

The following are used for publising to EPUB, Kindle and other formats:


https://github.com/dita-community

org.dita-community.adjust-copy-to
org.dita-community.common.mapdriven
org.dita-community.common.xslt
org.dita-community.dita13.html
org.dita-community.dita13.pdf
org.dita-community.preprocess-extensions


https://github.com/dita4publishers

org.dita4publishers.common.html
org.dita4publishers.common.mapdriven
org.dita4publishers.common.xslt
org.dita4publishers.dita2indesign
org.dita4publishers.epub
org.dita4publishers.html2
org.dita4publishers.json
org.dita4publishers.kindle
org.dita4publishers.word2dita
----------PATCHES---------------------
These is an overview of the major changes we made to the DITA For publishers plugins.
org.dita-community.dita13.html/xsl/localFunctions.xsl
    EXM-37092 Look into jobs.xml
org.dita-community.dita13.html/xsl/mathml-d2html.xsl
   EXM-46302 Disable calling a template if certain parameters are not enabled.
org.dita4publishers.epub/xsl/epubHtmlOverrides.xsl
   EXM-42549 - adding a / for paths that do not end in a / or \
org.dita4publishers.epub/lib/epub-font-obfuscator.jar
    EXM-46537 Removed references to Apache commons io classes

--------REMOVED RESOURCES----------------
The following directories have been removed:
doc
docsrc

----------PATCHES---------------------
These is an overview of the major changes we made to the default DITA-OT plugins.
org.dita.base/build_preprocess_template.xml
org.dita.base/build_preprocess2_template.xml
  DCP-363 Add parameter to enable/disable inclusion of coderefs outside the map directory.
org.dita.eclipsehelp/xsl/contexts.xsl
org.dita.eclipsehelp/build_contexts.xml	
org.dita.eclipsehelp/build_dita2eclipsehelp_template.xml
  EXM-18224	Creates a context file mapping from id to file

org.dita.htmlhelp/lib/htmlhelp.jar
  EXM-43161 HTML topics inside CHM should use UTF-8 encoding
org.dita.htmlhelp/xsl/map2htmlhelp/map2hhpImpl.xsl
  EXM-18626 Changes for better CHM rendering
  EXM-31236 Add parameter args.htmlhelp.default.topic in DITA CHM transform that sets the
	path of the topic opened by default in CHM output.

org.dita.html5/xsl/get-meta.xsl
  OPE-298 Use all <keywords> children as <meta name="keywords"/>
org.dita.html5/xsl/topic.xsl
org.dita.html5/xsl/ut-d.xsl
  DCP-642 Added scaling in image-maps.

org.dita.xhtml/xsl/dita2html-util.xsl
	EXM-41800 REMOVE HTML 5 elements from content, to make compatible the JavaHelp output with the help reader.

org.lwdita
	Changed the plugin.xml to use the wildcard for library references.
org.lwdta/lib/flexmark-ext-gfm-tasklist-0.64.0.jar
	EXM-53399 We use the jars from lwdita to convert Markdown to HTML and this jar is required

org.dita.pdf2.fop
	Updated XML Graphics Commons and FOP libraries to 2.11.

org.dita.pdf2.fop/cfg.fop.xconf
  EXM-42187, use a higher source resolution so that SVGs do not appear scaled up

org.oasis-open.dita.v2_0
org.oasis-open.dita.techcomm.v2_0
  Added OASIS license and updated to latest OASIS DTDs from DITA OT project.

com.elovirta.ooxml/docx/word/document.topic.xsl
    EXM-44025 Added a patch which uses only the SVG file name for the reference.
com.elovirta.ooxml/docx/word/_rels/document.xml.xsl
    EXM-44025 Added a patch which uses only the SVG file name for the reference.
com.elovirta.ooxml/docx/word/flatten.xsl
    EXM-40361 Added a patch which processes images description.

config/logback.xml
    EXM-47855 Set slf4j log level to INFO for some packages from plugin com.oxygenxml.zendesk:
    io.netty, org.zendesk.client, org.asynchttpclient, com.oxygenxml.zendesk, com.oxygenxml.platform.integration

lib/saxon/Saxon-HE-12.9.jar
    OPE-366 Update to Saxon 12.9 to fix NPE in template optimization.
