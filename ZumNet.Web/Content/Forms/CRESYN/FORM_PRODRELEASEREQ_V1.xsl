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
					.m {width:780px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
					.fh h1 {font-size:20.0pt;letter-spacing:2pt}

					/* 결재칸 넓이 */
					.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

					/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
					.m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
					.m .ft .f-option {width:20%} .m .ft .f-option1 {width:} .m .ft .f-option2 {width:}
					.m .ft-sub .f-option {width:49%}

					/* 인쇄 설정 : 맨하단으로 */
					@media print {.m .fm-editor {height:650px}}
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
					<div class="ff" />
					<div class="ff" />
					<div class="ff" />

					<div class="fb">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="width:320px">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
								</td>
								<td style="font-size:1px">&nbsp;</td>
								<td style="width:95px">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Site', '1', '확인')"/>
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
								<td style="border-right:0;border-bottom:0">
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
								<td style="border-right:0">
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
              <tr>
                <td class="f-lbl" style="border-bottom:0;">출고요청일</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RELDATE" class="txtDate" maxlength="8" style="width: 100px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/RELDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RELDATE))" />
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
								<xsl:when test="$mode='new' or $mode='edit' ">
									<tr>
										<td>
											<span>&nbsp;</span>
										</td>
										<td class="fm-button">
											<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
											</button>
											<button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
												<img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
											</button>
										</td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td colspan="2">
											<span>&nbsp;</span>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
							<tr>
								<td>
									<div class="ff" />
									<div class="ff" />
								</td>
							</tr>
							<tr>
								<td colspan="2">
									<table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
										<xsl:if test="$mode='new' or $mode='edit'">
										  <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
										</xsl:if>
										<colgroup>
											<col width="4%" />
											<col width="16%" />
											<col width="16%" />
											<col width="19%" />
											<col width="9%" />
                      <col width="10%" />
                      <col width="8%" />
											<col width="6%" />
                      <col width="12%" />
										</colgroup>
										<tr style="height:22px">
											<td class="f-lbl-sub" style="border-top:0">NO</td>
											<td class="f-lbl-sub" style="border-top:0">고객</td>
											<td class="f-lbl-sub" style="border-top:0">품목번호</td>
											<td class="f-lbl-sub" style="border-top:0">품목명칭</td>
											<td class="f-lbl-sub" style="border-top:0">From 창고</td>
                      <td class="f-lbl-sub" style="border-top:0">F. On-hand</td>
                      <td class="f-lbl-sub" style="border-top:0">To 창고</td>
											<td class="f-lbl-sub" style="border-top:0">수량</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
										</tr>
										<xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
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

	<xsl:template match="//forminfo/subtables/subtable1/row">
		<tr class="sub_table_row">
			<td class="tdRead_Center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="CUSTOMER" style="width:83%" class="txtText_u" readonly="readonly" value="{CUSTOMER}" />
						<button onclick="parent.fnExternal('erp.customers',240,40,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
							<img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
						</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CUSTOMER))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="ITEMNO" style="width:81%" class="txtText_u" readonly="readonly" value="{ITEMNO}" />
						<button onclick="parent.fnExternal('erp.items',240,40,80,70,'',this,'ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
							<img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
						</button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNO))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="ITEMNAME" class="txtRead" readonly="readonly" value="{ITEMNAME}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNAME))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="tdRead_Center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FROMINVEN" style="width:70%" class="txtText_u" readonly="readonly" value="{FROMINVEN}" />
            <button onclick="parent.fnOption('erp.inven',350,500,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(FROMINVEN))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FONHAND" class="txtRead_Center" readonly="readonly" value="{FONHAND}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FONHAND))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="TOINVEN" class="txtRead_Center" readonly="readonly" value="{TOINVEN}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TOINVEN))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>			
			<td class="tdRead_Center">
				<xsl:choose>
					<xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" name="RELCNT" class="txtCurrency" maxlength="10" value="{RELCNT}" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(RELCNT))" />
					</xsl:otherwise>
				</xsl:choose>
			</td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="50" value="{ETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
          </xsl:otherwise>
        </xsl:choose>
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
	<xsl:template match="//fileinfo/file[@isfile='N']">
		<a target="_blank">
			<xsl:attribute name="href">
				<xsl:value-of disable-output-escaping="yes" select="phxsl:down2(string(//config/@web), string($root), string(virtualpath), string(savedname), string(filename))" />
			</xsl:attribute>
			<xsl:value-of select="filename" />
		</a>
	</xsl:template>
</xsl:stylesheet>
