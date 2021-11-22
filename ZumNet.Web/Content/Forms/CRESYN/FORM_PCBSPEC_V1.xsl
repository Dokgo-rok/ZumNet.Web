<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>

<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:msxsl="urn:schemas-microsoft-com:xslt"
	xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">

  <xsl:import href="../../Forms/XFormScript.xsl"/>

  <xsl:variable name="mode" select="//config/@mode" />
  <xsl:variable name="partid" select="//config/@partid" />
  <xsl:variable name="bizrole" select="//config/@bizrole" />
  <xsl:variable name="actrole" select="//config/@actrole" />
  <xsl:variable name="root" select="//config/@root" />
  <xsl:variable name="displaylog">true</xsl:variable>

  <!--<xsl:strip-space elements="*"/>-->
  <xsl:template match="/">
    <xsl:value-of select="phxsl:init(string($root), string(//config/@companycode), string(//config), string($partid), string($bizrole), string($actrole))"/>
    <html>
      <head>
        <title>전자결재</title>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <style type="text/css">
          <xsl:value-of select="phxsl:baseStyle()" />
          .m {width:700px;margin:0;margin-top:30px}
          .m .fm1 {width:100%;padding:0;border:windowtext 2pt solid}
          .m .ff {height:20px}
          .m .fh {height:10px}

          .fm-editor {height:500px;border:0;border-top:windowtext 2pt solid;border-bottom:windowtext 2pt solid}
          .fm2 table,.m .fm3 table {width:100%}

          .fh h1 {margin:0;font-size:30pt;letter-spacing:5pt;font-family:돋움}
          .fh h2 {margin:0;font-size:20pt;letter-spacing:0pt;font-family:돋움}
          .fm td,.fm input {font-size:15px;font-family:Arial}
          .fm2 td,.fm2 input,.fm3 td {font-size:16px;font-family:돋움}

          .fm td {height:30px;padding:1px}
          .fm2 td,.fm3 td {height:30px;padding:2px;border-right:1px solid windowtext;border-bottom:1px solid windowtext}

          /* 특별 결재판 */
          .si-onlyone {width:100%;height:100%}
          .si-onlyone td {font-size:16px;font-family:맑은 고딕;text-align:center;border:0}
          .si-onlyone .si-top {height:25px;border-bottom:1px solid windowtext}
          .si-onlyone .si-middle {height:90px;border-bottom:1px solid windowtext}
          .si-onlyone .si-bottom {height:25px}
        </style>
      </head>
      <body>
        <div class="m">
          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0" style="border:0;border-bottom:windowtext 1px solid">
              <tr>
                <td rowspan="2">&nbsp;</td>
                <td style="width:20%;text-align:center;border:windowtext 1px solid">Ref NO.</td>
                <td style="width:20%;text-align:center;border:windowtext 1px solid;border-left:0">SPEC NO.</td>
              </tr>
              <tr>
                <td style="border:0;border-left:windowtext 1px solid;border-right:windowtext 1px solid">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REFNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/REFNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REFNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border:0;border-right:windowtext 1px solid">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SPECNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />

          <div class="fm1">
            <div class="ff" />
            <div class="fh">
              <h1>
                <xsl:value-of select="//docinfo/docname" />
              </h1>
            </div>
            <div class="ff" />

            <div class="fm2">
              <table border="0" cellspacing="0" cellpadding="0" style="border:0;border-top:windowtext 2pt solid;border-bottom:windowtext 2pt solid">
                <tr>
                  <td style="width:28%">ITEM</td>
                  <td style="width:36%">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="ITEMNO">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">50</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/ITEMNO" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNO))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="width:15%">CUSTOMER</td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="CUSTOMER">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">50</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td>CUSTOMER'S PART NO.</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="PARTNO">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">50</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTNO" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>PCB ASS'Y</td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="PCBASSY" style="height:">
                          <xsl:attribute name="class">txaText</xsl:attribute>
                          <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 50)</xsl:attribute>
                          <xsl:if test="$mode='edit'">
                            <xsl:value-of select="//forminfo/maintable/PCBASSY" />
                          </xsl:if>
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div id="__mainfield" name="PCBASSY" style="height:">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PCBASSY))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td>MODEL NO.</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/MODELNAME}" />
                        <button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                        </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>SMT ASS'Y</td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="SMTASSY" style="height:">
                          <xsl:attribute name="class">txaText</xsl:attribute>
                          <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 50)</xsl:attribute>
                          <xsl:if test="$mode='edit'">
                            <xsl:value-of select="//forminfo/maintable/SMTASSY" />
                          </xsl:if>
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div id="__mainfield" name="SMTASSY" style="height:">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SMTASSY))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td style="border-bottom:0">DATE</td>
                  <td style="border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="DODATE">
                          <xsl:attribute name="class">txtDateKo</xsl:attribute>
                          <xsl:attribute name="maxlength">8</xsl:attribute>
                          <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/DODATE" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DODATE))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="border-bottom:0">VERSION</td>
                  <td style="border-bottom:0;border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="VERSION">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">20</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/VERSION" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/VERSION))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </table>
            </div>

            <div class="ff" />
            <div class="fh">
              <h2>
                Electrical Design Team
              </h2>
            </div>
            <div class="ff" />

            <div class="fm-editor">
              <xsl:choose>
                <xsl:when test="$mode='read'">
                  <div name="WEBEDITOR" id="__mainfield" style="width:100%;height:100%;padding:0;position:relative">
                    <xsl:attribute name="class">txaRead</xsl:attribute>
                    <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
                  </div>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:if test="$mode='edit'">
                    <textarea id="bodytext" style="display:none">
                      <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                    </textarea>
                  </xsl:if>
                  <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no">
                    <xsl:attribute name="src">
                      /<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx
                    </xsl:attribute>
                  </iframe>
                </xsl:otherwise>
              </xsl:choose>
            </div>

            <div class="fm3">
              <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td style="height:130px;width:33%;border-bottom:0;padding:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSinglePart($root, //processinfo/signline/lines, 'normal', '_drafter', '작성')"/>
                  </td>
                  <td style="width:;border-bottom:0;padding:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSinglePart($root, //processinfo/signline/lines, 'normal', '_reviewer', '검토')"/>
                  </td>
                  <td style="width:33%;border-bottom:0;border-right:0;padding:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSinglePart($root, //processinfo/signline/lines, 'normal', '_approver', '승인')"/>
                  </td>
                </tr>
              </table>
            </div>
          </div>

          <xsl:if test="//linkeddocinfo/linkeddoc or //fileinfo/file">
            <div class="ff" />
            <div class="ff" />

            <div class="fm-file">
              <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td>
                    <table border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="//linkeddocinfo/linkeddoc[@xfalias!='pdmpd']">
                        <tr>
                          <td class="file-title">관련 문서&nbsp;:&nbsp;</td>
                          <td class="file-info">
                            <xsl:apply-templates select="//linkeddocinfo/linkeddoc[@xfalias!='pdmpd']"/>
                          </td>
                        </tr>
                      </xsl:if>
                      <xsl:if test="//linkeddocinfo/linkeddoc[@xfalias='pdmpd']">
                        <tr>
                          <td class="file-title">관련 제품/부품&nbsp;:&nbsp;</td>
                          <td class="file-info">
                            <xsl:apply-templates select="//linkeddocinfo/linkeddoc[@xfalias='pdmpd']"/>
                          </td>
                        </tr>
                      </xsl:if>
                      <xsl:if test="//fileinfo/file[@isfile='Y']">
                        <tr>
                          <td class="file-title">첨부 문서&nbsp;:&nbsp;</td>
                          <td class="file-info">
                            <xsl:apply-templates select="//fileinfo/file[@isfile='Y']"/>
                          </td>
                        </tr>
                      </xsl:if>
                    </table>
                  </td>
                  <td class="file-end">끝.</td>
                </tr>
              </table>
            </div>
          </xsl:if>

          <xsl:if test="$mode='read' and count(//processinfo/signline/lines/line)>0">
            <div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>
            <div class="fm-lines">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignTable(//processinfo/signline/lines)"/>
            </div>
          </xsl:if>
        </div>

        <!-- 필수 양식정보 -->
        <input type="hidden" id="__PHBFF" name="__PHBFF"  value="" />
        <xsl:if test="$displaylog='true'">
          <div>
            <xsl:value-of select="phxsl:getLog()"/>
          </div>
        </xsl:if>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="//linkeddocinfo/linkeddoc">
    <div>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="phxsl:isEqual(string(@xfalias),'pdm') or phxsl:isEqual(string(@xfalias),'pdmpd')">
              <xsl:value-of select="reserved1" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown(string(//config/@web), string($root), string(reserved1), string(reserved2))" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="subject" />
      </a>
    </div>
  </xsl:template>
  <xsl:template match="//fileinfo/file[@isfile='Y']">
    <div>
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:value-of disable-output-escaping="yes" select="phxsl:fileDown(string(//config/@web), string($root), string(virtualpath), string(savedname), string(filename))" />
        </xsl:attribute>
        <xsl:value-of select="filename" />
      </a>
    </div>
  </xsl:template>
</xsl:stylesheet>
