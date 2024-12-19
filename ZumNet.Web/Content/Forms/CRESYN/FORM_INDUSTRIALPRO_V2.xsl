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
  <xsl:variable name="submode" select="//config/@submode" />
  <xsl:variable name="partid" select="//config/@partid" />
  <xsl:variable name="bizrole" select="//config/@bizrole" />
  <xsl:variable name="actrole" select="//config/@actrole" />
  <xsl:variable name="root" select="//config/@root" />
  <xsl:variable name="mlvl" select="phxsl:modLevel(string(//config/@mode), string(//bizinfo/@docstatus), string(//config/@partid), string(//creatorinfo/@uid), string(//currentinfo/@uid), //processinfo/signline/lines)" />
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
			.m {width:750px} .m .fm-editor {height:400px;min-height:400px;border:windowtext 0 solid}
			.fh h1 {font-size:20.0pt;letter-spacing:1pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:?}
			.m .ft .f-option {width:25%} .m .ft .f-option1 {width:34%}
			.m .ft-sub .f-option {width:49%}

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:450px; min-height:450px}}
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
                <td class="fh-r">
                  &nbsp;
                </td>
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
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '4', '합의부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <!--<xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>-->
              <colgroup>
				  <col style="width:12%"></col>
				  <col style="width:22%"></col>
				  <col style="width:12%"></col>
				  <col style="width:21%"></col>
				  <col style="width:12%"></col>
				  <col style="width:21%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">문서번호</td>
                <td>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">구분</td>
                <td colspan="3" style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbDOCCLASS" value="품의">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'품의')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'품의')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">품의</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb12" name="ckbDOCCLASS" value="보고">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'보고')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'보고')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">보고</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbDOCCLASS" value="검토">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'검토')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'검토')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">검토</label>
                  </span>
                </td>
                <input type="hidden" id="__mainfield" name="DOCCLASS">
                  <xsl:attribute name="value">
                    <xsl:value-of select="//forminfo/maintable/DOCCLASS"></xsl:value-of>
                  </xsl:attribute>
                </input>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">기안부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="">기안자</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
                <td class="f-lbl">기안일자</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
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
					<colgroup>
						<col style="width:12%"></col>
						<col style="width:22%"></col>
						<col style="width:12%"></col>
						<col style="width:21%"></col>
						<col style="width:12%"></col>
						<col style="width:21%"></col>
					</colgroup>
					<tr>
						<td class="f-lbl">발명명칭</td>
						<td colspan="3">
						    <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                    <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
                                </xsl:when>
                                <xsl:otherwise>
								    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                                </xsl:otherwise>
                            </xsl:choose>
						</td>
						<td class="f-lbl">산업재산권</td>
						<td style="border-right: 0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="INDRIGHTS" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/INDRIGHTS}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="산업재산권" onclick="_zw.formEx.optionWnd('external.indprop_rights',140,94,-80,0,'','INDRIGHTS');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INDRIGHTS))" />
								</xsl:otherwise>
							</xsl:choose>
					    </td>
					</tr>
					<tr>
						<td class="f-lbl">출원일</td>
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="APPDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/APPDATE}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/APPDATE))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">등록일</td>
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="REGDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/REGDATE}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REGDATE))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">권리만료일</td>
						<td style="border-right: 0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="EXPDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/EXPDATE}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXPDATE))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="f-lbl">유지연차</td>
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="MAINTNYEAR" class="txtText" maxlength="20" value="{//forminfo/maintable/MAINTNYEAR}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MAINTNYEAR))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">유지비용</td>
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $partid!='')">
									<input type="text" id="__mainfield" name="MAINTNEXPENSE" class="txtText" maxlength="20" value="{//forminfo/maintable/MAINTNEXPENSE}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MAINTNEXPENSE))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">출원부서</td>
						<td style="border-right: 0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="APPDEPT" class="txtText" maxlength="50" value="{//forminfo/maintable/APPDEPT}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/APPDEPT))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="f-lbl">출원번호</td>
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="APPNUMBER" class="txtText" maxlength="50" value="{//forminfo/maintable/APPNUMBER}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/APPNUMBER))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">등록번호</td>
						<td>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="REGNUMBER" class="txtText" maxlength="50" value="{//forminfo/maintable/REGNUMBER}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REGNUMBER))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">검토자</td>
						<td style="border-right: 0">
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<input type="text" id="__mainfield" name="REVIEWER" class="txtText" maxlength="50" value="{//forminfo/maintable/REVIEWER}" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEWER))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="f-lbl" style="border-bottom: 0">발명내용</td>
						<td colspan="5" style="border-right: 0; border-bottom: 0">
							<div class="fm-editor">
								<xsl:if test="$mode!='new' and $mode!='edit'">
									<xsl:attribute name="class">fm-editor h-auto</xsl:attribute>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$mode='read'">
										<xsl:if test="$mlvl='A' or $mlvl='B'">
											<xsl:attribute name="id">___editable</xsl:attribute>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="$submode='revise'">
												<textarea id="bodytext" style="display:none">
													<xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
												</textarea>
												<div class="h-100" id="__DextEditor"></div>
											</xsl:when>
											<xsl:otherwise>
												<div name="WEBEDITOR" id="__mainfield" class="txaRead" style="width:100%;height:100%;padding:0px;position:relative">
													<xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
												</div>
											</xsl:otherwise>
										</xsl:choose>
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
						</td>
					</tr>
				</table>
			</div>

			<div class="ff" />
			<div class="ff" />
			<div class="ff" />
			<div class="ff" />

			<div class="fm">
				<span class="">* 검토 의견</span>
			</div>
			<div class="ff" />

			<div class="fm">
				<table class="ft" border="0" cellspacing="0" cellpadding="0">
					<colgroup>
						<col style="width:12%"></col>
						<col style="width:22%"></col>
						<col style="width:12%"></col>
						<col style="width:21%"></col>
						<col style="width:12%"></col>
						<col style="width:21%"></col>
					</colgroup>
					<tr>
						<td class="f-lbl">청구권리</td>
						<td>
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<input type="text" id="__mainfield" name="CLAIMRIGHTS" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CLAIMRIGHTS}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="청구권리" onclick="_zw.formEx.optionWnd('external.indprop_claim',140,152,-120,0,'','CLAIMRIGHTS');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CLAIMRIGHTS))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">미래적용</td>
						<td>
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<input type="text" id="__mainfield" name="FUTUREAPP" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/FUTUREAPP}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="미래적용" onclick="_zw.formEx.optionWnd('external.indprop_future',140,152,-120,0,'','FUTUREAPP');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FUTUREAPP))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">타사적용</td>
						<td style="border-right: 0">
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<input type="text" id="__mainfield" name="OTHERAPP" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/OTHERAPP}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="타사적용" onclick="_zw.formEx.optionWnd('external.indprop_other',140,152,-80,0,'','OTHERAPP');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OTHERAPP))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="f-lbl">제품적용</td>
						<td>
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<input type="text" id="__mainfield" name="PRODAPP" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PRODAPP}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="제품적용" onclick="_zw.formEx.optionWnd('external.indprop_product',140,152,-120,0,'','PRODAPP');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODAPP))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl">적용모델</td>
						<td colspan="3" style="border-right: 0">
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<input type="text" id="__mainfield" name="APPMODEL" style="width:95%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/APPMODEL}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="적용모델" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'','APPMODEL');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/APPMODEL))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
					<tr>
						<td class="f-lbl" style="border-bottom: 0">검토결과</td>
						<td style="border-bottom: 0">
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<input type="text" id="__mainfield" name="REVIEWRESULT" style="width:87%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/REVIEWRESULT}" />
									<button type="button" class="btn btn-outline-secondary btn-18" title="검토결과" onclick="_zw.formEx.optionWnd('external.indprop_result',140,68,-120,0,'','REVIEWRESULT');">
										<i class="fas fa-angle-down"></i>
									</button>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEWRESULT))" />
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td class="f-lbl" style="border-bottom: 0">검토의견</td>
						<td colspan="3" style="border-right: 0; border-bottom: 0">
							<xsl:choose>
								<xsl:when test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
									<textarea id="__mainfield" name="REVIEWMEMO" style="height:100px" class="txaText bootstrap-maxlength" maxlength="500">
										<xsl:if test="$bizrole='normal' and $actrole='_reviewer' and $partid!=''">
											<xsl:value-of select="//forminfo/maintable/REVIEWMEMO" />
										</xsl:if>
									</textarea>
								</xsl:when>
								<xsl:otherwise>
									<div class="txaRead">
										<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REVIEWMEMO))" />
									</div>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</table>
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
