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
				<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
				<style type="text/css">
					html, body {
					margin:0px;
					padding:0px;
					}
					body {
					margin-bottom:2px;
					border:0;
					background-color:#ffffff;
					text-align:center;
					overflow:auto
					}
					.m {
					width:680px;
					vertical-align:top;
					}
					.m .ff {
					height:2px;
					font-size:1px;
					vertical-align:top
					}
					.m .fh {
					height:60px;
					vertical-align:top
					}
					.m .fb {
					height:80px;
					vertical-align:top
					}
					.m .fm {
					height:;
					vertical-align:top
					}
					.m .fm1 {
					height:;
					vertical-align:top
					}
					.m .fm2 {
					height:;
					vertical-align:top
					}
					.m .fm3 {
					height:;
					vertical-align:top
					}
					.m .fm4 {
					height:;
					vertical-align:top
					}
					.m .fm-editor {
					height:500px;
					vertical-align:top;
					border:windowtext 1.5pt solid;
					}
					.m .fm-file {text-align:left}
					/* 폰트 */
					.fh h1 {
					font-family:굴림체;
					font-weight:bold;
					font-size:20.0pt;
					letter-spacing:15pt;
					}
					.si-tbl td {
					font-size:13px;
					font-family:맑은 고딕
					}
					.m .ft td, .m .ft input, .m .ft select, .m .ft-sub td, .m .ft-sub input, .m .ft-sub select {
					font-size:13px;
					font-family:맑은 고딕
					}
					.m .fm span {
					font-size:13px;
					font-family:맑은 고딕
					}
					/* 로고 및 양식명 */
					.fh table {
					width:100%;
					height:100%
					}
					.fh .fh-l {
					width:150px;
					text-align:center
					}
					.fh .fh-m {
					padding-top:15px;
					text-align:center
					}
					.fh .fh-r {
					width:150px
					}
					.fh .fh-l img {
					border:0px solid red;
					vertical-align:middle;
					margin-top:0px
					}
					.m .fm-file td, .m .fm-file td a {font-size:13px;font-family:맑은 고딕}
					/* 결재칸 */
					.si-tbl {
					border:windowtext 1.5pt solid
					}
					.si-tbl td {
					vertical-align:middle;
					border-right:windowtext 1pt solid;
					border-bottom:windowtext 1pt solid
					}
					.si-tbl .si-title {
					width:5%;
					text-align:center
					}
					.si-tbl .si-top {
					height:20px;
					text-align:center;
					padding-top:2px
					}
					.si-tbl .si-middle {
					height:65px;
					text-align:center
					}
					.si-tbl .si-bottom {
					height:20px;
					text-align:center;
					width:19%
					}
					.si-tbl img {
					margin:0px
					}
					/* 버튼 스타일 */
					.btn_bg {
					height:21px;
					border:1 solid #b1b1b1;
					background:url('/<xsl:value-of select="$root"/>
					/EA/Images/btn_bg.gif');background-color:#ffffff;
					font-size:11px;
					letter-spacing:-1px;
					margin:0 2 0 2;
					padding:0 0 0 0;
					vertical-align:middle;
					cursor:hand;
					}
					img.blt01 {
					margin:0 2 0 -2;
					vertical-align:middle;
					}
					.si-tbl img {
					margin:0px
					}
					/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
					.m .ft {
					border:windowtext 1.5pt solid
					}
					.m .ft td {
					height:24px;
					border-right:windowtext 1pt solid;
					border-bottom:windowtext 1pt solid;
					padding-left:2px;
					padding-right:2px;
					padding-top:1px
					}
					.m .ft .f-lbl {
					width:15%;
					text-align:center
					}
					.m .ft .f-lbl1 {
					width:?;
					text-align:center
					}
					.m .ft .f-lbl2 {
					width:?;
					text-align:center
					}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {
					width:100%;
					height:100%
					}
					.fm span {
					text-align:center
					}
					/* 본문 하위 테이블 */
					.m .ft-sub {
					border:windowtext 1.5pt solid
					}
					.m .ft-sub td {
					height:24px;
					border-right:windowtext 1pt solid;
					border-top:windowtext 1pt solid;
					padding-left:2px;
					padding-right:2px;
					padding-top:1px
					}
					.m .ft-sub .f-lbl-sub {
					text-align:center;
					}
					/* 첨부파일 */
					.m .fm-file table {width:;height:100%}
					.m .fm-file td.file-title {vertical-align:top}
					.m .fm-file td.file-end {vertical-align:bottom;padding:0 0 3px 10px}
					.m .fm-file td.file-info {vertical-align:top}
					.m .fm-file td.file-info div {height:20px}
					/* 각종 필드 정의 - txt : input, txa : textarea */
					.m .txtText {
					ime-mode:active;
					width:100%;
					padding-top:2px
					}
					.m .txtText_m {
					ime-mode:active;
					width:100%;
					border:1px solid red;
					;
					padding-top:2px
					}
					.m .txaText {
					ime-mode:active;
					width:100%;
					overflow:auto
					}
					.m .txtNo {
					width:100%;
					padding-top:2px;
					padding-right:2;
					text-align:right
					}
					.m .txtNumberic {
					width:100%;
					padding-top:2px;
					direction:rtl;
					padding-right:2;
					ime-mode:disabled
					}
					.m .txtJuminDash {
					width:100%;
					padding-top:2px;
					padding-right:2;
					text-align:center;
					ime-mode:disabled
					}
					.m .txtCurrency, .m .txtDollar, .m .txtDollar1, .m .txtDollar2, .m .txtDollarMinus1, .m .txtDollarMinus2, .m .txtDollarMinus3 {
					direction:rtl;
					ime-mode:active;
					width:100%;
					padding-top:2px;
					padding-right:2;
					text-align:right;
					}
					.m .txtDate {
					ime-mode:disabled;
					width:80;
					padding-top:2px;
					text-align:center
					}
					.m .txtMonth {
					ime-mode:disabled;
					width:25;
					padding-top:2px;
					text-align:center
					}
					.m .txtHHmm {
					ime-mode:disabled;
					width:60;
					padding-top:2px;
					text-align:center
					}
					.m .txtHHmmss {
					ime-mode:disabled;
					width:25;
					padding-top:2px;
					text-align:center
					}
					.m .txttime {
					ime-mode:disabled;
					width:25;
					padding-top:2px;
					text-align:center
					}
					.m .txtCalculate {
					ime-mode:active;
					width:100%;
					padding-top:2px;
					padding-right:2
					}
					.m .txaRead {
					width:100%;
					text-align:left
					}
					.m .txtRead {
					width:100%;
					border:0;
					padding-top:2px
					}
					.m .txtRead_Right {
					width:100%;
					border:0;
					padding-top:2px;
					padding-right:2;
					text-align:right
					}
					.m .txtRead_Center {
					width:100%;
					border:0;
					padding-top:2px;
					text-align:center
					}
					.m .ddlSelect {
					width:100%
					}

					/* 인쇄 설정 : 맨하단으로 */
					@media print {
					.m .fm-editor {height:}
					.m .fm-file td a {text-decoration:none;color:#000000}
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

					<div class="ff"/>

					<div class="fb">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:60%">
									<table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5')" />
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

					<div class="ff"/>
					<div class="ff"/>

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="f-lbl">문서번호</td>
								<td style="width:35%" colspan="2">
									<input type="text" id="DocNumber" name="__commonfield">
										<xsl:attribute name="class">txtRead</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//docinfo/docnumber"/>
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl">작성부서</td>
								<td style="border-right:0" colspan="2">
									<input type="text" id="CreatorDept" name="__commonfield">
										<xsl:attribute name="class">txtRead_Center</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//creatorinfo/department"/>
										</xsl:attribute>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl" style="border-bottom:0">작성일자</td>
								<td style="border-bottom:0">
									<input type="text" id="CreateDate" name="__commonfield">
										<xsl:attribute name="class">txtRead_Center</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of disable-output-escaping="yes"
												select="phxsl:convertDate(string(//docinfo/createdate), '')"
											/>
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl" style="border-bottom:0">직위</td>
								<td class="f-lbl" style="border-bottom:0">
									<input type="text" id="CreatorGrade" name="__commonfield">
										<xsl:attribute name="class">txtRead_Center</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//creatorinfo/grade"/>
										</xsl:attribute>
									</input>
								</td>
								<td class="f-lbl" style="border-bottom:0">작성자</td>
								<td style="border-bottom:0;border-right:0">

									<input type="text" id="Creator" name="__commonfield">
										<xsl:attribute name="class">txtRead_Center</xsl:attribute>
										<xsl:attribute name="readonly">readonly</xsl:attribute>
										<xsl:attribute name="value">
											<xsl:value-of select="//creatorinfo/name"/>
										</xsl:attribute>
									</input>
								</td>
							</tr>
						</table>
					</div>
					<div class="ff"/>

					<div class="fm">
						<table class="ft" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td align="center" >휴일근무일</td>
								<td class="f-lbl" >근무일</td>
								<td style="border-right:0"><input type="text" name="WORKSTDAY"
										id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKSTDAY"/>
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="readonly"
												>readonly</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKSTDAY"/>
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose></input> 일 <input type="text" name="WORKSTTIME"
										id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtHHmm</xsl:attribute>
												<xsl:attribute name="maxlength">4</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtHHmm</xsl:attribute>
												<xsl:attribute name="maxlength">4</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKSTTIME"/>
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtHHmm</xsl:attribute>
												<xsl:attribute name="readonly"
												>readonly</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKSTTIME"/>
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input> 시:분~ <input type="text" name="WORKENDAY"
										id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="maxlength">12</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKENDAY"/>
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtDate</xsl:attribute>
												<xsl:attribute name="readonly"
												>readonly</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKENDAY"/>
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input> 일 <input type="text" name="WORKENDTIME"
										id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtHHmm</xsl:attribute>
												<xsl:attribute name="maxlength">4</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtHHmm</xsl:attribute>
												<xsl:attribute name="maxlength">4</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKENDTIME"/>
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtHHmm</xsl:attribute>
												<xsl:attribute name="readonly"
												>readonly</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/WORKENDTIME"/>
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input> &nbsp; &nbsp; (<input type="text" name="TOTALTIME" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txttime</xsl:attribute>
												<xsl:attribute name="maxlength">3</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txttime</xsl:attribute>
												<xsl:attribute name="maxlength">3</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/TOTALTIME"/>
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txttime</xsl:attribute>
												<xsl:attribute name="readonly"
												>readonly</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of
												select="//forminfo/maintable/TOTALTIME"/>
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>)시간</td>
							</tr>

							<tr>
								<td class="f-lbl" rowspan="3" style="width: 80px">휴일근무내용</td>
								<td class="f-lbl">근무사유</td>
								<td style="border-right:0">
									<input type="text" name="REASON" id="__mainfield">
										<xsl:choose>
											<xsl:when test="$mode='new'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
											</xsl:when>
											<xsl:when test="$mode='edit'">
												<xsl:attribute name="class">txtText</xsl:attribute>
												<xsl:attribute name="maxlength">100</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/REASON"
												/>
												</xsl:attribute>
											</xsl:when>
											<xsl:otherwise>
												<xsl:attribute name="class">txtRead</xsl:attribute>
												<xsl:attribute name="readonly"
												>readonly</xsl:attribute>
												<xsl:attribute name="value">
												<xsl:value-of select="//forminfo/maintable/REASON"
												/>
												</xsl:attribute>
											</xsl:otherwise>
										</xsl:choose>
									</input>
								</td>
							</tr>
							<tr>
								<td class="f-lbl">세부작업내용</td>
								<td style="border-right:0">
                                
                                <xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="WORKDETAIL" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/WORKDETAIL))" />
											</div>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="WORKDETAIL" id="__mainfield" rows="10">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/WORKDETAIL" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>
                                
                                
                                
								</td>
							</tr>
							<tr>
								<td class="f-lbl">보고사항</td>
								<td style="border-right:0">
								     <xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="REPORT" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/REPORT))" />
											</div>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="REPORT" id="__mainfield" rows="10">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/REPORT" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>
																		</td>
							</tr>

							<tr>
								<td align="center" style="width: 80px;border-bottom:0"><b>* 유의 사항</b></td>
								<td colspan="2" style="border-bottom:0;border-right=0"><br />1. 휴일근무가 필요한지
									사전에 충분한 검토 후 근무합니다.<br/> &nbsp; - 휴일근무가 필요할 정도의 긴급 또는 추가된
									업무인지?<br/> &nbsp; - 일상업무의 시간관리 미흡으로 인한 사유인지?<br/> &nbsp; -
									근무대상자, 인원수 등이 적절한지?<br/> 2. 휴일근무 사유에 타부서의 요청내역, 업무지시서 등의 근거에 대해
									자세히 기재합니다.<br/> 3. 잦은 휴일근무 발생시 업무프로세스, 업무일정 조정, 팀내 업무할당/조정 등
									개선사항이 <br /> &nbsp; &nbsp; 있는지 검토 합니다.<br/> 4. 휴일근무 보고시 실제 근무시간을 정확히 기재합니다.<br/> 5.
									휴일근무자는 입퇴실 시 반드시 출입카드기(지문/카드)에 등록해야 합니다.<br/><br/>
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
				<input type="hidden" id="__PHBFF" name="__PHBFF" value=""/>
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
