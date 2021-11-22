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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" rowspan="3" style="border-bottom:0">
                  신청자
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
                <td class="f-lbl">직위</td>
                <td style="width:20%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLGRADE!=''">
                          <input type="text" id="__mainfield" name="APPLGRADE" class="txtRead" readonly="redonly" value="{//forminfo/maintable/APPLGRADE}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLGRADE" class="txtRead" readonly="redonly" value="{//currentinfo/grade}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLGRADE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">성명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:choose>
                        <xsl:when test="//forminfo/maintable/APPLDN!=''">
                          <input type="text" id="__mainfield" name="APPLDN" class="txtRead" readonly="redonly" style="width:99%" value="{//forminfo/maintable/APPLDN}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <input type="text" id="__mainfield" name="APPLDN" class="txtRead" readonly="redonly" style="width:99%" value="{//currentinfo/name}" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLDN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">사번</td>
                <td style="border-bottom:0;border-right:0">
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
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">신청구분</td>
                <td style="border-bottom:0;border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbREQTYPE" value="신청">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbREQTYPE', this, 'REQTYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REQTYPE),'신청')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REQTYPE),'신청')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">신청</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbREQTYPE" value="취소">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbREQTYPE', this, 'REQTYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REQTYPE),'취소')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REQTYPE),'취소')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">취소</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbREQTYPE" value="변경">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbREQTYPE', this, 'REQTYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REQTYPE),'변경')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REQTYPE),'변경')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">변경</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="REQTYPE" value="{//forminfo/maintable/REQTYPE}" />
                </td>
              </tr>
            </table>
          </div>

          <div class="fm" id="panCancel">
            <xsl:choose>
              <xsl:when test="//forminfo/maintable/PREID!=''">
                <xsl:attribute name="style">margin-top:8px</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">display:none;margin-top:8px</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <span style="font-weight:bold">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <a href="javascript:parent.fnOption('report.LCM_MAIN',800,200,250,-20,'','PRECLSDN1');">* 취소 신청 내역</a>
                </xsl:when>
                <xsl:otherwise>* 취소 신청 내역</xsl:otherwise>
              </xsl:choose>
            </span>

            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl">사내외</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRECLSDN1" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PRECLSDN1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRECLSDN1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">교육방식</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRECLSDN2" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PRECLSDN2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRECLSDN2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">교육유형</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRECLSDN3" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PRECLSDN3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRECLSDN3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="width:12%">교육분야</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRECLSDN4" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PRECLSDN4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRECLSDN4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">교육과정명</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRECOURSEDN" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PRECOURSEDN}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRECOURSEDN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">교육장소</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PREPLACE" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PREPLACE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PREPLACE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">교육일자</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PREFROMDATE" class="txtRead" readonly="readonly" style="width:80px" value="{//forminfo/maintable/PREFROMDATE}" />
                      &nbsp;~&nbsp;<input type="text" id="__mainfield" name="PRETODATE" class="txtRead" readonly="readonly" style="width:80px" value="{//forminfo/maintable/PRETODATE}" />
                      &nbsp;<input type="text" id="__mainfield" name="PREDURDAY" class="txtRead" readonly="readonly" style="width:30px" value="{//forminfo/maintable/PREDURDAY}" />일간
                      &nbsp;<input type="text" id="__mainfield" name="PREDURTIME" class="txtRead" readonly="readonly" style="width:30px" value="{//forminfo/maintable/PREDURTIME}" />시간
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PREFROMDATE))" />
                      &nbsp;~&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRETODATE))" />
                      &nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PREDURDAY))" />일간
                      &nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PREDURTIME))" />시간
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">교육강사</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PREINSTRUCTORINFO" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PREINSTRUCTORINFO}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PREINSTRUCTORINFO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">취소사유</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000);" style="height:80px">
                        <xsl:value-of select="//forminfo/maintable/REASON" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DESCRIPTION">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>

            <input type="hidden" id="__mainfield" name="PREID" value="{//forminfo/maintable/PREID}" />
          </div>

          <div class="fm" id="panRequest" style="margin-top:8px">
            <xsl:choose>
              <xsl:when test="//forminfo/maintable/REQTYPE='취소'">
                <xsl:attribute name="style">display:none;margin-top:8px</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">margin-top:8px</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <span style="font-weight:bold">* 신청 과정</span>

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
                <td class="f-lbl1" style="width:12%">교육분야</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">border-right:0</xsl:attribute>
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
                    <button onclick="parent.fnOption('report.LCM_COURSE',800,400,250,-20,'','STDYEAR');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
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
                <td class="f-lbl1" style="width:12%">교육비용</td>
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
                <td class="f-lbl">교육일자</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDATE" class="txtDate" readonly="readonly" maxlength="8" style="width:80px" value="{//forminfo/maintable/FROMDATE}" />
                      &nbsp;~&nbsp;<input type="text" id="__mainfield" name="TODATE" class="txtDate" readonly="readonly" maxlength="8" style="width:80px" value="{//forminfo/maintable/TODATE}" />
                      &nbsp;<input type="text" id="__mainfield" name="DURDAY" class="txtCurrency" readonly="readonly" maxlength="10" style="width:30px" value="{//forminfo/maintable/DURDAY}" />일간
                      &nbsp;<input type="text" id="__mainfield" name="DURTIME" class="txtCurrency" readonly="readonly" maxlength="10" style="width:30px" value="{//forminfo/maintable/DURTIME}" />시간
                      &nbsp;<span style="color:red; width: 120px">(1일 최대 8시간)</span>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FROMDATE))" />
                      &nbsp;~&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TODATE))" />
                      &nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DURDAY))" />일간
                      &nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DURTIME))" />시간
                      &nbsp;<span style="color:red; width: 120px">(1일 최대 8시간)</span>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="width:15%">교육강사</td>
                <td colspan="3" style="border-right:0;padding:0">
                  <table class="ft" border="0" cellpadding="0" cellspacing="0" style="border:0">
                    <tr>
                      <td class="f-lbl1" style="width:12%;border-bottom:0">부서</td>
                      <td style="width:25%;border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INSTRUCTORINFO1" class="txtText" value="{//forminfo/maintable/INSTRUCTORINFO1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INSTRUCTORINFO1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl1" style="width:12%;border-bottom:0">직위</td>
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
                      <td class="f-lbl1" style="width:12%;border-bottom:0">성명</td>
                      <td style="width:24%;border-bottom:0;border-right:0">
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
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">특이사항</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000);" style="height:80px">
                        <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DESCRIPTION">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>

            <input type="hidden" id="__mainfield" name="COURSEID" value="{//forminfo/maintable/COURSEID}" />
            <input type="hidden" id="__mainfield" name="INSTID" value="{//forminfo/maintable/INSTID}" />
            <input type="hidden" id="__mainfield" name="INSTRUCTORID" value="{//forminfo/maintable/INSTRUCTORID}" />
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