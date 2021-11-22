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

					@media print {
					.fh, .fb {display:none}
					}

					.m {width:680px;vertical-align:top;}
					.m .ff {height:2px;font-size:1px;vertical-align:top}
					.m .fh {height:60px;vertical-align:top}
					.m .fb {height:80px;vertical-align:top}
					.m .fm {height:;vertical-align:top}
					.m .fm1 {height:;vertical-align:top}
					.m .fm2 {height:;vertical-align:top}
					.m .fm3 {height:;vertical-align:top}
					.m .fm4 {height:;vertical-align:top}
					.m .fm-editor {height:680px;vertical-align:top;margin-left:6px;border-top:#aaaaaa 2pt solid;}
					.m .fm-file {text-align:left}

					/* 폰트 */
					.fh h1 {font-family:굴림체;font-weight:bold;font-size:20.0pt;letter-spacing:4pt;}
					.si-tbl td {font-size:13px;font-family:맑은 고딕}
					.m .ft td, .m .ft input, .m .ft select, .m .ft-sub td, .m .ft-sub input, .m .ft-sub select {font-size:13px;font-family:맑은 고딕}
					.m .fm1 td, .m .fm1 input {font-size:15px;font-family:맑은 고딕}
					.m .fm h2 {font-size:24px;font-family:맑은 고딕;margin:0 0 4px 0;letter-spacing:4pt}
					.m .fm h3 {font-size:20px;font-family:맑은 고딕;margin:0 0 4px 0;letter-spacing:4pt}
					.m .fm div.info-addr, .m .fm div.info-addr input {font-size:13px;font-family:맑은 고딕;}
					.m .fm2 p {font-size:24px;font-weight:bold;font-family:맑은 고딕;margin:8px 0 0 0;letter-spacing:4pt}
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
					.m .ft .f-lbl {width:30%;text-align:center}
					.m .ft .f-lbl1 {width:30%;text-align:center}
					.m .ft .f-lbl2 {width:15%;text-align:center}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}
					.fm span {text-align:center}
					.fm1 .ft, .fm1 .ft td {border:0}
					.fm1 .ft1 {border:windowtext 1.5pt solid}
					.fm1 .ft1 td {height:24px;border-right:windowtext 1pt solid;border-bottom:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:1px}
					.m .fm div.info-addr {height:20px;margin-top:6px;border:1px solid #666666;padding:4px}
					.m .fm div.info-addr p {margin:4px 0 0 0}
					.m .fm div.info-addr input {text-align:center}

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
					.m .txaText {ime-mode:active;width:100%;overflow:auto}

					.m .txtNo {width:100%;padding-top:2px;padding-right:2;text-align:right}
					.m .txtNumberic {width:100%;padding-top:2px;direction:rtl;padding-right:2;ime-mode:disabled}
					.m .txtJuminDash {width:100%;padding-top:2px;padding-right:2;text-align:center;ime-mode:disabled}
					.m .txtCurrency, .m .txtDollar, .m .txtDollar1, .m .txtDollar2, .m .txtDollarMinus1, .m .txtDollarMinus2, .m .txtDollarMinus3
					{direction:rtl;ime-mode:active;width:100%;padding-top:2px;padding-right:2;text-align:right;}
					.m .txtDate, .txtDateDot, .m .txtMonth, .m .txtHHmm, .m .txtHHmmss
					{ime-mode:disabled;width:100%;padding-top:2px;text-align:center}
					.m .txtCalculate {ime-mode:active;width:100%;padding-top:2px;padding-right:2}
					.m .txaRead {width:100%;text-align:left}

					.m .txtRead {width:100%;border:0;padding-top:2px}
					.m .txtRead_Right {width:100%;border:0;padding-top:2px;padding-right:2;text-align:right}
					.m .txtRead_Center {width:100%;border:0;padding-top:2px;text-align:center}

					.m .ddlSelect {width:100%}

					/* 인쇄 설정 : 맨하단으로 */
					@media print {
					.fbSign {display:none}
					.m .fm-editor {height:680px}
					.m .fm-file {display:none}
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
										<h1>대외공문</h1>
									</h1>
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
						<xsl:choose>
							<xsl:when test="$mode='read'">
								<input type="hidden" id="__mainfield" name="CORPCODE">
									<xsl:attribute name="value">
										<xsl:value-of select="//forminfo/maintable/CORPCODE" />
									</xsl:attribute>
								</input>
							</xsl:when>
							<xsl:otherwise>
								<input type="hidden" id="__mainfield" name="CORPCODE">
									<xsl:attribute name="value">
										<xsl:value-of select="//creatorinfo/corp/corpcd" />
									</xsl:attribute>
								</input>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<div class="fb">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:260px">
									<table class="ft" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="f-lbl1">문서번호</td>
											<td style="border-right:0">
												<input type="text" id="DocNumber" name="__commonfield">
													<xsl:attribute name="class">txtRead</xsl:attribute>
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="value">
														<xsl:value-of select="//docinfo/docnumber" />
													</xsl:attribute>
												</input>
											</td>
										</tr>
										<tr>
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
											<td class="f-lbl1">작성자</td>
											<td style="border-right:0">
												<input type="text" id="Creator" name="__commonfield">
													<xsl:attribute name="class">txtRead</xsl:attribute>
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="value">
														<xsl:value-of select="//creatorinfo/name" />
													</xsl:attribute>
												</input>
											</td>
										</tr>
										<tr>
											<td class="f-lbl1" style="border-bottom:0">작성일</td>
											<td style="border-right:0;border-bottom:0">
												<input type="text" id="CreateDate" name="__commonfield">
													<xsl:attribute name="class">txtRead</xsl:attribute>
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="value">
														<xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
													</xsl:attribute>
												</input>
											</td>
										</tr>
									</table>
								</td>

								<td style="width:4px;font-size:1px">&nbsp;</td>

								<td>
									<table border="0" cellspacing="0" cellpadding="0" class="fbSign">
										<tr>
											<td>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5')"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>

					<div class="fm">
						<xsl:choose>
							<xsl:when test="$mode='read'">
								<xsl:choose>
									<xsl:when test="//forminfo/maintable/CORPCODE='esrikorea'">
										<xsl:call-template name="ESRIKOREA_INFO" />
									</xsl:when>
									<xsl:when test="//forminfo/maintable/CORPCODE='sundodata'">
										<xsl:call-template name="SUNDODATA_INFO" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="SUNDOSOFT_INFO" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="//creatorinfo/corp/corpcd='esrikorea'">
										<xsl:call-template name="ESRIKOREA_INFO" />
									</xsl:when>
									<xsl:when test="//creatorinfo/corp/corpcd='sundodata'">
										<xsl:call-template name="SUNDODATA_INFO" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="SUNDOSOFT_INFO" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />

					<div class="fm1">
						<table style="width:100%;" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:50%">
									<table class="ft" style="border:0;" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="f-lbl">공&nbsp;문&nbsp;번&nbsp;호&nbsp;:</td>
											<td>
												<input type="text" name="OFFICENUM" id="__mainfield">
													<xsl:attribute name="class">txtRead</xsl:attribute>
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/OFFICENUM" />
													</xsl:attribute>
												</input>
											</td>
										</tr>
										<tr>
											<td class="f-lbl">시&nbsp;행&nbsp;일&nbsp;자&nbsp;:</td>
											<td>
												<input type="text" name="ENFORCEMENTDATE" id="__mainfield" style="width:90px">
													<xsl:choose>
														<xsl:when test="$mode='new'">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">10</xsl:attribute>
														</xsl:when>
														<xsl:when test="$mode='edit'">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="style">width:90px</xsl:attribute>
															<xsl:attribute name="maxlength">10</xsl:attribute>
															<xsl:attribute name="value">
																<xsl:value-of select="//forminfo/maintable/ENFORCEMENTDATE" />
															</xsl:attribute>
														</xsl:when>
														<xsl:otherwise>
															<xsl:attribute name="class">txtRead</xsl:attribute>
															<xsl:attribute name="style">width:90px</xsl:attribute>
															<xsl:attribute name="readonly">readonly</xsl:attribute>
															<xsl:attribute name="value">
																<xsl:value-of select="//forminfo/maintable/ENFORCEMENTDATE" />
															</xsl:attribute>
														</xsl:otherwise>
													</xsl:choose>
												</input>
											</td>
										</tr>
										<tr>
											<td class="f-lbl">수&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;신&nbsp;:</td>
											<td>
												<xsl:choose>
													<xsl:when test="$mode='new'">
														<input type="text" name="RECEIVEORG" id="__mainfield">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">50</xsl:attribute>
														</input>
													</xsl:when>
													<xsl:when test="$mode='edit'">
														<input type="text" name="RECEIVEORG" id="__mainfield">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">50</xsl:attribute>
															<xsl:attribute name="value">
																<xsl:value-of select="//forminfo/maintable/RECEIVEORG" />
															</xsl:attribute>
														</input>
														</xsl:when>
													<xsl:otherwise>
														<!--<xsl:attribute name="class">txtRead</xsl:attribute>
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="value">
															<xsl:value-of select="//forminfo/maintable/RECEIVEORG" />
														</xsl:attribute>-->
														<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECEIVEORG))" />
													</xsl:otherwise>
												</xsl:choose>												
											</td>
										</tr>
										<tr>
											<td class="f-lbl">참&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;조&nbsp;:</td>
											<td>
												<xsl:choose>
													<xsl:when test="$mode='new'">
														<input type="text" name="REFERORG" id="__mainfield">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">50</xsl:attribute>
														</input>
													</xsl:when>
													<xsl:when test="$mode='edit'">
														<input type="text" name="REFERORG" id="__mainfield">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">50</xsl:attribute>
															<xsl:attribute name="value">
																<xsl:value-of select="//forminfo/maintable/REFERORG" />
															</xsl:attribute>
														</input>
														</xsl:when>
													<xsl:otherwise>
														<!--<xsl:attribute name="class">txtRead</xsl:attribute>
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="value">
															<xsl:value-of select="//forminfo/maintable/REFERORG" />
														</xsl:attribute>-->
														<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REFERORG))" />
													</xsl:otherwise>
												</xsl:choose>												
											</td>
										</tr>
									</table>
								</td>
								<td style="width:4%">&nbsp;</td>
								<td style="padding-bottom:2px">
									<table class="ft1" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td align="center" style="width: 46px">선 결</td>
											<td style="width: 48px">&nbsp;</td>
											<td style="width: 80px">&nbsp; </td>
											<td align="center">지시</td>
											<td style="border-right:0">&nbsp;</td>
										</tr>
										<tr>
											<td align="center" rowspan="2" style="width: 46px">접 수</td>
											<td align="center" style="width: 48px">일 시</td>
											<td style="width: 80px" >&nbsp;&nbsp; </td>
											<td rowspan="4" style="width: 38px;border-bottom:0" align="center">
												결재<br/>
												/<br/>공람
											</td>
											<td style="border-right:0">&nbsp;</td>
										</tr>
										<tr>
											<td align="center" style="width: 48px">번 호</td>
											<td style="width: 80px" >&nbsp;&nbsp;</td>
											<td style="border-right:0">&nbsp;</td>
										</tr>
										<tr>
											<td  align="center" colspan="2">처 리 팀</td>
											<td style="width: 80px">&nbsp;&nbsp;</td>
											<td style="border-right:0">&nbsp;</td>
										</tr>
										<tr>
											<td align="center" colspan="2" style="border-bottom:0">담 당 자</td>
											<td style="width: 80px;border-bottom:0">&nbsp;</td>
											<td style="border-right:0;border-bottom:0">&nbsp;</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<table class="ft" style="border:0;" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td class="f-lbl2">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목&nbsp;:</td>
											<td>
												<xsl:choose>
													<xsl:when test="$mode='new'">
														<input type="text" id="Subject" name="__commonfield">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">200</xsl:attribute>
														</input>
													</xsl:when>
													<xsl:when test="$mode='edit'">
														<input type="text" id="Subject" name="__commonfield">
															<xsl:attribute name="class">txtText</xsl:attribute>
															<xsl:attribute name="maxlength">200</xsl:attribute>
															<xsl:attribute name="value">
																<xsl:value-of select="//docinfo/subject" />
															</xsl:attribute>
														</input>
													</xsl:when>
													<xsl:otherwise>
														<!--<xsl:attribute name="class">txtRead</xsl:attribute>
														<xsl:attribute name="readonly">readonly</xsl:attribute>
														<xsl:attribute name="value">
															<xsl:value-of select="//docinfo/subject" />
														</xsl:attribute>-->
														<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/subject))" />
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>

					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />

					<div class="fm-editor">
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
								<iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no">
									<xsl:attribute name="src">
										/<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx?env=env_official.xml
									</xsl:attribute>
								</iframe>
							</xsl:otherwise>
						</xsl:choose>
					</div>

					<div class="fm2">
						<xsl:choose>
							<xsl:when test="$mode='read'">
								<xsl:choose>
									<xsl:when test="//forminfo/maintable/CORPCODE='esrikorea'">
										<xsl:call-template name="ESRIKOREA_CEO" />
									</xsl:when>
									<xsl:when test="//forminfo/maintable/CORPCODE='sundodata'">
										<xsl:call-template name="SUNDODATA_CEO" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="SUNDOSOFT_CEO" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when test="//creatorinfo/corp/corpcd='esrikorea'">
										<xsl:call-template name="ESRIKOREA_CEO" />
									</xsl:when>
									<xsl:when test="//creatorinfo/corp/corpcd='sundodata'">
										<xsl:call-template name="SUNDODATA_CEO" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="SUNDOSOFT_CEO" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
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

	<xsl:template name="SUNDOSOFT_INFO">
		<div>
			<h3>주식회사&nbsp;&nbsp;선도소프트</h3>
			<div class="info-addr">
				<p>(153-759) 서울시 금천구 가산동 426-5 월드메르디앙벤처센터 2차15층 Tel:02-2025-6500 Fax:02-2025-6511</p>
				<p>
					<input type="text" name="SUNDOADD" id="__mainfield">
						<xsl:choose>
							<xsl:when test="$mode='new'">
								<xsl:attribute name="class">txtText</xsl:attribute>
								<xsl:attribute name="maxlength">50</xsl:attribute>
							</xsl:when>
							<xsl:when test="$mode='edit'">
								<xsl:attribute name="class">txtText</xsl:attribute>
								<xsl:attribute name="maxlength">50</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="//forminfo/maintable/SUNDOADD" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">txtRead</xsl:attribute>
								<xsl:attribute name="readonly">readonly</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="//forminfo/maintable/SUNDOADD" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</input>
				</p>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="SUNDODATA_INFO">
		<div>
			<h3>주식회사&nbsp;&nbsp;선도데이타</h3>
			<div class="info-addr">
				<p>(153-759) 서울시 금천구 가산동 426-5 월드메르디앙벤처센터 2차15층 Tel:82-2-2025-6598 Fax:82-2-2025-6511</p>
				<p>
					<input type="text" name="SUNDOADD" id="__mainfield">
						<xsl:choose>
							<xsl:when test="$mode='new'">
								<xsl:attribute name="class">txtText</xsl:attribute>
								<xsl:attribute name="maxlength">50</xsl:attribute>
							</xsl:when>
							<xsl:when test="$mode='edit'">
								<xsl:attribute name="class">txtText</xsl:attribute>
								<xsl:attribute name="maxlength">50</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="//forminfo/maintable/SUNDOADD" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">txtRead</xsl:attribute>
								<xsl:attribute name="readonly">readonly</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="//forminfo/maintable/SUNDOADD" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</input>
				</p>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="ESRIKOREA_INFO">
		<div>
			<h3>주식회사&nbsp;&nbsp;한국ESRI</h3>
			<div class="info-addr">
				<p>(153-759) 서울시 금천구 가산동 426-5 월드메르디앙벤처센터 2차1502호 Tel:02-2025-6700 Fax:02-2025-6701</p>
				<p>
					<input type="text" name="SUNDOADD" id="__mainfield">
						<xsl:choose>
							<xsl:when test="$mode='new'">
								<xsl:attribute name="class">txtText</xsl:attribute>
								<xsl:attribute name="maxlength">50</xsl:attribute>
							</xsl:when>
							<xsl:when test="$mode='edit'">
								<xsl:attribute name="class">txtText</xsl:attribute>
								<xsl:attribute name="maxlength">50</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="//forminfo/maintable/SUNDOADD" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">txtRead</xsl:attribute>
								<xsl:attribute name="readonly">readonly</xsl:attribute>
								<xsl:attribute name="value">
									<xsl:value-of select="//forminfo/maintable/SUNDOADD" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</input>
				</p>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="SUNDOSOFT_CEO">
		<div>
			<p>주식회사&nbsp;&nbsp;선도소프트</p>
			<p>대표이사&nbsp;&nbsp;윤&nbsp;&nbsp;재&nbsp;&nbsp;준</p>
		</div>
	</xsl:template>
	<xsl:template name="ESRIKOREA_CEO">
		<div>
			<p>주식회사&nbsp;&nbsp;한국ESRI</p>
			<p>대표이사&nbsp;&nbsp;윤&nbsp;&nbsp;재&nbsp;&nbsp;준</p>
		</div>
	</xsl:template>
	<xsl:template name="SUNDODATA_CEO">
		<div>
			<p>주식회사&nbsp;&nbsp;선도데이타</p>
			<p>대표이사&nbsp;&nbsp;이&nbsp;&nbsp;연&nbsp;&nbsp;희</p>
		</div>
	</xsl:template>

	<xsl:template match="//linkeddocinfo/linkeddoc">
		<div>
			<a target="_blank">
				<xsl:attribute name="href">
					<xsl:value-of select="reserved1" />
				</xsl:attribute>
				<xsl:value-of select="subject" />
			</a>
		</div>
	</xsl:template>
	<xsl:template match="//fileinfo/file[@isfile='Y']">
		<div>
			<a target="_blank">
				<xsl:attribute name="href">
					<xsl:value-of select="virtualpath" />/<xsl:value-of select="savedname" />
				</xsl:attribute>
				<xsl:value-of select="filename" />
			</a>
		</div>
	</xsl:template>
</xsl:stylesheet>
