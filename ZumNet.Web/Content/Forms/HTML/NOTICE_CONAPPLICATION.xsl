<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">

  <xsl:import href="../../Forms/XFormScript.xsl"/>
  <xsl:variable name="displaylog">false</xsl:variable>

<xsl:template match="/">
<div>
  <p>
    <b>
      <font face ="맑은 고딕">
      <font size="5">   
    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPT))" />&nbsp;
    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />&nbsp;
    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTGRADE))" />&nbsp;님,&nbsp;
        <br><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CELTYPE))" />을 축하드립니다!</br>
    </font>
    </font>
  </b>
  </p>
  
  <font face ="맑은 고딕">
    <font color="blue" size="5">
      <b>
        <p>
          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE))" />
        </p>
      </b>
    </font>
  </font>

  <font face ="맑은 고딕">
    <font size="5">
      <p>
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PLACE))" />
      </p>

      <p>
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TEL))" />
      </p>
    </font>
  </font>

  <font face ="맑은 고딕">
    <font size="3">
      <p>
        ※축의금 입금계좌: <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BANK))" />
      </p>      
    </font>
  </font>
</div>
</xsl:template>
</xsl:stylesheet>

