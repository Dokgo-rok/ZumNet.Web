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
          .m {width:700px} .m .fm-editor {height:350px;border:windowtext 1pt solid}
          .fh h1 {font-size:15.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}
          .span-lbl{font-size:7.0pt;}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%; font-size:9.0pt} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:10%}
          .m .ft .f-option {width:47%; margin-left:2%} .m .ft .f-option1 {margin-left:4px; width:112px; font-size:9.0pt} .m .ft .f-option2 {margin-left:6%}
          .m .ft-sub .f-option {width:49%}

          .m table.ft span input[type="radio"], .m table.ft span input[type="checkbox"] {
            margin-top: .1rem;
          }

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:350px}}
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
                    거래처정보등록신청서 <br/>
                    (Client Registration Application)
                    <!--<xsl:value-of select="//docinfo/docname" />-->
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
          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '3', '처리부서')"/>
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
              <colgroup>
                <col style="width:15%"/>
                <col style="width:35%"/>
                <col style="width:15%"/>
                <col style="width:35%"/>
              </colgroup>
              <tr>
                <td class="f-lbl">관리번호</td>
                <td>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일자</td>
                <td style="border-right:0px">
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
              <colgroup>
                <col style="width:15%" />
                <col style="width:85%" />
              </colgroup>
              <tr>
                <!--<td class="f-lbl" style="border-bottom:0;">ERP 등록번호</td>-->
                <!--<td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="ERPSEQ" value="{//forminfo/maintable/ERPSEQ}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ERPSEQ))" />
                    </xsl:otherwise>
                  </xsl:choose>-->
                <!--</td>-->
                <td class="f-lbl" style="border-bottom:0;">등록법인<span style="font-size:7.0pt;text-align:center"> (COMPANY)</span>
              </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:40%" type="text" id="__mainfield" name="COMPANY" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/COMPANY}"/>
                      <input type="hidden" id="__mainfield" name="COMPANYCODE" value="{//forminfo/maintable/COMPANYCODE}"/>
                      <!--<button onclick="parent.fnOption('report.ERP_FACTORY',240,200,126,70,'COMPANY','COMPANY','COMPANYCODE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="등록법인" onclick="_zw.formEx.optionWnd('report.ERP_FACTORY',240,200,126,70,'COMPANY','COMPANY','COMPANYCODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANY))" />
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

          <div class ="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:15%" />
                <col style="width:35%" />
                <col style="width:15%" />
                <col style="width:35%" />
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0px" colspan="4">1.기초정보</td>
              </tr>
              <tr>
                <td class="f-lbl" >거래처구분<span style="font-size:7.0pt;text-align:center">(Client)</span></td>
                <td>
                  <span class="f-option1">
                    <input id="ckb1" name="ckbCLIENT_TYPE"  type="checkbox" value="CUST">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCLIENT_TYPE', this, 'CLIENT_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb1">고객</label>
                  </span>
                  <span class="f-option1">
                    <input id="ckb2" name="ckbCLIENT_TYPE"  type="checkbox" value="PROD">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCLIENT_TYPE', this, 'CLIENT_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb2">공급자</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CLIENT_TYPE" value="{//forminfo/maintable/CLIENT_TYPE}" />
                </td>
                <td class="f-lbl">
                  국외구분 <span style="font-size:7.0pt;text-align:center">(TYPE)</span>
                </td>
                <td style="border-right:0;">
                  <span class="f-option1" style="width:45%" >
                    <input id="ckb3" name="ckbCOUNTRY_TYPE"  type="checkbox" value="D">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOUNTRY_TYPE', this, 'COUNTRY_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COUNTRY_TYPE),'D')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COUNTRY_TYPE),'D')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb3">국내(Domestic)</label>
                  </span>
                  <span class="f-option1" style="width:45%">
                    <input id="ckb4" name="ckbCOUNTRY_TYPE"  type="checkbox" value="F">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOUNTRY_TYPE', this, 'COUNTRY_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COUNTRY_TYPE),'F')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COUNTRY_TYPE),'F')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb4">국외(Foreign)</label>
                    <input type="hidden" id="__mainfield" name="COUNTRY_TYPE" value="{//forminfo/maintable/COUNTRY_TYPE}" />
                  </span>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">고객구분<span style="font-size:7.0pt;text-align:center;" >(Class)</span>
              </td>
              <td colspan="3" style="border-right:0;">
                <span class="f-option1">
                  <input id="ckb5" name="ckbCUST_TYPE"  type="checkbox" value="COMPANY">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">_zw.form.checkYN('ckbCUST_TYPE', this, 'CUST_TYPE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUST_TYPE),'COMPANY')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CUST_TYPE),'COMPANY')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb5">Company</label>
                </span>
                <span class="f-option1">
                  <input id="ckb6" name="ckbCUST_TYPE"  type="checkbox" value="PEOPLE">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">_zw.form.checkYN('ckbCUST_TYPE', this, 'CUST_TYPE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUST_TYPE),'PEOPLE')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CUST_TYPE),'PEOPLE')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb6">People</label>
                </span>
                <span class="f-option1">
                  <input id="ckb7" name="ckbCUST_TYPE"  type="checkbox" value="PUBLIC">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">_zw.form.checkYN('ckbCUST_TYPE', this, 'CUST_TYPE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COUNTRY_TYPE),'PUBLIC')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CUST_TYPE),'PUBLIC')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input> 
                  <label for="ckb7">Public</label>
                </span>
                <input type="hidden" id="__mainfield" name="CUST_TYPE" value="{//forminfo/maintable/CUST_TYPE}" />
              </td>
            </tr>
            <tr>
              <td class="f-lbl" style="border-bottom:0;">
                공급자구분<span style="font-size:7.0pt;text-align:center;" >(Class)</span>
              </td>
                <td style="border-right:0;border-bottom:0;" colspan="3">
                  <span class="f-option1">
                    <input id="ckb9" name="ckbPRODUCER_TYPE"  type="checkbox" value="SUPPLIER">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbPRODUCER_TYPE', this, 'PRODUCER_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PRODUCER_TYPE),'SUPPLIER')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PRODUCER_TYPE),'SUPPLIER')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb9">Supplier</label>
                  </span>
                  <span class="f-option1">
                    <input id="ckb10" name="ckbPRODUCER_TYPE"  type="checkbox" value="OSP">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbPRODUCER_TYPE', this, 'PRODUCER_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PRODUCER_TYPE),'OSP')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PRODUCER_TYPE),'OSP')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb10">Supplier(OSP)</label>
                  </span>
                  <span class="f-option1">
                    <input id="ckb11" name="ckbPRODUCER_TYPE"  type="checkbox" value="OTHER">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbPRODUCER_TYPE', this, 'PRODUCER_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PRODUCER_TYPE),'OTHER')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PRODUCER_TYPE),'OTHER')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">Supplier(Other)</label>
                  </span>
                  <span class="f-option1">
                    <input id="ckb12" name="ckbPRODUCER_TYPE"  type="checkbox" value="EMPLOYEE">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbPRODUCER_TYPE', this, 'PRODUCER_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PRODUCER_TYPE),'EMPLOYEE')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PRODUCER_TYPE),'EMPLOYEE')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input> 
                    <label for="ckb12">Employee</label>
                  </span>
                  <span class="f-option1">
                    <input id="ckb13" name="ckbPRODUCER_TYPE"  type="checkbox" value="BANK">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbPRODUCER_TYPE', this, 'PRODUCER_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PRODUCER),'BANK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PRODUCER_TYPE),'BANK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">Bank Insurance</label>
                    <input type="hidden" id="__mainfield" name="PRODUCER_TYPE" value="{//forminfo/maintable/PRODUCER_TYPE}" />
                    
                  </span>
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
                  <colgroup>
                      <col style="width:15%"/>
                      <col style="width:35%"/>
                      <col style="width:15%"/>
                      <col style="width:35%"/>
                  </colgroup>
                <tr>
                  <td class="f-lbl" style="border-right:0px" colspan="4">2.업체정보</td>
                </tr>  
              <tr>
                <td class="f-lbl">거래처이름<span style="font-size:7.0pt;text-align:center;" >(Name)</span>
                </td>
                <td style="" >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="CLIENT_NAME" value="{//forminfo/maintable/CLIENT_NAME}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLIENT_NAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  거래처이름2<span style="font-size:7.0pt;text-align:center;" >(Ship to Name)</span>
                </td>
                <td style="border-right:0px" >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="CLIENT_NAME2" value="{//forminfo/maintable/CLIENT_NAME2}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLIENT_NAME2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >사업자등록번호<span style="font-size:0.525rem;text-align:center;" >(Tax Registration Number)</span>
              </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="CLIENT_NUMBER" value="{//forminfo/maintable/CLIENT_NUMBER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLIENT_NUMBER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >주민등록번호<span style="font-size:0.525rem;text-align:center;" >(Social Security Number)</span>
              </td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="SOCIAL_NUMBER" value="{//forminfo/maintable/SOCIAL_NUMBER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SOCIAL_NUMBER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">
                 국가<span style="font-size:7.0pt;text-align:center;" >(Bill to country)</span>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" style="width:92%" type="text" readonly="readonly"  id="__mainfield" name="COUNTRY" value="{//forminfo/maintable/COUNTRY}"/>
                      <input type="hidden" id="__mainfield" name="COUNTRYCODE" value="{//forminfo/maintable/COUNTRYCODE}"/>
                      <!--<button onclick="parent.fnExternal('report.ERP_COUNTRY2',240,40,126,70,'COUNTRY','COUNTRY','COUNTRYCODE');" id="btcc"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="국가" onclick="_zw.formEx.externalWnd('report.ERP_COUNTRY2',240,40,126,70,'COUNTRY','COUNTRY','COUNTRYCODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  국가 2<span style="font-size:7.0pt;text-align:center;">(Ship to country)</span>
                </td>
                <td style="border-right:0px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="COUNTRY2" value="{//forminfo/maintable/COUNTRY2}"/>
                      <input type="hidden" id="__mainfield" name="COUNTRYCODE2" value="{//forminfo/maintable/COUNTRYCODE2}"/>
                      <!--<button onclick="parent.fnExternal('report.ERP_COUNTRY',240,40,126,70,'COUNTRY2','COUNTRY2','COUNTRYCODE2');" onfocus="this.blur()"  name="COUNTRYBUTTOM2"  class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">
                  주소<span style="font-size:7.0pt;text-align:center;" >(Bill to address)</span>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="ADDRES" value="{//forminfo/maintable/ADDRES}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ADDRES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  주소 2<span style="font-size:7.0pt;text-align:center;" >(Ship to address)</span>
                </td>
                <td style="border-right:0px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="ADDRES2" value="{//forminfo/maintable/ADDRES2}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ADDRES2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl"  style="border-bottom:0;" >
                  우편번호<span style="font-size:7.0pt;text-align:center;" >(PostalCode)</span>
                </td>
                <td style="border-bottom:0px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="POST_CODE" value="{//forminfo/maintable/POST_CODE}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/POST_CODE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0;">
                  대표자<span style="font-size:7.0pt;text-align:center;" >(Taxable Person)</span>
                </td >
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="TAXBLE_PERSON" value="{//forminfo/maintable/TAXBLE_PERSON}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXBLE_PERSON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  </td>
                </tr>
              </table>
          </div>

          <div class="fm">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
                <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td style="font-size:12px;text-align:right">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <span class="f-option">
                            <input id="ckb73" name="ckbBILLTO"  type="checkbox" value="BILL" class="mt-1">
                              <xsl:if test="$mode='new' or $mode='edit'">
                                <xsl:attribute name="onclick">_zw.form.checkYN('ckbBILLTO', this, 'BILLTO')</xsl:attribute>
                              </xsl:if>
                              <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BILLTO),'BILL')">
                                <xsl:attribute name="checked">true</xsl:attribute>
                              </xsl:if>
                              <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BILLTO),'BILL')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </input>
                            <label for="ckb73" class="small">Bill to 정보와 Ship to 정보를 동일하게 합니다.</label>
                          </span>
                        </xsl:when>
                        <xsl:otherwise>
                          &nbsp;
                        </xsl:otherwise>
                      </xsl:choose>
                      <input type="hidden" id="__mainfield" name="BILLTO" value="{//forminfo/maintable/BILLTO}" />
                    </td>
                  </tr>
                </table>
                
              </xsl:when>
              <xsl:otherwise>
                &nbsp;
              </xsl:otherwise>
            </xsl:choose>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:15%"/>
                <col style="width:35%"/>
                <col style="width:15%"/>
                <col style="width:10%"/>
                <col style="width:25%"/>
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0px" colspan="5">3.거래정보</td>
              </tr>
              <tr>
                <td class="f-lbl" >세금구분<span style="font-size:7.0pt;text-align:center;" >(Tax Code)</span>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="TAX_CODE" value="{//forminfo/maintable/TAX_CODE}"/>
                      <input  type="hidden" id="__mainfield" name="TAXID" value="{//forminfo/maintable/TAXID}"/>
                      <!--<button onclick="parent.fnOption('report.ERP_TAXCODE',240,250,126,70,'TAX_CODE','TAX_CODE','TAXID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="세금구분" onclick="_zw.formEx.optionWnd('report.ERP_TAXCODE',240,250,126,70,'TAX_CODE','TAX_CODE','TAXID');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAX_CODE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >결제조건<span style="font-size:7.0pt;text-align:center;" >(Payment Term)</span>
                </td>
                <td style="border-right:0;" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="CUST_PAYMENT" value="{//forminfo/maintable/CUST_PAYMENT}"/>
                      <input  type="hidden" id="__mainfield" name="CUSTPAYMENTCODE" value="{//forminfo/maintable/CUSTPAYMENTCODE}"/>
                      <!--<button onclick="parent.fnOption('report.ERP_PAYMENTCLT',240,250,150,70,'CUST_PAYMENT','CUST_PAYMENT','CUSTPAYMENTCODE');" name="CUSTPAYBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="결제조건" onclick="_zw.formEx.optionWnd('report.ERP_PAYMENTCLT',240,250,150,70,'CUST_PAYMENT','CUST_PAYMENT','CUSTPAYMENTCODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUST_PAYMENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >가격목록<span style="font-size:7.0pt;text-align:center;" >(PriceList)</span>
              </td>
              <td>
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input class="txtText_u" readonly="readonly"  style="width:92%" type="text" id="__mainfield" name="PRICE_LIST" value="{//forminfo/maintable/PRICE_LIST}"/>
                    <input  type="hidden" id="__mainfield" name="PRICELISTCODE" value="{//forminfo/maintable/PRICELISTCODE}"/>
                    <!--<button onclick="parent.fnExternal('report.ERP_PRICE',240,40,126,70,'PRICE_LIST','PRICELISTCODE','PRICE_LIST');" name="PRICELISTBUTTON" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                    </button>-->
                    <button type="button" class="btn btn-outline-secondary btn-18" title="" onclick="_zw.formEx.externalWnd('report.ERP_PRICE',240,40,126,70,'PRICE_LIST','PRICELISTCODE','PRICE_LIST');">
                      <i class="fas fa-angle-down"></i>
                    </button>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRICE_LIST))" />
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              <td class="f-lbl" >선적조건<span style="font-size:7.0pt;text-align:center;" >(terms of shipment)</span>
              </td>
              <td style="border-right:0;" colspan="2">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="SHIPMENT_TERM" value="{//forminfo/maintable/SHIPMENT_TERM}"/>
                    <input type="hidden" id="__mainfield" name="SHIPMENTTERMCODE" value="{//forminfo/maintable/SHIPMENT_TERMCODE}"/>
                    <!--<button onclick="parent.fnOption('external.shipmentcond',160,140,10,115,'etc','SHIPMENT_TERM');" name="SHIPMENTBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">                   
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                    </button>-->
                    <button type="button" class="btn btn-outline-secondary btn-18" title="선적조건" onclick="_zw.formEx.optionWnd('external.shipmentcond',160,140,10,115,'etc','SHIPMENT_TERM');">
                      <i class="fas fa-angle-down"></i>
                    </button>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SHIPMENT_TERMCODE))" />
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
            <tr>
              <td class="f-lbl">결제은행<span style="font-size:7.0pt;text-align:center;" >(Customer Bank)</span></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="CUST_BANK" style="width:92%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CUST_BANK}" />                      
                      <!--<button onclick="parent.fnOption('external.mainbank',160,140,10,115,'etc','CUST_BANK');" name="CUSTBANKBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="결제은행" onclick="_zw.formEx.optionWnd('external.mainbank',160,140,10,115,'etc','CUST_BANK');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUST_BANK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >결제계좌<span style="font-size:7.0pt;text-align:center;" >(Customer Account)</span>
              </td>
                <td style="border-right:0;" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%" type="text" id="__mainfield" name="CUST_BANKACCOUNT" value="{//forminfo/maintable/CUST_BANKACCOUNT}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUST_BANKACCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >담당영업사원<span style="font-size:7.0pt;text-align:center;" >(Sales Person)</span>
              </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="SALES_PERSON" value="{//forminfo/maintable/SALES_PERSON}"/>
                      <input  type="hidden" id="__mainfield" name="SALESPERSONID" value="{//forminfo/maintable/SALESPERSONID}"/>
                      <!--<button onclick="parent.fnOption('report.ERP_SALSEMAN',240,300,126,70,'SALES_PERSON','SALES_PERSON','SALESPERSONID');" name="SALESPERBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="담당영업사원" onclick="_zw.formEx.optionWnd('report.ERP_SALSEMAN',240,300,126,70,'SALES_PERSON','SALES_PERSON','SALESPERSONID');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SALES_PERSON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >주문유형<span style="font-size:7.0pt;text-align:center;" >(OderType)</span>
              </td>
                <td style="border-right:0;" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="ORDER_TYPE" value="{//forminfo/maintable/ORDER_TYPE}"/>
                      <input  type="hidden" id="__mainfield" name="ORDERTYPECODE" value="{//forminfo/maintable/ORDERTYPECODE}"/>
                      <!--<button onclick="parent.fnOption('report.ERP_ORDER',240,200,126,70,'ORDER_TYPE','ORDER_TYPE','ORDERTYPECODE');" name="ORDERTYPEBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="주문유형" onclick="_zw.formEx.optionWnd('report.ERP_ORDER',240,200,126,70,'ORDER_TYPE','ORDER_TYPE','ORDERTYPECODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ORDER_TYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >업태<span style="font-size:7.0pt;text-align:center;" >(Industry Classification)</span>
               </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" maxlength="150"  name="INDUSTRY_CLASS" value="{//forminfo/maintable/INDUSTRY_CLASS}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INDUSTRY_CLASS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >업종<span style="font-size:0.5rem;text-align:center;" >(Industry Subclassification)</span>
                </td>
                <td style="border-right:0;" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" maxlength="150" name="INDUSTRY_SUBCLASS" value="{//forminfo/maintable/INDUSTRY_SUBCLASS}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INDUSTRY_SUBCLASS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >지급은행<span style="font-size:7.0pt;text-align:center;" >(Supplier bank)</span></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                                            
                      <input type="text" id="__mainfield" name="PAYMENT_BANK" style="width:92%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PAYMENT_BANK}" />                      
                      <!--<button onclick="parent.fnOption('external.mainbank',160,140,10,115,'etc','PAYMENT_BANK');" name="PAYMENTBANKBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="지급은행" onclick="_zw.formEx.optionWnd('external.mainbank',160,140,10,115,'etc','PAYMENT_BANK');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAYMENT_BANK))" />
                    </xsl:otherwise>
                  </xsl:choose>                 
                </td>
                <td class="f-lbl" rowspan="2">계좌번호<span style="font-size:7.0pt;text-align:center;">(Account no)</span></td>
                <td class="f-lbl2" >국내</td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="ACCOUNT_DOMESTIC" value="{//forminfo/maintable/ACCOUNT_DOMESTIC}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCOUNT_DOMESTIC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >지급조건<span style="font-size:7.0pt;text-align:center;" >(Payment Term)</span></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="PAYMENT_TERM" value="{//forminfo/maintable/PAYMENT_TERM}"/>
                      <input  type="hidden" id="__mainfield" name="PAYMENTTERMCODE" value="{//forminfo/maintable/PAYMENTTERMCODE}"/>
                      <!--<button onclick="parent.fnOption('report.ERP_PAYMENTPROD',240,200,126,70,'PAYMENT_TERM','PAYMENT_TERM','PAYMENTTERMCODE');" name="PAYMENTTERMBUTTON"  onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}//EA/Images/ico_28.gif" />
                      </button>-->
                      <button type="button" class="btn btn-outline-secondary btn-18" title="지급조건" onclick="_zw.formEx.optionWnd('report.ERP_PAYMENTPROD',240,200,126,70,'PAYMENT_TERM','PAYMENT_TERM','PAYMENTTERMCODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAYMENT_TERM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" >해외<span style="font-size:7.0pt;text-align:center;" >(SWIFT Code)</span></td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="ACCOUNT_FOREIGN" value="{//forminfo/maintable/ACCOUNT_FOREIGN}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCOUNT_FOREIGN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="border-bottom:0;">&nbsp;
              </td>
                <td class="f-lbl"  style="border-bottom:0;">수취인명<span style="font-size:0.5rem;text-align:center;" >(Beneficiary Name of Bank)</span>
              </td>
                <td style="border-bottom:0;border-right:0;" colspan="2" >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="BANK_CALLDATE" value="{//forminfo/maintable/BANK_CALLDATE}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BANK_CALLDATE))" />
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:16%"/>
                <col style="width:16%"/>
                <col style="width:16%"/>
                <col style="width:16%"/>
                <col style="width:16%"/>
                <col style="width:16%"/>
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0px" colspan="6">4.연락처 정보</td>
              </tr>
              <tr>
                <td class="f-lbl" >거래처담당자<span style="font-size:7.0pt;text-align:center;" >(Name)</span>
              </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="MANAGER" value="{//forminfo/maintable/MANAGER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MANAGER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" >담당자 메일<span style="font-size:7.0pt;text-align:center;" >(E-mail)</span>
              </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="EMAIL" value="{//forminfo/maintable/EMAIL}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EMAIL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" >비고</td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="REMARK" value="{//forminfo/maintable/REMARK}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REMARK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;"  >
                  유선<span style="font-size:7.0pt;text-align:center;" >(Telephone)</span>
                </td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="TEL" value="{//forminfo/maintable/TEL}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TEL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2"  style="border-bottom:0;">무선<span style="font-size:7.0pt;text-align:center;" >(Mobile)</span>
              </td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="MOBILE" value="{//forminfo/maintable/MOBILE}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MOBILE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom:0;" >팩스<span style="font-size:7.0pt;text-align:center;" >(Fax No.)</span>
              </td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100%"  type="text" id="__mainfield" name="FAX" value="{//forminfo/maintable/FAX}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FAX))" />
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
