<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:zsxsl="http://www.zumsoft.io/xslt/ea" exclude-result-prefixes="zsxsl">

<!--<xsl:output method="html" version="4.0"/>-->
<xsl:template  xmlns:d="urn:schemas:httpmail:" xmlns:a="DAV:" match="/">
  <div>
		<xsl:for-each select="a:multistatus/a:response">
      <div>
        <xsl:choose>
          <xsl:when test="position()=last()">
            <xsl:if test="a:propstat/a:prop/read[.= '0']">
              <xsl:attribute name="class">font-weight-bold</xsl:attribute>
            </xsl:if>
          </xsl:when>
          <xsl:when test="a:propstat/a:prop/read[.= '0']">
            <xsl:attribute name="class">mb-2 font-weight-bold</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">mb-2</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>

        <div class="float-right text-secondary">
          <xsl:value-of select="zsxsl:lvDate(string(a:propstat/a:prop/datereceived))"/>
        </div>
        <div class="text-truncate">
          <a href="javascript:void(0)" data-owareadurl="{a:propstat/a:prop/owareadurl}" data-itemid="{a:propstat/a:prop/itemid}" data-changekey="{a:propstat/a:prop/changekey}">
            <xsl:value-of select="a:propstat/a:prop/subject"/>
          </a>
        </div>
      </div>
		</xsl:for-each>
  </div>
</xsl:template>
  <msxsl:script language="javascript" implements-prefix="zsxsl">
<![CDATA[
  function lvDate(utcDate) {
    return utcDate.substr(2, 8);
  }
]]>
</msxsl:script>
</xsl:stylesheet> 