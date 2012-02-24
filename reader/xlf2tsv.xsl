<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:exslt="http://exslt.org/common"
 xmlns:math="http://exslt.org/math"
 xmlns:date="http://exslt.org/dates-and-times"
 xmlns:func="http://exslt.org/functions"
 xmlns:set="http://exslt.org/sets"
 xmlns:str="http://exslt.org/strings"
 xmlns:dyn="http://exslt.org/dynamic"
 xmlns:saxon="http://icl.com/saxon"
 xmlns:xalanredirect="org.apache.xalan.xslt.extensions.Redirect"
 xmlns:xt="http://www.jclark.com/xt"
 xmlns:libxslt="http://xmlsoft.org/XSLT/namespace"
 xmlns:test="http://xmlsoft.org/XSLT/"
 xmlns:x="urn:oasis:names:tc:xliff:document:1.2"
 xmlns:iws="http://www.idiominc.com/ws/asset"
 extension-element-prefixes="exslt math date func set str dyn saxon xalanredirect xt libxslt test"
 exclude-result-prefixes="math str">
<xsl:output omit-xml-declaration="yes" indent="no" method="text" encoding="UTF-8"/>
<xsl:param name="inputFile">-</xsl:param>
<xsl:template match="/">
  <xsl:call-template name="t1"/>
</xsl:template>
<xsl:template name="t1">
  <xsl:value-of select="'&quot;File&quot;&#9;&quot;ID&quot;&#9;&quot;Source&quot;&#9;&quot;Target&quot;&#9;&quot;Note&quot;&#9;&quot;SID&quot;&#10;'"/>
  <xsl:for-each select="//x:file">
    <xsl:for-each select="x:body/x:trans-unit">
      <xsl:value-of select="'&quot;'"/>
      <xsl:value-of select="../../@original"/>
      <xsl:value-of select="'&quot;&#9;&quot;'"/>
      <xsl:value-of select="@id"/>
      <xsl:value-of select="'&quot;&#9;&quot;'"/>
      <xsl:value-of select="str:replace(x:source, '&quot;', '&quot;&quot;')"/>
      <xsl:value-of select="'&quot;&#9;&quot;'"/>
      <xsl:value-of select="str:replace(x:target, '&quot;', '&quot;&quot;')"/>
      <xsl:value-of select="'&quot;&#9;&quot;'"/>
      <xsl:value-of select="str:replace(x:note, '&quot;', '&quot;&quot;')"/>
      <xsl:value-of select="'&quot;&#9;&quot;'"/>
      <xsl:value-of select="str:replace(iws:segment-metadata/@sid, '&quot;', '&quot;&quot;')"/>
      <xsl:value-of select="'&quot;'"/>
      <xsl:value-of select="'&#10;'"/>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>
</xsl:stylesheet>
