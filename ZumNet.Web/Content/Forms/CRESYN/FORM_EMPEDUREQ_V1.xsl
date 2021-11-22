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
					.fh h1 {font-family:굴림체;font-weight:bold;font-size:20.0pt;letter-spacing:10pt;}
					.si-tbl td {font-size:13px;font-family:맑은 고딕}
					.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,
					.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div
					{font-size:13px;font-family:맑은 고딕}
					.m .fm span {font-size:15px;font-family:맑은 고딕}
					.m .fm1 span {font-size:14px;font-family:맑은 고딕}
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
					.m .ft .f-lbl1 {width:?;text-align:center}
					.m .ft .f-lbl2 {width:?;text-align:center}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}
					.m .fm span {font-size:14px;font-family:맑은 고딕}
					.m .fm1 span {font-size:14px;font-family:맑은 고딕}

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
					.m .txtText_h {ime-mode:active;width:150;padding-top:2px}
					.m .txtText_m {ime-mode:active;width:100%;border:1px solid red;;padding-top:2px}
					.m .txaText {ime-mode:active;width:100%;height:100%;overflow:auto}

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
					<div class="ff" />

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
					<div class="ff"/>

					<div class="fm">
                        <table border="0" class="ft" cellspacing="0" cellpadding="0" height="30">
                                
                                <tr>
                                    <td class="f-lbl" style="border-bottom:0">교육구분 </td>
                                    <td style="border-right:0;border-bottom:0">
                                   		<xsl:choose>
											<xsl:when test="$mode='read'">
                                                <input type="radio" name="CRSCHK" id="CRSCHK">
                                                   <xsl:choose>
                                                        <xsl:when test="//forminfo/maintable/CRS1[.='사내교육']">
                                                            <xsl:attribute name="checked">true</xsl:attribute>                                                            
                                                        </xsl:when>
                                                        <xsl:when test="//forminfo/maintable/CRS1[.='외부교육']">
                                                            <xsl:attribute name="checked">false</xsl:attribute>
                                                             <xsl:attribute name="disabled">true</xsl:attribute>
                                                            
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                           <xsl:attribute name="checked">true</xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <xsl:attribute name="value">사내교육</xsl:attribute>
                                                </input>
                                            </xsl:when>
                                            <xsl:otherwise> 
												<input type="radio" name="CRSCHK" id="CRSCHK" onclick="parent.fnSetRadioChecked(this.value, 'CRS1');">
                                                   <xsl:choose>
                                                        <xsl:when test="//forminfo/maintable/CRS1[.='사내교육']">
                                                            <xsl:attribute name="checked">true</xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:when test="//forminfo/maintable/CRS1[.='외부교육']">
                                                            <xsl:attribute name="checked">false</xsl:attribute>
                                                            <xsl:attribute name="disabled">true</xsl:attribute>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                           <xsl:attribute name="checked">true</xsl:attribute>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                    <xsl:attribute name="value">사내교육</xsl:attribute>
                                                </input>
                                            </xsl:otherwise>
										</xsl:choose>
									<span>사내교육</span>  &nbsp; &nbsp; &nbsp;
                                    
                                    	<xsl:choose>
											<xsl:when test="$mode='read'">
                                                <input type="radio" name="CRSCHK" id="CRSCHK">
                                                   <xsl:choose>
                                                        <xsl:when test="//forminfo/maintable/CRS1[.='외부교육']">
                                                            <xsl:attribute name="checked">true</xsl:attribute>
                                                        </xsl:when>
                                                         <xsl:when test="//forminfo/maintable/CRS1[.='사내교육']">
                                                          <xsl:attribute name="disabled">true</xsl:attribute>
                                                            
                                                        </xsl:when>
                                                    </xsl:choose>
                                                    <xsl:attribute name="value">외부교육</xsl:attribute>
                                                </input>
                                            </xsl:when>
                                            
                                            <xsl:otherwise> 
                                            	<input type="radio" name="CRSCHK" id="CRSCHK"  onclick="parent.fnSetRadioChecked(this.value, 'CRS1');">
                                                   <xsl:choose>
                                                        <xsl:when test="//forminfo/maintable/CRS1[.='외부교육']">
                                                            <xsl:attribute name="checked">true</xsl:attribute>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                    <xsl:attribute name="value">외부교육</xsl:attribute>
                                                </input>
                                            </xsl:otherwise>
										</xsl:choose>

                                   
                                   <span>외부교육</span>
                                   </td>
                                </tr>
                            </table>

                        <div class="ff"/>
                        <div class="fm">
                            <table class="ft" border="0" cellspacing="0" cellpadding="0">
                                
                                <tr>
                                    <td class="f-lbl">수강교육명</td>
                                    <td colspan="5" style="border-right:0">
                                    <input type="text" name="CRSNAME" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/CRSNAME" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/CRSNAME" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                    </input>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="f-lbl">수강일시</td>
                                    <td colspan="5" style="border-right:0">
                                    <input type="text" name="CRSDATE" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtDate</xsl:attribute>
                                               <xsl:attribute name="maxlength">10</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtDate</xsl:attribute>
                                               <xsl:attribute name="maxlength">10</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/CRSDATE" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/CRSDATE" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
										<xsl:attribute name="style">width:100px</xsl:attribute>
                                    </input>~
										<input type="text" name="CRSTODATE" id="__mainfield">
											<xsl:choose>
												<xsl:when test="$mode='new'">
													<xsl:attribute name="class">txtDate</xsl:attribute>
													<xsl:attribute name="maxlength">10</xsl:attribute>
												</xsl:when>
												<xsl:when test="$mode='edit'">
													<xsl:attribute name="class">txtDate</xsl:attribute>
													<xsl:attribute name="maxlength">10</xsl:attribute>
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/CRSTODATE" />
													</xsl:attribute>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="class">txtRead</xsl:attribute>
													<xsl:attribute name="readonly">readonly</xsl:attribute>
													<xsl:attribute name="value">
														<xsl:value-of select="//forminfo/maintable/CRSTODATE" />
													</xsl:attribute>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:attribute name="style">width:100px</xsl:attribute>
										</input>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="f-lbl">수강장소*</td>
                                    <td colspan="5" style="border-right:0">
                                    <input type="text" name="CRSLOC" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/CRSLOC" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/CRSLOC" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                    </input>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="f-lbl" style="width:15%;">수강료*</td>
                                    <td class="f-lbl" colspan="2">
                                    <input type="text" name="CRSCOST" id="__mainfield">
                                           <xsl:choose>
                                               <xsl:when test="$mode='new'">
                                                   <xsl:attribute name="class">txtCurrency</xsl:attribute>
                                                   <xsl:attribute name="maxlength">100</xsl:attribute>
                                               </xsl:when>
                                               <xsl:when test="$mode='edit'">
                                                   <xsl:attribute name="class">txtCurrency</xsl:attribute>
                                                   <xsl:attribute name="maxlength">100</xsl:attribute>
                                                   <xsl:attribute name="value">
                                                       <xsl:value-of select="//forminfo/maintable/CRSCOST" />
                                                   </xsl:attribute>
                                               </xsl:when>
                                               <xsl:otherwise>
                                                   <xsl:attribute name="class">txtRead</xsl:attribute>
                                                   <xsl:attribute name="readonly">readonly</xsl:attribute>
                                                   <xsl:attribute name="value">
                                                       <xsl:value-of select="//forminfo/maintable/CRSCOST" />
                                                   </xsl:attribute>
                                               </xsl:otherwise>
                                           </xsl:choose>
                                        </input>
                                        </td>
                                    <td class="f-lbl" style="width:15%;">환급비용*</td>
                                    <td class="f-lbl" colspan="2" style="width:230px;border-right:0">
                                    <input type="text" name="COSTRETURN" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtCurrency</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtCurrency</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/COSTRETURN" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/COSTRETURN" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                    </input>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="f-lbl" rowspan="3" style="border-bottom:0">수강료<br />입금처*
                                    </td>
                                    <td class="f-lbl" >입금은행명</td>
                                    <td colspan="2" style="width:230px;border-right:0"><input type="text" name="BANKNAME" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtText_h</xsl:attribute>
                                               <xsl:attribute name="maxlength">20</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtText_h</xsl:attribute>
                                               <xsl:attribute name="maxlength">20</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BANKNAME" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BANKNAME" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                    </input> 은행
                                    </td> 
                                     <td colspan="2" style="width:230px;border-right:0">
                                    <input type="text" name="BRANCH" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtText_h</xsl:attribute>
                                               <xsl:attribute name="maxlength">20</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtText_h</xsl:attribute>
                                               <xsl:attribute name="maxlength">20</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BRANCH" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BRANCH" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose></input> 지점
                                    </td>
                                </tr>
                                <tr>
                                    <td class="f-lbl">입금계좌번호</td>
                                    <td colspan="4" style="border-right:0">
                                    <input type="text" name="BANKNO" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BANKNO" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BANKNO" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                    </input>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="f-lbl" style="border-bottom:0">예금주명</td>
                                    <td colspan="4" style="border-right:0;border-bottom:0">
                                    <input type="text" name="BANKERNAME" id="__mainfield">
                                       <xsl:choose>
                                           <xsl:when test="$mode='new'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                           </xsl:when>
                                           <xsl:when test="$mode='edit'">
                                               <xsl:attribute name="class">txtText</xsl:attribute>
                                               <xsl:attribute name="maxlength">100</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BANKERNAME" />
                                               </xsl:attribute>
                                           </xsl:when>
                                           <xsl:otherwise>
                                               <xsl:attribute name="class">txtRead</xsl:attribute>
                                               <xsl:attribute name="readonly">readonly</xsl:attribute>
                                               <xsl:attribute name="value">
                                                   <xsl:value-of select="//forminfo/maintable/BANKERNAME" />
                                               </xsl:attribute>
                                           </xsl:otherwise>
                                       </xsl:choose>
                                    </input>
                                    </td>
                                </tr>
                            </table>
                        </div>
                            <table border="0" cellspacing="0" cellpadding="0" height="25" width="100%">
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;">*  표시 부분은 외부기술교육 수강시에만 해당되는 부분입니다.</td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;"><b><u>수강자 협조 사항</u></b></td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;">*  모든 교육은 수강자가 신청함을 원칙으로 합니다.</td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;"><b><u>경영지원본부 업무 협조 사항 (외부기술교육 수강시)</u></b></td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;">*  본 신청서에 명시되어 있는 수강일시에 따라 외근을 인정해 주시기 바랍니다.</td>
                                </tr>
                                <tr>
                                    <td style="text-align:left;height:24px;font-size:12px;padding-left:2px;padding-right:2px;padding-top:1px;">*  본 신청서에 명시되어 있는 수강일시에 이전까지 수강료를 입금처로 송금하여 주시기 바랍니다. 입금이 완료되면, 교육 수강자에게 통보하여 주시기 바랍니다.</td>
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
                
                <xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="id">__mainfield</xsl:attribute>
					<xsl:attribute name="name">CRS1</xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="//forminfo/maintable/CRS1[.='외부교육']">
                            <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/CRS1"/>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:attribute name="value">사내교육</xsl:attribute>
                        </xsl:otherwise>
                    </xsl:choose>
				</xsl:element>
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
