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
          .m {width:768px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:20px} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
          .m .ft-sub {border:1px solid windowtext;border-top:0}
          .m .ft-sub .ft-sub-sub td {border:0;border-right:windowtext 1pt dotted;border-bottom:windowtext 1pt dotted}
          .m .ft-sub .f-option {width:49%} .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

          /* 하위테이블 추가삭제 버튼 */
          .subtbl_div button {height:16px;width:16px}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:650px}}
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
                <input type="hidden" id="__mainfield" name="LOGOPATH" value="{//forminfo/maintable/LOGOPATH}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" id="__mainfield" name="LOGOPATH" value="/Storage/{//config/@companycode}/CI/{//creatorinfo/corp/logo}" />
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:345">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '의뢰부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:345px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">문서번호</td>
                <td style="width:35%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일</td>
                <td style="width:35%;border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">사업장</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ORGCODE" style="width:30%" tabindex="2">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ORGCODE" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','ORGCODE', 'ORGID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ORGCODE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">제목</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" tabindex="4">
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
                <td class="f-lbl" style="border-bottom:0;">폐기사유 및<br/> 내역 요약</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:80px" tabindex="5">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="DESCRIPTION" style="height:80px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>* 금형상세내역</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>* 금형상세내역</span>
                    </td>
                    <td class="fm-button">&nbsp;</td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:96%"></col>
                    </colgroup>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
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

        <!-- Main Table Hidden Field 01 -->
        <input type="hidden" id="__mainfield" name="ORGID">
          <xsl:attribute name="value">
            <xsl:value-of select="//forminfo/maintable/ORGID" />
          </xsl:attribute>
        </input>
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

  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
      <td style="border:0;border-top:1px solid windowtext;border-right:1px dotted windowtext">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border:0;border-top:1px solid windowtext;padding:0;height:232px">
        <table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
          <xsl:if test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">table-layout:</xsl:attribute>
          </xsl:if>
          <colgroup>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
          </colgroup>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">금형번호</td>
            <td colspan="3"  style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="TOOLINGNUMBER" style="width:40%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="TOOLINGNUMBER" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnOpen('/BizForce/EA/ReportSheet.aspx?M=&amp;ft=REGISTER_TOOLING&amp;Lc=%uAE08%uD615%uB300%uC7A5',840,700,'resize','',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <a target="_blank">
                    <xsl:attribute name="href">
                      /<xsl:value-of select="$root"/>/EA/Forms/XFormMain.aspx?M=read&amp;xf=tooling&amp;fi=REGISTER_TOOLING&amp;mi=<xsl:value-of select="TOOLINGNUMBER"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="TOOLINGNUMBER"/>
                    </xsl:attribute>
                    <xsl:value-of select="TOOLINGNUMBER"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td class="f-lbl-sub">제작일자</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="COMPLETEDATE">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="COMPLETEDATE" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMPLETEDATE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">공용구분</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="CMNTYPE">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="CMNTYPE" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CMNTYPE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">적용모델</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNO">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNO" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="MODELOID!=''">
                      <a target="_blank">
                        <xsl:attribute name="href">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(MODELOID))" />
                        </xsl:attribute>
                        <xsl:value-of select="MODELNO" />
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="MODELOID">
                <xsl:attribute name="value">
                  <xsl:value-of select="MODELOID" />
                </xsl:attribute>
              </input>
            </td>
            <td class="f-lbl-sub">모델명</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNM">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNM" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNM))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">부품</td>
            <td colspan="3" style="border-right:0">
              <div class="subtbl_div">
                <div>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="PARTNO1" style="width:250px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="PARTNO1" />
                        </xsl:attribute>
                      </input>&nbsp;(
                      <input type="text" name="PARTNM1" style="width:330px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="PARTNM1" />
                        </xsl:attribute>
                      </input>)
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="PARTOID1!=''">
                          <a target="_blank">
                            <xsl:attribute name="href">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID1))" />
                            </xsl:attribute>
                            <xsl:value-of select="PARTNO1" />
                          </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO1))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="PARTOID1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTOID1" />
                    </xsl:attribute>
                  </input>
                </div>
                <xsl:if test="phxsl:isDiff(string(PARTNO2),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO2" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO2" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM2" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM2" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID2!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID2))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO2" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO2))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID2">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID2" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO3),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO3" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO3" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM3" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM3" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID3!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID3))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO3" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM3))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO3))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM3))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID3">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID3" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO4),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO4" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO4" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM4" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM4" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID4!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID4))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO4" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM4))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO4))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM4))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID4">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID4" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO5),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO5" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO5" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM5" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM5" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID5!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID5))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO5" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM5))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO5))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM5))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID5">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID5" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO6),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO6" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO6" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM6" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM6" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID6!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID6))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO6" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM6))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO6))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM6))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID6">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID6" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO7),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO7" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO7" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM7" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM7" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID7!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID7))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO7" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM7))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO7))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM7))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID7">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID7" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO8),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO8" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO8" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM8" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM8" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID8!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID8))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO8" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM8))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO8))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM8))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID8">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID8" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO9),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO9" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO9" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM9" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM9" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID9!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID9))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO9" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM9))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO9))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM9))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID9">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID9" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO10),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO10" style="width:250px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO10" />
                          </xsl:attribute>
                        </input>&nbsp;(
                        <input type="text" name="PARTNM10" style="width:330px">
                          <xsl:attribute name="class">txtRead</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM10" />
                          </xsl:attribute>
                        </input>)
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID10!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID10))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO10" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM10))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO10))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM10))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID10">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID10" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
              </div>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">금형소유처</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="OWNER">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="OWNER" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(OWNER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="OWNERID">
                <xsl:attribute name="value">
                  <xsl:value-of select="OWNERID" />
                </xsl:attribute>
              </input>
              <input type="hidden" name="OWNERSITEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="OWNERSITEID" />
                </xsl:attribute>
              </input>
            </td>
            <td class="f-lbl-sub">금형사용처</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="STOREPLACE">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="STOREPLACE" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(STOREPLACE))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="STOREPLACEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="STOREPLACEID" />
                </xsl:attribute>
              </input>
              <input type="hidden" name="STOREPLACESITEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="STOREPLACESITEID" />
                </xsl:attribute>
              </input>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">CAVITY</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="CAVITY">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="CAVITY" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">폐기일자</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DISUSEDATE" style="width:80px">
                    <xsl:attribute name="class">txtDate</xsl:attribute>
                    <xsl:attribute name="maxlength">8</xsl:attribute>
                    <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DISUSEDATE" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DISUSEDATE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">사용SHOT</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="SHOT">
                    <xsl:attribute name="class">txtCurrency</xsl:attribute>
                    <xsl:attribute name="maxlength">18</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="SHOT" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SHOT))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">만기SHOT</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="EXPIREDSHOT">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="EXPIREDSHOT" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPIREDSHOT))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">height:44px</xsl:attribute>
              </xsl:if>폐기사유
            </td>
            <td colspan="3" style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <textarea name="DISUSEREASON" style="height:40px">
                    <xsl:attribute name="class">txaText</xsl:attribute>
                    <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                    <xsl:if test="$mode='edit'">
                      <xsl:value-of select="DISUSEREASON" />
                    </xsl:if>
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div name="DISUSEREASON" style="height:40px">
                    <xsl:attribute name="class">txaRead</xsl:attribute>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DISUSEREASON))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:attribute name="style">border-bottom:0;height:44px</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style">border-bottom:0</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>폐기방법
            </td>
            <td colspan="3" style="border-bottom:0;border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <textarea name="DISUSEMETHOD" style="height:40px">
                    <xsl:attribute name="class">txaText</xsl:attribute>
                    <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                    <xsl:if test="$mode='edit'">
                      <xsl:value-of select="DISUSEMETHOD" />
                    </xsl:if>
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div name="DISUSEMETHOD" style="height:40px">
                    <xsl:attribute name="class">txaRead</xsl:attribute>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DISUSEMETHOD))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </td>
    </tr>
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
