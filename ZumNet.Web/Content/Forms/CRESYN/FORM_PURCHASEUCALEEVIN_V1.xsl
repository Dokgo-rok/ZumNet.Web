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
          .m {width:740px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}
          .m .ft-sub label {font-size:13px}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {height:14px;font-size:11px;width:110px} .m .ft .f-option2 {width:70px}

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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:390px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>             
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
                <td style="width:38%">
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
              <xsl:if test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%" />
                <col style="width:26%" />
                <col style="width:12%" />
                <col style="width:22%" />
                <col style="width:12%" />
                <col />
              </colgroup>
              <tr>
                <td class="f-lbl">결정구분</td>
                <td colspan="5" style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbSETCLASS" value="신규확정">
                      <xsl:if test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbSETCLASS', this, 'SETCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/SETCLASS),'신규확정')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/SETCLASS),'신규확정') and $actrole='_approver'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">신규확정</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbSETCLASS" value="임시설정">
                      <xsl:if test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbSETCLASS', this, 'SETCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/SETCLASS),'임시설정')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/SETCLASS),'임시설정') and $actrole='_approver'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">임시설정</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="SETCLASS">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/SETCLASS" />
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">품명</td>
                <td>
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtRead" readonly="readonly" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText" maxlength="100" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">품번</td>
                <td>
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="ITEMNO" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/ITEMNO}" />
                      <button onclick="parent.fnExternal('erp.items',240,40,80,70,'','ITEMNO','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNO))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="ITEMNO" class="txtText" maxlength="100" value="{//forminfo/maintable/ITEMNO}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">관련모델</td>
                <td style="border-right:0">
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="MODELNAME" style="width:83%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/MODELNAME}" />
                      <button onclick="parent.fnExternal('erp.items',240,40,20,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText" maxlength="100" value="{//forminfo/maintable/MODELNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">적용사업장</td>
                <td>
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="PRODUCTCENTER" style="width:89%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PRODUCTCENTER}" />
                      <button onclick="parent.fnOption('external.centercode',240,140,100,120,'','PRODUCTCENTER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTCENTER))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="PRODUCTCENTER" class="txtText" maxlength="50" value="{//forminfo/maintable/PRODUCTCENTER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTCENTER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">업체명</td>
                <td>
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="COMPANY" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/COMPANY}" />
                      <button onclick="parent.fnExternal('erp.vendors',240,40,80,70,'','COMPANY','COMPANYCODE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANY))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="COMPANY" class="txtText" maxlength="100" value="{//forminfo/maintable/COMPANY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">업체코드</td>
                <td style="border-right:0">
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="COMPANYCODE" class="txtRead" readonly="readonly" value="{//forminfo/maintable/COMPANYCODE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYCODE))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="COMPANYCODE" class="txtText" maxlength="50" value="{//forminfo/maintable/COMPANYCODE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYCODE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">결제예정단가</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="UNITCOST" class="txtDollar5" style="width:187px"  maxlength="20" value="{//forminfo/maintable/UNITCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">결제조건</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SETTLEMENT" class="txtText" maxlength="50" value="{//forminfo/maintable/SETTLEMENT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SETTLEMENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">적용시점</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="APPLYPOINT" class="txtDate" maxlength="8" value="{//forminfo/maintable/APPLYPOINT}">
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLYPOINT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">통화</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:89px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CURRENCY}" />
                      <button onclick="parent.fnOption('iso.currency',160,140,100,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">적용 환율</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="EXCHANGERATE" style="width:138px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/EXCHANGERATE}" />
                      <button onclick="parent.fnExternal('erp.exchangerate',240,40,80,70,'KRW','EXCHANGERATE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGERATE))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">개발원가견적</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="PRICE1" class="txtText" maxlength="20" value="{//forminfo/maintable/PRICE1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRICE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">차 액</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="PRICE2" class="txtText" maxlength="20" value="{//forminfo/maintable/PRICE2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRICE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">인하율</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE1" class="txtText" maxlength="20" value="{//forminfo/maintable/RATE1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RATE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">Pre L/T</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="PRELT" class="txtText" maxlength="20" value="{//forminfo/maintable/PRELT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRELT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">Prcess L/T</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="PROCLT" class="txtText" maxlength="20" value="{//forminfo/maintable/PROCLT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PROCLT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">Post L/T</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="POSTLT" class="txtText" maxlength="20" value="{//forminfo/maintable/POSTLT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/POSTLT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">TOTAL L/T</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="TOTALLT" style="width:186px" class="txtText" maxlength="20" value="{//forminfo/maintable/TOTALLT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALLT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">구매담당자</td>
                <td colspan="3" style="border-right:0">
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="BUYER" style="width:94%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/BUYER}" />
                      <button onclick="parent.fnExternal('erp.buyer',240,40,240,70,'','BUYER','BUYERID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BUYER))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="BUYER" class="txtText" maxlength="100" value="{//forminfo/maintable/BUYER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BUYER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">PO TYPE</td>
                <td style="border-bottom:0">
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="POTYPE" style="width:89px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/POTYPE}" />
                      <button onclick="parent.fnOption('erp.potype',80,90,60,90,'','POTYPE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/POTYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="POTYPE" class="txtText" maxlength="50" value="{//forminfo/maintable/POTYPE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/POTYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <!--<td class="f-lbl1" style="border-bottom:0">BPA NUM</td>
                <td colspan="3" style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="BPANUM" style="width:94%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/BPANUM}" />
                      <button onclick="parent.fnOption('erp.bpanum',400,160,100,120,'','BPANUM');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BPANUM))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>-->
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td colspan="2" class="f-lbl2" style="width:8%">구분</td>
                <td class="f-lbl2" style="width:35%">견적가</td>
                <td class="f-lbl2" style="width:35%">NEGO가</td>
                <td class="f-lbl2" style="border-right:0;width:22%">차액</td>
              </tr>
              <tr>
                <td rowspan="7" class="f-lbl3" style="width:4%">
                  제<br /><br />조<br /><br />원<br /><br />가
                </td>
                <td rowspan="2" class="f-lbl3" style="width:4%">
                  재<br /><br />료<br /><br />비
                </td>
                <td style="height:80px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT1" style="height:75px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT1" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT1">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT1))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT2" style="height:75px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT2" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT2">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT2))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT3" style="height:75px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT3" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT3">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT3))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td>
                  소&nbsp;계&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM1" style="width:120px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM1))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  소&nbsp;계&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM2" style="width:120px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM2))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM3" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM3))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td rowspan="2" class="f-lbl3">
                  노<br /><br />무<br /><br />비
                </td>
                <td style="height:70px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT4" style="height:64px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT4" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT4">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT4))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT5" style="height:64px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT5" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT5">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT6" style="height:64px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT6" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT6">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td>
                  소&nbsp;계&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM4" style="width:120px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM4))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  소&nbsp;계&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM5" style="width:120px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM5))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM6" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM6))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td class="f-lbl3" rowspan="2">
                  경<br />비
                </td>
                <td style="height:50px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT7" style="height:46px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT7" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT7">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT8" style="height:46px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT8" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT8">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <textarea id="__mainfield" name="COMMENT9" style="height:46px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:if test="$mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                          <xsl:value-of select="//forminfo/maintable/COMMENT9" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield"  name="COMMENT9">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td>
                  소&nbsp;계&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM22" style="width:120px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM22" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM22))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  소&nbsp;계&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM23" style="width:120px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM23" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM23))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM24" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM24" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM24))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td class="f-lbl3">계</td>
                <td>
                  <span class="f-option1">재료비+노무비+경비</span>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM7" style="width:90px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM7))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  <span class="f-option1">재료비+노무비+경비</span>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM8" style="width:90px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM8))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM9" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM9" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM9))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td rowspan="3" class="f-lbl3">
                  판<br />관<br />비
                </td>
                <td class="f-lbl3">
                  일<br />반
                </td>
                <td style="height:44px">
                  제조원가의
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE2" style="width:30px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATE2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE2))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;%&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM10" style="width:80px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM10" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM10))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  제조원가의
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE3" style="width:30px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATE3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE3))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;%&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM11" style="width:80px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM11" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM11))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM12" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM12" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM12))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="maxlength">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td class="f-lbl3">
                  판<br />매
                </td>
                <td style="height:44px">
                  제조원가의
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE4" style="width:30px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATE4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE4))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;%&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM13" style="width:80px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM13" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM13))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  제조원가의
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE5" style="width:30px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATE5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE5))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;%&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM14" style="width:80px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM14" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM14))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM15" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM15" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM15))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td class="f-lbl3">계</td>
                <td>
                  <span class="f-option1">재료비+노무비+경비</span>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM16" style="width:90px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM16" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM16))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  <span class="f-option1">재료비+노무비+경비</span>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM17" style="width:90px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM17" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM17))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM18" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM18" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM18))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td colspan="2" class="f-lbl3">이윤</td>
                <td style="height:30px">
                  제조원가의
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE6" style="width:30px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATE6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE6))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;%&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM19" style="width:80px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM19" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM19))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  제조원가의
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="RATE7" style="width:30px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATE7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE7))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;%&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM20" style="width:80px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM20" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM20))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:30px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="SUM21" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUM21" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUM21))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td colspan="2" class="f-lbl3">합계</td>
                <td style="height:30px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="TOTALSUM1" style="width:160px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTALSUM1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM1))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="TOTALSUM2" style="width:160px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTALSUM2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM2))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:60px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" id="__mainfield" name="TOTALSUM3" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTALSUM3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM3))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                      <input type="text" name="CoCurrency" style="width:40px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                </td>
              </tr>
              <tr>
                <td colspan="2" class="f-lbl2" style="border-bottom:0">기타</td>
                <td colspan="3" style="padding:0;border-right:0;border-bottom:0;height:48px">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border:0">
                    <tr>
                      <td class="f-lbl2" style="width:80px">거래조건</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                            <input type="text" id="__mainfield" name="CONDITION">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">100</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/CONDITION" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONDITION))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" style="border-bottom:0">관세</td>
                      <td style="border-right:0;border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
                            <input type="text" id="__mainfield" name="TARIFF" style="width:100px">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">10</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TARIFF" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TARIFF))" />
                          </xsl:otherwise>
                        </xsl:choose>&nbsp;%
                      </td>
                    </tr>
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

        <!-- HIdden Field -->
        <!--<input type="hidden" id="__mainfield" name="BUYERID" value="{//forminfo/maintable/BUYERID}" />-->
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