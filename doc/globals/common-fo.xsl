<?xml version='1.0'?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

  <xsl:import href="xsl-stylesheets/fo/docbook.xsl" />

  <!-- Don't forget the quotes inside the double quotes -->
  <xsl:param name="paper.type" select="'A4'" />
  <xsl:param name="page.orientation" select="'portrait'" />

  <!-- FOP extension, doesn't work !
  <xsl:param name="fop.extensions" select="1" /> -->

  <!-- Draft mode, not supported by FOP
  <xsl:param name="draft.mode" select="maybe" /> -->

  <!-- Print section numbers -->
  <xsl:param name="section.autolabel" select="1" />

  <!-- Display admonition icons (warning, note, tip, etc.) -->
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.extension" select="'.svg'" />
  <xsl:param name="admon.graphics.path">../globals/xsl-stylesheets/images/</xsl:param>
  <xsl:attribute-set name="graphical.admonition.properties">
    <xsl:attribute name="space-before.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-before.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-before.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="space-after.optimum">1em</xsl:attribute>
    <xsl:attribute name="space-after.minimum">0.8em</xsl:attribute>
    <xsl:attribute name="space-after.maximum">1.2em</xsl:attribute>
    <xsl:attribute name="border-style">dashed</xsl:attribute>
    <xsl:attribute name="border-width">.5pt</xsl:attribute>
    <xsl:attribute name="border-color">#555555</xsl:attribute>
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>
    <xsl:attribute name="padding">5pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="admonition.properties">
  </xsl:attribute-set>
  <xsl:attribute-set name="admonition.title.properties">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
  </xsl:attribute-set>
  
  
  <!-- Callout configuration -->
  <xsl:param name="callout.graphics" select="0" />
  <xsl:param name="callout.unicode" select="1" />

  <!-- Disable text label in admonitions -->
  <!-- <xsl:param name="admon.textlabel" select="0" /> -->

  <!-- Customization of the TOC : indent by 15 pt -->
  <xsl:param name="toc.indent.width" select="15" />

  <!-- Images path -->
  <xsl:param name="img.src.path">img/</xsl:param>

  <!-- Set the default font for the text body -->
  <xsl:param name="body.font.family" select="'Georgia'"/>

  <!-- Customize the font used for programlisting -->
  <xsl:attribute-set name="monospace.properties">
    <!-- Reduce the size of the monospace font -->
    <xsl:attribute name="font-size">
      <xsl:text>90%</xsl:text>
    </xsl:attribute>
    
    <!-- Light gray background -->
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute>

    <!-- Change the font to "Courier New" -->
    <!-- <xsl:attribute name="font-family">CourierNew</xsl:attribute> -->
  </xsl:attribute-set>

  <!-- Template overload -->
  <xsl:template name="inline.monoseq">
    <xsl:param name="content">
      <xsl:apply-templates/>
    </xsl:param>
    <fo:inline xsl:use-attribute-sets="monospace.properties">
      <xsl:attribute name="background-color">transparent</xsl:attribute>
      <xsl:if test="@dir">
        <xsl:attribute name="direction">
          <xsl:choose>
            <xsl:when test="@dir = 'ltr' or @dir = 'lro'">ltr</xsl:when>
            <xsl:otherwise>rtl</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </fo:inline>
  </xsl:template>
  
  <!-- TOC template -->
  <xsl:template name="toc.line">
    <xsl:variable name="id">
      <xsl:call-template name="object.id"/>
    </xsl:variable>

    <xsl:variable name="label">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:variable>

    <fo:block text-align-last="justify"
              text-align="start"
              end-indent="{$toc.indent.width}pt"
              last-line-end-indent="-{$toc.indent.width}pt">
    
      <!-- Adds space before main elements -->
      <xsl:choose>
        <xsl:when test="parent::book">
          <xsl:attribute name="space-before">3pt</xsl:attribute>
          <xsl:attribute name="space-after">1pt</xsl:attribute>
        </xsl:when>
      </xsl:choose>

      <fo:inline keep-with-next.within-line="always">

        <!-- Main elements in bold -->
        <xsl:choose>
          <xsl:when test="parent::book">
            <xsl:attribute name="font-weight">bold</xsl:attribute>
          </xsl:when>
        </xsl:choose>

        <fo:basic-link internal-destination="{$id}">
          <xsl:if test="$label != ''">
            <xsl:copy-of select="$label"/>
            <xsl:value-of select="$autotoc.label.separator"/>
          </xsl:if>
          <xsl:apply-templates select="." mode="titleabbrev.markup"/>
        </fo:basic-link>
      </fo:inline>

      <fo:inline keep-together.within-line="always">
        <xsl:text> </xsl:text>
        
        <!-- Main elements do not have leaders (dots) -->
        <xsl:choose>
          <xsl:when test="parent::book">
            <fo:leader leader-pattern="space"
                       leader-pattern-width="3pt"
                       leader-alignment="reference-area"
                       keep-with-next.within-line="always"/>
          </xsl:when>
          <xsl:otherwise>
            <fo:leader leader-pattern="dots"
                       leader-pattern-width="3pt"
                       leader-alignment="reference-area"
                       keep-with-next.within-line="always"/>
          </xsl:otherwise>
        </xsl:choose>

        <xsl:text> </xsl:text> 
        <fo:basic-link internal-destination="{$id}">
          <fo:page-number-citation ref-id="{$id}"/>
        </fo:basic-link>
      </fo:inline>
    </fo:block>
  </xsl:template>

  <!-- Customization of the bibliography -->
  <xsl:template match="title" mode="bibliodiv.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="section.title.properties section.title.level1.properties">
      <xsl:value-of select="." />
    </fo:block>
  </xsl:template>
  
  <!-- Customization of the glossary -->
  <xsl:template match="title" mode="glossdiv.titlepage.recto.auto.mode">
    <fo:block xsl:use-attribute-sets="section.title.properties section.title.level1.properties">
      <xsl:value-of select="." />
    </fo:block>
  </xsl:template>
  
  <!-- Component's title (chapter, appendix, etc.) -->
  <xsl:attribute-set name="component.title.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 2"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- Section 1 title -->
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.75"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
    <!-- 
      <xsl:attribute name="border-bottom">0.5pt solid black</xsl:attribute>
      <xsl:attribute name="margin-right">4cm</xsl:attribute>
    -->
  </xsl:attribute-set>
  
  <!-- Section 2 title -->
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.5"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Section 3 title -->
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.25"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Section 4 title -->
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.master * 1.1"/>
      <xsl:text>pt</xsl:text>
    </xsl:attribute>
  </xsl:attribute-set>
</xsl:stylesheet>
