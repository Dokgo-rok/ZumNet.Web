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
          .m {width:1200px} .m .fm-editor {height:530px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:5%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:25%} .m .ft .f-option1 {width:62px}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:530px}}
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
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="CORPORATION" style="width:80px;font-size:19pt">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/CORPORATION" />
                          </xsl:attribute>
                        </input>
                        <button onclick="parent.fnOption('external.centercode',180,140,70,122,'','CORPORATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">
                              /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                            </xsl:attribute>
                          </img>
                        </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CORPORATION))" />
                      </xsl:otherwise>
                    </xsl:choose>&nbsp;
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                      </xsl:otherwise>
                    </xsl:choose>년
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:35px;font-size:19pt">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:19pt">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                      </xsl:otherwise>
                    </xsl:choose>월
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
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="style">table-layout:fixed;border-right:0</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">border-right:0</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <tr>
                      <td class="f-lbl">등록번호</td>
                      <td style="width:27%">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                      </td>
                      <td class="f-lbl">작성일</td>
                      <td style="width:12%">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                      </td>
                      <td class="f-lbl">작성부서</td>
                      <td style="width:16%">
                        <xsl:value-of select="//creatorinfo/department" />
                      </td>
                      <td class="f-lbl">작성자</td>
                      <td style="width:12%;border-right:0">
                        <xsl:value-of select="//creatorinfo/name" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl">혁신분야</td>
                      <td colspan="3">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INNOBRANCH">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">100</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INNOBRANCH" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INNOBRANCH))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl">구분</td>
                      <td colspan="3"  style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DOCCLASS" style="width:92%">
                              <xsl:attribute name="class">txtText_u</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/DOCCLASS" />
                              </xsl:attribute>
                            </input>
                            <button onclick="parent.fnOption('external.mfinnoclass',140,120,140,60,'','DOCCLASS');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0">
                                <xsl:attribute name="src">
                                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                                </xsl:attribute>
                              </img>
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DOCCLASS))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl">제목</td>
                      <td colspan="7" style="border-right:0">
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
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl" style="border-bottom:0;height:48px">혁신활동개요</td>
                      <td colspan="7" style="border-right:0;border-bottom:0;">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <textarea id="__mainfield" name="SUMMARY" style="height:44px">
                              <xsl:attribute name="class">txaText</xsl:attribute>
                              <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
                              <xsl:if test="$mode='edit'">
                                <xsl:value-of select="//forminfo/maintable/SUMMARY" />
                              </xsl:if>
                            </textarea>
                          </xsl:when>
                          <xsl:otherwise>
                            <div name="SUMMARY" style="height:44px">
                              <xsl:attribute name="class">txaRead</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUMMARY))" />
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>
                </td>

                <td style="width:452px">
                  <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '6', '결재')"/>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm-editor">
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <div name="WEBEDITOR" id="__mainfield" style="width:100%;height:100%;padding:0x;position:relative">
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
                    /<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx?doctype=MFINNOVATIONDEFINE_1.html
                  </xsl:attribute>
                </iframe>
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