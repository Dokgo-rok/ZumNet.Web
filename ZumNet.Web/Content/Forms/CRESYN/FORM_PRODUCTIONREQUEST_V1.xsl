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
					.m {width:1400px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
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
										<!--<xsl:value-of select="//docinfo/docname" />-->
										생산요청서(
										<xsl:choose>
											<xsl:when test="$mode='new' or $mode='edit'">
												<select id="__mainfield" name="DOCCLASS" class="custom-select d-inline-block" style="width: 100px;font-size:16pt;font-weight:bold">
													<xsl:choose>
														<xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'')">
															<option value="" selected="selected">선택</option>
														</xsl:when>
														<xsl:otherwise>
															<option value="">선택</option>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'중개')">
															<option value="중개" selected="selected">중개</option>
														</xsl:when>
														<xsl:otherwise>
															<option value="중개">중개</option>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:choose>
														<xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'직거래')">
															<option value="직거래" selected="selected">직거래</option>
														</xsl:when>
														<xsl:otherwise>
															<option value="직거래">직거래</option>
														</xsl:otherwise>
													</xsl:choose>
												</select>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCCLASS))" />
											</xsl:otherwise>
										</xsl:choose>
										)
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
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '6', '의뢰부서')"/>
								</td>
								<td style="font-size:1px">&nbsp;</td>
								<td style="width:470px">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '6', '검토부서')"/>
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
						<table border="0" cellspacing="0" cellpadding="0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit' ">
									<tr>
										<td>
											<span>&nbsp;</span>
										</td>
										<td class="fm-button">
											<!--<button onclick="parent.importFile();" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_42.gif" />가져오기
                      </button>-->
											<!--<button class="btn btn-default btn-sm" data-toggle="tooltip" data-placement="bottom" title="가져오기" onclick="_zw.fn.importFile();">
												<i class="fe-upload text-success"></i>
												<span class="ml-1">가져오기</span>
											</button>-->
											<!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnCopyChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />복사
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
											<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable1');">
												<i class="fas fa-plus"></i>
											</button>
											<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="복사" onclick="_zw.form.copyRow('__subtable1');">
												<i class="fas fa-copy"></i>
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
									<table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$mode='new' or $mode='edit'">
											<xsl:attribute name="style">table-layout:fixed</xsl:attribute>
										</xsl:if>
										<colgroup>
											<col style="width:2%"></col> 
											<col style="width:4%"></col>
											<col style="width:9%"></col>
											<col style="width:7%"></col> <!--4 고객번호-->
											<col style="width:7%"></col>
											<col style="width:6%"></col>
											<col style="width:5%"></col> <!--7 통화-->
											<col style="width:8%"></col>
											<col style="width:6%"></col>
											<col style="width:5%"></col> <!--10 청구인-->
											<col style="width:8%"></col>
											<col style="width:5%"></col>
											<col style="width:6%"></col>
											<col style="width:6%"></col> 
											<col style="width:6%"></col> <!-- OrderState-->
											<col style="width:6%"></col>
											<col style="width:4%"></col>
										</colgroup>
										<tr style="height:40px">
											<td class="f-lbl-sub" style="border-top:0">NO</td>
											<td class="f-lbl-sub" style="border-top:0">ORG</td>
											<td class="f-lbl-sub" style="border-top:0">고객명</td>
											<td class="f-lbl-sub" style="border-top:0">고객번호</td>
											<td class="f-lbl-sub" style="border-top:0">OrderType</td>
											<td class="f-lbl-sub" style="border-top:0">PriceList</td>
											<td class="f-lbl-sub" style="border-top:0">통화</td>
											<td class="f-lbl-sub" style="border-top:0">PaymentTerm</td>
											<td class="f-lbl-sub" style="border-top:0">PO</td>
											<td class="f-lbl-sub" style="border-top:0">Charger</td>
											<td class="f-lbl-sub" style="border-top:0">OrderedItem</td>
											<td class="f-lbl-sub" style="border-top:0">수량</td>
											<td class="f-lbl-sub" style="border-top:0">RQ/D</td>
											<td class="f-lbl-sub" style="border-top:0">S/S/D</td>
											<td class="f-lbl-sub" style="border-top:0">OrderStatus</td>
											<td class="f-lbl-sub" style="border-top:0">내부PO</td>
											<td class="f-lbl-sub" style="border-top:0;border-right:0">Factory</td>
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
						<input type="checkbox" name="ROWSEQ">
							<xsl:attribute name="value">
								<xsl:value-of select="ROWSEQ" />
							</xsl:attribute>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" class="txtText_u" name="ORDERCENTER" style="width:50%" value="{ORGCENTER}"/>
						<button type="button" class="btn btn-outline-secondary btn-18" title="ORG" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-50,0,'orgcode','ORDERCENTER','ORGID');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
				</xsl:choose>
				<input type="hidden" name="ORGID" value="{ORGID}"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" class="txtText_u" name="CUSTOMERNAME" style="width:80%" value="{CUSTOMERNAME}"/>
						<button type="button" class="btn btn-outline-secondary btn-18" title="고객명" onclick="_zw.formEx.externalWnd('report.ERP_CUSTOMERNUMBER',240,40,100,70,'','CUSTOMERNAME','CUSTOMERNUM');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CUSTOMERNAME))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" class="txtText_u" name="CUSTOMERNUM" value="{CUSTOMERNUM}"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CUSTOMERNUM))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" class="txtText_u" name="ORDERTYPE" style="width:80%" value="{ORDERTYPE}"/>
						<button type="button" class="btn btn-outline-secondary btn-18" title="OrderType" onclick="_zw.formEx.optionWnd('report.ERP_ORDERTYPE',400,400,-100,70,'','ORDERTYPE');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ORDERTYPE))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit' ">
						<input type="text" class="txtText" name="PRICELIST" value="{PRICELIST}"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRICELIST))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" class="txtText_u" name="CURRENCY" style="width:60%" value="{CURRENCY}"/>
						<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<!--<xsl:attribute name="class">tdRead_Center</xsl:attribute>-->
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CURRENCY))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" class="txtText_u" name="PAYMENTTERM" style="width:80%" value="{PAYMENTTERM}"/>
						<button type="button" class="btn btn-outline-secondary btn-18" title="PaymentTerm" onclick="_zw.formEx.optionWnd('report.ERP_PAYMENTTYPE',400,400,-100,70,'','PAYMENTTERM');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PAYMENTTERM))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit' ">
						<input type="text" class="txtText" name="PURCHASEORDERNUM" value="{PURCHASEORDERNUM}"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PURCHASEORDERNUM))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit' ">
						<input type="text" class="txtText" name="CHARGER" value="{CHARGER}"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CHARGER))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit' ">
						<input type="text" name="ORDERITEM">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="ORDERITEM" />
							</xsl:attribute>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ORDERITEM))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit' ">
						<input type="text" id="__mainfield" name="REVCNT"  class="txtDollar" maxlength="10" data-inputmask="number;10;0" value="{REVCNT}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REVCNT))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="tdRead_Center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="REQUESTDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{REQUESTDATE}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REQUESTDATE))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="tdRead_Center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="SHIPDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{SHIPDATE}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SHIPDATE))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td style="text-align:center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<select name="ORDERSTATUS" class="form-control">
							<xsl:choose>
								<xsl:when test="phxsl:isEqual(string(ORDERSTATUS),'')">
									<option value="" selected="selected">선택</option>
								</xsl:when>
								<xsl:otherwise>
									<option value="">선택</option>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="phxsl:isEqual(string(ORDERSTATUS),'Confirmed')">
									<option value="Confirmed" selected="selected">Confirmed</option>
								</xsl:when>
								<xsl:otherwise>
									<option value="Confirmed">Confirmed</option>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:choose>
								<xsl:when test="phxsl:isEqual(string(ORDERSTATUS),'Reserve')">
									<option value="Reserve" selected="selected">Reserve</option>
								</xsl:when>
								<xsl:otherwise>
									<option value="Reserve">Reserve</option>
								</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="class">tdRead_Center</xsl:attribute>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ORDERSTATUS))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='edit' ">
						<input type="text" name="INNERPONUM">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="INNERPONUM" />
							</xsl:attribute>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(INNERPONUM))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="PRODUCTCENTER" style="width:50%">
							<xsl:attribute name="class">txtText_u</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="PRODUCTCENTER" />
							</xsl:attribute>
						</input>
						<button type="button" class="btn btn-outline-secondary btn-18" title="Factory" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-130,0,'','PRODUCTCENTER');">
							<i class="fas fa-angle-down"></i>
						</button>
					</xsl:when>
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
