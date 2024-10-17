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
					.m {width:700px} .m .fm-editor {height:400px;min-height:400px;border:windowtext 1pt solid}
					.fh h1 {font-size:20.0pt;letter-spacing:2pt}

					/* 결재칸 넓이 */
					.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

					/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
					.m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
					.m .ft .f-option {width:;margin-right: 5px} .m .ft .f-option1 {width:20%} .m .ft .f-option2 {width:70px}
					.m .ft-sub .f-option {width:49%}

					/* 인쇄 설정 : 맨하단으로 */
					@media print {.m .fm-editor {height:400px;min-height:400px}}
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
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '의뢰부서')"/>
								</td>
								<td style="font-size:1px">&nbsp;</td>
								<td style="width:245px">
									<!--<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Site', '3', '처리부서')"/>-->
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
								<td class="f-lbl">제목</td>
								<td colspan="3" style="border-right: 0">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" id="Subject" name="__commonfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">200</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//docinfo/subject" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl" style="border-bottom:0;">생산지</td>
								<td style="border-bottom:0; width: 20%">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" id="__mainfield" name="PRODUCECENTER" style="width:80%">
												<xsl:attribute name="class">txtText_u</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PRODUCECENTER" />
												</xsl:attribute>
											</input>
											<button type="button" class="btn btn-outline-secondary btn-18" title="생산지" onclick="_zw.formEx.optionWnd('external.centercode3',200,140,150,-10,'','PRODUCECENTER');">
												<i class="fas fa-angle-down"></i>
											</button>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCECENTER))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl" style="border-bottom:0">추가등록지</td>
								<td style="border-right:0;border-bottom:0">
									<span class="f-option">
										<input type="checkbox" id="ckb11" name="ckbADDREG" value="VH">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'VH;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'VH;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb11">VH</label>
									</span>
									<span class="f-option">
										<input type="checkbox" id="ckb12" name="ckbADDREG" value="VS">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'VS;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'VS;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb12">VS</label>
									</span>
									<span class="f-option">
										<input type="checkbox" id="ckb13" name="ckbADDREG" value="VW">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'VW;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'VW;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb13">VW</label>
									</span>

									<span class="f-option">
										<input type="checkbox" id="ckb14" name="ckbADDREG" value="VU">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'VU;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'VU;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb14">VU</label>
									</span>
									<span class="f-option">
										<input type="checkbox" id="ckb15" name="ckbADDREG" value="CD">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'CD;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'CD;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb15">CD</label>
									</span>
									<span class="f-option">
										<input type="checkbox" id="ckb16" name="ckbADDREG" value="IC">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'IC;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'IC;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb16">IC</label>
									</span>
									<span class="f-option">
										<input type="checkbox" id="ckb17" name="ckbADDREG" value="IS">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'IS;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'IS;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb17">IS</label>
									</span>
									<span class="f-option">
										<input type="checkbox" id="ckb18" name="ckbADDREG" value="MST">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbADDREG', this, 'ADDREG', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/ADDREG),'MST;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/ADDREG),'MST;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb18">MST</label>
									</span>
									<input type="hidden" id="__mainfield" name="ADDREG" value="{//forminfo/maintable/ADDREG}" />
								</td>
							</tr>
						</table>
					</div>

					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />

					<div class="fm">
						<span class="">* 변경 사항</span>
					</div>
					<div class="ff" />

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="f-lbl">설계지원</td>
								<td style="border-right: 0">
									<span class="f-option1">
										<input type="checkbox" id="ckb21" name="ckbCHANGES" value="Code">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Code;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Code;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb21">Code</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb22" name="ckbCHANGES" value="Add">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Add;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Add;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb22">Add</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb23" name="ckbCHANGES" value="Delete">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Delete;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Delete;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb23">Delete</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb24" name="ckbCHANGES" value="Quantity">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Quantity;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Quantity;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb24">Quantity</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb25" name="ckbCHANGES" value="Level">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Level;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Level;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb25">Level</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb26" name="ckbCHANGES" value="Descripton">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Descripton;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Descripton;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb26">Descripton</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb27" name="ckbCHANGES" value="Catalog">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Catalog;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Catalog;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb27">Catalog</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb28" name="ckbCHANGES" value="Category">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Category;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Category;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb28">Category</label>
									</span>
									
									<span class="f-option1">
										<input type="checkbox" id="ckb30" name="ckbCHANGES" value="ETC">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'ETC;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'ETC;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb30">ETC</label>
									</span>
									<input type="hidden" id="__mainfield" name="CHANGES" value="{//forminfo/maintable/CHANGES}" />
								</td>
							</tr>
							<tr>
								<td class="f-lbl">개발구매</td>
								<td style="border-right: 0">
									<span class="f-option1">
										<input type="checkbox" id="ckb31" name="ckbCHANGES" value="Supplier">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Supplier;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Supplier;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb31">Supplier</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb32" name="ckbCHANGES" value="Price">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Price;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Price;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb32">Price</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb33" name="ckbCHANGES" value="MOQ">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'MOQ;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'MOQ;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb33">MOQ</label>
									</span>
									<span class="f-option1">
										<input type="checkbox" id="ckb29" name="ckbCHANGES" value=" L/T">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),' L/T;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),' L/T;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb29"> L/T</label>
									</span>
								</td>
							</tr>
							<!--<tr>
								<td class="f-lbl">경영기획</td>
								<td style="border-right: 0">
									<span class="f-option1">
										<input type="checkbox" id="ckb34" name="ckbCHANGES" value="Supply Type">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Supply Type;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Supply Type;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb34">Supply Type</label>
									</span>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">경영기획</td>
								<td style="border-right: 0">
									<span class="f-option1">
										<input type="checkbox" id="ckb35" name="ckbCHANGES" value="Routing">
											<xsl:if test="$mode='new' or $mode='edit'">
												<xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGES', this, 'CHANGES', ';')</xsl:attribute>
											</xsl:if>
											<xsl:if test="phxsl:isExist(string(//forminfo/maintable/CHANGES),'Routing;')">
												<xsl:attribute name="checked">true</xsl:attribute>
											</xsl:if>
											<xsl:if test="$mode='read' and phxsl:isExist(string(//forminfo/maintable/CHANGES),'Routing;')=false">
												<xsl:attribute name="disabled">disabled</xsl:attribute>
											</xsl:if>
										</input>
										<label for="ckb35">Routing</label>
									</span>
								</td>
							</tr>-->
							<tr>
								<td class="f-lbl" style="border-bottom: 0">참고</td>
								<td style="border-right: 0; border-bottom: 0">
									<div style="padding: ">
										<span class="f-option" style="font-size: 13px">Code (품번 변경),</span>
										<span class="f-option" style="font-size: 13px">Add (품번 추가),</span>
										<span class="f-option" style="font-size: 13px">Delete (품번 삭제),</span>
										<span class="f-option" style="font-size: 13px">Quantity (소요량),</span>
										<span class="f-option" style="font-size: 13px">Level (레벨),</span>
										<span class="f-option" style="font-size: 13px">Descripton (품명),</span>
										<span class="f-option" style="font-size: 13px">Catalog (사양, 규격),</span>
										<span class="f-option" style="font-size: 13px">Category (Item Type/Product, 품목 분류), </span>
										<span class="f-option" style="font-size: 13px">L/T (리드 타임),</span>
										<span class="f-option" style="font-size: 13px">ETC,</span>
										<span class="f-option" style="font-size: 13px">Supplier (업체명),</span>
										<span class="f-option" style="font-size: 13px">Price (단가),</span>
										<span class="f-option" style="font-size: 13px">MOQ (최소 발주 수량),</span>
										<!--<span class="f-option" style="font-size: 13px">Supply Type (출고 처리),</span>
										<span class="f-option" style="font-size: 13px">Routing (공수)</span>-->
									</div>									
								</td>
							</tr>
						</table>
					</div>
						
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />

					<div class="fm">
						<span class="">* 변경 내용</span>
					</div>
					<div class="ff" />

					<div class="fm-editor">
						<xsl:if test="$mode!='new' and $mode!='edit'">
							<xsl:attribute name="class">fm-editor h-auto</xsl:attribute>
						</xsl:if>
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
								<div class="h-100" id="__DextEditor"></div>
							</xsl:otherwise>
						</xsl:choose>
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
