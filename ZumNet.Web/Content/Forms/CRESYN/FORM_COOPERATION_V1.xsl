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
  <xsl:variable name="submode" select="//config/@submode" />
  <xsl:variable name="partid" select="//config/@partid" />
  <xsl:variable name="bizrole" select="//config/@bizrole" />
  <xsl:variable name="actrole" select="//config/@actrole" />
  <xsl:variable name="root" select="//config/@root" />
  <xsl:variable name="mlvl" select="phxsl:modLevel(string(//config/@mode), string(//bizinfo/@docstatus), string(//config/@partid), string(//creatorinfo/@uid), string(//currentinfo/@uid), //processinfo/signline/lines)" />
  <xsl:variable name="displaylog">false</xsl:variable>

  <!--<xsl:strip-space elements="*"/>-->
  <xsl:template match="/">
    <xsl:value-of select="phxsl:init(string($root), string(//config/@companycode), string(//config), string($partid), string($bizrole), string($actrole))"/>
    <html>
      <head>
        <title>전자결재</title>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <style type="text/css">
          <xsl:value-of select="phxsl:baseStyle()" />
          /* 화면 넓이, 에디터 높이, 양식명크기 */
          .m {width:700px} .m .fm-editor {height:600px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:10pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:5%} .si-tbl .si-bottom {width:19%}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:80px} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:700px} }
        </style>
      </head>
      <body>
        <div class="m">
          <div class="fh">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="fh-l">
                  <img alt="">
                    <xsl:attribute name="src">
                      <xsl:choose>
                        <xsl:when test="$mode='read'">
                          <xsl:value-of select="//forminfo/maintable/LOGOPATH" />
                        </xsl:when>
                        <xsl:otherwise>
                          /Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </img>
                </td>
                <td class="fh-m">
                  <h1>
                    <xsl:value-of select="//docinfo/docname" />
                  </h1>
                </td>
                <td class="fh-r">&nbsp;</td>
              </tr>
            </table>
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <input type="hidden" id="__mainfield" name="LOGOPATH">
                  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/LOGOPATH" /></xsl:attribute>
                </input>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" id="__mainfield" name="LOGOPATH">
                  <xsl:attribute name="value">/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" /></xsl:attribute>
                </input>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <table class="ft" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="f-lbl1">발행번호</td>
                      <td style="border-right:0">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">보존년한</td>
                      <td style="border-right:0">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/keepyear))" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">구분</td>
                      <td style="border-right:0">
                        <span class="f-option">
                          <input type="checkbox" id="ckb11" name="ckbDOCCLASS" value="통보">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'통보')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'통보')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb11">통보</label>
                        </span>
                        <span class="f-option">
                          <input type="checkbox" id="ckb12" name="ckbDOCCLASS" value="의뢰">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'의뢰')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'의뢰')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb12">의뢰</label>
                        </span>
                        <span class="f-option">
                          <input type="checkbox" id="ckb13" name="ckbDOCCLASS" value="송부">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'송부')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'송부')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb13">송부</label>
                        </span>
                      </td>
                      <input type="hidden" id="__mainfield" name="DOCCLASS">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DOCCLASS"></xsl:value-of>
                        </xsl:attribute>
                      </input>
                    </tr>
                    <tr>
                      <td class="f-lbl1">회신</td>
                      <td style="border-right:0">
                        <span class="f-option">
                          <input type="checkbox" id="ckb21" name="ckbREPLY" value="요">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbREPLY', this, 'REPLY')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REPLY),'요')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REPLY),'요')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb21">요</label>
                        </span>
                        <span class="f-option">
                          <input type="checkbox" id="ckb22" name="ckbREPLY" value="불요">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbREPLY', this, 'REPLY')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REPLY),'불요')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REPLY),'불요')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb22">불요</label>
                        </span>
                      </td>
                      <input type="hidden" id="__mainfield" name="REPLY">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/REPLY"></xsl:value-of>
                        </xsl:attribute>
                      </input>
                    </tr>
                    <tr>
                      <td class="f-lbl1">기안일자</td>
                      <td style="border-right:0">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">기안부서</td>
                      <td style="border-right:0">
                        <xsl:value-of select="//creatorinfo/department" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1" style="border-bottom:0;">기안자</td>
                      <td style="border-right:0;border-bottom:0">
                        <xsl:value-of select="//creatorinfo/name" />
                      </td>
                    </tr>
                  </table>
                </td>

                <td style="width:2px;font-size:1px">&nbsp;</td>

                <td style="width:395px">
                  <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="height:49%">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5', '발신부서')"/>
                      </td>
                    </tr>
                    <tr>
                      <td style="font-size:1px;">&nbsp;</td>
                    </tr>
                    <tr>
                      <td style="height:49%">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'distribution', '__si_Distribution', '5', '수신부서')"/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1" style="border-bottom:0;">제목</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//docinfo/subject" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200"  value="{//docinfo/subject}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm-editor">
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <xsl:if test="$mlvl='A' or $mlvl='B'">
                  <xsl:attribute name="id">___editable</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$submode='revise'">
                    <textarea id="bodytext" style="display:none">
                      <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                    </textarea>
                    <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx"></iframe>
                  </xsl:when>
                  <xsl:otherwise>
                    <div name="WEBEDITOR" id="__mainfield" class="txaRead" style="width:100%;height:100%;padding:4px 4px 4px 4px;position:relative">
                      <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$mode='edit'">
                  <textarea id="bodytext" style="display:none">
                    <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                  </textarea>
                </xsl:if>
                <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx"></iframe>
              </xsl:otherwise>
            </xsl:choose>
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
            <!--<div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>-->
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
