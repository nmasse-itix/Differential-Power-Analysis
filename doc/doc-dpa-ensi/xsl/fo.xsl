<?xml version='1.0'?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

  <xsl:import href="../../globals/xsl-stylesheets/fo/docbook.xsl" />
  
  <!-- Biblio -->
  <xsl:param name="bibliography.numbered" select="1"/>
  
  <!-- Custom titlepage for the ENSI -->
  <xsl:template name="book.titlepage.recto">
    <!-- ENSI -->
    <fo:block-container absolute-position="absolute" top="-10mm" left="0mm">
      <fo:block>
        <fo:external-graphic 
              src="img/logos/ensi.png" 
              content-width="4cm" 
              content-type="content-type:image/png" />
      </fo:block>
      <fo:block font-family="serif" font-size="12pt">6, bd maréchal Juin</fo:block>
      <fo:block font-family="serif" font-size="12pt" space-before="0pt">F-14050 Caen Cedex 4</fo:block>
      <fo:block font-family="serif" font-size="14pt" space-before="5pt">Spécialité informatique</fo:block>
      <fo:block font-family="serif" font-size="14pt" space-before="0pt">Option Monétique</fo:block>
      <fo:block font-family="serif" font-size="14pt" space-before="0pt">3<fo:inline vertical-align="super" font-size="8pt">e</fo:inline> année</fo:block>
    </fo:block-container>
    
    <!-- ENSI vertical -->
    <fo:block-container absolute-position="absolute" bottom="-10mm" left="-2mm" display-align="after">
      <fo:block>
        <fo:external-graphic 
              src="img/logos/ensi-vertical-long.png" 
              content-height="21.59cm"
              content-type="content-type:image/png" />
      </fo:block>
    </fo:block-container>
    
    <!-- Ingenico -->
    <fo:block-container absolute-position="absolute" top="-10mm" right="0mm">
      <fo:block text-align="right">
        <fo:external-graphic 
              src="img/logos/ingenico.jpg" 
              content-width="6cm" 
              content-type="content-type:image/jpeg" />
      </fo:block>
      <fo:block text-align="right" font-family="serif" font-size="12pt">192, Avenue Charles de Gaulle</fo:block>
      <fo:block text-align="right" font-family="serif" font-size="12pt">92200 Neuilly-Sur-Seine</fo:block>
      <fo:block text-align="right" font-family="serif" font-size="12pt">http://www.ingenico.fr/</fo:block>
    </fo:block-container>
    
    <!-- Title -->
    <fo:block-container absolute-position="absolute" top="6cm" bottom="2cm" left="20mm" right="0cm" display-align="center">
      <fo:block text-align="center" font-family="serif" font-size="18pt" space-after="15mm">
        <xsl:value-of select="bookinfo/subtitle" />
      </fo:block>
      <fo:block text-align="center" space-after="0mm"><fo:leader leader-length="5cm" leader-pattern="rule" rule-thickness="1pt"/></fo:block>
      <fo:block text-align="center" font-family="serif" font-size="36pt" space-before="7.8mm" space-after="7.8mm">
        <xsl:value-of select="bookinfo/title" />
      </fo:block>
      <fo:block text-align="center" space-before="0mm"><fo:leader leader-length="5cm" leader-pattern="rule" rule-thickness="1pt"/></fo:block>
      <fo:block text-align="center" font-family="serif" font-size="14pt" space-before="20mm">
        <xsl:apply-templates select="bookinfo/author[position()=1]" />
      </fo:block>
      <fo:block text-align="center" font-family="serif" font-size="14pt">
        <xsl:apply-templates select="bookinfo/author[position()=2]" />
      </fo:block>
    </fo:block-container>

    <!-- Suivi -->
    <fo:block-container absolute-position="absolute" bottom="-10mm" left="20mm" display-align="after">
      <fo:block font-family="serif" font-size="14pt">Suivi Ensicaen :</fo:block>
      <fo:block font-family="serif" font-size="14pt">OTMANI Ayoub</fo:block>
      <fo:block font-family="serif" font-size="14pt" space-before="14pt">Suivi Entreprise :</fo:block>
      <fo:block font-family="serif" font-size="14pt">NACCACHE David</fo:block>
    </fo:block-container>

    <!-- Date -->
    <fo:block-container absolute-position="absolute" bottom="-10mm" right="0mm" display-align="after">
      <fo:block text-align="right" font-family="serif" font-size="14pt">1<fo:inline vertical-align="super" font-size="8pt">er</fo:inline> semestre 2006-2007</fo:block>
    </fo:block-container>

  </xsl:template>

  <!-- User defined page layout -->
  <xsl:template name="user.pagemasters">
    <!-- custom setup for title page(s) -->
    <fo:page-sequence-master master-name="custom-titlepage">
      <fo:repeatable-page-master-alternatives>
        <fo:conditional-page-master-reference master-reference="blank"
                                              blank-or-not-blank="blank"/>
        <fo:conditional-page-master-reference master-reference="custom-titlepage-first"
                                              page-position="first"/>
        <fo:conditional-page-master-reference master-reference="titlepage-odd"
                                              odd-or-even="odd"/>
        <fo:conditional-page-master-reference 
                                              odd-or-even="even">
          <xsl:attribute name="master-reference">
            <xsl:choose>
              <xsl:when test="$double.sided != 0">titlepage-even</xsl:when>
              <xsl:otherwise>titlepage-odd</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </fo:conditional-page-master-reference>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>

    <!-- Custom first title page -->
    <fo:simple-page-master master-name="custom-titlepage-first"
                           page-width="{$page.width}"
                           page-height="{$page.height}"
                           margin-top="20mm"
                           margin-bottom="20mm"
                           margin-left="20mm"
                           margin-right="20mm">
      <fo:region-body margin-bottom="0mm"
                      margin-top="0mm"
                      column-count="1">
      </fo:region-body>
    </fo:simple-page-master>
  </xsl:template>
  
  <!-- Wrapper override -->
  <xsl:template name="select.user.pagemaster">
    <xsl:param name="element"/>
    <xsl:param name="pageclass"/>
    <xsl:param name="default-pagemaster"/>

    <!-- Return my customized title page master name if for titlepage,
         otherwise return the default -->

    <xsl:choose>
      <xsl:when test="$default-pagemaster = 'titlepage'">
        <xsl:value-of select="'custom-titlepage'" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default-pagemaster"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <!-- Don't forget the quotes inside the double quotes -->
  <xsl:param name="paper.type" select="'A4'" />
  <xsl:param name="page.orientation" select="'portrait'" />

  <!-- Print section numbers -->
  <xsl:param name="section.autolabel" select="1" />
  <xsl:param name="section.label.includes.component.label" select="1" />

  <!-- 
    <xsl:template match="*" mode="intralabel.punctuation">
      <xsl:text>-</xsl:text>
    </xsl:template>
  -->

  <!-- Customization of the TOC : indent by 10 pt -->
  <xsl:param name="toc.indent.width" select="10" />

  <!-- Do not indent the body -->
  <xsl:param name="body.start.indent" select="0pt" />

  <!-- The text body is 12pt large -->
  <xsl:param name="body.font.master" select="12" />

  <!-- Title are 'times new roman' -->
  <xsl:param name="title.font.family" select="'serif'" />

  <!-- Images path -->
  <xsl:param name="img.src.path">img/</xsl:param>

  <!-- No rule between the header and the body -->
  <xsl:param name="header.rule" select="0"/>
  
  <!-- No rule between the footer and the body -->
  <xsl:param name="footer.rule" select="0"/>

  <!-- No header -->
  <xsl:template name="header.content" />

  <!-- Standard numbering-->
  <xsl:template name="page.number.format">1</xsl:template>

  <!-- No point after the section numbering -->
  <xsl:param name="autotoc.label.separator" select="' '" />

  <!-- Set the default font for the text body -->
  <!-- <xsl:param name="body.font.family" select="'Georgia'"/> -->

  <!-- Custom separator between numbering and titles --> 
  <xsl:param name="local.l10n.xml" select="document('')" />
  <l:i18n xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0">
    <l:l10n language="fr">
       <l:context name="title-numbered">
          <l:template name="appendix" text="Annexe&#160;%n.&#160;%t"/>
          <l:template name="chapter" text="%n&#160;&#160;%t"/>
          <l:template name="sect1" text="%n&#160;&#160;%t"/>
          <l:template name="sect2" text="%n&#160;&#160;%t"/>
          <l:template name="sect3" text="%n&#160;&#160;%t"/>
          <l:template name="sect4" text="%n&#160;&#160;%t"/>
          <l:template name="sect5" text="%n&#160;&#160;%t"/>
          <l:template name="section" text="%n&#160;&#160;%t"/>
       </l:context>
    </l:l10n>
  </l:i18n>

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
    <xsl:attribute name="font-size">22pt</xsl:attribute>
  </xsl:attribute-set>

  <!-- Section 1 title -->
  <xsl:attribute-set name="section.title.level1.properties">
    <xsl:attribute name="font-size">18pt</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Section 2 title -->
  <xsl:attribute-set name="section.title.level2.properties">
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="start-indent">1.27cm</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Section 3 title -->
  <xsl:attribute-set name="section.title.level3.properties">
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="start-indent">1.27cm</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Section 4 title -->
  <xsl:attribute-set name="section.title.level4.properties">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="start-indent">1.27cm</xsl:attribute>
  </xsl:attribute-set>

  <!-- Custom title for the table of contents-->
  <xsl:template name="table.of.contents.titlepage" priority="1">
    <fo:block xsl:use-attribute-sets="component.title.properties"
              font-weight="bold"
              space-after="12pt">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'TableofContents'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

  <!-- Custom title for the list of figures -->
  <xsl:template name="list.of.figures.titlepage" priority="1">
    <fo:block xsl:use-attribute-sets="component.title.properties"
              font-weight="bold"
              space-after="12pt">
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'ListofFigures'"/>
      </xsl:call-template>
    </fo:block>
  </xsl:template>

</xsl:stylesheet>

