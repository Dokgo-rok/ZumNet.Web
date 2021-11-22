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
					.m .fm-file, .m .fm2 {text-align:left}

					/* 폰트 */
					.fh h1 {font-family:굴림체;font-weight:bold;font-size:20.0pt;letter-spacing:10pt;}
					.si-tbl td {font-size:13px;font-family:맑은 고딕}
					.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,
					.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div
					{font-size:13px;font-family:맑은 고딕}
					.m .fm span {font-size:13px;font-family:맑은 고딕}
					.m .fm1 span, .m .fm2 {font-size:13px;font-family:맑은 고딕}
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
					.m .ft .f-lbl {width:100;text-align:center}
					.m .ft .f-lbl1 {width:40;text-align:center}
					.m .ft .f-lbl2 {width:130;text-align:center}
					.m .ft .f-lbl3 {width:230;text-align:center}
					.fb table, .fm table, .fm1 table, .fm2 table, .fm3 table, .fm4 table {width:100%;height:100%}
					.m .fm span {font-size:11px;font-family:맑은 고딕}
					.m .fm1 span {font-size:14px;font-family:맑은 고딕}
					.m .fm2 div {line-height:18px}
					.m .fm2 dt, .m .fm2 dd {margin-top:2px}

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
					{ime-mode:disabled;width:100;padding-top:2px;text-align:center}
					.m .txtCalculate {ime-mode:active;width:100%;padding-top:2px;padding-right:2}

					.m .txaRead {width:100%;text-align:left}
					.m .txtRead {width:100%;border:0;padding-top:2px}
					.m .txtRead1 {width:80;border:0;padding-top:2px}
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
                      <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      		<tr>
                            	<td class="f-lbl">날인부수
                                </td>
                                <td class="f-lbl1" align="center">
                                    <input type="text" name="STPAGE" id="__mainfield" >
                                   <xsl:choose>
                                       <xsl:when test="$mode='new'">
                                           <xsl:attribute name="class">txtText</xsl:attribute>
                                           <xsl:attribute name="maxlength">100</xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="$mode='edit'">
                                           <xsl:attribute name="class">txtText</xsl:attribute>
                                           <xsl:attribute name="maxlength">100</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/STPAGE" />
                                           </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <xsl:attribute name="class" >txtRead</xsl:attribute>
                                           <xsl:attribute name="readonly">readonly</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/STPAGE" />
                                           </xsl:attribute>
                                       </xsl:otherwise>
                                   </xsl:choose>
                                </input>
                                </td>
                                <td class="f-lbl">날인개수</td>
                                <td class="f-lbl1" >
                                    <input type="text" name="STPCS" id="__mainfield">
                                   <xsl:choose>
                                       <xsl:when test="$mode='new'">
                                           <xsl:attribute name="class">txtText</xsl:attribute>
                                           <xsl:attribute name="maxlength">100</xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="$mode='edit'">
                                           <xsl:attribute name="class">txtText</xsl:attribute>
                                           <xsl:attribute name="maxlength">100</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/STPCS" />
                                           </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <xsl:attribute name="class">txtRead</xsl:attribute>
                                           <xsl:attribute name="readonly">readonly</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/STPCS" />
                                           </xsl:attribute>
                                       </xsl:otherwise>
                                   </xsl:choose>
                                </input>

                                </td>
                                <td class="f-lbl">제출처 </td>
                                <td class="f-lbl3" style="border-right:0" colspan="2">
                                <input type="text" name="SUBMIT" id="__mainfield">
                               <xsl:choose>
                                   <xsl:when test="$mode='new'">
                                       <xsl:attribute name="class">txtText</xsl:attribute>
                                       <xsl:attribute name="maxlength">25</xsl:attribute>
                                   </xsl:when>
                                   <xsl:when test="$mode='edit'">
                                       <xsl:attribute name="class">txtText</xsl:attribute>
                                       <xsl:attribute name="maxlength">25</xsl:attribute>
                                       <xsl:attribute name="value">
                                           <xsl:value-of select="//forminfo/maintable/SUBMIT" />
                                       </xsl:attribute>
                                   </xsl:when>
                                   <xsl:otherwise>
                                       <xsl:attribute name="class">txtRead</xsl:attribute>
                                       <xsl:attribute name="readonly">readonly</xsl:attribute>
                                       <xsl:attribute name="value">
                                           <xsl:value-of select="//forminfo/maintable/SUBMIT" />
                                       </xsl:attribute>
                                   </xsl:otherwise>
                               </xsl:choose>
                            </input>
                               
                                </td>
                                </tr>
                             <tr>
                                <td class="f-lbl">내용(용도)</td>
                                <td colspan="6" style="border-right:0;height:200px;vertical-align:top">
                                <xsl:choose>
										<xsl:when test="$mode='read'">
											<div name="CONTENT" id="__mainfield">
												<xsl:attribute name="class">txaRead</xsl:attribute>
												<xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/CONTENT))" />
											</div>
										</xsl:when>
										<xsl:otherwise>
											<textarea name="CONTENT" id="__mainfield">
												<xsl:attribute name="class">txaText</xsl:attribute>
												<xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
												<xsl:if test="$mode='edit'">
													<xsl:value-of select="//forminfo/maintable/CONTENT" />
												</xsl:if>
											</textarea>
										</xsl:otherwise>
									</xsl:choose>                                
                                </td>
                            </tr> 
                             <tr>
                                <td class="f-lbl" rowspan="2" style="border-bottom:0">날인인장명의<br />
                                사용인감은 등록No기록</td>
                                <td class="f-lbl1" rowspan="2" style="border-bottom:0">
                                <input type="text" name="STNO" id="__mainfield">
                               <xsl:choose>
                                   <xsl:when test="$mode='new'">
                                       <xsl:attribute name="class">txtText</xsl:attribute>
                                       <xsl:attribute name="maxlength">100</xsl:attribute>
                                   </xsl:when>
                                   <xsl:when test="$mode='edit'">
                                       <xsl:attribute name="class">txtText</xsl:attribute>
                                       <xsl:attribute name="maxlength">100</xsl:attribute>
                                       <xsl:attribute name="value">
                                           <xsl:value-of select="//forminfo/maintable/STNO" />
                                       </xsl:attribute>
                                   </xsl:when>
                                   <xsl:otherwise>
                                       <xsl:attribute name="class">txtRead</xsl:attribute>
                                       <xsl:attribute name="readonly">readonly</xsl:attribute>
                                       <xsl:attribute name="value">
                                           <xsl:value-of select="//forminfo/maintable/STNO" />
                                       </xsl:attribute>
                                   </xsl:otherwise>
                               </xsl:choose>
                            </input>
                                </td>
                                <td colspan="2" align="center" >인장 지참 여부</td>
                               <td class="f-lbl2" >인감증명서 발급여부</td>
                                <td colspan="2" align="center" style="border-right:0;"> 사용기간</td>            
                              </tr>
                              
                              <tr>
                              	<td colspan="2" align="center" style="border-bottom:0">
									<xsl:choose>
										<xsl:when test="$mode='read'">
											<xsl:choose>
												<xsl:when test="//forminfo/maintable/STOUT[.='Y']">
													<input type="radio"  name="STOUT1" checked="checked" value="Y" />
													<label>유</label>
													<input type="radio" name="STOUT1" disabled="disabled" value="N" />
													<label>무</label>
												</xsl:when>
												<xsl:otherwise>
													<input type="radio" name="STOUT1" disabled="disabled" value="Y" />
													<label>유</label>
													<input type="radio" name="STOUT1" checked="checked" value="N" />
													<label>무</label>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="//forminfo/maintable/STOUT[.='Y']">
													<input type="radio"  name="STOUT1" checked="checked" value="Y" onclick="parent.fnSetRadioChecked(this.value, 'STOUT');" />
													<label>유</label>
													<input type="radio" name="STOUT1" value="N" onclick="parent.fnSetRadioChecked(this.value, 'STOUT');" />
													<label>무</label>
												</xsl:when>
												<xsl:otherwise>
													<input type="radio" name="STOUT1" value="Y" onclick="parent.fnSetRadioChecked(this.value, 'STOUT');" />
													<label>유</label>
													<input type="radio" name="STOUT1" checked="checked" value="N" onclick="parent.fnSetRadioChecked(this.value, 'STOUT');" />
													<label>무</label>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
                                </td> 
                                 <td class="f-lbl2" style="border-bottom:0">
									 <xsl:choose>
										 <xsl:when test="$mode='read'">
											 <xsl:choose>
												 <xsl:when test="//forminfo/maintable/STDOC[.='Y']">
													 <input type="radio"  name="STDOC1" checked="checked" value="Y" />
													 <label>유</label>
													 <input type="radio" name="STDOC1" disabled="disabled" value="N" />
													 <label>무</label>
												 </xsl:when>
												 <xsl:otherwise>
													 <input type="radio" name="STDOC1" disabled="disabled" value="Y" />
													 <label>유</label>
													 <input type="radio" name="STDOC1" checked="checked" value="N" />
													 <label>무</label>
												 </xsl:otherwise>
											 </xsl:choose>
										 </xsl:when>
										 <xsl:otherwise>
											 <xsl:choose>
												 <xsl:when test="//forminfo/maintable/STDOC[.='Y']">
													 <input type="radio"  name="STDOC1" checked="checked" value="Y" onclick="parent.fnSetRadioChecked(this.value, 'STDOC');" />
													 <label>유</label>
													 <input type="radio" name="STDOC1" value="N" onclick="parent.fnSetRadioChecked(this.value, 'STDOC');" />
													 <label>무</label>
												 </xsl:when>
												 <xsl:otherwise>
													 <input type="radio" name="STDOC1" value="Y" onclick="parent.fnSetRadioChecked(this.value, 'STDOC');" />
													 <label>유</label>
													 <input type="radio" name="STDOC1" checked="checked" value="N" onclick="parent.fnSetRadioChecked(this.value, 'STDOC');" />
													 <label>무</label>
												 </xsl:otherwise>
											 </xsl:choose>
										 </xsl:otherwise>
									 </xsl:choose>	
                                 </td>
                                <td colspan="2" align="center" style="border-right:0;border-bottom:0">
                                <input type="text" name="USESTIME" id="__mainfield">
                                   <xsl:choose>
                                       <xsl:when test="$mode='new'">
                                           <xsl:attribute name="class">txtDate</xsl:attribute>
                                           <xsl:attribute name="maxlength">12</xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="$mode='edit'">
                                           <xsl:attribute name="class">txtDate</xsl:attribute>
                                           <xsl:attribute name="maxlength">12</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/USESTIME" />
                                           </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <xsl:attribute name="class">txtRead1</xsl:attribute>
                                           <xsl:attribute name="readonly">readonly</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/USESTIME" />
                                           </xsl:attribute>
                                       </xsl:otherwise>
                                   </xsl:choose>
                                </input> ~ 
                                <input type="text" name="USEETIME" id="__mainfield">
                                   <xsl:choose>
                                       <xsl:when test="$mode='new'">
                                           <xsl:attribute name="class">txtDate</xsl:attribute>
                                           <xsl:attribute name="maxlength">12</xsl:attribute>
                                       </xsl:when>
                                       <xsl:when test="$mode='edit'">
                                           <xsl:attribute name="class">txtDate</xsl:attribute>
                                           <xsl:attribute name="maxlength">12</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/USEETIME" />
                                           </xsl:attribute>
                                       </xsl:when>
                                       <xsl:otherwise>
                                           <xsl:attribute name="class">txtRead1</xsl:attribute>
                                           <xsl:attribute name="readonly">readonly</xsl:attribute>
                                           <xsl:attribute name="value">
                                               <xsl:value-of select="//forminfo/maintable/USEETIME" />
                                           </xsl:attribute>
                                       </xsl:otherwise>
                                   </xsl:choose>
                                </input>
                                </td> 
                             </tr>                                                    
                        </table>          
					</div>

					<div class="fm2">
						<dl>
							<dt>- 작성시 유의사항 -</dt>
							<dd>&nbsp;</dd>
							<dt>1. 인장날인 신청시 유의사항</dt>
							<dd>
								<dl>
									<dt>① 인장관리규정에 의해 소속부서의 관리자에게 반드시 승인을 받기 바랍니다.</dt>
									<dd>기준외 처리시 반려 처리될 수 있습니다.</dd>

									<dt>
										② <span style="color:red;text-decoration:underline">필수 작성사항에 대해 담당자 확인이 가능하도록 자세히 작성바랍니다.</span>
									</dt>
									<dd>
										- '작성 내용' 상에 다음의 내용을 포함시켜 작성바랍니다.
										<dl>
											<dt style="float:left">EX)</dt>
											<dd>가. 문서종류: 계약서/ 협약서/ 입찰신청서 등</dd>
											<dd style="padding-left:3px">나. 문서제목(사업명): OOO 사업구축 계약 체결의 건</dd>
											<dd style="padding-left:3px">다. 문서용도: 계약 체결/ 입찰 신청/ 등기 신청 등</dd>
										</dl>
									</dd>

									<dt>③ 법인인감 날인의 경우</dt>
									<dd>
										- '작성 내용' 상에 '사용인감계' 필요여부를 작성해 주시기 바랍니다.
										<dl>
											<dt style="float:left;">EX)</dt>
											<dd>가. 문서종류: 계약서/ 협약서/ 입찰신청서 등</dd>
											<dd style="padding-left:3px">나. 문서제목(사업명): OOO 사업구축 계약 체결의 건</dd>
											<dd style="padding-left:3px">다. 문서용도: 계약 체결/ 입찰 신청/ 등기 신청 등</dd>
											<dd style="padding-left:3px">라. 사용인감계: 1번/ 5번 등</dd>
										</dl>
									</dd>
								</dl>
							</dd>
						</dl>
						<dl>
							<dt>2. 회사의 인장날인은 사내외적으로 매우 중요한 행위입니다.</dt>
							<dd>상기 용도 이외로 사용시 회사규정 및 관련법규에 의해 책임을 질 수 있습니다</dd>
						</dl>
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

				<input type="hidden" id="__mainfield" name="STOUT">
					<xsl:choose>
						<xsl:when test="//forminfo/maintable/STOUT[.='Y']">
							<xsl:attribute name="value">Y</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value">N</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>

				<input type="hidden" id="__mainfield" name="STDOC">
					<xsl:choose>
						<xsl:when test="//forminfo/maintable/STDOC[.='Y']">
							<xsl:attribute name="value">Y</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="value">N</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</input>
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
