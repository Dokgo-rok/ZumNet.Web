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
			.m {width:700px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
			.fh h1 {font-size:20.0pt;letter-spacing:2pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
			.m .ft .f-option {width:20px} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
			.m .ft-sub {border:1px solid #343a40;border-top:0}
			.m .ft-sub .ft-sub-sub td {border:0;border-right:#343a40 1px dotted;border-bottom:#343a40 1px dotted}
			.m .ft-sub .f-option {width:49%} .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

			/* 하위테이블 추가삭제 버튼 */
			<!--.subtbl_div button {height:16px;width:16px}-->

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:650px} }
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                </td>
                <td style="width:6.7px;font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='영업수신' and @partid!='' and @step!='0'], '__si_Form', '3', '영업수신')"/>-->
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, '영업수신', '__si_Form', '3', '영업수신')"/>
                </td>
                <td style="width:6.6px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '확인')"/>
                </td>
                <td style="width:6.6px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
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
                <td class="f-lbl">작성일</td>
                <td style="width:15%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="width:5%">Rev.</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAINREVISION">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAINREVISION" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAINREVISION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">사업장</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ORGCODE" style="width:60%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ORGCODE" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','ORGCODE', 'ORGID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="사업장" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-130,0,'orgcode','ORGCODE', 'ORGID');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ORGCODE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">BUYER</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYER" style="width:91%; margin-right:2px">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYER" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'BUYER','BUYER','BUYERID','BUYERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="BUYER" onclick="_zw.formEx.externalWnd('erp.vendorcustomer',240,40,126,70,'BUYER','BUYER','BUYERID','BUYERSITEID');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">제목</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//docinfo/subject" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <span style="width:20%;border:0 solid red">1. 신작현황</span>
                <span style="width:80%;text-align:right;padding-right:4px;border:0 solid blue">
                  <!--<a href="javascript:" onclick="if (parent.fnOpen) parent.fnOpen('/BizForce/EA/ReportSheet.aspx?M=&amp;ft=SEARCH_TOOLING&amp;Lc=%uC801%uC6A9%uBAA8%uB378%20%uAE08%uD615%uD604%uD669&amp;pop=' + document.getElementById('FMODELNO').value,1000,700,'resize','','');">적용모델 금형현황</a>-->
					<a onclick="_zw.formEx.optionWnd('report.SEARCH_TOOLING',800,500,-400,0,'','{//forminfo/maintable/FMODELNO}');" id="lnkReport" style="text-decoration:none;font-weight:bold" href="javascript:" title="적용모델 금형현황">적용모델 금형현황</a>
                </span>  
              </xsl:when>
              <xsl:otherwise>
                <span>1. 신작현황</span>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">적용완제모델</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FMODELNO" style="width:91%;margin-right:2px">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FMODELNO" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdmproduct','FMODELNO','FMODELNM','FMODELOID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="적용완제모델" onclick="_zw.formEx.externalWnd('erp.items',240,40,136,74,'pdmproduct','FMODELNO','FMODELNM','FMODELOID');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="FMODELOID!=''">
                          <a target="_blank">
                            <xsl:attribute name="href">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/FMODELOID))" />
                            </xsl:attribute>
                            <xsl:value-of select="//forminfo/maintable/FMODELNO" />
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FMODELNO))" />
                        </xsl:otherwise>
                      </xsl:choose>
                      <input type="hidden" id="__mainfield" name="FMODELNO" value="{//forminfo/maintable/FMODELNO}" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="FMODELOID" value="{//forminfo/maintable/FMODELOID}" />
                </td>
                <td class="f-lbl">품명</td>
                <td style="width:35%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FMODELNM" class="txtText" value="{//forminfo/maintable/FMODELNM}" onblur="_zw.formEx.event('FMODELNM');" />
                      </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FMODELNM))" />
                      <input type="hidden" id="__mainfield" name="FMODELNM" value="{//forminfo/maintable/FMODELNM}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">금형제작처</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FSUPPLIER" style="width:92%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FSUPPLIER" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.vendorcustomer',240,40,136,74,'VENDOR','FSUPPLIER','FSUPPLIERID','FSUPPLIERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="금형제작처" onclick="_zw.formEx.externalWnd('erp.vendorcustomer',240,40,126,70,'VENDOR','FSUPPLIER','FSUPPLIERID','FSUPPLIERSITEID');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FSUPPLIER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="FSUPPLIERID" value="{//forminfo/maintable/FSUPPLIERID}" />
                  <input type="hidden" id="__mainfield" name="FSUPPLIERSITEID" value="{//forminfo/maintable/FSUPPLIERSITEID}" />
                </td>
                <td class="f-lbl">금형제작기간</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDATE" style="width:78px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/FROMDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;~&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TODATE" style="width:78px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TODATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TODATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DAYS" class="txtNumberic" readonly="readonly" style="width:25px" maxlength="3" value="{//forminfo/maintable/DAYS}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DAYS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;일&nbsp;)
                </td>
              </tr>
              <tr>
                <td class="f-lbl">신작사유</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKEREASON">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAKEREASON" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKEREASON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <!--<td class="f-lbl" style="border-bottom:0">금형비부담</td>
                <td style="width:35%;text-align:center;border-bottom:0">
                  <span style="width:100px">
                    <input type="checkbox" id="ckb21" name="ckbMONEY" value="당사">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMONEY', this, 'WHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'당사')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WHOMONEY),'당사')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">당사</label>
                  </span>
                  <span style="width:50px">
                    <input type="checkbox" id="ckb22" name="ckbMONEY" value="고객">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMONEY', this, 'WHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'고객')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WHOMONEY),'고객')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">고객</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="WHOMONEY">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/WHOMONEY"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>-->
                <td class="f-lbl" style="border-bottom:0">비용지급예정일</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MONEYDATE" style="width:100px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/MONEYDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MONEYDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
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
                    <td style="width:200px">
                      <span>2. 금형비내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : 
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:60px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',240,274,-130,0,'etc','CURRENCY');">
							<i class="fas fa-angle-down"></i>
						</button>
                      &nbsp;&nbsp;적용환율 :
                      <input type="text" id="__mainfield" name="EXCHANGERATE" style="width:100px; border-radius:0" class="datepicker txtText_u" maxlength="10" data-inputmask="date;yyyy-MM-dd" readonly="readonly" value="{//forminfo/maintable/EXCHANGERATE}" />
                      &nbsp;&nbsp;
                      <!--<button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable2');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable2');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td style="width:200px">
                      <span>2. 금형비내역</span>
                    </td>
                    <td class="fm-button">
                      통화 :                       
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:60px" class="txtRead" readonluy="" value="{//forminfo/maintable/CURRENCY}" />
                      &nbsp;&nbsp;적용환율 :
                      <!--<input type="text" id="__mainfield" name="EXCHANGERATE" style="width:100px;height:16px" class=" txtText_u txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" onfocusout="parent.fnDateFormat(this)"  readonly="readonly" value="{//forminfo/maintable/EXCHANGERATE}" />-->
						<input type="text" id="__mainfield" name="EXCHANGERATE" style="width:100px" class="txtRead" readonluy="" value="{//forminfo/maintable/EXCHANGERATE}" />
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
                  <table id="__subtable2" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:140px"></col>
                      <col style="width:45px"></col>
                      <col style="width:55px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:50">
                      <td class="f-lbl-sub" style="">NO</td>
                      <td class="f-lbl-sub" style="">부품명</td>
                      <td class="f-lbl-sub" style="">벌수</td>
                      <td class="f-lbl-sub" style="">CAVITY</td>
                      <td class="f-lbl-sub" style="">금형단가</td>
                      <td class="f-lbl-sub" style="">
                        제작비용                        
                        &nbsp;
                      </td>
                      <!--<td class="f-lbl-sub" style="" onclick="parent.fnExchangeInfo3('B');">-->
						<td class="f-lbl-sub">
                        제작비용<br />(KRW)                        
                      </td>
                      <td class="f-lbl-sub" style="border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="2">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALBUL">
                              <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALBUL" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALBUL))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" style="border-bottom:0">
                        &nbsp;
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>                            
                            <input type="text" id="__mainfield" name="TOTALSUM">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM" />
                              </xsl:attribute>
                            </input>
                          </xsl:otherwise>
                        </xsl:choose>                      
                      </td>
                      <td>                        
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUMKRW">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUMKRW" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <input type="text" id="__mainfield" name="TOTALSUMKRW">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUMKRW" />
                              </xsl:attribute>
                            </input>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        (VAT
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="VATVALUE" style="width: 30px" class="txtDollar" maxlength="4" data-inputmask="number;2;2" value="{//forminfo/maintable/VATVALUE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/VATVALUE))" />
                          </xsl:otherwise>
                        </xsl:choose>%)&nbsp;&nbsp;
						
                        <input type="checkbox" id="ckb31" name="ckbINCLUDE" value="포함">
                            <xsl:if test="$mode='new' or $mode='edit'">
                                <xsl:attribute name="onclick">_zw.form.checkYN('ckbINCLUDE', this, 'INCLUDE')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INCLUDE),'포함')">
                                <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/INCLUDE),'포함')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                        </input>
                        <label for="ckb31" style="margin-left: 2px">포함</label>&nbsp;
						
                        <input type="checkbox" id="ckb32" name="ckbINCLUDE" value="미포함">
                            <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">_zw.form.checkYN('ckbINCLUDE', this, 'INCLUDE')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INCLUDE),'미포함')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/INCLUDE),'미포함')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                        </input>
                        <label for="ckb32" style="margin-left: 2px">미포함</label>

                        <input type="hidden" id="__mainfield" name="INCLUDE">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/INCLUDE"></xsl:value-of>
                          </xsl:attribute>
                        </input>

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
            <span>3. 同고객 금형보유현황</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1" style="width:12%">소유구분</td>
                <td class="f-lbl1" style="width:12%">수량</td>
                <td class="f-lbl1" style="width:18%">금액(USD)</td>
                <td class="f-lbl1" style="width:58%;border-right:0">비고</td>
              </tr>
              <tr>
                <td class="f-lbl1">당사</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYSTOCKQTY">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANYSTOCKQTY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYSTOCKQTY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYCOSTUSD">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANYCOSTUSD" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYCOSTUSD))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYETC">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANYETC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">고객</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERSTOCKQTY">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERSTOCKQTY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERSTOCKQTY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCOSTUSD">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERCOSTUSD" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERCOSTUSD))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERETC">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERETC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <!--<div class="fm">
            <span>4. 同고객 금형대금회수현황</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col width="12%" />
                <col width="12%" />
                <col width="18%" />
                <col width="12%" />
                <col width="12%" />
                <col width="17%" />
                <col width="17%" />
              </colgroup>
              <tr>
                <td class="f-lbl1" rowspan="2">재고(고객)</td>
                <td class="f-lbl1" rowspan="2">청구벌수</td>
                <td class="f-lbl1" rowspan="2">청구금액(USD)</td>
                <td class="f-lbl1" colspan="2">회수여부</td>
                <td class="f-lbl1" colspan="2" style="border-right:0">금액(USD)</td>
              </tr>
              <tr>
                <td class="f-lbl1">회수벌수</td>
                <td class="f-lbl1">미회수벌수</td>
                <td class="f-lbl1">회수금액</td>
                <td class="f-lbl1" style="border-right:0">미회수금액</td>
              </tr>
              <tr>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTSTOCKQTY">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTSTOCKQTY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTSTOCKQTY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCHARGETYPE">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERCHARGETYPE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERCHARGETYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCHARGESUM">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERCHARGESUM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERCHARGESUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALCNT1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALCNT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALCNT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALCNT2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALCNT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALCNT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALSUM1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALSUM1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALSUM1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALSUM2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALSUM2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALSUM2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>-->
          <input type="hidden" id="__mainfield" name="BUYERRETRIEVALSUM2" class="txtText" value="{//forminfo/maintable/BUYERRETRIEVALSUM2}" />
          <input type="hidden" id="__mainfield" name="BUYERRETRIEVALSUM1" class="txtText" value="{//forminfo/maintable/BUYERRETRIEVALSUM1}" />
          <input type="hidden" id="__mainfield" name="BUYERRETRIEVALCNT2" class="txtText" value="{//forminfo/maintable/BUYERRETRIEVALCNT2}" />
          <input type="hidden" id="__mainfield" name="BUYERRETRIEVALCNT1" class="txtText" value="{//forminfo/maintable/BUYERRETRIEVALCNT1}" />
          <input type="hidden" id="__mainfield" name="BUYERCHARGESUM" class="txtText" value="{//forminfo/maintable/BUYERCHARGESUM}" />
          <input type="hidden" id="__mainfield" name="BUYERCHARGETYPE" class="txtText" value="{//forminfo/maintable/BUYERCHARGETYPE}" />
          <input type="hidden" id="__mainfield" name="TOTSTOCKQTY" class="txtText" value="{//forminfo/maintable/TOTSTOCKQTY}" />

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>4. 금형상세내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : USD&nbsp;&nbsp;
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable1');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable1');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>4. 금형상세내역</span>
                    </td>
                    <td class="fm-button">통화 : USD&nbsp;</td>
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
                  <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:96%"></col>
                    </colgroup>
                    <!--<tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">금형정보</td>
                    </tr>-->
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>5. 특기사항</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:80px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:">&nbsp;</td>
                <td style="width:245px">
                  <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='제작수신' and @partid!='' and @step!='0'], '__si_Form2', '3', '제작수신')"/>-->
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, '제작수신', '__si_Form2', '3', '제작수신')"/>
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
            <!--<div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>-->
            <div class="fm-lines">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignTable(//processinfo/signline/lines)"/>
            </div>
          </xsl:if>
        </div>

        <!-- Main Table Hidden Field 01 -->
        <input type="hidden" id="__mainfield" name="ORGID" value="{//forminfo/maintable/ORGID}" />
        <input type="hidden" id="__mainfield" name="BUYERID">
          <xsl:attribute name="value">
            <xsl:value-of select="//forminfo/maintable/BUYERID" />
          </xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="BUYERSITEID">
          <xsl:attribute name="value">
            <xsl:value-of select="//forminfo/maintable/BUYERSITEID" />
          </xsl:attribute>
        </input>
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
    <xsl:variable name="rowidx" select="ROWSEQ" />
    <tr class="sub_table_row">
      <td class="tdRead_Center" style="border-right:1px dotted #343a40">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
			  <br />
            <xsl:value-of select="ROWSEQ"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="text" name="ROWSEQ" value="{ROWSEQ}" class="txtRead_Center" readonly="readonly" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border:0;border-top:1px solid #343a40;padding:0">
        <table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
          <xsl:if test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">table-layout:</xsl:attribute>
          </xsl:if>
          <colgroup>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
          </colgroup>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">금형분류</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingcls'],'CLSCODE',string(CLSCODE),'CLSNM',string(CLSNM),'120px')"/>                  
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CLSNM))" />
                    <input type="hidden" name="CLSCODE" value="{CLSCODE}" />
                </xsl:otherwise>                
              </xsl:choose>              
            </td>
            <td class="f-lbl-sub">RFID등록</td>
            <td style="border-right:0">
              <span class="f-option1" style="width:25%">
                <input type="checkbox" name="ckbRFID" value="Y" disabled="disabled">
                  <xsl:if test="CLSCODE!='Q' and CLSCODE!='S' and CLSCODE!='J' and CLSCODE!='C' and CLSCODE!='ETC'">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                </input>
                <label style="margin-left: 4px">대상</label>
              </span>
              <span class="f-option1" style="width:25%">
                <input type="checkbox" name="ckbRFID" value="N" disabled="disabled">
                  <xsl:if test="CLSCODE='Q' or CLSCODE='S' or CLSCODE='J' or CLSCODE='C' or CLSCODE='ETC'">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                </input>
				  <label style="margin-left: 4px">비대상</label>
              </span>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="font-size:11px">적용(Sub)모델</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNO" style="width:92%">
                    <!--<xsl:attribute name="tabindex">
                      <xsl:value-of select="ROWSEQ" />02
                    </xsl:attribute>-->
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNO" />
                    </xsl:attribute>
                  </input>
                  <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdmproduct',this,'MODELNM','MODELOID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="적용(Sub)모델" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdmproduct','MODELNO','MODELNM','MODELOID');">
	                    <i class="fas fa-angle-down"></i>
                    </button>
                  <!--<input type="text" name="MODELNO" class="txtRead" readonly="readonly" value="{MODELNO}" />-->
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="MODELOID!=''">
                      <a target="_blank">
                        <xsl:attribute name="href">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(MODELOID))" />
                        </xsl:attribute>
                        <xsl:value-of select="MODELNO" />
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="MODELOID" value="{MODELOID}" />

				<xsl:if test="ModelImgPath!=''">
					&nbsp;
					<a class="btn btn-default btn-sm" aria-controls="vw-toggle-{ROWSEQ}-{MODELNO}" onclick="_zw.ut.ctrls();" title="사진">
						<i class="fas fa-angle-up text-dark"></i>
					</a>

					<div class="zf-photoview w-100 p-2 d-none" data-controls="vw-toggle-{ROWSEQ}-{MODELNO}">
						<a href="javascript://" onclick="_zw.mu.photoPopup('model', '{MODELNO}');" class="img-thumbnail img-thumbnail-shadow" title="{MODELNO}">
							<span class="img-thumbnail-overlay bg-white opacity-25"></span>
							<img src="{ModelImgPath}" class="img-fluid" alt="" style="max-width: " />
						</a>
					</div>
				</xsl:if>
            </td>
            <td class="f-lbl-sub">품명</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <!--<input type="text" name="MODELNM">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNM" />
                    </xsl:attribute>
                  </input>-->
                  <input type="text" name="MODELNM" class="txtRead" readonly="readonly" value="{MODELNM}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNM))" />
                  <input type="hidden" name="MODELOID" value="{MODELNM}" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">부품</td>
            <td colspan="3" style="border-right:0">
              <div class="subtbl_div" max="5" min="1" fld="PARTNO^PARTNM^PARTOID">
                <div>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="PARTNO1" style="width:230px">
						  <!--<xsl:attribute name="tabindex">
                          <xsl:value-of select="ROWSEQ" />03
                        </xsl:attribute>-->
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="PARTNO1" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							<i class="fas fa-angle-down"></i>
						</button>&nbsp;(
                      <input type="text" name="PARTNM1" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="PARTNM1" />
                        </xsl:attribute>
                      </input>)
                      <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 1)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg" style="display:none">
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>-->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="PARTOID1!=''">
                          <a target="_blank">
                            <xsl:attribute name="href">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID1))" />
                            </xsl:attribute>
                            <xsl:value-of select="PARTNO1" />
                          </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO1))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="PARTOID1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTOID1" />
                    </xsl:attribute>
                  </input>

					<xsl:if test="PartImgPath!=''">
						&nbsp;
						<a class="btn btn-default btn-sm" aria-controls="vw-toggle-{ROWSEQ}-{PARTNO1}" onclick="_zw.ut.ctrls();" title="사진">
							<i class="fas fa-angle-up text-dark"></i>
						</a>

						<div class="zf-photoview w-100 p-2 d-none" data-controls="vw-toggle-{ROWSEQ}-{PARTNO1}">
							<a href="javascript://" onclick="_zw.mu.photoPopup('part', '{PARTNO1}');" class="img-thumbnail img-thumbnail-shadow" title="{PARTNO1}">
								<span class="img-thumbnail-overlay bg-white opacity-25"></span>
								<img src="{PartImgPath}" class="img-fluid" alt="" style="max-width: " />
							</a>
						</div>
					</xsl:if>
                </div>
                <xsl:if test="phxsl:isDiff(string(PARTNO2),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO2" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO2" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM2" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM2" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 2)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 2)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID2!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID2))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO2" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO2))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID2">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID2" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO3),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO3" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO3" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM3" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM3" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 3)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 3)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID3!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID3))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO3" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM3))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO3))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM3))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID3">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID3" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO4),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO4" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO4" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM4" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM4" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 4)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 4)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID4!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID4))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO4" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM4))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO4))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM4))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID4">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID4" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO5),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO5" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO5" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM5" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM5" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 5)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 5)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID5!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID5))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO5" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM5))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO5))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM5))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID5">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID5" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO6),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO6" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO6" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM6" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM6" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 6)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 6)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID6!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID6))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO6" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM6))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO6))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM6))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID6">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID6" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO7),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO7" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO7" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM7" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM7" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 7)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 7)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID7!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID7))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO7" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM7))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO7))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM7))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID7">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID7" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO8),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO8" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO8" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM8" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM8" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 8)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 8)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID8!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID8))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO8" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM8))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO8))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM8))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID8">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID8" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO9),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO9" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO9" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM9" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM9" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 9)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <xsl:if test="phxsl:isGt(string(PARTCNT), 9)">
                            <xsl:attribute name="style">display:none</xsl:attribute>
                          </xsl:if>
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID9!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID9))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO9" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM9))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO9))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM9))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID9">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID9" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO10),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO10" style="width:230px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNO10" />
                          </xsl:attribute>
                        </input>
                        <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                          </img>
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="부품" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'pdm','PARTNO','PARTNM','PARTOID');">
							  <i class="fas fa-angle-down"></i>
						  </button>&nbsp;(
                        <input type="text" name="PARTNM10" style="width:278px">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="PARTNM10" />
                          </xsl:attribute>
                        </input>)
                        <!--<button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg" style="display:none">
                          <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                          </img>
                        </button>
                        <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                          <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                            <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                          </img>
                        </button>-->
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID10!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID10))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO10" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM10))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO10))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM10))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID10">
                      <xsl:attribute name="value">
                        <xsl:value-of select="PARTOID10" />
                      </xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
              </div>
              <input type="hidden" name="PARTCNT">
                <xsl:attribute name="value">
                  <xsl:value-of select="PARTCNT" />
                </xsl:attribute>
              </input>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">관련도면</td>
            <td colspan="3" style="border-right:0;padding:2px">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">&nbsp;</xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="//optioninfo/foption1[ROWSEQ=$rowidx]">
                      <xsl:for-each select="//optioninfo/foption1[ROWSEQ=$rowidx]">
                        <div>
                          <a target="_blank" href="javascript:void(0)">
                            <xsl:attribute name="onclick">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkForm(string(//config/@web), string($root), string(MessageID))" />
                            </xsl:attribute>
                            <xsl:value-of select="PIName"/>_V<xsl:value-of select="MAINREVISION"/>&nbsp;(<xsl:value-of select="DocNumber"/>)
                          </a>
                          <!--<xsl:if test="position()&lt;last()"><xsl:text>,&nbsp;&nbsp;</xsl:text></xsl:if>--><!-- label,span 태그 사용시 -->
                        </div>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>&nbsp;</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">공용구분</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpub'],'CMNTYPE',string(CMNTYPE),'','','120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CMNTYPE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">제작벌수</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="TOOLREQQTY" style="width:60px" class="txtVolume" maxlength="3" data-inputmask="number;3;0" value="{TOOLREQQTY}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOOLREQQTY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">CAVITY</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="CAVITYA" style="width:53px" class="txtNumberic" maxlength="3" data-inputmask="number;3;0" value="{CAVITYA}" />
                  &nbsp;*&nbsp;
                  <input type="text" name="CAVITY" style="width:53px" class="txtNumberic" maxlength="3" data-inputmask="number;3;0" value="{CAVITY}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITYA))" />
                  &nbsp;*&nbsp;
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">만기SHOT</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="EXPIREDSHOT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{EXPIREDSHOT}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPIREDSHOT))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
          
            <!--<td class="f-lbl-sub">예상투자비</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="EXPECTCOSTCURRENCY" style="width:35px">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                  <input type="text" name="EXPECTCOST" style="width:110px">
                    <xsl:attribute name="class">txtDollar</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="onblur">parent.fnFormEvent(this)</xsl:attribute>
                  </input>
                  <input type="text" name="CONVEXPECTCOST" style="width:110px">
                    <xsl:attribute name="class">txtDollar</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPECTCOSTCURRENCY))" />)&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPECTCOST))" />
                  &nbsp;=>&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONVEXPECTCOST))" />
                </xsl:otherwise>
              </xsl:choose>              
            </td>-->
            <td class="f-lbl-sub">제작단가</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PRODUCTCOSTCURRENCY" style="width:38px;height:16px;margin-right:2px">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="PRODUCTCOSTCURRENCY" />
                    </xsl:attribute>
                  </input>
                  <!--<button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,214,-100,0,'etc','PRODUCTCOSTCURRENCY');">
						<i class="fas fa-angle-down"></i>
					</button>
                  <input type="text" name="PRODUCTCOST" style="width:90px" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PRODUCTCOST}" />&nbsp;
                  <input type="text" name="CONVPRODUCTCOST" style="width:90px" class="txtDollar" readonly="readonly" value="{CONVPRODUCTCOST}" />
                </xsl:when>
                <xsl:otherwise>
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOSTCURRENCY))" />)&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOST))" />
                  &nbsp;=>&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONVPRODUCTCOST))" />
                  <input type="hidden" name="CONVPRODUCTCOST" value="{CONVPRODUCTCOST}" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">제작비용</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PRODUCTCOSTSUM" style="width:100px">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                  <input type="text" name="CONVPRODUCTCOSTSUM" style="width:100px">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOSTCURRENCY))" />)&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOSTSUM))" />
                  &nbsp;=>&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONVPRODUCTCOSTSUM))" />
                  <input type="hidden" name="CONVPRODUCTCOSTSUM" value="{CONVPRODUCTCOSTSUM}" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">           
            <td class="f-lbl-sub">제작처</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="SUPPLIER" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="SUPPLIER" />
                    </xsl:attribute>
                  </input>
                  <!--<button onclick="parent.fnExternal('erp.vendorcustomer',240,40,136,74,'VENDOR',this,'SUPPLIERID','SUPPLIERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="BUYER" onclick="_zw.formEx.externalWnd('erp.vendorcustomer',240,40,126,70,'VENDOR','SUPPLIER','SUPPLIERID','SUPPLIERSITEID');">
						<i class="fas fa-angle-down"></i>
					</button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUPPLIER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="SUPPLIERID">
                <xsl:attribute name="value">
                  <xsl:value-of select="SUPPLIERID" />
                </xsl:attribute>
              </input>
              <input type="hidden" name="SUPPLIERSITEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="SUPPLIERSITEID" />
                </xsl:attribute>
              </input>
            </td>
            <!--<td class="f-lbl-sub">차이금액</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MARGIN">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MARGIN))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>-->
            <td class="f-lbl-sub">결제조건</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingsettl'],'SETTLEMENTCODE',string(SETTLEMENTCODE),'SETTLEMENT',string(SETTLEMENT),'120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SETTLEMENT))" />
                  <input type="hidden" name="SETTLEMENTCODE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="SETTLEMENTCODE" />
                    </xsl:attribute>
                  </input>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">          
            <td class="f-lbl-sub">소유구분</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='영업수신' and $actrole='__r' and $partid!='')">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpos'],'POSTYPE',string(POSTYPE),'','','120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(POSTYPE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">소유처</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='영업수신' and $actrole='__r' and $partid!='')">
                  <input type="text" name="OWNER" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="OWNER" />
                    </xsl:attribute>
                  </input>
                  <!--<button onclick="parent.fnExternal('erp.vendorcustomer',240,40,136,74,'BUYER',this,'OWNERID','OWNERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="소유처" onclick="_zw.formEx.externalWnd('erp.vendorcustomer',240,40,126,70,'BUYER','OWNER','OWNERID','OWNERSITEID');">
						<i class="fas fa-angle-down"></i>
					</button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(OWNER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="OWNERID">
                <xsl:attribute name="value">
                  <xsl:value-of select="OWNERID" />
                </xsl:attribute>
              </input>
              <input type="hidden" name="OWNERSITEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="OWNERSITEID" />
                </xsl:attribute>
              </input>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">재질</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="TOOLSPEC">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="TOOLSPEC" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TOOLSPEC))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">영업담당</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='영업수신' and $actrole='__r' and $partid!='')">
                  <input type="text" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="CHARGEDEPT" />
                      <xsl:value-of select="CHARGEUSER" />
                    </xsl:attribute>
                  </input>
                  <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='영업수신' and $actrole='__r' and $partid!='')">
                    <!--<button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                    </button>-->
					  <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="영업담당" onclick="_zw.fn.org('user','n',this);">
						  <i class="fas fa-angle-down"></i>
					  </button>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CHARGEDEPT))" />&nbsp;
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CHARGEUSER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="CHARGEDEPT" value="{CHARGEDEPT}" />
              <input type="hidden" name="CHARGEDEPTCD" value="{CHARGEDEPTCD}" />
              <input type="hidden" name="CHARGEUSER" value="{CHARGEUSER}" />
              <input type="hidden" name="CHARGEUSERID" value="{CHARGEUSERID}" />
              <input type="hidden" name="CHARGEUSEREMPID" value="{CHARGEUSEREMPID}" />
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">제작기간</td>
            <td colspan="3" style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MAKEFROM" class="datepicker txtDate" style="width:100px" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{MAKEFROM}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(MAKEFROM))" />
                </xsl:otherwise>
              </xsl:choose>
              &nbsp;~&nbsp;
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MAKETO" class="datepicker txtDate" style="width:100px" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{MAKETO}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(MAKETO))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">금형비부담</td>
            <td colspan="3" style="border-right:0">
              <span class="f-option3" style="width:10%">
                <input type="checkbox" name="ckbWHOMONEY" value="당사" id="ckb.{ROWSEQ}.1">
                  <xsl:if test="$bizrole='영업수신' and $actrole='__r' and $partid!=''">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbWHOMONEY', this, 'WHOMONEY')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(WHOMONEY),'당사')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='영업수신' and $actrole='__r' and $partid!='')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.{ROWSEQ}.1" style="margin-left: 2px">당사</label>
              </span>
              <span class="f-option3" style="width:8%">
                <input type="checkbox" name="ckbWHOMONEY" value="고객" id="ckb.{ROWSEQ}.2">
                  <xsl:if test="$bizrole='영업수신' and $actrole='__r' and $partid!=''">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbWHOMONEY', this, 'WHOMONEY')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(WHOMONEY),'고객')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='영업수신' and $actrole='__r' and $partid!='')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.{ROWSEQ}.2" style="margin-left: 2px">고객</label>
              </span>
              (&nbsp;<span class="f-option3" style="width:15%">
                <input type="checkbox" name="ckbWHOMONEYDETAIL" value="감가상각" id="ckb.{ROWSEQ}.3">
                  <xsl:if test="$bizrole='영업수신' and $actrole='__r' and $partid!=''">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbWHOMONEYDETAIL', this, 'WHOMONEYDETAIL')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(WHOMONEYDETAIL),'감가상각')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new'">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <xsl:if test="phxsl:isEqual(string(WHOMONEY),'당사')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(WHOMONEYDETAIL),'감가상각')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>-->
                </input>
                <label for="ckb.{ROWSEQ}.3" style="margin-left: 2px">감가상각</label>
              </span>
              <span class="f-option3" style="width:13%">
                <input type="checkbox" name="ckbWHOMONEYDETAIL" value="고객청구" id="ckb.{ROWSEQ}.4">
                  <xsl:if test="$bizrole='영업수신' and $actrole='__r' and $partid!=''">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbWHOMONEYDETAIL', this, 'WHOMONEYDETAIL')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(WHOMONEYDETAIL),'고객청구')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new'">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <xsl:if test="phxsl:isEqual(string(WHOMONEY),'당사')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(WHOMONEYDETAIL),'고객청구')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>-->
                </input>
                <label for="ckb.{ROWSEQ}.4" style="margin-left: 2px">고객청구</label>
              </span>)
              <input type="hidden" name="WHOMONEY" value="{WHOMONEY}" />
              <input type="hidden" name="WHOMONEYDETAIL" value="{WHOMONEYDETAIL}" />
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="border-bottom:0;font-size:11px">비용회수<br />사업장</td>
            <td style="0;border-bottom:0">
              <xsl:choose>
                <xsl:when test="$bizrole='영업수신' and $actrole='__r' and $partid!=''">
                  <input type="text" name="RTVLORGNM" style="width:60%" class="txtText_u" readonly="readonly" value="{RTVLORGNM}" />
                  <!--<button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode',this, 'RTVLORGID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                  </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="사업장" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-160,0,'orgcode','RTVLORGNM', 'RTVLORGID');">
						<i class="fas fa-angle-down"></i>
					</button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(RTVLORGNM))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="RTVLORGID" value="{RTVLORGID}" />
            </td>
            <td class="f-lbl-sub" style="border-bottom:0;font-size:11px">비용회수<br />예정일</td>
            <td style="border-right:0;border-bottom:0">
              <xsl:choose>
                <xsl:when test="$bizrole='영업수신' and $actrole='__r' and $partid!=''">
                  <input type="text" name="RTVLORGEXPDT" class="datepicker txtDate" style="width:100px" maxlength="8" data-inputmask="date;yyyy-MM-dd" value="{RTVLORGEXPDT}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(RTVLORGEXPDT))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />-->
            <input type="text" class="txtRead"  name="ROWSEQ">
              <xsl:attribute name="value"><xsl:value-of select="ROWSEQ" /></xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMNAME">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNAME))" />-->
            <input type="text" class="txtRead"  name="ITEMNAME">
              <xsl:attribute name="value"><xsl:value-of select="ITEMNAME" /></xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT" class="txtVolume" maxlength="10" data-inputmask="number;10;0" value="{COUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COUNT))" />-->
            <input type="text" class="txtRead"  name="COUNT">
              <xsl:attribute name="value">
                <xsl:value-of select="COUNT" />
              </xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAVITYS" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{CAVITYS}" />
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITYS))" />-->
            <input type="text" class="txtRead"  name="CAVITYS">
              <xsl:attribute name="value">
                <xsl:value-of select="CAVITYS" />
              </xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNIT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{UNIT}" />
          </xsl:when>
          <xsl:otherwise>            
            <input type="text" class="txtRead"  name="UNIT">
              <xsl:attribute name="value">
                <xsl:value-of select="UNIT" />
              </xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:right</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM" class="txtRead_Right" readonly="readonly" value="{SUM}" />              
          </xsl:when>
          <xsl:otherwise>            
            <input type="text" class="txtRead"  name="SUM">
              <xsl:attribute name="value">
                <xsl:value-of select="SUM" />
              </xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:right</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUMKRW" class="txtRead_Right" readonly="readonly" value="{SUMKRW}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="text" class="txtRead"  name="SUMKRW">
              <xsl:attribute name="value">
                <xsl:value-of select="SUMKRW" />
              </xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:right</xsl:attribute>
            </input>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
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
</xsl:stylesheet>
