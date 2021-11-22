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
          .m {width:700px} .m .fm-editor {height:300px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:20%} .m .ft .f-option1 {width:} .m .ft .f-option2 {width:}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:300px}}
        </style>
      </head>
      <body>
        <div class="m">
          <div class="fh">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="fh-l">
                  <xsl:choose>
                    <xsl:when test="$mode='read'">
                      <img alt="" src="{//forminfo/maintable/LOGOPATH}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <img alt="" src="/Storage/{//config/@companycode}/CI/{//creatorinfo/corp/logo}" />
                    </xsl:otherwise>
                  </xsl:choose>
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
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px;">
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
                <td class="f-lbl">작성일자</td>
                <td style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:value-of select="//creatorinfo/name" />
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
                <td class="f-lbl" rowspan="2">
                  강사신청자
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                    </button>
                  </xsl:if>
                </td>
                <td class="f-lbl">소속</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLCORP!=''">
                          <input type="text" id="__mainfield" name="APPLCORP" class="txtRead" readonly="redonly" style="width:100px" value="{//forminfo/maintable/APPLCORP}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLCORP" class="txtRead" readonly="redonly" style="width:100px" value="{//currentinfo/belong}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLCORP))" />
                    </xsl:otherwise>
                  </xsl:choose>.
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLDEPT!=''">
                          <input type="text" id="__mainfield" name="APPLDEPT" class="txtRead" readonly="redonly" style="width:130px" value="{//forminfo/maintable/APPLDEPT}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLDEPT" class="txtRead" readonly="redonly" style="width:130px" value="{//currentinfo/department}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">희망년도</td>
                <td style="width:20%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="STDYEAR" style="width:80px;height:20px">
                        <xsl:for-each select="//optioninfo/foption[@sk='stdyear']">
                          <option value="{@cd}">
                            <xsl:if test="Item1='current'">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="@cd"/>년
                          </option>
                        </xsl:for-each>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/STDYEAR"/>년
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">성명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLGRADE!=''">
                          <input type="text" id="__mainfield" name="APPLGRADE" class="txtRead" readonly="redonly" style="width:50px" value="{//forminfo/maintable/APPLGRADE}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLGRADE" class="txtRead" readonly="redonly" style="width:50px" value="{//currentinfo/grade}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLGRADE))" />
                    </xsl:otherwise>
                  </xsl:choose>.
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLDN!=''">
                          <input type="text" id="__mainfield" name="APPLDN" class="txtRead" readonly="redonly" style="width:130px" value="{//forminfo/maintable/APPLDN}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLDN" class="txtRead" readonly="redonly" style="width:130px" value="{//currentinfo/name}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLDN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">사번</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLEMPNO!=''">
                          <input type="text" id="__mainfield" name="APPLEMPNO" class="txtRead" readonly="redonly" value="{//forminfo/maintable/APPLEMPNO}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLEMPNO" class="txtRead" readonly="redonly" value="{//currentinfo/empno}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">업무경력</td>
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="BIZCAREER" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/BIZCAREER" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="BIZCAREER" style="height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIZCAREER))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">교육경력</td>
                <td colspan="4" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="EDUCAREER" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/EDUCAREER" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="EDUCAREER" style="height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EDUCAREER))" />
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
            <span>* 교육목적</span>

            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PURPOSE" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);" style="height:40px">
                        <xsl:value-of select="//forminfo/maintable/PURPOSE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="PURPOSE" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PURPOSE))" />
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
            <span>* 교육내용</span>
          </div>

          <div class="ff" />

          <div class="fm-editor">
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <div name="WEBEDITOR" id="__mainfield" style="width:100%;height:100%;padding:4px 4px 4px 4px;position:relative">
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
                  <xsl:attribute name="src">/<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx</xsl:attribute>
                </iframe>
              </xsl:otherwise>
            </xsl:choose>
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
                      <span>* 해당년도 교육진행 계획</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td colspan="2">
                      <span>* 해당년도 교육진행 계획</span>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff"></div>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="4%" />
                      <col width="31%" />
                      <col width="20%" />
                      <col width="15%" />
                      <col width="15%" />
                      <col width="15%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">교육명</td>
                      <td class="f-lbl-sub" style="border-top:0">수강대상자</td>
                      <td class="f-lbl-sub" style="border-top:0">희망교육일시</td>
                      <td class="f-lbl-sub" style="border-top:0">교육시간</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>* 자격평가서</span>

            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl">평가점수</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="EPOINT" class="txtText" maxlength="3" style="width:100px" value="{//forminfo/maintable/EPOINT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EPOINT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">평가의견</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <textarea id="__mainfield" name="EOPINION" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);" style="height:40px">
                        <xsl:value-of select="//forminfo/maintable/EOPINION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="EOPINION" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EOPINION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
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

        <!-- Hidden Field -->
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <xsl:choose>
              <xsl:when test="//forminfo/maintable/APPLID!=''">
                <input type="hidden" id="__mainfield" name="APPLID" value="{//forminfo/maintable/APPLID}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" id="__mainfield" name="APPLID" value="{//currentinfo/@uid}" />
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="//forminfo/maintable/APPLDEPTID!=''">
                <input type="hidden" id="__mainfield" name="APPLDEPTID" value="{//forminfo/maintable/APPLDEPTID}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" id="__mainfield" name="APPLDEPTID" value="{//currentinfo/@deptid}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield" name="APPLID" value="{//forminfo/maintable/APPLID}" />
            <input type="hidden" id="__mainfield" name="APPLDEPTID" value="{//forminfo/maintable/APPLDEPTID}" />
          </xsl:otherwise>
        </xsl:choose>

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
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PLSUBJECT" class="txtText" value="{PLSUBJECT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PLSUBJECT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PLTGT" class="txtText" value="{PLTGT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PLTGT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PLDATE" class="txtText" value="{PLDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PLDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PLTIME" class="txtText" value="{PLTIME}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PLTIME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" value="{ETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
          </xsl:otherwise>
        </xsl:choose>
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
  <xsl:template match="//fileinfo/file[@isfile='N']">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:down2(string(//config/@web), string($root), string(virtualpath), string(savedname), string(filename))" />
      </xsl:attribute>
      <xsl:value-of select="filename" />
    </a>
  </xsl:template>
</xsl:stylesheet>