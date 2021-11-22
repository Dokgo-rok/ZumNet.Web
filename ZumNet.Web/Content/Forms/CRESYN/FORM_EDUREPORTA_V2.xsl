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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:20%} .m .ft .f-option1 {width:} .m .ft .f-option2 {width:}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:450px}}
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

          <div class="fm" id="panRequest">
            <span>신청 과정</span>

            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl">교육년도</td>
                <td colspan="3" style="border-right:0">
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
                <td class="f-lbl">교육유형</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="CLSCD3" onchange="parent.fnSelectChange(this, 'CLSDN3');" style="width:80px;height:20px">
                        <option value="">선택</option>
                        <xsl:for-each select="//optioninfo/foption[@sk='class_c']">
                          <option value="{@cd}">
                            <xsl:if test="@cd=//forminfo/maintable/CLSCD3">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="Item1"/>
                          </option>
                        </xsl:for-each>
                      </select>
                      <input type="hidden" id="__mainfield" name="CLSDN3" value="{//forminfo/maintable/CLSDN3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLSDN3))" />
                      <input type="hidden" id="__mainfield" name="CLSCD3" value="{//forminfo/maintable/CLSCD3}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">교육분야</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">border-right:0;padding:0</xsl:attribute>
                      <select onchange="parent.fnSelectChange(this, 'CLSDN4');" style="width:110px;height:20px;margin-right:2px">
                        <option value="">선택</option>
                        <xsl:for-each select="//optioninfo/foption[@sk='class_d']">
                          <option value="{Item1}">
                            <xsl:if test="Item1=//forminfo/maintable/CLSDN4">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="Item1"/>
                          </option>
                        </xsl:for-each>
                        <option value="--WRITE--">직접선택</option>
                      </select>
                      <input type="text" id="__mainfield" name="CLSDN4" class="txtText" maxlength="50" value="{//forminfo/maintable/CLSDN4}" style="width:130px;display:none" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="style">border-right:0</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLSDN4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">
                  교육과정명
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button onclick="parent.fnOption('report.LCM_COURSE',800,250,250,0,'','STDYEAR');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                    </button>
                  </xsl:if>
                </td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COURSEDN" class="txtRead" readonly="readonly" maxlength="100" value="{//forminfo/maintable/COURSEDN}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COURSEDN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">교육장소</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLACE" class="txtRead" readonly="readonly" maxlength="100" value="{//forminfo/maintable/PLACE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PLACE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">교육비용</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COST" class="txtCurrency" maxlength="20" style="width:80px" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/COST), 0)}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(//forminfo/maintable/COST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">교육일자</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDATE" class="txtDate" readonly="readonly" maxlength="8" style="width:80px" value="{//forminfo/maintable/FROMDATE}" />
                      &nbsp;~&nbsp;<input type="text" id="__mainfield" name="TODATE" class="txtDate" readonly="readonly" maxlength="8" style="width:80px" value="{//forminfo/maintable/TODATE}" />
                      &nbsp;<input type="text" id="__mainfield" name="DURDAY" class="txtCurrency" readonly="readonly" maxlength="10" style="width:30px" value="{//forminfo/maintable/DURDAY}" />일간
                      &nbsp;<input type="text" id="__mainfield" name="DURTIME" class="txtCurrency" readonly="readonly" maxlength="10" style="width:30px" value="{//forminfo/maintable/DURTIME}" />시간
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FROMDATE))" />
                      &nbsp;~&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TODATE))" />
                      &nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DURDAY))" />일간
                      &nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DURTIME))" />시간
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>

            <input type="hidden" id="__mainfield" name="COURSEID" value="{//forminfo/maintable/COURSEID}" />
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-top:0">
              <tr>
                <td class="f-lbl" style="width:15%;border-bottom:0">
                  교육강사
                 
                </td>
                <td class="f-lbl1" style="width:10%;border-bottom:0">부서</td>
                <td style="width:20%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INSTRUCTORINFO1" class="txtText" value="{//forminfo/maintable/INSTRUCTORINFO1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INSTRUCTORINFO1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="width:10%;border-bottom:0">직위</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INSTRUCTORINFO2" class="txtText" value="{//forminfo/maintable/INSTRUCTORINFO2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INSTRUCTORINFO2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="width:10%;border-bottom:0">성명</td>
                <td style="width:;border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INSTRUCTOR" class="txtText"  value="{//forminfo/maintable/INSTRUCTOR}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INSTRUCTOR))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
            <input type="hidden" id="__mainfield" name="INSTRUCTORID" value="{//forminfo/maintable/INSTRUCTORID}" />
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>교육내용요약</span>

            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENTS" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000);" style="height:80px">
                        <xsl:value-of select="//forminfo/maintable/CONTENTS" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENTS" style="height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENTS))" />
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
                      <span>교육참석자 및 평가결과</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.importFile();" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_42.gif" />가져오기
                      </button>
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
                      <span>교육참석자 및 평가결과</span>
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
                      <col width="21%" />
                      <col width="15%" />
                      <col width="15%" />
                      <col width="15%" />
                      <col width="30%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">부서명</td>
                      <td class="f-lbl-sub" style="border-top:0">직급</td>
                      <td class="f-lbl-sub" style="border-top:0">성명</td>
                      <td class="f-lbl-sub" style="border-top:0">사번</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">평가결과</td>
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
            <span>특기사항(재교육 계획/교육과정 보완 등의 사내교육 개선 필요성 등을 기술)</span>

            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000);" style="height:80px">
                        <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DESCRIPTION" style="height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
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
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="hidden" id="__mainfield" name="CLSDN1" value="{//optioninfo/foption[@sk='class_a' and Item1='사내']/Item1}" />
            <input type="hidden" id="__mainfield" name="CLSCD1" value="{//optioninfo/foption[@sk='class_a' and Item1='사내']/@cd}" />
            <input type="hidden" id="__mainfield" name="CLSDN2" value="{//optioninfo/foption[@sk='class_b' and Item1='집합']/Item1}" />
            <input type="hidden" id="__mainfield" name="CLSCD2" value="{//optioninfo/foption[@sk='class_b' and Item1='집합']/@cd}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield" name="CLSDN1" value="{//forminfo/maintable/CLSDN1}" />
            <input type="hidden" id="__mainfield" name="CLSCD1" value="{//forminfo/maintable/CLSCD1}" />
            <input type="hidden" id="__mainfield" name="CLSDN2" value="{//forminfo/maintable/CLSDN2}" />
            <input type="hidden" id="__mainfield" name="CLSCD2" value="{//forminfo/maintable/CLSCD2}" />
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
            <input type="text" name="APPLDEPT" class="txtText_u" readonly="readonly"  value="{APPLDEPT}" style="width:86%" />
            <button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="APPLID" value="{APPLID}" />
        <input type="hidden" name="APPLDEPTID" value="{APPLDEPTID}" />
        <input type="hidden" name="APPLCORP" value="{APPLCORP}" />  
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLGRADE" class="txtRead" readonly="readonly" value="{APPLGRADE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLGRADE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLDN" class="txtRead" readonly="readonly" value="{APPLDN}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLDN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLEMPNO" class="txtRead" readonly="readonly" value="{APPLEMPNO}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLEMPNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <span class="f-option">
          <input type="checkbox" id="ckb.{ROWSEQ}.1" name="ckbPOLLA" value="만족">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbPOLLA', this, 'POLLA')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(POLLA),'만족')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(POLLA),'만족')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.1">만족</label>
        </span>
        <span class="f-option">
          <input type="checkbox" id="ckb.{ROWSEQ}.2" name="ckbPOLLA" value="재교육">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbPOLLA', this, 'POLLA')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(POLLA),'재교육')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(POLLA),'재교육')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.2">재교육</label>
        </span>
        <input type="hidden" name="POLLA" value="{POLLA}" />
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