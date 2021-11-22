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
	<!--<xsl:variable name="companycode" select="//config/@companycode" />-->
	<xsl:variable name="displaylog">false</xsl:variable>

	<!--<xsl:strip-space elements="*"/>-->
	<xsl:template match="/">
		<xsl:value-of select="phxsl:init(string($root), string(//config/@companycode), string(//config))"/>
		<html>
			<head>
				<title>전자결재</title>
				<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
				<style type="text/css">
					html, body {margin:0px;padding:0px;}
					body {margin-bottom:2px;border:0;background-color:#ffffff;text-align:center;overflow:auto}

					.m {width:700px;vertical-align:top;}
					.m .ff {height:2px;font-size:1px;vertical-align:top}
					.m .fh {height:60px;vertical-align:top}
					.m .fb {height:80px;vertical-align:top}
					.m .fm {height:;vertical-align:top}
					.m .fm1 {height:;vertical-align:top}
					.m .fm2 {height:;vertical-align:top}
					.m .fm3 {height:;vertical-align:top}
					.m .fm4 {height:;vertical-align:top}
					.m .fm-editor {height:500px;vertical-align:top;border:windowtext 1.5pt solid;}

					/* 폰트 */
					.fh h1 {font-family:;font-weight:bold;font-size:20.0pt;letter-spacing:0pt}
					.fh h2 {font-family:;font-weight:;font-size:9.0pt;letter-spacing:0pt}
					.si-tbl td {font-size:13px;font-family:맑은 고딕}
					.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,
					.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div
					{font-size:13px;font-family:맑은 고딕}
					.m .fm span {font-size:14px;font-family:맑은 고딕}

					/* 로고 및 양식명 */
					.fh table {width:100%;height:100%}
					.fh h1 {margin-top:0}
					.fh h2 {margin-bottom:0}
					.fh .fh-l {width:150px;text-align:center}
					.fh .fh-m {padding-top:15px;text-align:center}
					.fh .fh-r {width:150px}
					.fh .fh-l img {border:0px solid red;vertical-align:middle;margin-top:0px}

					/* 결재칸 */
					.si-tbl {border:windowtext 1.5pt solid}
					.si-tbl td {vertical-align:middle;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid}
					.si-tbl .si-title {width:5%;text-align:center}
					.si-tbl .si-top {height:20px;text-align:center;padding-top:2px}
					.si-tbl .si-middle {height:65px;text-align:center}
					.si-tbl .si-bottom {height:20px;text-align:center;width:19%}
					.si-tbl img {margin:0px}

					/* 버튼 스타일 */
					.btn_bg {height:21px;border:1 solid #b1b1b1;background:url('/<xsl:value-of select="$root" />/EA/Images/btn_bg.gif');background-color:#ffffff;
					font-size:11px;letter-spacing:-1px;margin:0 2 0 2;padding:0 0 0 0 ;	vertical-align:middle;cursor:hand;}
					img.blt01	 {margin:0 2 0 -2 ; vertical-align:middle;}
					.si-tbl img {margin:0px}

					/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
					.m .ft {border:windowtext 1.5pt solid}
					.m .ft td {height:24px;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}
					.m .ft .f-lbl {width:15%;text-align:center}
					.m .ft .f-lbl1 {width:14%;text-align:center}
					.m .ft .f-lbl2 {width:16%;text-align:center}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}
					.fm span {text-align:center}

					/* 본문 하위 테이블 */
					.m .ft-sub {border:windowtext 1.5pt solid}
					.m .ft-sub td {height:24px;border-right:windowtext 1pt solid;border-top:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}
					.m .ft-sub .f-lbl-sub {text-align:center;}

					/* 각종 필드 정의 - txt : input, txa : textarea */
					.m .txtText {ime-mode:active;width:100%;padding-top:2px}
					.m .txtText_m {ime-mode:active;width:100%;border:1px solid red;;padding-top:2px}
					.m .txaText {ime-mode:active;width:100%;overflow:auto}

					.m .txtNo {width:100%;padding-top:2px;padding-right:2;text-align:right}
					.m .txtNumberic {width:100%;padding-top:2px;direction:rtl;padding-right:2;ime-mode:disabled}
					.m .txtJuminDash {width:100%;padding-top:2px;padding-right:2;text-align:center;ime-mode:disabled}
					.m .txtCurrency, .m .txtDollar, .m .txtDollar1, .m .txtDollar2, .m .txtDollarMinus1, .m .txtDollarMinus2, .m .txtDollarMinus3
					{direction:rtl;ime-mode:active;width:100%;padding-top:2px;padding-right:2;text-align:right;}
					.m .txtDate, .m .txtMonth, .m .txtHHmm, .m .txtHHmmss
					{ime-mode:disabled;width:100%;padding-top:2px;text-align:center}
					.m .txtCalculate {ime-mode:active;width:100%;padding-top:2px;padding-right:2}
					.m .txaRead {width:100%;text-align:left}

					.m .txtRead {width:100%;border:0;padding-top:2px}
					.m .txtRead_Right {width:100%;border:0;padding-top:2px;padding-right:2;text-align:right}
					.m .txtRead_Center {width:100%;border:0;padding-top:2px;text-align:center}

					.m .ddlSelect {width:100%}
				</style>
			</head>
			<body>
				<div class="m">
					<div class="fh">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="fh-l">
									<img alt="">
										<xsl:attribute name="src">
											<xsl:choose>
												<xsl:when test="$mode='read'">
													<xsl:value-of select="//forminfo/maintable/LOGOPATH" />
												</xsl:when>
												<xsl:otherwise>
													/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
									</img>
								</td>
								<td class="fh-m">
									<h2>CONFIDENTIAL</h2>
									<h1>DEMO License 신청서</h1>
								</td>
								<td class="fh-r">&nbsp;</td>
							</tr>
						</table>
						<xsl:choose>
							<xsl:when test="$mode='read'">
								<input type="hidden" id="__mainfield" name="LOGOPATH">
									<xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/LOGOPATH" /></xsl:attribute>
								</input>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" id="__mainfield" name="LOGOPATH">
									<xsl:attribute name="value">/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" /></xsl:attribute>
								</input>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<div class="ff" />

					<div class="fb">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:60%">
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5')"/>
											</td>
										</tr>
									</table>
								</td>
								<td style="width:4%;font-size:1px">&nbsp;</td>

								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='receive' and @partid!='' and @actrole!='__r' and @step!='0'], '__si_Receive', '3')"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>

					<div class="ff" />
					<div class="ff" />

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="f-lbl1">문서번호</td>
								<td style="width:28%">
									<input type="text" id="DocNumber" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//docinfo/docnumber" />
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl1">작성부서</td>
								<td style="border-right:0">
									<input type="text" id="CreatorDept" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//creatorinfo/department" />
										</xsl:attribute>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl1" style="border-bottom:0">작성일자</td>
								<td style="border-bottom:0">
									<input type="text" id="CreateDate" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl1" style="border-bottom:0">작성자</td>
								<td style="border-right:0;border-bottom:0">
									<input type="text" id="Creator" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//creatorinfo/name" />
										</xsl:attribute>
									</input>
								</td>
							</tr>
						</table>
					</div>

					<div class="ff" />
					<div class="ff" />

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="f-lbl1">수령희망일</td>
								<td class="f-lbl1">
									<input type="text" name="RECEIVEDATE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/RECEIVEDATE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Center</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/RECEIVEDATE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1">용 도</td>
								<td class="f-lbl1">
									<xsl:choose>
										<xsl:when test="$mode='read'">
											<input type="text" name="MULTIPURPOSE1" id="__mainfield">
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/MULTIPURPOSE" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<select class="txtRead" onchange="parent.fnChangeDemoLicense(this.value)">
												<xsl:choose>
													<xsl:when test="//forminfo/maintable/MULTIPURPOSE[.='']">
														<option value="직원사용" selected="true">직원사용</option>
														<option value="고객대여">고객대여</option>
														<option value="교육용">교육용</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/MULTIPURPOSE[.='직원사용']">
														<option value="직원사용" selected="true">직원사용</option>
														<option value="고객대여">고객대여</option>
														<option value="교육용">교육용</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/MULTIPURPOSE[.='고객대여']">
														<option value="직원사용">직원사용</option>
														<option value="고객대여" selected="true">고객대여</option>
														<option value="교육용">교육용</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/MULTIPURPOSE[.='교육용']">
														<option value="직원사용">직원사용</option>
														<option value="고객대여">고객대여</option>
														<option value="교육용" selected="true">교육용</option>
													</xsl:when>
													<xsl:otherwise>
														<option value="직원사용" selected="true">직원사용</option>
														<option value="고객대여">고객대여</option>
														<option value="교육용">교육용</option>
													</xsl:otherwise>
												</xsl:choose>
											</select>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl1">사용기간</td>
								<td colspan="2" style="border-right:0;">
									<input type="text" name="USESDATE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:88px</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:88px</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/USESDATE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Center</xsl:attribute>
												<xsl:attribute name="style">width:88px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/USESDATE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>&nbsp;~&nbsp;
									<input type="text" name="USEEDATE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:88px</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:88px</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/USEEDATE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Center</xsl:attribute>
												<xsl:attribute name="style">width:88px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/USEEDATE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl1">요청사유</td>
								<td colspan="6" style="height:60px;border-right:0;">                                
                                <xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="REQCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/REQCONTENTS))" />
											</div>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="REQCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/REQCONTENTS" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>                                
								
								</td>
							</tr>

							<tr>
								<td class="f-lbl1" rowspan="2" style="border-bottom:0;">고객정보</td>
								<td class="f-lbl1">기관명</td>
								<td class="f-lbl1">
									<input type="text" name="ORGNAME" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGNAME" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGNAME" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1">부서명</td>
								<td class="f-lbl1">
									<input type="text" name="ORGDEPTNAME" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGDEPTNAME" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGDEPTNAME" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1">담당자명</td>
								<td class="f-lbl2" style="border-right:0;">
									<input type="text" name="ORGUSERNAME" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGUSERNAME" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGUSERNAME" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl1" style="border-bottom:0;">전화번호</td>
								<td colspan="2" style="border-bottom:0;">
									<input type="text" name="ORGTEL" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">20</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">20</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGTEL" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGTEL" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1" style="border-bottom:0;">E-mail</td>
								<td colspan="2" style="border-bottom:0;border-right:0;">
									<input type="text" name="ORGEMAIL" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGEMAIL" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORGEMAIL" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
						</table>
					</div>

					<div class="ff"></div>
					<div class="ff"></div>

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="f-lbl1" align="center">&nbsp;</td>
								<td colspan="3" align="center">제 품 명</td>
								<td class="f-lbl1" align="center">수 량</td>
								<td class="f-lbl1" align="center">단 가</td>
								<td class="f-lbl2" align="center" style="border-right:0;">금 액</td>
							</tr>
							<tr>
								<td class="f-lbl1" align="center" rowspan="7">Server GIS</td>
								<td class="f-lbl1" align="center">Arcgis Server</td>
								<td class="f-lbl1" align="center">Workgroup</td>
								<td class="f-lbl1" align="center">Enterprise</td>
								<td class="f-lbl1" align="center">-</td>
								<td class="f-lbl1" align="center">-</td>
								<td class="f-lbl2" align="center" style="border-right:0;">-</td>
							</tr>

							<tr>
								<td class="f-lbl1" align="center">Basic</td>
								<td class="f-lbl1" align="center">
									<input type="text" name="BASICWORKGROUP" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICWORKGROUP" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICWORKGROUP" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1" align="center">
									<input type="text" name="BASICENTERPRISE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICENTERPRISE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICENTERPRISE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1" align="center">
									<input type="text" name="BASICQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl1" align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="BASICAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BASICAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td align="center">Standard</td>
								<td align="center">
									<input type="text" name="STANDARDWORKGROUP" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDWORKGROUP" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDWORKGROUP" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">
									<input type="text" name="STANDARDENTERPRISE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDENTERPRISE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDENTERPRISE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">
									<input type="text" name="STANDARDQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="STANDARDAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/STANDARDAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td align="center">Advanced</td>
								<td align="center">
									<input type="text" name="ADVANSEDWORKGROUP" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVANSEDWORKGROUP" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVANSEDWORKGROUP" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">
									<input type="text" name="ADVANSEDENTERPRISE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVANSEDENTERPRISE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVANSEDENTERPRISE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">
									<input type="text" name="ADVENCEDQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVENCEDQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVENCEDQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ADVENCEDAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVENCEDAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ADVENCEDAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td colspan="3">ArcIMS License (V9.1이하)</td>
								<td align="center">
									<input type="text" name="ARCIMSQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCIMSQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCIMSQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ARCIMSAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCIMSAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCIMSAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td colspan="3">ArcSDE Server License(V9.1이하)</td>
								<td align="center">
									<input type="text" name="ARCSDEQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCSDEQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCSDEQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ARCSDEAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCSDEAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCSDEAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td colspan="6" style="border-right:0;">
									OS:
									<input type="text" name="SERVEROS" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:90px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:90px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVEROS" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:90px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVEROS" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>&nbsp;&nbsp;
									DBMS:
									<input type="text" name="SERVERDBMS" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:80px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:80px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVERDBMS" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:80px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVERDBMS" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									&nbsp;&nbsp;
									Webserver:
									<input type="text" name="SERVERWEB" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:87px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:87px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVERWEB" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:87px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVERWEB" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>&nbsp;&nbsp;
									Servlet:
									<input type="text" name="SERVERLET" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:80px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:80px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVERLET" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:80px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SERVERLET" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl1" align="center" rowspan="5">Desktop GIS</td>
								<td colspan="3">&nbsp;ArcInfo License</td>
								<td align="center">
									<input type="text" name="ARCINFOQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCINFOQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCINFOQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ARCINFOAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCINFOAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCINFOAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td colspan="3">&nbsp;ArcEditor License</td>
								<td align="center">
									<input type="text" name="ARCEDITORQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCEDITORQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCEDITORQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ARCEDITORQAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCEDITORQAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCEDITORQAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td colspan="3">&nbsp;ArcView License </td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ARCVIEWQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCVIEWQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCVIEWQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">N/A</td>
								<td align="center" style="border-right:0;">필요수량제공</td>
							</tr>

							<tr>
								<td colspan="3">&nbsp;ArcGIS Extensions</td>
								<td align="center">
									<input type="text" name="ARCGISQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCGISQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ARCGISQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">N/A</td>
								<td align="center" style="border-right:0;">필요수량제공</td>
							</tr>

							<tr>
								<td colspan="6" style="border-right:0;">
									License Server:
									<input type="text" name="LICENSESERVER" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:49px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:49px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/LICENSESERVER" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:49px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/LICENSESERVER" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									Windows-Parallel/USB Key NO:
									<input type="text" name="WINDOWKEY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:40px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:40px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/WINDOWKEY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:40px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/WINDOWKEY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
									UNIX(IBMAX)&nbsp;HostID:
									<input type="text" name="HOSTKEY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:55px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="style">width:55px</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/HOSTKEY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="style">width:54px</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/HOSTKEY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td class="f-lbl1" align="center">기타</td>
								<td align="center" colspan="3">
									<input type="text" name="ETCPRODUCT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">50</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCPRODUCT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCPRODUCT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">
									<input type="text" name="ETCQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">
									<input type="text" name="ETCPRICE" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCPRICE" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCPRICE" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="ETCAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ETCAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td align="center" rowspan="4">비용구분</td>
								<td align="center" colspan="3">License(\30,000 / 1 License )</td>
								<td align="center">
									<input type="text" name="LICENSEQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/LICENSEQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/LICENSEQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\30,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="LICENSEAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/LICENSEAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/LICENSEAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td align="center" colspan="3">Sential Key(\60,000 / 1EA)</td>
								<td align="center">
									<input type="text" name="KEYQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/KEYQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/KEYQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td  align="center">\60,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="KEYAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/KEYAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/KEYAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td colspan="2" rowspan="2">&nbsp; 설치지원(지역에따른 구분)</td>
								<td align="center">서울/경기</td>
								<td align="center">
									<input type="text" name="SEOULQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SEOULQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SEOULQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\160,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="SEOULQAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SEOULQAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/SEOULQAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>

							<tr>
								<td align="center">기타 지역</td>
								<td align="center">
									<input type="text" name="OUTSEOULQTY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="onKeyUp">parent.sumDemolicense(this)</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/OUTSEOULQTY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/OUTSEOULQTY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td align="center">\360,000</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="OUTSEOULAMOUNT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="maxlength">15</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/OUTSEOULAMOUNT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead_Right</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/OUTSEOULAMOUNT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td align="center" colspan="6" style="text-align: right">
									<strong>합 계</strong> &nbsp;
								</td>
								<td align="center" style="border-right:0;">
									<input type="text" name="TOTALAMOUNT" id="__mainfield">
										<xsl:attribute name="class">txtRead_Right</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//forminfo/maintable/TOTALAMOUNT" />
										</xsl:attribute>
									</input>
								</td>
							</tr>
							<tr>
								<td colspan="7" style="border-right:0;border-bottom:0;">
									&nbsp;&nbsp;1. 참고 : License 수량,
									Sentinel Key 제공, 설치지원에 따라 비용 산정되며, 기간은 최대 1년까지 가능합니다.<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 방문 설치지원의 경우 Desktop은
									해당되지 않으며, ESRI System Requirement 에 적합한 경우에 지원합니다.<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 각 사업단(본부)별 라이센스 사용 비용은
									공헌이익에서 차감됩니다.<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 예외사항 : 교육/시연 목적의 2주 이하는 무상지원, 납품 대체의 경우 고객지원팀 직접 처리합니다.<br/>
									<br/>
									2. 신청방법 : 당사 직원은 Desktop License만 신청할 수 있으며, 내근 시 회사 공용 License를 활용하기 바랍니다.<br/>
									&nbsp;&nbsp;&nbsp;&nbsp;
									Server License의 경우 기 제공된 NFR(Not For Resale) License 사용(직원외 사용은 엄격히 제한합니다)<br/>&nbsp;&nbsp;&nbsp;&nbsp; 필요
									라이센스 수량을 해당란(녹색란)에 숫자로 기입하기 바라며, 참고 정보를 충분히 기재하기 바랍니다.
								</td>
							</tr>
						</table>
					</div>

				</div>

				<!-- 필수 양식정보 -->
				<input type="hidden" id="__PHBFF" name="__PHBFF"  value="" />
				<xsl:if test="$displaylog='true'">
					<div>
						<xsl:value-of select="phxsl:getLog()"/>
					</div>
				</xsl:if>

				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">__mainfield</xsl:attribute>
					<xsl:attribute name="name">MULTIPURPOSE</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="//forminfo/maintable/MULTIPURPOSE"/>
					</xsl:attribute>
				</xsl:element>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
