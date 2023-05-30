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
          .m {width:750px} .m .fm-editor {height:500px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:6%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:20%} .m .ft .f-option1 {width:8%} .m .ft .f-option2 {width:25%}
          .m .ft-sub .f-option {width:45%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:500px}}
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
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
                <td class="f-lbl" style="border-bottom:0">담당부서</td>
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0;">제목</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
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
            <span>선행 제품 개발 내용</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">Target 고객/시장</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TARGETMARKET" class="txtText" maxlength="50" value="{//forminfo/maintable/TARGETMARKET}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TARGETMARKET))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">품명</td>
                <td style="width: 35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText" maxlength="50" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">목표개발원가</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GOALDEVCOST" class="txtText" maxlength="20" value="{//forminfo/maintable/GOALDEVCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GOALDEVCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">개발 목적</td>
                <td colspan="3" style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbDEVPURPOSE" value="내부 검토">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVPURPOSE', this, 'DEVPURPOSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVPURPOSE),'내부 검토')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVPURPOSE),'내부 검토')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">내부 검토</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbDEVPURPOSE" value="고객 제안">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVPURPOSE', this, 'DEVPURPOSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVPURPOSE),'고객 제안')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVPURPOSE),'고객 제안')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">고객 제안</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb13" name="ckbDEVPURPOSE" value="제품 개선">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVPURPOSE', this, 'DEVPURPOSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVPURPOSE),'제품 개선')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVPURPOSE),'제품 개선')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">제품 개선</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb14" name="ckbDEVPURPOSE" value="기타">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVPURPOSE', this, 'DEVPURPOSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVPURPOSE),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVPURPOSE),'기타')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb14">기타</label>
                  </span>
                  (<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVPURPOSEETC" style="width:120px" class="txtRead" maxlength="50" readonly="readonly" value="{//forminfo/maintable/DEVPURPOSEETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVPURPOSEETC))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="DEVPURPOSE" value="{//forminfo/maintable/DEVPURPOSE}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">개발 구분</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbDEVCLASS" value="선행 제품">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVCLASS', this, 'DEVCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVCLASS),'선행 제품')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVCLASS),'선행 제품')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">선행 제품</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbDEVCLASS" value="기존 제품 개선">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVCLASS', this, 'DEVCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVCLASS),'기존 제품 개선')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVCLASS),'기존 제품 개선')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">기존 제품 개선</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb23" name="ckbDEVCLASS" value="경쟁사 제품 벤치마킹">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVCLASS', this, 'DEVCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVCLASS),'경쟁사 제품 벤치마킹')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVCLASS),'경쟁사 제품 벤치마킹')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">경쟁사 제품 벤치마킹</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb24" name="ckbDEVCLASS" value="기타">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDEVCLASS', this, 'DEVCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DEVCLASS),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DEVCLASS),'기타')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">기타</label>
                  </span>
                  (<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVCLASSETC" style="width:120px" class="txtRead" maxlength="50" readonly="readonly" value="{//forminfo/maintable/DEVCLASSETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVCLASSETC))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="DEVCLASS" value="{//forminfo/maintable/DEVCLASS}" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>제품 개발 목적</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PRODPURPOSE" style="height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:value-of select="//forminfo/maintable/PRODPURPOSE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div style="min-height:60px" class="txaRead">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODPURPOSE))" />
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
            <span>제품 개요</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PRODDESC" style="height:120px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:value-of select="//forminfo/maintable/PRODDESC" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div style="min-height:120px" class="txaRead">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODDESC))" />
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
            <span>제품 개발 및 검토 일정</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:110px" />
                <col style="width:80px" />
                <col style="width:80px" />
                <col style="width:80px" />
                <col style="width:80px" />
                <col style="width:80px" />
                <col style="width:80px" />
                <col style="width:80px" />
                <col style="width:80px" />
              </colgroup>
              <tr>
                <td class="f-lbl">개발기간</td>
                <td colspan="8" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVFROM" class="datepicker-slash txtDateSlash" maxlength="10" style="width: 90px" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/DEVFROM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVFROM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;~&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVTO" class="datepicker-slash txtDateSlash" maxlength="10" style="width: 90px" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/DEVTO}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVTO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;&nbsp;&nbsp;[
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PERIODMONTH" class="txtNumberic" maxlength="3" data-inputmask="number;3;0" style="width: 30px" value="{//forminfo/maintable/PERIODMONTH}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIODMONTH))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;개월&nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PERIODDAY" class="txtNumberic" maxlength="3" data-inputmask="number;3;0" style="width: 30px" value="{//forminfo/maintable/PERIODDAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIODDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;일&nbsp;]
              </td>
              </tr>
              <tr>
                <td class="f-lbl">개발단계</td>
                <td class="f-lbl2">디자인확정</td>
                <td class="f-lbl2">설계</td>
                <td class="f-lbl2">목업</td>
                <td class="f-lbl2">금형</td>
                <td class="f-lbl2">1차검토</td>
                <td class="f-lbl2">2차검토</td>
                <td class="f-lbl2">3차검토</td>
                <td class="f-lbl2" style="border-right:0">개발완료</td>
              </tr>
              <tr>
                <td class="f-lbl">계획일</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE1" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE2" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE12}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE3" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE4" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE5" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE6" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE7" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANDATE7" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">수량</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT1" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT2" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT3" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT4" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT5" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT6" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT7" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0; border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCOUNT8" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PLANCOUNT8}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCOUNT8))" />
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
                      <span>예상투자비</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:70px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('iso.currency',160,140,40,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
							<i class="fas fa-angle-down"></i>
						</button>
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
					<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable1');">
	                    <i class="fas fa-plus"></i>
                    </button>
                    <button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable1');">
	                    <i class="fas fa-minus"></i>
                    </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>예상투자비</span>
                    </td>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:150px"></col>
                      <col style="width:130px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0;">항목</td>
                      <td class="f-lbl-sub" style="border-top:0;">투자금액</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="2" style="border-bottom:0">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM" class="txtRead_Right" readonly="readonly" values="{//forminfo/maintable/TOTALSUM}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="1" style="border-right:0">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

			<xsl:if test="//linkeddocinfo/linkeddoc or //fileinfo/file[@isfile='Y']">
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

  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <!--<xsl:attribute name="style">height:10px</xsl:attribute>-->
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item1', 'ITEM', string(ITEM), '100')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PREDICTPRICE" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PREDICTPRICE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PREDICTPRICE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td  style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
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
            <xsl:when test="phxsl:isEqual(string(@xfalias),'pdm')">
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
