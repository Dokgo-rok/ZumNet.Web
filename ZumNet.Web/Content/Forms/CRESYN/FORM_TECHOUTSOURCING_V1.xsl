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
					.m .fm1 {height:;vertical-align:top}
					.m .fm2 {height:;vertical-align:top}
					.m .fm3 {height:;vertical-align:top}
					.m .fm4 {height:;vertical-align:top}
					.m .fm-editor {height:500px;vertical-align:top;border:windowtext 1.5pt solid;}
					.m .fm-file {text-align:left}

					/* 폰트 */
					.fh h1 {font-family:굴림체;font-weight:bold;font-size:20.0pt;letter-spacing:0pt;}
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
					.fh .fh-r {width:100px}
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
					.m .ft .f-lbl1 {width:25px;text-align:center}
					.m .ft .f-lbl2 {width:50px;text-align:center}
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

					/* 인쇄 설정 : 맨하단으로 */
					@media print {
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
								<td style="width:25%;font-size:1px">&nbsp;</td>

								<td>
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '1')"/>
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
								<td class="f-lbl">문서번호</td>
								<td style="width:35%">
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
								<td class="f-lbl" style="border-bottom:0">작성일자</td>
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
								<td style="border-bottom:0;border-right:0">
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

					<div class="ff"></div>
					<div class="ff" />

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td rowspan="5" class="f-lbl1">수주내역</td>
								<td class="f-lbl">수주번호</td>
								<td style="border-right:0" colspan="6">
									<input type="text" name="PROJECTNO" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
                                              	<xsl:attribute name="style">border:1px solid red</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
                                                <xsl:attribute name="style">border:1px solid red</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PROJECTNO" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PROJECTNO" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="$mode!='read'">
											<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('order', 'PROJECTNAME', 'PROJECTNO');</xsl:attribute>
										</xsl:if>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">사업명</td>
								<td style="border-right:0" colspan="6">
									<input type="text" name="PROJECTNAME" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
                                                <xsl:attribute name="style">border:1px solid red</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
                                                <xsl:attribute name="style">border:1px solid red</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PROJECTNAME" />
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="value">
													<xsl:value-of select="//forminfo/maintable/PROJECTNAME" />
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:if test="$mode!='read'">
											<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('order', 'PROJECTNAME', 'PROJECTNO');</xsl:attribute>
										</xsl:if>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">발주처</td>
								<td style="border-right:0" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="ORDERORG" id="__mainfield">
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/ORDERORG" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/ORDERORG" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ORDERORG))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>

							<tr>
								<td class="f-lbl">계약금액</td>
								<td style="border-right:0" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="CONTRACTPRICE" id="__mainfield">
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="style">width:100px;</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/CONTRACTPRICE" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Right</xsl:attribute>
											<xsl:attribute name="style">width:100px;</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/CONTRACTPRICE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CONTRACTPRICE))" />
										</xsl:otherwise>
									</xsl:choose>&nbsp;(부가세 포함)
								</td>
							</tr>
							<tr>
								<td class="f-lbl">계약기간</td>
								<td style="border-right:0" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="CONTRACTSDATE" id="__mainfield">
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:100px;</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/CONTRACTSDATE" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Center</xsl:attribute>
											<xsl:attribute name="style">width:100px;</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/CONTRACTSDATE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CONTRACTSDATE))" />
										</xsl:otherwise>
									</xsl:choose>&nbsp;~&nbsp;
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="CONTRACTEDATE" id="__mainfield">
												<xsl:attribute name="readonly">readonly</xsl:attribute>
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:100px;</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/CONTRACTEDATE" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Center</xsl:attribute>
											<xsl:attribute name="style">width:100px;</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/CONTRACTEDATE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CONTRACTEDATE))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td rowspan="7" class="f-lbl1" >외주<br/>신청내역</td>
								<td class="f-lbl">외주예산금액</td>
								<td style="border-right:0" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="OUTPRICE" id="__mainfield">
												<xsl:attribute name="class">txtCurrency</xsl:attribute>
												<xsl:attribute name="style">width:100px;</xsl:attribute>
												<xsl:attribute name="maxlength">64</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/OUTPRICE" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Right</xsl:attribute>
											<xsl:attribute name="style">width:100px;</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/OUTPRICE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTPRICE))" />
										</xsl:otherwise>
									</xsl:choose>&nbsp;원
								</td>
							</tr>
							<tr>
								<td class="f-lbl">외주기간</td>
								<td style="border-right:0" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="OUTSDATE" id="__mainfield">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:100px;</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/OUTSDATE" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Center</xsl:attribute>
											<xsl:attribute name="style">width:100px;</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/OUTSDATE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTSDATE))" />
										</xsl:otherwise>
									</xsl:choose>&nbsp;~&nbsp;
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="OUTEDATE" id="__mainfield">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="style">width:100px;</xsl:attribute>
												<xsl:attribute name="maxlength">10</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/OUTEDATE" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead_Center</xsl:attribute>
											<xsl:attribute name="style">width:100px;</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/OUTEDATE" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEDATE))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">외주내역</td>
								<td style="border-right:0;height:220px;vertical-align:top" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="BIZCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/BIZCONTENTS))" />
											</div>
										</xsl:when>
										<xsl:when test="$mode='new'">
											<textarea name="BIZCONTENTS" id="__mainfield" onfocus="parent.fnTextboxKeyEvant(this);">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>상세하게 적어 주시기 바랍니다. 부족하면 별첨하고, 신청시 메일로 보내주시기 바랍니다.</textarea>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="BIZCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/BIZCONTENTS" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">요청업무<br />(자격,능력)</td>
								<td style="border-right:0;height:60px;vertical-align:top" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="REQCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/REQCONTENTS))" />
											</div>
										</xsl:when>
										<xsl:when test="$mode='new'">
											<textarea name="REQCONTENTS" id="__mainfield" onfocus="parent.fnTextboxKeyEvant(this);">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>예)  1. Flex 개발가능자, -중급 1M/M, 초급 2M/M,
     2. 자바 고급 1M/M, 중급 1M/M 등</textarea>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="REQCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/REQCONTENTS" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl" rowspan="2">업체추천</td>
								<td class="f-lbl2">1.업체명</td>
								<td class="f-lbl">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECCOMP1" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">200</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECCOMP1" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RECCOMP1" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECCOMP1))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl2">전화</td>
								<td class="f-lbl">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECTEL1" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">30</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECTEL1" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RECTEL1" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECTEL1))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td style="width:65px;text-align:center">E-Mail주소</td>
								<td class="f-lbl" style="border-right:0;">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECEMAIL1" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECEMAIL1" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RECEMAIL1" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECEMAIL1))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl2">2.업체명</td>
								<td class="f-lbl">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECCOMP2" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">200</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECCOMP2" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RECCOMP2" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECCOMP2))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td class="f-lbl2">전화</td>
								<td class="f-lbl">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECTEL2" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">30</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECTEL2" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RECTEL2" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECTEL2))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
								<td style="width:65px;text-align:center">E-Mail주소</td>
								<td class="f-lbl" style="border-right:0;">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECEMAIL2" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECEMAIL2" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//forminfo/maintable/RECEMAIL2" />
										</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECEMAIL2))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">외주업무<br />수행장소</td>
								<td style="border-right:0;height:60px;vertical-align:top" colspan="6">
									<xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="OUTCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/OUTCONTENTS))" />
											</div>
										</xsl:when>
										<xsl:when test="$mode='new'">
											<textarea name="OUTCONTENTS" id="__mainfield" onfocus="parent.fnTextboxKeyEvant(this);">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>반드시 주소 번지까지 정확하게 기재할 것.</textarea>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="OUTCONTENTS" id="__mainfield">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/OUTCONTENTS" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td colspan="2" style="text-align:center;border-bottom:0">부서 협조 확인</td>
								<td style="border-right:0;height:45px;border-bottom:0" colspan="6">
									당사의 중복되는 부서에서 반드시 확인 받을 것.
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
								<td style="text-align:center;width:127">영업담당자</td>
								<td style="border-right:0">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="BIZCHARGER" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/BIZCHARGER" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/BIZCHARGER" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BIZCHARGER))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td style="text-align:center;width:127">업체 추천 사유</td>
								<td style="border-right:0">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="RECREASON" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/RECREASON" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/RECREASON" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECREASON))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td style="text-align:center;width:127">외주 사유</td>
								<td style="border-right:0">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="OUTREASON" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/OUTREASON" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/OUTREASON" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTREASON))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
							<tr>
								<td style="text-align:center;width:127;border-bottom:0">기타</td>
								<td style="border-right:0;border-bottom:0">
									<xsl:choose>
										<xsl:when test="$mode='new' or $mode='edit'">
											<input type="text" name="ETC" id="__mainfield">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/ETC" />
													</xsl:attribute>
												</xsl:if>
											</input>
										</xsl:when>
										<xsl:otherwise>
											<!--<xsl:attribute name="class">txtRead</xsl:attribute>
											<xsl:attribute name="readonly">readonly</xsl:attribute>
											<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/ETC" />
											</xsl:attribute>-->
											<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ETC))" />
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</table>
					</div>

					<div class="fm">
						<span style="text-align:left;width:100%">* 외주신청 상세내역란에 해당사항을 기입하세요.</span>
						<br/>
						<span style="text-align:left;width:100%">* 첨부 : 실행예산 품의서, 견적서, 기타관련서류 첨부</span>
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
