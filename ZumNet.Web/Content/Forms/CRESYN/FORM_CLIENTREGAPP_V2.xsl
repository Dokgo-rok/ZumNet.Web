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
			.fh h1 {font-size:15.0pt;letter-spacing:0pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}
			.span-lbl{font-size:7.0pt;}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:15%; font-size:9.0pt} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:10%} .m .ft .f-lbl-en {display: block; font-size: 7.0pt}
			.m .ft .f-option {width:47%; margin-left:2%} .m .ft .f-option1 {margin-left:4px; width: 25%} .m .ft .f-option1 input {margin-top: 4px !important}
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
					  거래처정보등록신청서
					  (<xsl:choose>
						  <xsl:when test="$mode='new' or $mode='edit'">
							  <select id="__mainfield" name="CLIENT_TYPE" class="custom-select d-inline-block" onchange="_zw.formEx.change(this, 'CLIENT_TYPEDN');" style="width: 120px;font-size:14pt;font-weight:bold">
								  <xsl:choose>
									  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CLIENT_TYPE),'')">
										  <option value="" selected="selected">선택</option>
									  </xsl:when>
									  <xsl:otherwise>
										  <option value="">선택</option>
									  </xsl:otherwise>
								  </xsl:choose>
								  <xsl:choose>
									  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
										  <option value="CUST" selected="selected">고객</option>
									  </xsl:when>
									  <xsl:otherwise>
										  <option value="CUST">고객</option>
									  </xsl:otherwise>
								  </xsl:choose>
								  <xsl:choose>
									  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
										  <option value="PROD" selected="selected">공급자</option>
									  </xsl:when>
									  <xsl:otherwise>
										  <option value="PROD">공급자</option>
									  </xsl:otherwise>
								  </xsl:choose>
							  </select>
							  <input type="hidden" id="__mainfield" name="CLIENT_TYPEDN" value="{//forminfo/maintable/CLIENT_TYPEDN}" />
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CLIENT_TYPEDN))" />
							  <input type="hidden" id="__mainfield" name="CLIENT_TYPE" value="{//forminfo/maintable/CLIENT_TYPE}" />
							  <input type="hidden" id="__mainfield" name="CLIENT_TYPEDN" value="{//forminfo/maintable/CLIENT_TYPEDN}" />
						  </xsl:otherwise>
					  </xsl:choose>)
					  <br/>
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
                <td class="f-lbl" style="border-bottom:0;">등록법인<span class="f-lbl-en"> (COMPANY)</span>
              </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input style="width:100px" type="text" id="__mainfield" name="COMPANY" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/COMPANY}"/>
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
					<input type="hidden" id="__mainfield" name="COMPANYCODE" value="{//forminfo/maintable/COMPANYCODE}"/>
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
                <col style="width:85%" />
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0px" colspan="4">기초정보</td>
              </tr>
              <tr>
                <td class="f-lbl">국내외구분 <span class="f-lbl-en">(TYPE)</span></td>
                <td style="border-right:0;">
                  <span class="f-option1">
                    <input id="ckb3" name="ckbCOUNTRY_TYPE"  type="checkbox" value="LO">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOUNTRY_TYPE', this, 'COUNTRY_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COUNTRY_TYPE),'LO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COUNTRY_TYPE),'LO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb3">국내(Domestic)</label>
                  </span>
                  <span class="f-option1">
                    <input id="ckb4" name="ckbCOUNTRY_TYPE"  type="checkbox" value="DI">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOUNTRY_TYPE', this, 'COUNTRY_TYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COUNTRY_TYPE),'DI')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COUNTRY_TYPE),'DI')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb4">국외(Foreign)</label>
                  </span>
				<input type="hidden" id="__mainfield" name="COUNTRY_TYPE" value="{//forminfo/maintable/COUNTRY_TYPE}" />
                </td>
              </tr>
              <tr data-for="CUST">
				  <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
					  <xsl:attribute name="class">d-none</xsl:attribute>
				  </xsl:if>
                <td class="f-lbl" style="border-bottom:0;">고객구분<span class="f-lbl-en">(Class)</span>
              </td>
				  <td style="border-right:0;border-bottom:0;">
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
				<tr data-for="PROD">
					<xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
						<xsl:attribute name="class">d-none</xsl:attribute>
					</xsl:if>
              <td class="f-lbl" style="border-bottom:0;">공급자구분<span class="f-lbl-en">(Class)</span></td>
                <td style="border-right:0;border-bottom:0;">
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
                    <label for="ckb9">공급자(Supplier)</label>
                  </span>
                  <span class="f-option1" style="width: 40%">
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
                    <label for="ckb10">공급자_외주가공(Supplier_OSP)</label>
                  </span>
                  <!--<span class="f-option1">
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
                  </span>-->
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
                    <label for="ckb12">임직원(Employee)</label>
                  </span>
                  <!--<span class="f-option1">
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
                  </span>-->
					<input type="hidden" id="__mainfield" name="PRODUCER_TYPE" value="{//forminfo/maintable/PRODUCER_TYPE}" />
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
                  <td class="f-lbl" style="border-right:0px" colspan="4">업체정보</td>
                </tr>  
              <tr>
                <td class="f-lbl">거래처이름<span class="f-lbl-en">(Name)</span>
                </td>
                <td style="" >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="CLIENT_NAME" maxlength="100" value="{//forminfo/maintable/CLIENT_NAME}" />
						<button type="button" class="btn btn-outline-secondary btn-18 ml-1 d-none" data-toggle="tooltip" data-placement="bottom" title="임직원 선택" id="btnOrganChart" onclick="_zw.fn.org('user','n');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLIENT_NAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
				  <td class="f-lbl">국가<span class="f-lbl-en" >(Bill to country)</span></td>
				  <td style="border-right:0">
					  <xsl:choose>
						  <xsl:when test="$mode='new' or $mode='edit'">
							  <input class="txtText_u" style="width:92%" type="text" readonly="readonly"  id="__mainfield" name="COUNTRY" value="{//forminfo/maintable/COUNTRY}"/>
							  <button type="button" class="btn btn-outline-secondary btn-18" title="국가코드" onclick="_zw.formEx.externalWnd('report.ERP_COUNTRY2',240,40,126,70,'COUNTRY','COUNTRY','COUNTRYCODE');">
								  <i class="fas fa-angle-down"></i>
							  </button>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY))" />
						  </xsl:otherwise>
					  </xsl:choose>
					  <input type="hidden" id="__mainfield" name="COUNTRYCODE" value="{//forminfo/maintable/COUNTRYCODE}"/>
				  </td>
              </tr>
				  <tr data-for="EMPLOYEE">
					  <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PRODUCER_TYPE),'EMPLOYEE')">
						  <xsl:attribute name="class">d-none</xsl:attribute>
					  </xsl:if>
					  <td class="f-lbl">사번<span class="f-lbl-en">(Employee ID)</span></td>
					  <td>
						  <xsl:choose>
							  <xsl:when test="$mode='new' or $mode='edit'">
								  <input class="txtRead" type="text" id="__mainfield" name="EMPLOYEEID" readonly="readonly" value="{//forminfo/maintable/EMPLOYEEID}"/>
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EMPLOYEEID))" />
							  </xsl:otherwise>
						  </xsl:choose>
					  </td>
					  <td class="f-lbl">부서<span class="f-lbl-en">(Department)</span></td>
					  <td style="border-right:0;">
						  <xsl:choose>
							  <xsl:when test="$mode='new' or $mode='edit'">
								  <input type="text" id="__mainfield" name="SUPPLIERDEPT" style="width:92%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/SUPPLIERDEPT}" />
								  <button type="button" class="btn btn-outline-secondary btn-18" title="Supplier" onclick="_zw.formEx.externalWnd('report.ERP_DEPARTMENT',240,40,20,70,'','SUPPLIERDEPT','SUPPLIERDEPTCD');">
									  <i class="fas fa-angle-down"></i>
								  </button>
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUPPLIERDEPT))" />
							  </xsl:otherwise>
						  </xsl:choose>
						  <input type="hidden" id="__mainfield" name="SUPPLIERDEPTCD" value="{//forminfo/maintable/SUPPLIERDEPTCD}" />
					  </td>
				  </tr>
              <tr>
                <td class="f-lbl" >사업자등록번호<span class="f-lbl-en">(Tax ID)</span></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="CLIENT_NUMBER" maxlength="20" value="{//forminfo/maintable/CLIENT_NUMBER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLIENT_NUMBER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >주민등록번호<span style="font-size:0.525rem">(Social Security Number)</span>
              </td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="SOCIAL_NUMBER" maxlength="20" value="{//forminfo/maintable/SOCIAL_NUMBER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SOCIAL_NUMBER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
				  <tr>
					  <td class="f-lbl" >업태<span class="f-lbl-en" >(Industry Classification)</span></td>
					  <td>
						  <xsl:choose>
							  <xsl:when test="$mode='new' or $mode='edit'">
								  <input class="txtText" type="text" id="__mainfield" maxlength="100"  name="INDUSTRY_CLASS" value="{//forminfo/maintable/INDUSTRY_CLASS}"/>
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INDUSTRY_CLASS))" />
							  </xsl:otherwise>
						  </xsl:choose>
					  </td>
					  <td class="f-lbl" >업종<span style="font-size:0.5rem;text-align:center;" >(Industry Subclassification)</span></td>
					  <td style="border-right:0;" colspan="2">
						  <xsl:choose>
							  <xsl:when test="$mode='new' or $mode='edit'">
								  <input class="txtText" type="text" id="__mainfield" maxlength="100" name="INDUSTRY_SUBCLASS" value="{//forminfo/maintable/INDUSTRY_SUBCLASS}"/>
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INDUSTRY_SUBCLASS))" />
							  </xsl:otherwise>
						  </xsl:choose>
					  </td>
				  </tr>
				  <tr>
					  <td class="f-lbl">대표자<span class="f-lbl-en" >(Representative)</span></td >
					  <td>
						  <xsl:choose>
							  <xsl:when test="$mode='new' or $mode='edit'">
								  <input class="txtText" type="text" id="__mainfield" name="TAXBLE_PERSON" maxlength="100" value="{//forminfo/maintable/TAXBLE_PERSON}"/>
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXBLE_PERSON))" />
							  </xsl:otherwise>
						  </xsl:choose>
					  </td>
					  <td class="f-lbl">우편번호<span class="f-lbl-en" >(PostalCode)</span></td>
					  <td style="border-right:0">
						  <xsl:choose>
							  <xsl:when test="$mode='new' or $mode='edit'">
								  <input class="txtText" type="text" id="__mainfield" name="POST_CODE" value="{//forminfo/maintable/POST_CODE}"/>
							  </xsl:when>
							  <xsl:otherwise>
								  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/POST_CODE))" />
							  </xsl:otherwise>
						  </xsl:choose>
					  </td>					  
				  </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0px">
                  주소<span class="f-lbl-en" >(Bill to address)</span>
                </td>
                <td colspan="3" style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="ADDRES" maxlength="200" value="{//forminfo/maintable/ADDRES}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ADDRES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              
              </table>
          </div>

          <!--<div class="fm">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
                <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td style="font-size:12px;text-align:right">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <span class="d-flex align-items-center justify-content-end mt-1">
                            <input id="ckb73" name="ckbBILLTO"  type="checkbox" value="BILL">
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
                            <label for="ckb73" class="small ml-1">Bill to 정보와 Ship to 정보를 동일하게 합니다.</label>
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
          </div>-->
          
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
                <td class="f-lbl" style="border-right:0px" colspan="4">거래정보</td>
              </tr>
              <tr>
                <td class="f-lbl" >세금구분<span class="f-lbl-en" >(Tax Code)</span>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="TAXRATE" value="{//forminfo/maintable/TAXRATE}"/>
                      <button type="button" class="btn btn-outline-secondary btn-18" title="세금구분" onclick="_zw.formEx.optionWnd('report.ERP_TAXCODE',240,250,126,70,'','TAXRATE','TAXRATECODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXRATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
					<input  type="hidden" id="__mainfield" name="TAXRATECODE" value="{//forminfo/maintable/TAXRATECODE}"/>
                </td>
                <td class="f-lbl" >결제조건<span class="f-lbl-en" >(Payment Term)</span>
                </td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="CUST_PAYMENT" value="{//forminfo/maintable/CUST_PAYMENT}"/>
                      <button type="button" class="btn btn-outline-secondary btn-18" title="결제조건" onclick="_zw.formEx.optionWnd('report.ERP_PAYMENTCLT',240,250,150,70,'CUST_PAYMENT','CUST_PAYMENT','CUSTPAYMENTCODE');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUST_PAYMENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
					<input  type="hidden" id="__mainfield" name="CUSTPAYMENTCODE" value="{//forminfo/maintable/CUSTPAYMENTCODE}"/>
                </td>
              </tr>
              <tr>
				  <td class="f-lbl" >
					  세목<span class="f-lbl-en" >(Tax Explanation)</span>
				  </td>
				  <td>
					  <xsl:choose>
						  <xsl:when test="$mode='new' or $mode='edit'">
							  <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="TAXEXPL" value="{//forminfo/maintable/TAXEXPL}"/>
							  <button type="button" class="btn btn-outline-secondary btn-18" title="세목" onclick="_zw.formEx.optionWnd('report.ERP_TAXEXPL',240,250,126,70,'','TAXEXPL','TAXEXPLCODE');">
								  <i class="fas fa-angle-down"></i>
							  </button>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXEXPL))" />
						  </xsl:otherwise>
					  </xsl:choose>
					  <input  type="hidden" id="__mainfield" name="TAXEXPLCODE" value="{//forminfo/maintable/TAXEXPLCODE}"/>
				  </td>
				  <td class="f-lbl" >
					  지급수단<span class="f-lbl-en" >(Payment Instrument)</span>
				  </td>
				  <td style="border-right:0;">
					  <xsl:choose>
						  <xsl:when test="$mode='new' or $mode='edit'">
							  <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="PAYMENTMTD" value="{//forminfo/maintable/PAYMENTMTD}"/>
							  <button type="button" class="btn btn-outline-secondary btn-18" title="지급수단" onclick="_zw.formEx.optionWnd('report.ERP_PAYMENTMTD',160,140,10,115,'','PAYMENTMTD','PAYMENTMTDCODE');">
								  <i class="fas fa-angle-down"></i>
							  </button>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAYMENTMTD))" />
						  </xsl:otherwise>
					  </xsl:choose>
					  <input  type="hidden" id="__mainfield" name="PAYMENTMTDCODE" value="{//forminfo/maintable/PAYMENTMTDCODE}"/>
				  </td>
            </tr>
				<tr data-for="CUST">
					<xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
						<xsl:attribute name="class">d-none</xsl:attribute>
					</xsl:if>
              <td class="f-lbl">결제은행<span class="f-lbl-en" >(Customer Bank)</span></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="CUST_BANK" style="width:92%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CUST_BANK}" />                      
                      <button type="button" class="btn btn-outline-secondary btn-18" title="결제은행" onclick="_zw.formEx.optionWnd('report.ERP_BANKCODE',160,140,10,115,'etc','CUST_BANK');">
                        <i class="fas fa-angle-down"></i>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUST_BANK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" >결제계좌<span class="f-lbl-en" >(Customer Account)</span>
              </td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="CUST_BANKACCOUNT" maxlength="100" value="{//forminfo/maintable/CUST_BANKACCOUNT}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUST_BANKACCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" >담당영업사원<span class="f-lbl-en" >(Sales Person)</span>
              </td>
				  <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
						<input class="txtText" type="text" id="__mainfield" name="SALES_PERSON" maxlength="100" value="{//forminfo/maintable/SALES_PERSON}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SALES_PERSON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
				  <td class="f-lbl" >
					  선적조건<span class="f-lbl-en" >(terms of shipment)</span>
				  </td>
				  <td style="border-right:0;">
					  <xsl:choose>
						  <xsl:when test="$mode='new' or $mode='edit'">
							  <input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="SHIPMENT_TERM" value="{//forminfo/maintable/SHIPMENT_TERM}"/>
							  <input type="hidden" id="__mainfield" name="SHIPMENTTERMCODE" value="{//forminfo/maintable/SHIPMENT_TERMCODE}"/>
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
				<tr data-for="CUST">
					<xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
						<xsl:attribute name="class">d-none</xsl:attribute>
					</xsl:if>
					<td class="f-lbl">통화<span class="f-lbl-en" >(Currency Code)</span></td>
					<td>
						<xsl:choose>
							<xsl:when test="$mode='new' or $mode='edit'">
								<input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="CURRENCY" value="{//forminfo/maintable/CURRENCY}"/>
								<button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',240,250,126,70,'','CURRENCY');">
									<i class="fas fa-angle-down"></i>
								</button>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="f-lbl">채권계정<span class="f-lbl-en" >(G/L Offset)</span></td>
					<td style="border-right:0;">
						<xsl:choose>
							<xsl:when test="$mode='new' or $mode='edit'">
								<input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="ACCOUNTDN" value="{//forminfo/maintable/ACCOUNTDN}"/>
								<button type="button" class="btn btn-outline-secondary btn-18" title="채권계정과목" onclick="_zw.formEx.optionWnd('report.ERP_BONDACCOUNT',160,140,10,115,'','ACCOUNTDN','ACCOUNTCD');">
									<i class="fas fa-angle-down"></i>
								</button>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCOUNTDN))" />
							</xsl:otherwise>
						</xsl:choose>
						<input  type="hidden" id="__mainfield" name="ACCOUNTCD" value="{//forminfo/maintable/ACCOUNTCD}"/>
					</td>
				</tr>
				<tr data-for="PROD">
					<xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
						<xsl:attribute name="class">d-none</xsl:attribute>
					</xsl:if>
					<td class="f-lbl">통화<span class="f-lbl-en" >(Currency Code)</span></td>
					<td>
						<xsl:choose>
							<xsl:when test="$mode='new' or $mode='edit'">
								<input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="CURRENCY2" value="{//forminfo/maintable/CURRENCY2}"/>
								<button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',240,250,126,70,'','CURRENCY2');">
									<i class="fas fa-angle-down"></i>
								</button>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY2))" />
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="f-lbl">채무계정<span class="f-lbl-en" >(G/L Offset)</span></td>
					<td style="border-right:0;">
						<xsl:choose>
							<xsl:when test="$mode='new' or $mode='edit'">
								<input class="txtText_u" readonly="readonly" style="width:92%" type="text" id="__mainfield" name="ACCOUNTDN2" value="{//forminfo/maintable/ACCOUNTDN2}"/>
								<button type="button" class="btn btn-outline-secondary btn-18" title="채무계정과목" onclick="_zw.formEx.optionWnd('report.ERP_DEBTACCOUNT',160,140,10,115,'','ACCOUNTDN2','ACCOUNTCD2');">
									<i class="fas fa-angle-down"></i>
								</button>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCOUNTDN2))" />
							</xsl:otherwise>
						</xsl:choose>
						<input  type="hidden" id="__mainfield" name="ACCOUNTCD2" value="{//forminfo/maintable/ACCOUNTCD2}"/>
					</td>
				</tr>
              <tr data-for="PROD">
				  <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
					  <xsl:attribute name="class">d-none</xsl:attribute>
				  </xsl:if>
                <td class="f-lbl" >지급은행<span class="f-lbl-en" >(Supplier bank)</span></td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                                            
                      <input type="text" id="__mainfield" name="PAYMENT_BANK" style="width:92%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PAYMENT_BANK}" />                      
						<button type="button" class="btn btn-outline-secondary btn-18" title="지급은행" onclick="_zw.formEx.optionWnd('report.ERP_BANKCODE',160,140,10,115,'etc','PAYMENT_BANK','BANKCD');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAYMENT_BANK))" />
                    </xsl:otherwise>
                  </xsl:choose>
					<input  type="hidden" id="__mainfield" name="BANKCD" value="{//forminfo/maintable/BANKCD}"/>
                </td>
                <td class="f-lbl">계좌번호<span class="f-lbl-en">(Account no)</span></td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText"  type="text" id="__mainfield" name="ACCOUNT_DOMESTIC" maxlength="30" oninput="this.value = this.value.replace(/[^0-9-]/g, '');" placeholder="숫자-하이픈만 입력" value="{//forminfo/maintable/ACCOUNT_DOMESTIC}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCOUNT_DOMESTIC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
				<tr data-for="PROD">
					<xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'PROD')">
						<xsl:attribute name="class">d-none</xsl:attribute>
					</xsl:if>
				  <td class="f-lbl"  style="border-bottom:0;">수취인명<span style="font-size:0.5rem;">(Beneficiary Name of Bank)</span></td>
				  <td style="border-bottom:0">
					  <xsl:choose>
						  <xsl:when test="$mode='new' or $mode='edit'">
							  <input class="txtText"  type="text" id="__mainfield" name="BANK_CALLDATE" maxlength="100" value="{//forminfo/maintable/BANK_CALLDATE}"/>
						  </xsl:when>
						  <xsl:otherwise>
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BANK_CALLDATE))" />
						  </xsl:otherwise>
					  </xsl:choose>
				  </td>
                <td class="f-lbl" style="border-bottom:0">SWIFT CODE</td>
                <td style="border-bottom:0;border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="ACCOUNT_FOREIGN" maxlength="100" value="{//forminfo/maintable/ACCOUNT_FOREIGN}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCOUNT_FOREIGN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

			
			<div class="fm" data-for="CUST">
				<xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CLIENT_TYPE),'CUST')">
					<xsl:attribute name="class">d-none</xsl:attribute>
				</xsl:if>
			<div class="ff" />
			<div class="ff" />
			<div class="ff" />
			<div class="ff" />
				
				<table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:15%"/>
                <col style="width:18%"/>
                <col style="width:15%"/>
                <col style="width:19%"/>
                <col style="width:15%"/>
                <col style="width:18%"/>
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0px" colspan="6">세금계산서 정보</td>
              </tr>
              <tr>
                <td class="f-lbl">청구/영수</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" id="__mainfield" name="TAXINVR" style="width:85%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/TAXINVR}" />
						<button type="button" class="btn btn-outline-secondary btn-18" title="청구/영수" onclick="_zw.formEx.optionWnd('report.ERP_TAXINVRR',160,140,10,115,'','TAXINVR','TAXINVRCD');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXINVR))" />
                    </xsl:otherwise>
                  </xsl:choose>
					<input  type="hidden" id="__mainfield" name="TAXINVRCD" value="{//forminfo/maintable/TAXINVRCD}"/>
                </td>
                <td class="f-lbl2">정/역발행</td>
                <td>
					<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" id="__mainfield" name="TAXINVD" style="width:85%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/TAXINVD}" />
						<button type="button" class="btn btn-outline-secondary btn-18" title="정/역발행" onclick="_zw.formEx.optionWnd('report.ERP_TAXINVIS',160,140,10,115,'','TAXINVD','TAXINVDCD');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXINVD))" />
					</xsl:otherwise>
					</xsl:choose>
					<input  type="hidden" id="__mainfield" name="TAXINVDCD" value="{//forminfo/maintable/TAXINVDCD}"/>
                </td>
                <td class="f-lbl2" >월합여부</td>
                <td style="border-right:0;">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<input type="text" id="__mainfield" name="TAXINVYN" style="width:85%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/TAXINVYN}" />
							<button type="button" class="btn btn-outline-secondary btn-18" title="월합여부" onclick="_zw.formEx.optionWnd('report.ERP_TAXINVMM',160,140,10,115,'','TAXINVYN','TAXINVYNCD');">
								<i class="fas fa-angle-down"></i>
							</button>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXINVYN))" />
						</xsl:otherwise>
					</xsl:choose>
					<input  type="hidden" id="__mainfield" name="TAXINVYNCD" value="{//forminfo/maintable/TAXINVYNCD}"/>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;">담당자<span class="f-lbl-en" >(Name)</span></td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="TAXMANAGER" maxlength="100" value="{//forminfo/maintable/TAXMANAGER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXMANAGER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2"  style="border-bottom:0;">메일<span class="f-lbl-en" >(E-Mail)</span>
              </td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="TAXEMAIL" maxlength="50" value="{//forminfo/maintable/TAXEMAIL}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXEMAIL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom:0;" >연락처<span class="f-lbl-en" >(Tel.)</span>
              </td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="TAXTEL" maxlength="50" value="{//forminfo/maintable/TAXTEL}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAXTEL))" />
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
				  <col style="width:15%"/>
				  <col style="width:18%"/>
				  <col style="width:15%"/>
				  <col style="width:19%"/>
				  <col style="width:15%"/>
				  <col style="width:18%"/>
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0px" colspan="6">거래처담당자 정보</td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">성명<span class="f-lbl-en">(Name)</span>
              </td>
				  <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="MANAGER" maxlength="100" value="{//forminfo/maintable/MANAGER}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MANAGER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom:0">메일<span class="f-lbl-en" >(E-Mail)</span>
              </td>
				  <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="EMAIL" maxlength="50" value="{//forminfo/maintable/EMAIL}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EMAIL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom:0">연락처<span class="f-lbl-en" >(Tel.)</span></td>
                <td style="border-bottom:0;border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input class="txtText" type="text" id="__mainfield" name="TEL" maxlength="50" value="{//forminfo/maintable/TEL}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TEL))" />
                    </xsl:otherwise>
                  </xsl:choose>
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
