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
					.m {width:1400px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
					.fh h1 {font-size:20.0pt;letter-spacing:1pt}

					/* 결재칸 넓이 */
					.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

					/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
					.m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
					.m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
					.m .ft-sub .f-option {width:49%}

					.m .ft-sub-sub .f-lbl-sub, .m .ft-sub-sub .subsub_table_row td {border-style: dotted; border-color: windowtext; border-left: 0; border-top: 0}

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
								<td style="width:320px">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '신청부서')"/>
								</td>
								<td style="font-size:1px">&nbsp;</td>
								<td style="width:320px">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '수신부서')"/>
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
						<span>&nbsp;1. 기초정보</span>
					</div>

					<div class="ff" />

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0" style="width: 75%">
							<colgroup>
								<col style="width:10.67%"></col>
								<col style="width:22.7%"></col>
								<col style="width:10.67%"></col>
								<col style="width:22.7%"></col>
								<col style="width:10.67%"></col>
								<col style="width:"></col>
							</colgroup>
							<tr>
								<td class="f-lbl2" style="border-bottom:0;">
									Supplier
									<xsl:if test="$mode='new' or $mode='edit'">
										<button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="Contacts" onclick="_zw.fn.org('user','n');">
											<i class="fas fa-angle-down"></i>
										</button>
									</xsl:if>
								</td>
								<td style="border-bottom: 0">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" id="__mainfield" name="SUPPLIER" class="txtText" readonly="readonly" value="" />
										</xsl:when>
										<xsl:when test="$mode='edit'">
											<input type="text" id="__mainfield" name="SUPPLIER" class="txtText" readonly="readonly" value="{//forminfo/maintable/SUPPLIER}" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUPPLIER))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl2" style="border-bottom:0;">Supplier 부서</td>
								<td style="border-bottom: 0">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" id="__mainfield" name="SUPPLIERDEPT" class="txtText" readonly="readonly" value="" />
										</xsl:when>
										<xsl:when test="$mode='edit'">
											<input type="text" id="__mainfield" name="SUPPLIERDEPT" class="txtText" readonly="readonly" value="{//forminfo/maintable/SUPPLIERDEPT}" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUPPLIERDEPT))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl2" style="border-bottom:0;">AP 일자</td>
								<td style="border-bottom: 0;border-right: 0">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" id="__mainfield" name="APDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{phxsl:convertDate(string(//docinfo/createdate), '')}" />
										</xsl:when>
										<xsl:when test="$mode='edit'">
											<input type="text" id="__mainfield" name="APDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/APDATE}" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/APDATE))" />
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
											<span style="margin-right: 1rem">&nbsp;2. 지출내역</span>
											<a onclick="_zw.formEx.popupWnd('report.CC_CARDACK', '50rem');" style="text-decoration:none;font-weight:bold" href="javascript:"><i class="fas fa-credit-card"></i> 카드사용현황 (개인법인카드 경우 해당)</a>
										</td>
										<td class="fm-button">
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
											<span>&nbsp;2. 지출내역</span>
										</td>
										<td class="fm-button">
											
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
									<table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$mode='new' or $mode='edit'">
											<xsl:attribute name="style">table-layout:fixed</xsl:attribute>
										</xsl:if>
										<tr>
											<td class="f-lbl-sub" style="width: 2.5%; border-top:0; border-right:1px dotted windowtext">NO</td>
											<td style="border:0; padding: 0">
												<table class="ft-sub-sub" border="0" cellspacing="0" cellpadding="0">
													<colgroup>
														<col style="width:10%"></col>
														<col style="width:10%"></col>
														<col style="width:10%"></col>
														<col style="width:6%"></col>
														<col style="width:11%"></col>
														<col style="width:6%"></col>
														<col style="width:18%"></col>
														<col style="width:7%"></col>
														<col style="width:5.5%"></col>
														<col style="width:5.5%"></col>
														<col style="width:5.5%"></col>
														<col style="width:5.5%"></col>
													</colgroup>
													<tr style="height:40px">
														<td class="f-lbl-sub">구분</td>
														<td class="f-lbl-sub">계정</td>
														<td class="f-lbl-sub">Supplier<br />(카드사)</td>
														<td class="f-lbl-sub">사용일자</td>
														<td class="f-lbl-sub">카드번호</td>
														<td class="f-lbl-sub">승인번호</td>														
														<td class="f-lbl-sub">가맹점명</td>
														<td class="f-lbl-sub">사업자<br />등록번호</td>
														<td class="f-lbl-sub">승인금액<br />(원화)</td>
														<td class="f-lbl-sub">공급가액<br />(원화)</td>
														<td class="f-lbl-sub">부가세<br />(원화)</td>
														<td class="f-lbl-sub" style="border-right: 0">인정금액<br />(원화)</td>
													</tr>
													<tr>
														<td class="f-lbl-sub" style="border-bottom: 0">과세구분</td>
														<td class="f-lbl-sub" style="border-bottom: 0">세금구분</td>
														<td class="f-lbl-sub" style="border-bottom: 0">세목</td>
														<td class="f-lbl-sub" style="border-bottom: 0" colspan="3">불공제사유</td>														
														<td class="f-lbl-sub" style="border-bottom: 0" colspan="5">적요</td>
														<td class="f-lbl-sub" style="border-bottom: 0; border-right: 0">세부정보</td>
													</tr>
												</table> 
											</td>
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

				<!-- HIdden Field -->
				<xsl:choose>
					<xsl:when test="$mode='new'">
						<input type="hidden" id="__mainfield" name="APPLICANT" value="{//creatorinfo/name}" />
						<input type="hidden" id="__mainfield" name="APPLICANTID" value="{//creatorinfo/@uid}" />
						<input type="hidden" id="__mainfield" name="APPLICANTEMPNO" value="{//creatorinfo/empno}" />
						<input type="hidden" id="__mainfield" name="APPLICANTGRADE" value="{//creatorinfo/grade}" />
						<input type="hidden" id="__mainfield" name="APPLICANTDEPT" value="{//creatorinfo/department}" />
						<input type="hidden" id="__mainfield" name="APPLICANTDEPTID" value="{//creatorinfo/@deptid}" />
						<input type="hidden" id="__mainfield" name="APPLICANTORG" value="{//creatorinfo/belong}" />
					</xsl:when>
					<xsl:otherwise>
						<input type="hidden" id="__mainfield" name="APPLICANT" value="{//forminfo/maintable/APPLICANT}" />
						<input type="hidden" id="__mainfield" name="APPLICANTID" value="{//forminfo/maintable/APPLICANTID}" />
						<input type="hidden" id="__mainfield" name="APPLICANTEMPNO" value="{//forminfo/maintable/APPLICANTEMPNO}" />
						<input type="hidden" id="__mainfield" name="APPLICANTGRADE" value="{//forminfo/maintable/APPLICANTGRADE}" />
						<input type="hidden" id="__mainfield" name="APPLICANTDEPT" value="{//forminfo/maintable/APPLICANTDEPT}" />
						<input type="hidden" id="__mainfield" name="APPLICANTDEPTID" value="{//forminfo/maintable/APPLICANTDEPTID}" />
						<input type="hidden" id="__mainfield" name="APPLICANTORG" value="{//forminfo/maintable/APPLICANTORG}" />
					</xsl:otherwise>
				</xsl:choose>
				
				<input type="hidden" id="__mainfield" name="SUPPLIERID" value="{//forminfo/maintable/SUPPLIERID}" />
				<input type="hidden" id="__mainfield" name="SUPPLIEREMPNO" value="{//forminfo/maintable/SUPPLIEREMPNO}" />
				<input type="hidden" id="__mainfield" name="SUPPLIERDEPTCD" value="{//forminfo/maintable/SUPPLIERDEPTCD}" />
				<input type="hidden" id="__mainfield" name="SUPPLIERGLC" value="{//forminfo/maintable/SUPPLIERGLC}" />

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
			<td class="tdRead_Center" style="border:0;border-top:1px solid windowtext;border-right:1px dotted windowtext">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td style="border:0;border-top:1px solid windowtext;padding:0">
				<table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
					<colgroup>
						<col style="width:10%"></col>
						<col style="width:10%"></col>
						<col style="width:10%"></col>
						<col style="width:6%"></col>
						<col style="width:11%"></col>
						<col style="width:6%"></col>
						<col style="width:18%"></col>
						<col style="width:7%"></col>
						<col style="width:5.5%"></col>
						<col style="width:5.5%"></col>
						<col style="width:5.5%"></col>
						<col style="width:5.5%"></col>
					</colgroup>
					<tr class="subsub_table_row">
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='expensetype'], 'EXPENSETYPECODE', string(EXPENSETYPECODE), 'EXPENSETYPE', string(EXPENSETYPE))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSETYPE))" />
									<input type="hidden" name="EXPENSETYPECODE" value="{EXPENSETYPECODE}" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="ACNTNM" style="width:84%" class="txtText_u" readonly="readonly" value="{ACNTNM}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="계정과목" onclick="_zw.formEx.externalWnd('report.ERP_ACCOUNTCLS',240,40,20,70,'','ACNTNM','ACNTDPCD','ACNTMAIN','ACNTSUB','ACNTID','ACNTCLS','ACNTCLSNM');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACNTNM))" />
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="ACNTDPCD" value="{ACNTDPCD}" />
							<input type="hidden" name="ACNTMAIN" value="{ACNTMAIN}" />
							<input type="hidden" name="ACNTSUB" value="{ACNTSUB}" />
							<input type="hidden" name="ACNTID" value="{ACNTID}" />
							<input type="hidden" name="ACNTCLS" value="{ACNTCLS}" />
							<input type="hidden" name="ACNTCLSNM" value="{ACNTCLSNM}" />
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="SUPPLIERDEPT" style="width:84%" class="txtText_u" readonly="readonly" value="{SUPPLIERDEPT}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="Supplier" onclick="_zw.formEx.externalWnd('report.ERP_DEPARTMENT',240,40,20,70,'','SUPPLIERDEPT','SUPPLIERDEPTCD');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUPPLIERDEPT))" />
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="SUPPLIERDEPTCD" value="{SUPPLIERDEPTCD}" />
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="AQUIDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{AQUIDATE}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(AQUIDATE))" />
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="ACKID" value="{ACKID}" />
							<input type="hidden" name="PURCHASEFLAG" value="{PURCHASEFLAG}" />
							<input type="hidden" name="CURRENCY" value="{CURRENCY}" />
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="CARDNUM" class="txtText" maxlength="20" data-inputmask="card;number" autocomplete="off" value="{CARDNUM}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CARDNUM))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="ACKNO" class="txtText" maxlength="10" data-inputmask="number-n" autocomplete="off" value="{ACKNO}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACKNO))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>						
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="MERCNAME" class="txtText" maxlength="100" value="{MERCNAME}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MERCNAME))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="MERCSOCNO" class="txtText" maxlength="20" data-inputmask="number-n" autocomplete="off" value="{MERCSOCNO}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MERCSOCNO))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="ACKAMT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" autocomplete="off" value="{ACKAMT}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACKAMT))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="VALSUPPLY" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" autocomplete="off" value="{VALSUPPLY}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(VALSUPPLY))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="VAT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" autocomplete="off" value="{VAT}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(VAT))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center" style="border-right:0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="REQAMT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" autocomplete="off" value="{REQAMT}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REQAMT))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>						
					</tr>
					<tr class="subsub_table_row">
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='ERP_TAXKIND'], 'MERCTAXKINDCODE', string(MERCTAXKINDCODE), 'MERCTAXKIND', string(MERCTAXKIND))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MERCTAXKIND))" />
									<input type="hidden" name="EXPENSETYPECODE" value="{MERCTAXKINDCODE}" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="TAXRATE" style="width:84%" class="txtText_u" readonly="readonly" value="{TAXRATE}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="세금구분" onclick="_zw.formEx.optionWnd('report.ERP_TAXCODE',240,40,20,70,'','TAXRATE','TAXRATECODE');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TAXRATE))" />
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="TAXRATECODE" value="{TAXRATECODE}" />
						</td>
						<td class="tdRead_Center">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="TAXEXPL" style="width:84%" class="txtText_u" readonly="readonly" value="{TAXEXPL}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="세목" onclick="_zw.formEx.optionWnd('report.ERP_TAXEXPL',240,40,20,70,'','TAXEXPL','TAXEXPLCODE');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TAXEXPL))" />
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="TAXEXPLCODE" value="{TAXEXPLCODE}" />
						</td>
						<td class="tdRead_Center" colspan="3">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="TAXNONDEDU" style="width:93%" class="txtText_u" readonly="readonly" value="{TAXNONDEDU}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="불공제사유" onclick="_zw.formEx.optionWnd('report.ERP_TAXNONDEDU',240,40,20,70,'','TAXNONDEDU','TAXNONDEDUCODE');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TAXNONDEDU))" />
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="TAXNONDEDUCODE" value="{TAXNONDEDUCODE}" />
						</td>
						
						<td colspan="5">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" name="ETC" class="txtText" maxlength="50" value="{ETC}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="tdRead_Center" style="border-right:0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" title="계정과목 세부정보" onclick="_zw.formEx.popupWnd('report.CC_ACCOUNTDETAILWND', '40rem');">
										<i class="far fa-comment-dots"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:if test="phxsl:isDiff(string(ACNTCLS),'')">
										<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" title="계정과목 세부정보" onclick="_zw.formEx.popupWnd('report.CC_ACCOUNTDETAILWND', '40rem');">
											<i class="far fa-comment-dots"></i>
										</button>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<input type="hidden" name="DETAILINFO1" value="{DETAILINFO1}" />
							<input type="hidden" name="DETAILINFO2" value="{DETAILINFO2}" />
							<input type="hidden" name="DETAILINFO3" value="{DETAILINFO3}" />
							<input type="hidden" name="DETAILINFO4" value="{DETAILINFO4}" />
							<input type="hidden" name="DETAILINFO5" value="{DETAILINFO5}" />
							<input type="hidden" name="DETAILINFO6" value="{DETAILINFO6}" />
							<input type="hidden" name="DETAILINFO7" value="{DETAILINFO7}" />
							<input type="hidden" name="DETAILINFO8" value="{DETAILINFO8}" />
							<input type="hidden" name="DETAILINFO9" value="{DETAILINFO9}" />
							<input type="hidden" name="DETAILINFO10" value="{DETAILINFO10}" />
							<input type="hidden" name="DETAILINFO11" value="{DETAILINFO11}" />
							<input type="hidden" name="DETAILINFO12" value="{DETAILINFO12}" />
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
