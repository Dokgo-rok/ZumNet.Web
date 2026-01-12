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
          .m {width:1200px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}

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
                <td style="width:470px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '6', '작성부서')"/>
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="width:17%;border-bottom:0;border-right:0">
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit' ">
                  <tr>
                    <td>
                      <span>&nbsp;</span>
                    </td>
                    <td class="fm-button">
                        생산지 :
                        <input type="text" id="__mainfield" name="PRODUCTCENTER" style="width:60px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PRODUCTCENTER}" />
                        <button type="button" class="btn btn-outline-secondary btn-18" title="생산지" onclick="_zw.formEx.optionWnd('report.ERP_PRODCENTER',120,124,-80,0,'','PRODUCTCENTER');">
                            <i class="fas fa-angle-down"></i>
                        </button>
					    생산지판매처 :
					    <input type="text" id="__mainfield" name="PRODCUSTOMER" style="width:180px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PRODCUSTOMER}" />
					    <button type="button" class="btn btn-outline-secondary btn-18" title="생산지판매처" onclick="_zw.formEx.optionWnd('report.ERP_PRODCUST',420,164,-260,0,'','PRODCUSTOMER','PRODCUSTOMER_CODE');">
						    <i class="fas fa-angle-down"></i>
					    </button>
						판매지 :
						<input type="text" id="__mainfield" name="SALECENTER" style="width:60px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/SALECENTER}" />                      
                        <button type="button" class="btn btn-outline-secondary btn-18" title="판매지" onclick="_zw.formEx.optionWnd('report.ERP_SALECENTER',120,124,-80,0,'','SALECENTER');">
                            <i class="fas fa-angle-down"></i>
                        </button>
						판매지공급처 :
						<input type="text" id="__mainfield" name="SALESUPPLIER" style="width:180px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/SALESUPPLIER}" />
						<button type="button" class="btn btn-outline-secondary btn-18" title="판매지공급처" onclick="_zw.formEx.optionWnd('report.ERP_SALESUPPL',420,164,-260,0,'','SALESUPPLIER','SALESUPPLIER_CODE');">
							<i class="fas fa-angle-down"></i>
						</button>
                        &nbsp;&nbsp;통화 :
                        <input type="text" id="__mainfield" name="CURRENCY" style="width:60px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CURRENCY}" />
                        <button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
                            <i class="fas fa-angle-down"></i>
                        </button>
                        &nbsp;&nbsp;
                        <!--<button class="btn btn-default btn-sm" data-toggle="tooltip" data-placement="bottom" title="가져오기" onclick="_zw.fn.importFile();">
                        <i class="fe-upload text-success"></i>
                            <span class="ml-1">가져오기</span>
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
                      <span>&nbsp;</span>
                    </td>
                    <td class="fm-button">
                        생산지 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODUCTCENTER))" />&nbsp;&nbsp;&nbsp;
						생산지판매처 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODCUSTOMER))" />&nbsp;&nbsp;&nbsp;
                        판매지 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALECENTER))" />&nbsp;&nbsp;&nbsp;
						판매지공급처 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALESUPPLIER))" />&nbsp;&nbsp;&nbsp;
                        통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;&nbsp;&nbsp;                      
                    </td>
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
                  <table id="__subtable1" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
					  <colgroup>
						  <col style="width:3%"></col>
						  <col style="width:10%"></col>
						  <col style="width:15%"></col>
						  <col style="width:6%"></col>
						  <col style="width:5%"></col>
						  <col style="width:6%"></col>
						  <col style="width:6%"></col>
						  <col style="width:8%"></col>
						  <col style="width:5%"></col>
						  <col style="width:15%"></col>
						  <col style="width:6%"></col>
						  <col style="width:6%"></col>
						  <col style="width:9%"></col>
					  </colgroup>
					  <tr style="height:40px">
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">고객구분</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">품번</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">변동요인</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">UOM</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">출하단가</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">선적조건</td>
						  <td class="f-lbl-sub" style="border-top:0" rowspan="2">적용시점</td>
						  <td class="f-lbl-sub" style="border-top:0" colspan="4">중개 거래시 등록</td>
						  <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
					  </tr>
					  <tr style="height:20px">
						  <td class="f-lbl-sub" style="">중개거래</td>
						  <td class="f-lbl-sub" style="" >고객</td>
						  <td class="f-lbl-sub" style="" >고객판매가</td>
						  <td class="f-lbl-sub" style="">이익율</td>
					  </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>              
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
        <input type="hidden" id="__mainfield" name="PRODCUSTOMER_CODE" value="{//forminfo/maintable/PRODCUSTOMER_CODE}" />
        <input type="hidden" id="__mainfield" name="SALESUPPLIER_CODE" value="{//forminfo/maintable/SALESUPPLIER_CODE}" />
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
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
		<td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="CUSTOMER" style="">
              <xsl:attribute name="class">txtText</xsl:attribute>              
              <xsl:attribute name="value">
                <xsl:value-of select="CUSTOMER" />
              </xsl:attribute>
            </input>            
          </xsl:when>
          <xsl:otherwise>
			  <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CUSTOMER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td> 
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="ITEMNO" style="width:88%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNO" />
              </xsl:attribute>
            </input>
			  <button type="button" class="btn btn-outline-secondary btn-18" title="품번" onclick="_zw.formEx.externalWnd('erp.saleitems',240,40,20,70,'','ITEMNO');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
	<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CHECKREASON" style="width:70%" class="txtText_u" readonly="readonly" value="{CHECKREASON}" />
			  <button type="button" class="btn btn-outline-secondary btn-18" title="변동요인" onclick="_zw.formEx.optionWnd('external.shipmentcod1',140,124,-100,0,'etc','CHECKREASON');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CHECKREASON))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
		<td>
			<xsl:choose>
				<xsl:when test="$mode='new' or $mode='edit'">
					<input type="text" name="UOM" style="width:63%" class="txtText_u" readonly="readonly" value="{UOM}" />
					<button type="button" class="btn btn-outline-secondary btn-18" title="UOM" onclick="_zw.formEx.optionWnd('report.ERP_UOM',90,124,-50,0,'','UOM');">
						<i class="fas fa-angle-down"></i>
					</button>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">tdRead_Center</xsl:attribute>
					<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(UOM))" />
				</xsl:otherwise>
			</xsl:choose>
		</td>
	<td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
			  <input type="text" name="ORGPRICE" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{ORGPRICE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ORGPRICE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
	<td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="SHIPCONDITION">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SHIPCONDITION" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SHIPCONDITION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
	<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="LEAVEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{LEAVEDATE}" />
          </xsl:when>
          <xsl:otherwise>
			  <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(LEAVEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
	<td class="tdRead_Center">      
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="YESNO" style="width:65%" class="txtText_u" readonly="readonly" value="{YESNO}" />
            <!--<button onclick="parent.fnOption('external.shipmentcod2',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="중개거래" onclick="_zw.formEx.optionWnd('external.shipmentcod2',140,64,-100,0,'','YESNO');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
			  <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(YESNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="MIDCUSTOMER" style="width:88%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MIDCUSTOMER" />
              </xsl:attribute>
            </input>
            <!--<button onclick="parent.fnExternal('erp.vendors2',240,40,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="판매지 판매처" onclick="_zw.formEx.externalWnd('erp.vendors2',240,40,100,70,'','MIDCUSTOMER','MIDCUSTOMER_CODE');">
				  <i class="fas fa-angle-down"></i>
			  </button>
            <input type="hidden" name="MIDCUSTOMER_CODE" >
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MIDCUSTOMER_CODE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MIDCUSTOMER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="SALEPRICE" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{SALEPRICE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALEPRICE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="SALEPER" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{SALEPER}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALEPER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
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
</xsl:stylesheet>
