<?xml version='1.0'?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0">

  <xsl:import href="xsl-stylesheets/xhtml/chunk.xsl" />
  <!-- <xsl:include href="./titlepage.xsl" /> -->

  <!-- Don't forget the quotes inside the double quotes -->
  <xsl:param name="base.dir" select="'./book-xhtml/'" />

  <!-- Print section numbers -->
  <xsl:param name="section.autolabel" select="1" />

  <!-- No image scaling -->
  <xsl:param name="ignore.image.scaling" select="1" />

  <!-- Display admonition icons (warning, note, tip, etc.) -->
  <xsl:param name="admon.graphics" select="1" />
  <xsl:param name="admon.graphics.extension" select="'.png'" />
  <xsl:param name="admon.graphics.path">std-img/</xsl:param>

  <!-- Disable text label in admonitions -->
  <!-- <xsl:param name="admon.textlabel" select="0" /> -->

  <!-- Callout configuration -->
  <xsl:param name="callout.graphics" select="1" />
  <xsl:param name="callout.graphics.extension" select="'.gif'" />
  <xsl:param name="callout.graphics.path">std-img/callouts/</xsl:param>

  <!-- Images path -->
  <xsl:param name="img.src.path">img/</xsl:param>

</xsl:stylesheet>

