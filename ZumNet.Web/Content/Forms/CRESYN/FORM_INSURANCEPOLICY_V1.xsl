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

					.m {width:680px;vertical-align:top;}
					.m .ff {height:2px;font-size:1px;vertical-align:top}
					.m .fh {height:60px;vertical-align:top}
					.m .fb {height:80px;vertical-align:top}
					.m .fm {height:;vertical-align:top}
					.m .fm1 {height:40px;vertical-align:top}
					.m .fm2 {height:;vertical-align:top}
					.m .fm3 {height:;vertical-align:top}
					.m .fm4 {height:;vertical-align:top}
					.m .fm-editor {height:500px;vertical-align:top;border:windowtext 1.5pt solid;}
					.m .fm-file {text-align:left}

					/* 폰트 */
					.fh h1 {font-family:굴림체;font-weight:bold;font-size:19.0pt;letter-spacing:0pt;}
					.si-tbl td {font-size:13px;font-family:맑은 고딕}
					.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,
					.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div
					{font-size:13px;font-family:맑은 고딕}
					.m .fm span {font-size:14px;font-family:맑은 고딕}
					.m .fm-file td, .m .fm-file td a {font-size:13px;font-family:맑은 고딕}

					/* 로고 및 양식명 */
					.fh table {width:100%;height:100%}
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
					.m .ft .f-lbl1 {width:18%;text-align:center}
					.m .ft .f-lbl2 {width:120;text-align:center}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}
					.fm span {text-align:center}

					/* 본문 하위 테이블 */
					.m .ft-sub {border:windowtext 1.5pt solid}
					.m .ft-sub td {height:24px;border-right:windowtext 1pt solid;border-top:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}
					.m .ft-sub .f-lbl-sub {text-align:center;}

					/* 첨부파일 */
					.m .fm-file table {width:;height:100%}
					.m .fm-file td.file-title {vertical-align:top}
					.m .fm-file td.file-end {vertical-align:bottom;padding:0 0 3px 10px}
					.m .fm-file td.file-info {vertical-align:top}
					.m .fm-file td.file-info div {height:20px}

					/* 각종 필드 정의 - txt : input, txa : textarea */
					.m .txtText {ime-mode:active;width:100%;padding-top:2px}
					.m .txtText_m {ime-mode:active;width:100%;border:1px solid red;;padding-top:2px}
					.m .txaText {ime-mode:active;width:100%;height:98%;overflow:auto}

					.m .txtNo {width:100%;padding-top:2px;padding-right:2;text-align:right}
					.m .txtNumberic, .m .txtVolume {width:100%;padding-top:2px;direction:rtl;padding-right:2;ime-mode:disabled}
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

					/* 인쇄 설정 : 맨하단으로 */
					@media print {
					.m .fm-editor {height:}
					.m .fm-file td a {text-decoration:none;color:#000000}
					}
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
									<h1>
										<xsl:value-of select="//docinfo/docname" />
									</h1>
								</td>
								<td class="fh-r"></td>
							</tr>
						</table>
						<xsl:choose>
							<xsl:when test="$mode='read'">
								<input type="hidden" id="__mainfield" name="LOGOPATH">
									<xsl:attribute name="value">
										<xsl:value-of select="//forminfo/maintable/LOGOPATH" />
									</xsl:attribute>
								</input>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" id="__mainfield" name="LOGOPATH">
									<xsl:attribute name="value">
										/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
									</xsl:attribute>
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
								<td style="width:4%;font-size:1px"></td>

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
								<td style="width:32%">
									<input type="text" id="DocNumber" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//docinfo/docnumber" />
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl">작성부서</td>
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
								<td class="f-lbl" style="border-bottom:0">작성자</td>
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
								<td class="f-lbl1">보증보험 종류</td>
								<td style="width:32%" >
									<xsl:choose>
										<xsl:when test="$mode='read'">
											<input type="text" name="POLICYTYPE" id="__mainfield">
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/POLICYTYPE" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<select  name="POLICYTYPE" id="__mainfield">
												<xsl:choose>
													<xsl:when test="//forminfo/maintable/POLICYTYPE[.='']">
														<option value="" selected="true">선택하세요</option>
														<option value="선급">선급</option>
														<option value="계약">계약</option>
														<option value="입찰">입찰</option>
														<option value="하자">하자</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/POLICYTYPE[.='선급']">
														<option value="">선택하세요</option>
														<option value="선급" selected="true">선급</option>
														<option value="계약">계약</option>
														<option value="입찰">입찰</option>
														<option value="하자">하자</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/POLICYTYPE[.='계약']">
														<option value="">선택하세요</option>
														<option value="선급">선급</option>
														<option value="계약" selected="true">계약</option>
														<option value="입찰">입찰</option>
														<option value="하자">하자</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/POLICYTYPE[.='입찰']">
														<option value="">선택하세요</option>
														<option value="선급">선급</option>
														<option value="계약">계약</option>
														<option value="입찰" selected="true">입찰</option>
														<option value="하자">하자</option>
													</xsl:when>
													<xsl:when test="//forminfo/maintable/POLICYTYPE[.='하자']">
														<option value="">선택하세요</option>
														<option value="선급">선급</option>
														<option value="계약">계약</option>
														<option value="입찰">입찰</option>
														<option value="하자" selected="true">하자</option>
													</xsl:when>
													<xsl:otherwise>
														<option value="" selected="true">선택하세요</option>
														<option value="선급">선급</option>
														<option value="계약">계약</option>
														<option value="입찰">입찰</option>
														<option value="하자">하자</option>
													</xsl:otherwise>
												</xsl:choose>
											</select>
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl">보험기간</td>
								<td style="border-right:0;">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="PERIOD1" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit'">
											<input type="text" name="PERIOD1" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PERIOD1" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/PERIOD1" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIOD1))" />
										</xsl:otherwise>
									</xsl:choose>&nbsp;~&nbsp;
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="PERIOD2" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit'">
											<input type="text" name="PERIOD2" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PERIOD2" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/PERIOD2" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIOD2))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl1">보험계약자</td>
								<td>
									<input type="text" name="ASSURER" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ASSURER" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ASSURER" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl">피보험자</td>
								<td style="border-right:0">
									<input type="text" name="INSURANT" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/INSURANT" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/INSURANT" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl1" style="border-bottom:0">보험가입금액</td>
								<td style="border-bottom:0">
									<input type="text" name="ASSUREMONEY" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ASSUREMONEY" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ASSUREMONEY" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
								<td class="f-lbl" style="border-bottom:0">보험료</td>
								<td style="border-bottom:0;border-right:0">
									<input type="text" name="PREMIUM" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PREMIUM" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PREMIUM" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
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
								<td style="width:3%;text-align:center;writing-mode:tb" rowspan="4">주계약내용</td>
								<td class="f-lbl">입찰(계약)명</td>
								<td colspan="3" style="border-right:0">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="BIDNAME" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="BIDNAME" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BIDNAME" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/BIDNAME" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BIDNAME))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">공고(계약)번호</td>
								<td style="width:32%">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="BIDNO" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="BIDNO" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BIDNO" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/BIDNO" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BIDNO))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl">입찰(계약)일</td>
								<td style="border-right:0;">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="BIDDAY" id="__mainfield">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="BIDDAY" id="__mainfield">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BIDDAY" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/BIDDAY" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BIDDAY))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">입찰(계약)금액</td>
								<td>
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="BIDMONEY" id="__mainfield">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">20</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="BIDMONEY" id="__mainfield">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="maxlength">20</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/BIDMONEY" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/BIDMONEY" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BIDMONEY))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl">보증금율</td>
								<td style="border-right:0">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="RATE" id="__mainfield" style="width:80px">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
											</input>%
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="RATE" id="__mainfield" style="width:80px">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/RATE" />
												</xsl:attribute>
											</input>%
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Right</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RATE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATE))" />&nbsp;%
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">계약기간</td>
								<td >
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="PERIOD3" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="PERIOD3" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PERIOD3" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/PERIOD3" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIOD3))" />
										</xsl:otherwise>
									</xsl:choose>&nbsp;~&nbsp;
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="PERIOD4" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="PERIOD4" id="__mainfield" style="width:95">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PERIOD4" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/PERIOD4" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIOD4))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl">수주번호</td>
								<td style="border-right:0">
									<xsl:choose>
										<xsl:when test="$mode='new'">
											<input type="text" name="ORDERNO" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:when test="$mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<input type="text" name="ORDERNO" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/ORDERNO" />
												</xsl:attribute>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/ORDERNO" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ORDERNO))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td colspan="2" class="f-lbl1" style="border-bottom:0">비고</td>
								<td colspan="3" style="border-right:0;border-bottom:0;height:100px;vertical-align:top">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit' or ($mode='read' and $bizrole='receive' and $actrole='__r' and $partid!='')">
											<textarea name="CONTENT" id="__mainfield">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
												<xsl:if test="$mode='edit' or $mode='read'">
													<xsl:value-of select="//forminfo/maintable/CONTENT" />
												</xsl:if>
											</textarea>
										</xsl:when>
										<xsl:otherwise>
											<div name="CONTENT" id="__mainfield">
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/CONTENT))" />
											</div>
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
									<td class="file-title">첨부 문서&nbsp;:&nbsp;</td>
									<td class="file-info">
										<xsl:apply-templates select="//linkeddocinfo/linkeddoc"/>
										<xsl:apply-templates select="//fileinfo/file[@isfile='Y']"/>
									</td>
									<td class="file-end">끝.</td>
								</tr>
							</table>
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
				<xsl:attribute name="href"><xsl:value-of select="reserved1" /></xsl:attribute>
				<xsl:value-of select="subject" />
			</a>
		</div>
	</xsl:template>
	<xsl:template match="//fileinfo/file[@isfile='Y']">
		<div>
			<a target="_blank">
				<xsl:attribute name="href"><xsl:value-of select="virtualpath" />/<xsl:value-of select="savedname" /></xsl:attribute>
				<xsl:value-of select="filename" />
			</a>
		</div>
	</xsl:template>
</xsl:stylesheet>