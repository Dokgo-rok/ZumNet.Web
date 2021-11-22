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

					.m {width:1000px;vertical-align:top;}
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
					.fh h1 {font-family:굴림체;font-weight:bold;font-size:20.0pt;letter-spacing:15pt;}
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
					.m .ft .f-lbl1 {width:12%;text-align:center}
					.m .ft .f-lbl2 {width:?;text-align:center}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}
					.fm span {text-align:center}

					/* 본문 하위 테이블 */
					.m .ft-sub {border:windowtext 1.5pt solid}
					.m .ft-sub td {height:24px;border-right:windowtext 1pt solid;border-top:windowtext 1pt solid;padding-left:2px;padding-right:2px;padding-top:0px}
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
									<xsl:attribute name="value">/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
								</xsl:attribute>
							</input>
						</xsl:otherwise>
					</xsl:choose>
				</div>

				<div class="ff" />

				<div class="fb">
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td style="width:50%">
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
											<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5')"/>
										</td>
									</tr>
								</table>
							</td>

							<td style="width:20%;font-size:1px">&nbsp;</td>

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
								<td class="f-lbl1" style="border-bottom:0">문서번호</td>
								<td class="f-lbl1" style="border-bottom:0">
									<input type="text" id="DocNumber" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//docinfo/docnumber" />
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl1" style="border-bottom:0">작성부서</td>
								<td class="f-lbl1" style="border-bottom:0">
									<input type="text" id="CreatorDept" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//creatorinfo/department" />
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl1" style="border-bottom:0">작성일자</td>
								<td class="f-lbl1" style="border-bottom:0">
									<input type="text" id="CreateDate" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl1" style="border-bottom:0">작성자</td>
								<td class="f-lbl1" style="border-bottom:0;border-right:0">
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
					<div class="ff" />

					<div class="fm">
						<table border="0" cellspacing="0" cellpadding="0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<tr>
										<td style="text-align:left">
											<span>A. 지출결의</span>
										</td>
										<td style="text-align:right">
											<span>(단위 : 원)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<button onclick="parent.fnAddRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01">
													<xsl:attribute name="src">
														/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
													</xsl:attribute>
												</img>추가
											</button>
											<button onclick="parent.fnDelRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01">
													<xsl:attribute name="src">
														/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
													</xsl:attribute>
												</img>삭제
											</button>
										</td>
									</tr>
									<tr>
										<td>
											<div class="ff" />
											<div class="ff" />
										</td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="text-align:left">
											<span>A. 지출결의</span>
										</td>
										<td style="text-align:right">
											<span>(단위 : 원)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										</td>
									</tr>
									<tr>
										<td>
											<div class="ff" />
											<div class="ff" />
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>

							<tr>
								<td colspan="2">
									<table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
										<tr style="height:25">
											<td class="f-lbl-sub" style="width:202px;border-top:0">Site-Proj</td>
											<td class="f-lbl-sub" style="width:75px;border-top:0">일자</td>
											<td class="f-lbl-sub" style="width:100px;border-top:0">항목</td>
											<td class="f-lbl-sub" style="width:100px;border-top:0">지출조건</td>
											<td class="f-lbl-sub" style="width:80px;border-top:0">카드명</td>
											<td class="f-lbl-sub" style="width:;border-top:0">업무내용</td>
											<td class="f-lbl-sub" style="width:60px;border-top:0">금액</td>
											<td class="f-lbl-sub" style="width:100px;border-top:0">지출선</td>
											<td class="f-lbl-sub" style="width:120px;border-top:0;border-right:0">특기사항</td>
										</tr>
										<xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
									</table>
								</td>
							</tr>
						</table>
					</div>

					<div class="ff" />
					<div class="ff" />

					<div class="fm">
						<table border="0" cellspacing="0" cellpadding="0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<tr>
										<td style="text-align:left">
											<span>B. 외출비</span>
										</td>
										<td style="text-align:right">
											<span>(단위 : 원)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<button onclick="parent.fnAddRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01">
													<xsl:attribute name="src">
														/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
													</xsl:attribute>
												</img>추가
											</button>
											<button onclick="parent.fnDelRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01">
													<xsl:attribute name="src">
														/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
													</xsl:attribute>
												</img>삭제
											</button>
										</td>
									</tr>
									<tr>
										<td>
											<div class="ff" />
											<div class="ff" />
										</td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="text-align:left">
											<span>B. 외출비</span>
										</td>
										<td style="text-align:right">
											<span>(단위 : 원)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										</td>
									</tr>
									<tr>
										<td>
											<div class="ff" />
											<div class="ff" />
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
							<tr>
								<td colspan="2">
									<table id="__subtable2" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
										<tr style="height:25">
											<td class="f-lbl-sub" style="width:262px;border-top:0">Site-Proj</td>
											<td class="f-lbl-sub" style="width:75px;border-top:0">일자</td>
											<td class="f-lbl-sub" style="width:120px;border-top:0">교통수단</td>
											<td class="f-lbl-sub" style="width:;border-top:0">업무내용</td>
											<td class="f-lbl-sub" style="width:159px;border-top:0">경유지</td>
											<td class="f-lbl-sub" style="width:60px;border-top:0;border-right:0">금액</td>
										</tr>
										<xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
									</table>
								</td>
							</tr>
						</table>
					</div>

					<div class="ff" />
					<div class="ff" />

					<div class="fm">
						<table border="0" cellspacing="0" cellpadding="0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<tr>
										<td style="text-align:left">
											<span>C. 차량유지비</span>
										</td>
										<td style="text-align:right">
											<span>(단위 : 원)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											<button onclick="parent.fnAddRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01">
													<xsl:attribute name="src">
														/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
													</xsl:attribute>
												</img>추가
											</button>
											<button onclick="parent.fnDelRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01">
													<xsl:attribute name="src">
														/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
													</xsl:attribute>
												</img>삭제
											</button>
										</td>
									</tr>
									<tr>
										<td>
											<div class="ff" />
											<div class="ff" />
										</td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="text-align:left">
											<span>C. 차량유지비</span>
										</td>
										<td style="text-align:right">
											<span>(단위 : 원)</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										</td>
									</tr>
									<tr>
										<td>
											<div class="ff" />
											<div class="ff" />
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
							<tr>
								<td colspan="2">
									<table id="__subtable3" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
										<tr style="height:25">
											<td class="f-lbl-sub" style="width:262px;border-top:0">Site-Proj</td>
											<td class="f-lbl-sub" style="width:75px;border-top:0">일자</td>
											<td class="f-lbl-sub" style="width:120px;border-top:0">차량/주차/통행료</td>
											<td class="f-lbl-sub" style="width:;border-top:0">업무내용</td>
											<td class="f-lbl-sub" style="width:159px;border-top:0">경유지</td>
											<td class="f-lbl-sub" style="width:60px;border-top:0">주행거리(Km)</td>
											<td class="f-lbl-sub" style="width:60px;border-top:0">적용단가</td>
											<td class="f-lbl-sub" style="width:60px;border-top:0;border-right:0">금액</td>
										</tr>
										<xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
									</table>
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

	<xsl:template match="//forminfo/subtables/subtable1/row">
		<tr class="sub_table_row">
			<td style="display:none;">
				<input type="text" name="ROWSEQ">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtNo</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="readonly">readonly</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="ROWSEQ" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="EXPROJECTNAME">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="style">border:1px solid red</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXPROJECTNAME" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXPROJECTNAME" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$mode!='read'">
						<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('project', this, 'next');</xsl:attribute>
					</xsl:if>
				</input>
				<input type="text" name="EXPROJECTNO" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="EXPROJECTNO" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="EXDATE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtDate</xsl:attribute>
							<xsl:attribute name="maxlenth">8</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXDATE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Center</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXDATE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td>
				<input type="text" name="EXITEM">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="maxlenth">100</xsl:attribute>
                            <xsl:attribute name="style">border:1px solid red</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXITEM" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXITEM" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$mode!='read'">
						<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('item', this,'');</xsl:attribute>
					</xsl:if>
				</input>
				<input type="text" name="ACCOUNTCODE" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="ACCOUNTCODE" />
					</xsl:attribute>
				</input>
				<input type="text" name="CURRENCYACCOUNT" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="CURRENCYACCOUNT" />
					</xsl:attribute>
				</input>
				<input type="text" name="CREDITACCOUNT" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="CREDITACCOUNT" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<input  style="width:100%" type="text" name="EXCONDITION">
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXCONDITION" />
							</xsl:attribute>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<select style="width:100%" class="txtRead" name="EXCONDITION" onchange="parent.fnExpenseCondition(this);">
							<xsl:choose>
								<xsl:when test="EXCONDITION[.='']">
									<option value="" selected="true">선택</option>
									<option value="간이영수증">간이영수증</option>
									<option value="개인카드">개인카드</option>
									<option value="법인카드">법인카드</option>
									<option value="현금영수증">현금영수증</option>
									<option value="부서사용">부서사용</option>
								</xsl:when>
								<xsl:when test="EXCONDITION[.='간이영수증']">
									<option value="">선택</option>
									<option value="간이영수증" selected="true">간이영수증</option>
									<option value="개인카드">개인카드</option>
									<option value="법인카드">법인카드</option>
									<option value="현금영수증">현금영수증</option>
									<option value="부서사용">부서사용</option>
								</xsl:when>
								<xsl:when test="EXCONDITION[.='개인카드']">
									<option value="">선택</option>
									<option value="간이영수증">간이영수증</option>
									<option value="개인카드" selected="true">개인카드</option>
									<option value="법인카드">법인카드</option>
									<option value="현금영수증">현금영수증</option>
									<option value="부서사용">부서사용</option>
								</xsl:when>
								<xsl:when test="EXCONDITION[.='법인카드']">
									<option value="">선택</option>
									<option value="간이영수증">간이영수증</option>
									<option value="개인카드">개인카드</option>
									<option value="법인카드" selected="true">법인카드</option>
									<option value="현금영수증">현금영수증</option>
									<option value="부서사용">부서사용</option>
								</xsl:when>
								<xsl:when test="EXCONDITION[.='현금영수증']">
									<option value="" selected="true">선택</option>
									<option value="간이영수증">간이영수증</option>
									<option value="개인카드">개인카드</option>
									<option value="법인카드">법인카드</option>
									<option value="현금영수증" selected="true">현금영수증</option>
									<option value="부서사용">부서사용</option>
								</xsl:when>
								<xsl:when test="EXCONDITION[.='부서사용']">
									<option value="" selected="true">선택</option>
									<option value="간이영수증">간이영수증</option>
									<option value="개인카드">개인카드</option>
									<option value="법인카드">법인카드</option>
									<option value="현금영수증">현금영수증</option>
									<option value="부서사용" selected="true">부서사용</option>
								</xsl:when>
								<xsl:otherwise>
									<option value="" selected="true">선택</option>
									<option value="간이영수증">간이영수증</option>
									<option value="개인카드">개인카드</option>
									<option value="법인카드">법인카드</option>
									<option value="현금영수증">현금영수증</option>
									<option value="부서사용">부서사용</option>
								</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:otherwise>
				</xsl:choose>
				<input type="text" name="SELECTACCOUNT" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="SELECTACCOUNT" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="CARDNAME">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="style">border:1px solid red</xsl:attribute>
							<xsl:attribute name="maxlenth">30</xsl:attribute>
							<xsl:attribute name="readonly">true</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARDNAME" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="maxlenth">30</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARDNAME" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$mode!='read'">
						<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('card', this, 'next', 'non');</xsl:attribute>
					</xsl:if>
				</input>
				<input type="text" name="CARDNUM" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="CARDNUM" />
					</xsl:attribute>
				</input>
			</td>
			<td style="height:20px;vertical-align:middle">
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<div name="BUSINESSCONT">
							<xsl:attribute name="class">txaRead</xsl:attribute>
							<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(BUSINESSCONT))" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<textarea name="BUSINESSCONT">
							<xsl:attribute name="class">txaText</xsl:attribute>
							<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
							<xsl:if test="$mode='edit'">
								<xsl:value-of select="BUSINESSCONT" />
							</xsl:if>
						</textarea>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<input type="text" name="COST">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtCurrency</xsl:attribute>
							<xsl:attribute name="maxlenth">15</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="COST" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="COST" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td>
				<input type="text" name="EXPENSELINE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="maxlenth">500</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXPENSELINE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="EXPENSELINE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td style="border-right:0;height:25px;vertical-align:middle;border-right:0">
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<div name="CONTENTS">
							<xsl:attribute name="class">txaRead</xsl:attribute>
							<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(CONTENTS))" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<textarea name="CONTENTS">
							<xsl:attribute name="class">txaText</xsl:attribute>
							<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
							<xsl:if test="$mode='edit'">
								<xsl:value-of select="CONTENTS" />
							</xsl:if>
						</textarea>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="//forminfo/subtables/subtable2/row">
		<tr class="sub_table_row">
			<td style="display:none;">
				<input type="text" name="ROWSEQ">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtNo</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="readonly">readonly</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="ROWSEQ" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="OUTPROJECTNAME">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="style">border:1px solid red</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTPROJECTNAME" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTPROJECTNAME" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$mode!='read'">
						<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('project', this, 'next');</xsl:attribute>
					</xsl:if>
				</input>
				<input type="text" name="OUTPROJECTNO" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="OUTPROJECTNO" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="OUTDATE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtDate</xsl:attribute>
							<xsl:attribute name="maxlenth">8</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTDATE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Center</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTDATE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<input  style="width:100%" type="text" name="TRAFFICNAME">
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="TRAFFICNAME" />
							</xsl:attribute>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<select style="width:100%" class="txtRead" name="TRAFFICNAME">
							<xsl:choose>
								<xsl:when test="EXCONDITION[.='']">
									<option value="" selected="true">선택</option>
									<option value="택시">택시</option>
									<option value="지하철">지하철</option>
									<option value="버스">버스</option>
									<option value="기차">기차</option>
									<option value="비행기">비행기</option>
								</xsl:when>
								<xsl:when test="TRAFFICNAME[.='택시']">
									<option value="">선택</option>
									<option value="택시" selected="true">택시</option>
									<option value="지하철">지하철</option>
									<option value="버스">버스</option>
									<option value="기차">기차</option>
									<option value="비행기">비행기</option>
								</xsl:when>
								<xsl:when test="TRAFFICNAME[.='지하철']">
									<option value="">선택</option>
									<option value="택시">택시</option>
									<option value="지하철" selected="true">지하철</option>
									<option value="버스">버스</option>
									<option value="기차">기차</option>
									<option value="비행기">비행기</option>
								</xsl:when>
								<xsl:when test="TRAFFICNAME[.='버스']">
									<option value="">선택</option>
									<option value="택시">택시</option>
									<option value="지하철">지하철</option>
									<option value="버스" selected="true">버스</option>
									<option value="기차">기차</option>
									<option value="비행기">비행기</option>
								</xsl:when>
								<xsl:when test="TRAFFICNAME[.='기차']">
									<option value="">선택</option>
									<option value="택시">택시</option>
									<option value="지하철">지하철</option>
									<option value="버스">버스</option>
									<option value="기차" selected="true">기차</option>
									<option value="비행기">비행기</option>
								</xsl:when>
								<xsl:when test="TRAFFICNAME[.='비행기']">
									<option value="">선택</option>
									<option value="택시">택시</option>
									<option value="지하철">지하철</option>
									<option value="버스">버스</option>
									<option value="기차">기차</option>
									<option value="비행기" selected="true">비행기</option>
								</xsl:when>
								<xsl:otherwise>
									<option value="" selected="true">선택</option>
									<option value="택시">택시</option>
									<option value="지하철">지하철</option>
									<option value="버스">버스</option>
									<option value="기차">기차</option>
									<option value="비행기">비행기</option>
								</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td style="height:25px;vertical-align:middle;">
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<div name="OUTBUSINESSCONT">
							<xsl:attribute name="class">txaRead</xsl:attribute>
							<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(OUTBUSINESSCONT))" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<textarea name="OUTBUSINESSCONT">
							<xsl:attribute name="class">txaText</xsl:attribute>
							<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
							<xsl:if test="$mode='edit'">
								<xsl:value-of select="OUTBUSINESSCONT" />
							</xsl:if>
						</textarea>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<input type="text" name="OUTVIAPLACE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="maxlenth">500</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTVIAPLACE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTVIAPLACE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td style="border-right:0;">
				<input type="text" name="OUTCOST">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtCurrency</xsl:attribute>
							<xsl:attribute name="maxlenth">15</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTCOST" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="OUTCOST" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="//forminfo/subtables/subtable3/row">
		<tr class="sub_table_row">
			<td style="display:none;">
				<input type="text" name="ROWSEQ">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtNo</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:attribute name="readonly">readonly</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="ROWSEQ" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="CARPROJECTNNAME">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="style">border:1px solid red</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARPROJECTNNAME" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARPROJECTNNAME" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="$mode!='read'">
						<xsl:attribute name="onkeyup">parent.PROJECTNO_onkeyup('project', this, 'next');</xsl:attribute>
					</xsl:if>
				</input>
				<input type="text" name="CARPROJECTNO" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="CARPROJECTNO" />
					</xsl:attribute>
				</input>
			</td>
			<td>
				<input type="text" name="CARDATE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtDate</xsl:attribute>
							<xsl:attribute name="maxlenth">8</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARDATE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Center</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARDATE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<input  style="width:100%" type="text" name="CARITEMNAME">
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARITEMNAME" />
							</xsl:attribute>
						</input>
					</xsl:when>
					<xsl:otherwise>
						<select style="width:100%" class="txtRead" name="CARITEMNAME" onchange="parent.fnExpenseItemChange(this)">
							<xsl:choose>
								<xsl:when test="CARITEMNAME[.='']">
									<option value="" selected="true">선택</option>
									<option value="가솔린">가솔린</option>
									<option value="경유">경유</option>
									<option value="LPG">LPG</option>
									<option value="통행료">통행료</option>
									<option value="주차료">주차료</option>
								</xsl:when>
								<xsl:when test="CARITEMNAME[.='가솔린']">
									<option value="">선택</option>
									<option value="가솔린" selected="true">가솔린</option>
									<option value="경유">경유</option>
									<option value="LPG">LPG</option>
									<option value="통행료">통행료</option>
									<option value="주차료">주차료</option>
								</xsl:when>
								<xsl:when test="CARITEMNAME[.='경유']">
									<option value="">선택</option>
									<option value="가솔린">가솔린</option>
									<option value="경유" selected="true">경유</option>
									<option value="LPG">LPG</option>
									<option value="통행료">통행료</option>
									<option value="주차료">주차료</option>
								</xsl:when>
								<xsl:when test="CARITEMNAME[.='LPG']">
									<option value="">선택</option>
									<option value="가솔린">가솔린</option>
									<option value="경유">경유</option>
									<option value="LPG" selected="true">LPG</option>
									<option value="통행료">통행료</option>
									<option value="주차료">주차료</option>
								</xsl:when>
								<xsl:when test="CARITEMNAME[.='통행료']">
									<option value="">선택</option>
									<option value="가솔린">가솔린</option>
									<option value="경유">경유</option>
									<option value="LPG">LPG</option>
									<option value="통행료" selected="true">통행료</option>
									<option value="주차료">주차료</option>
								</xsl:when>
								<xsl:when test="CARITEMNAME[.='주차료']">
									<option value="">선택</option>
									<option value="가솔린">가솔린</option>
									<option value="경유">경유</option>
									<option value="LPG">LPG</option>
									<option value="통행료">통행료</option>
									<option value="주차료" selected="true">주차료</option>
								</xsl:when>
								<xsl:otherwise>
									<option value="" selected="true">선택</option>
									<option value="가솔린">가솔린</option>
									<option value="경유">경유</option>
									<option value="LPG">LPG</option>
									<option value="통행료">통행료</option>
									<option value="주차료">주차료</option>
								</xsl:otherwise>
							</xsl:choose>
						</select>
					</xsl:otherwise>
				</xsl:choose>
				<input type="text" name="CARITEMCODE" style="display:none;">
					<xsl:attribute name="value">
						<xsl:value-of select="CARITEMCODE" />
					</xsl:attribute>
				</input>
			</td>
			<td style="height:20px;vertical-align:middle">
				<xsl:choose>
					<xsl:when test="$mode='read'">
						<div name="CARBUSINESSCONT">
							<xsl:attribute name="class">txaRead</xsl:attribute>
							<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(CARBUSINESSCONT))" />
						</div>
					</xsl:when>
					<xsl:otherwise>
						<textarea name="CARBUSINESSCONT">
							<xsl:attribute name="class">txaText</xsl:attribute>
							<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
							<xsl:if test="$mode='edit'">
								<xsl:value-of select="CARBUSINESSCONT" />
							</xsl:if>
						</textarea>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<input type="text" name="CARVIAPLACE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="maxlenth">100</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARVIAPLACE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARVIAPLACE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			
			<td>
				<input type="text" name="CARMILEAGE">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtDollar1</xsl:attribute>
							<xsl:attribute name="maxlenth">20</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="onkeyup">parent.fnExpenseCalSum(this);</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARMILEAGE" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARMILEAGE" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td >
				<input type="text" name="CARUNIT">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtText</xsl:attribute>
							<xsl:attribute name="maxlenth">20</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARUNIT" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARUNIT" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
			<td style="border-right:0">
				<input type="text" name="CARCOST">
					<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<xsl:attribute name="class">txtCurrency</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARCOST" />
							</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">txtRead_Right</xsl:attribute>
							<xsl:attribute name="readonly">readonly</xsl:attribute>
							<xsl:attribute name="value">
								<xsl:value-of select="CARCOST" />
							</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
			</td>
		</tr>
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
