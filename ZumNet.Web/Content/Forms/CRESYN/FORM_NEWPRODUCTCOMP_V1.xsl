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
          .m {width:760px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:13%} .m .ft .f-lbl1 {width:8%} .m .ft .f-lbl2 {width:10%} .m .ft .f-lbl3 {width:9%}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
          .m .ft-sub .f-option {width:49%}
          .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

          /* 폰트 작게 */
          .si-tbl td,.m .fm-lines .si-list td,.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div {font-size:12px}
          .m .fm span,.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:12px}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:650px} .fm-lines {display:none}}
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
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '4', '검증부서', 'N')"/>
                </td>
                <td style="width:75px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">문서번호</td>
                <td style="width:30%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일자</td>
                <td style="width:20%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl1">Rev</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
						<input type="text" id="__mainfield" name="MAINREVISION" class="txtNumberic" maxlength="5" data-inputmask="number;5;0" value="{//forminfo/maintable/MAINREVISION}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
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
                <td colspan="3"  style="border-bottom:0;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>* 개발품 개요</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:13%" />
                <col style="width:21%" />
                <col style="width:13%" />
                <col style="width:20%" />
                <col style="width:13%" />
                <col style="width:20%" />
              </colgroup>
              <tr>
                <td class="f-lbl4">모델명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" readonly="readonly"  style="width:86%" value="{//forminfo/maintable/MODELNAME}" />
                      <!--<button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="모델명" onclick="_zw.formEx.externalWnd('report.SEARCH_NEWDEVREQMODEL',240,40,20,70,'','MODELNAME');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">Description</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DESCRIPT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" >고객명</td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" >수주형태</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVTYPE" style="width:86%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVTYPE" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.devtype',120,110,100,80,'etc','DEVTYPE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="수주형태" onclick="_zw.formEx.optionWnd('external.devtype',140,124,-120,0,'etc','DEVTYPE');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVTYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">생산지</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCECENTER" style="width:85%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PRODUCECENTER" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.centercode',200,140,100,120,'','PRODUCECENTER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="생산지" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-60,0,'','PRODUCECENTER');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCECENTER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">개발등급</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVCLASS" style="width:86%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCLASS" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.devclass',80,110,100,80,'','DEVCLASS');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="개발등급" onclick="_zw.formEx.optionWnd('external.devclass',140,124,-120,0,'','DEVCLASS');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCLASS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" style="border-bottom:0">개발방법</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVTERMS" style="width:86%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVTERMS" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.devterms',100,110,80,80,'etc','DEVTERMS');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="개발방법" onclick="_zw.formEx.optionWnd('external.devterms',140,124,-120,0,'etc','DEVTERMS');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVTERMS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="STEP" value="PMP" />
                </td>
                <td class="f-lbl4" style="border-bottom:0">&nbsp;</td>
                <td style="border-bottom:0;border-right:0">
                  &nbsp;
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>* 투입개발인력</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl2">부서명</td>
                <td class="f-lbl2">PM
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT7">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTDEPT8">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">직급</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE7">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE8">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTGRADE9">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE9" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="border-bottom:0">담당</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT7">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT8">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTICIPANT9">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT9" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div>
            <table border="0" cellspacing="0" cellpadding="0" style="width:100%">
              <tr>
                <td style="width:70%">
                  <div class="fm">
                    <span>* 개발일정 계획대비 실적</span>
                  </div>
                  <div class="ff" />

                  <div class="fm">
                    <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                      </xsl:if>
                      <colgroup>
                        <col style="width:10%" />
                        <col style="width:13%" />
                        <col style="width:13%" />
                        <col style="width:13%" />
                        <col style="width:13%" />
                        <col style="width:13%" />
                        <col style="width:13%" />
                        <col style="width:12%" />                        
                      </colgroup>
                      <tr>
                        <td class="f-lbl4" rowspan="2"  style="height:40px">개발기간</td>
                        <td colspan="5">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
								<input type="text" id="__mainfield" name="DEVFROM" class="datepicker txtDate" style="width:90px" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/DEVFROM}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVFROM))" />
                            </xsl:otherwise>
                          </xsl:choose>
                          &nbsp;~&nbsp;
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">								
                              <input type="text" id="__mainfield" name="DEVTO" class="datepicker txtDate" style="width:90px" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/DEVTO}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVTO))" />
                            </xsl:otherwise>
                          </xsl:choose>
                          &nbsp;&nbsp;&nbsp;[
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVYEAR" class="txtNumberic" style="width:30px" maxlength="4" data-inputmask="number;4;0" value="{//forminfo/maintable/DEVYEAR}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVYEAR))" />
                            </xsl:otherwise>
                          </xsl:choose>
                          &nbsp;년&nbsp;
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVMONTH" class="txtNumberic" style="width:30px" maxlength="2" data-inputmask="number;2;0" value="{//forminfo/maintable/DEVMONTH}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVMONTH))" />
                            </xsl:otherwise>
                          </xsl:choose>
                          &nbsp;개월&nbsp;                          
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVDAY" class="txtNumberic" style="width:30px" maxlength="2" data-inputmask="number;2;0" value="{//forminfo/maintable/DEVDAY}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVDAY))" />
                            </xsl:otherwise>
                          </xsl:choose>
                          &nbsp;일&nbsp;개발기간]
                        </td>
                        <td class="f-lbl4">신개의 접수일</td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REQUESTDAY" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/REQUESTDAY}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REQUESTDAY))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                      <tr>
                        <td class="f-lbl4">W-Mock</td>
                        <td class="f-lbl4">EP</td>
                        <td class="f-lbl4">PP</td>
                        <td class="f-lbl4">고객승인</td>
                        <td class="f-lbl4">PMP</td>
                        <td class="f-lbl4">MP</td>
                        <td class="f-lbl4" style="border-right:0">비고</td>
                      </tr>
                      <tr>
                        <td class="f-lbl4">계획</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PLANDATE1" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PLANDATE2" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PLANDATE3" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PLANDATE4" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PLANDATE5" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE5}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE5))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PLANDATE6" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/PLANDATE6}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANDATE6))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                      
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ETC1">
                                <xsl:attribute name="class">txtText</xsl:attribute>
                                <xsl:attribute name="maxlength">50</xsl:attribute>
                                <xsl:attribute name="value">
                                  <xsl:value-of select="//forminfo/maintable/ETC1" />
                                </xsl:attribute>
                              </input>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETC1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                      <tr>
                        <td class="f-lbl4">실적</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ENFORCEDATE1" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/ENFORCEDATE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ENFORCEDATE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ENFORCEDATE2" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/ENFORCEDATE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ENFORCEDATE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ENFORCEDATE3" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/ENFORCEDATE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ENFORCEDATE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ENFORCEDATE4" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/ENFORCEDATE4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ENFORCEDATE4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ENFORCEDATE5" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/ENFORCEDATE5}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ENFORCEDATE5))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ENFORCEDATE6" class="datepicker-slash txtDateSlash" maxlength="10" data-inputmask="date;yyyy/MM/dd" value="{//forminfo/maintable/ENFORCEDATE6}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ENFORCEDATE6))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                      
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ETC2">
                                <xsl:attribute name="class">txtText</xsl:attribute>
                                <xsl:attribute name="maxlength">50</xsl:attribute>
                                <xsl:attribute name="value">
                                  <xsl:value-of select="//forminfo/maintable/ETC2" />
                                </xsl:attribute>
                              </input>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETC2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="border-bottom:0;font-size:11px">Try 횟수</td>
                        <td style="border-bottom:0">
                          &nbsp;
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="EVENTCOUNT1" class="txtCurrency" maxlength="5" data-inputmask="number;5;0" value="{//forminfo/maintable/EVENTCOUNT1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EVENTCOUNT1))" />
                            </xsl:otherwise>
                          </xsl:choose> 
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="EVENTCOUNT2" class="txtCurrency" maxlength="5" data-inputmask="number;5;0" value="{//forminfo/maintable/EVENTCOUNT2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EVENTCOUNT2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          &nbsp;
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="EVENTCOUNT3" class="txtCurrency" maxlength="5" data-inputmask="number;5;0" value="{//forminfo/maintable/EVENTCOUNT3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EVENTCOUNT3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          &nbsp;
                        </td>
                        <td style="border-bottom:0;border-right:0">
                          &nbsp;
                        </td>
                      </tr>
                    </table>
                  </div>
                </td>                
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl4" style="height:80px;width:4%;border-bottom:0">
                 제<br />품<br />개<br />요
                </td>
                <td style="width:46%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PRODUCTSUMMARY" style="height:70px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PRODUCTSUMMARY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:70px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTSUMMARY))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" style="width:4%;border-bottom:0">
                  제<br />품<br />성<br />능
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PRODUCTABILLITY" style="height:70px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PRODUCTABILLITY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
						<div class="txaRead" style="min-height:70px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTABILLITY))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          
          <div>
            <table border="0" cellspacing="0" cellpadding="0" style="width:100%">
              <tr>
                <td style="width:42%; vertical-align: top">
                  <div class="fm">
                    <span>* 개발원가(재료비) 현황&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      통화&nbsp;:&nbsp;
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="CURRENCY2" style="width:60px;height:16px">
                            <xsl:attribute name="class">txtText_u</xsl:attribute>
                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/CURRENCY2" />
                            </xsl:attribute>
                          </input>
                          <!--<button onclick="parent.fnOption('iso.currency',160,140,40,110,'etc','CURRENCY2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                            <img alt="" class="blt01" style="margin:0 0 2px 0">
                              <xsl:attribute name="src">
                                /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                              </xsl:attribute>
                            </img>
                          </button>-->
							<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY2');">
								<i class="fas fa-angle-down"></i>
							</button>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />&nbsp;
                        </xsl:otherwise>
                      </xsl:choose>
                    </span>                    
                  </div>
                  <div class="ff" />
                  <div class="fm">
                    <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                      </xsl:if>
                      <colgroup>
                        <col style="width:" />
                        <col style="width:20%" />
                        <col style="width:16%" />
                        <col style="width:16%" />
                        <col style="width:16%" />
                        <col style="width:16%" />
                      </colgroup>
                      <tr>
                        <td class="f-lbl4" colspan="2">&nbsp;</td>                        
                        <td class="f-lbl4">EP</td>
                        <td class="f-lbl4">PP</td>
                        <td class="f-lbl4">PMP</td>
                        <td class="f-lbl4" style="border-right:0">MP</td>
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0" colspan="2">실제개발원가</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REALCOST1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/REALCOST1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALCOST1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REALCOST2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/REALCOST2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALCOST2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REALCOST3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/REALCOST3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALCOST3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REALCOST4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/REALCOST4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALCOST4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                       
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0" colspan="2">개발견적가</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVCOSTS1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/DEVCOSTS1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVCOSTS1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVCOSTS2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/DEVCOSTS2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVCOSTS2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVCOSTS3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/DEVCOSTS3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVCOSTS3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="DEVCOSTS4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/DEVCOSTS4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVCOSTS4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                        
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0" colspan="2">판매가</td>
                        <td style="">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="RELPRICE1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/RELPRICE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RELPRICE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="RELPRICE2" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{//forminfo/maintable/RELPRICE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RELPRICE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="RELPRICE3" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{//forminfo/maintable/RELPRICE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RELPRICE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="RELPRICE4" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{//forminfo/maintable/RELPRICE4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RELPRICE4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                       
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0;border-bottom:0" rowspan="2">개당<br />이익율<br />(%)</td>
                        <td class="f-lbl4" style="font-size:11px;padding:0">견적가대비</td>
                        <td style="">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIDEVCOST1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIDEVCOST1}" />                                
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIDEVCOST1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIDEVCOST2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIDEVCOST2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIDEVCOST2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIDEVCOST3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIDEVCOST3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIDEVCOST3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0;">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIDEVCOST4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIDEVCOST4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIDEVCOST4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                       
                      </tr>
                      <tr>                        
                        <td class="f-lbl4" style="font-size:11px;padding:0;border-bottom:0">판매가대비</td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIRELPRICE1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIRELPRICE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIRELPRICE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIRELPRICE2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIRELPRICE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIRELPRICE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIRELPRICE3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIRELPRICE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIRELPRICE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0;border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="BIRELPRICE4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BIRELPRICE4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BIRELPRICE4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                    </table>
                  </div>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:29%; vertical-align: top">
                  <div class="fm">
                    <span>* 문제점 발생 및 해결율 현황</span>
                  </div>
                  <div class="ff" />

                  <div class="fm">
                    <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                      </xsl:if>
                      <colgroup>
                        <col style="width:28%" />
                        <col style="width:24%" />
                        <col style="width:24%" />
                        <col style="width:24%" />
                      </colgroup>
                      <tr>
                        <td class="f-lbl4">&nbsp;</td>
                        <td class="f-lbl4" >EP</td>
                        <td class="f-lbl4" >PP</td>
                        <td class="f-lbl4" style="border-right:0" >PMP</td>                        
                      </tr>                      
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0">등록건수</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REGISTCOUNT1" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/REGISTCOUNT1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REGISTCOUNT1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REGISTCOUNT2" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/REGISTCOUNT2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REGISTCOUNT2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="REGISTCOUNT3" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/REGISTCOUNT3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REGISTCOUNT3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                       
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0">해결건수</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SOLVECOUNT1" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/SOLVECOUNT1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SOLVECOUNT1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SOLVECOUNT2" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/SOLVECOUNT2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SOLVECOUNT2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SOLVECOUNT3" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/SOLVECOUNT3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SOLVECOUNT3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                      
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="font-size:11px;padding:0">미결건수</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROBUSCOUNT1" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PROBUSCOUNT1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROBUSCOUNT1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROBUSCOUNT2" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PROBUSCOUNT2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROBUSCOUNT2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROBUSCOUNT3" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/PROBUSCOUNT3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROBUSCOUNT3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                       
                      </tr>
                      <tr>
                        <td class="f-lbl4"  style="font-size:11px;padding:0;border-bottom:0">해결율%</td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SOLVERATE1" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/SOLVERATE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SOLVERATE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SOLVERATE2" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/SOLVERATE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SOLVERATE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0;border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SOLVERATE3" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/SOLVERATE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SOLVERATE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                      
                      </tr>
                    </table>
                  </div>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:28%; vertical-align: top">
                  <div class="fm">
                    <span>* 공정수율</span>
                  </div>
                  <div class="ff" />

                  <div class="fm">
                    <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                      </xsl:if>
                      <colgroup>
                        <col style="width:34%" />
                        <col style="width:22%" />
                        <col style="width:22%" />
                        <col style="width:22%" />
                      </colgroup>
                      <tr>
                        <td class="f-lbl4">단계</td>
                        <td class="f-lbl4">EP</td>
                        <td class="f-lbl4">PP</td>
                        <td class="f-lbl4" style="border-right:0">PMP</td>
                      </tr>
                      <tr>
                        <td class="f-lbl4">목표수율</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCGOALRATE1" class="txtDollar" maxlength="5" data-inputmask="number;2;3" value="{//forminfo/maintable/PROCGOALRATE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCGOALRATE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCGOALRATE2" class="txtDollar" maxlength="5" data-inputmask="number;2;3" value="{//forminfo/maintable/PROCGOALRATE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCGOALRATE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCGOALRATE3" class="txtDollar" maxlength="5" data-inputmask="number;2;3" value="{//forminfo/maintable/PROCGOALRATE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCGOALRATE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                      <tr>
                        <td class="f-lbl4">실적수율</td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCDORATE1" class="txtDollar" maxlength="5" data-inputmask="number;2;3" value="{//forminfo/maintable/PROCDORATE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCDORATE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCDORATE2" class="txtDollar" maxlength="5" data-inputmask="number;2;3" value="{//forminfo/maintable/PROCDORATE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCDORATE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCDORATE3" class="txtDollar" maxlength="5" data-inputmask="number;2;3" value="{//forminfo/maintable/PROCDORATE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCDORATE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                      <tr>
                        <td class="f-lbl4" style="border-bottom:0">달성율%</td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCRATE1" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/PROCRATE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCRATE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCRATE2" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/PROCRATE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCRATE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0;border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="PROCRATE3" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/PROCRATE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PROCRATE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                    </table>
                  </div>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div>
            <table border="0" cellspacing="0" cellpadding="0" style="width:100%">
              <tr>                
                <td style="width:100%">
                  <div class="fm">
                    <span class="f-option1">* 제품개발 투자비용(신규)</span>
                    <span class="f-option2">
                      통화&nbsp;:&nbsp;
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="CURRENCY" style="width:60px;height:16px">
                            <xsl:attribute name="class">txtText_u</xsl:attribute>
                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                            </xsl:attribute>
                          </input>
                          <!--<button onclick="parent.fnOption('iso.currency',160,140,40,110,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                            <img alt="" class="blt01" style="margin:0 0 2px 0">
                              <xsl:attribute name="src">
                                /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                              </xsl:attribute>
                            </img>
                          </button>-->
							<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
								<i class="fas fa-angle-down"></i>
							</button>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;
                        </xsl:otherwise>
                      </xsl:choose>
                    </span>
                  </div>
                  <div class="ff" />

                  <div class="fm">
                    <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                      </xsl:if>
                      <colgroup>
                        <col style="width:10%" />
                        <col style="width:10%" />
                        <col style="width:10%" />
                        <col style="width:10%" />
                        <col style="width:10%" />
                        <col style="width:5%" />
                        <col style="width:5%" />
                        <col style="width:10%" />
                        <col style="width:10%" />
                        <col style="width:12%" />                        
                      </colgroup>
                      <tr>
                        <td class="f-lbl4" colspan="2">금형투자</td>
                        <td class="f-lbl4" >설비/치공구</td>
                        <td class="f-lbl4" >인증비용</td>
                        <td class="f-lbl4" >외주설계</td>
                        <td class="f-lbl4" colspan="4">샘플</td>                      
                        <td class="f-lbl4" style="border-right:0">TOTAL</td>
                      </tr>
                      <tr>
                        <td class="f-lbl4">수량</td>
                        <td class="f-lbl4">금액</td>
                        <td class="f-lbl4">금액</td>
                        <td class="f-lbl4">금액</td>
                        <td class="f-lbl4">금액</td>
                        <td class="f-lbl4">유상</td>
                        <td class="f-lbl4">무상</td>
                        <td class="f-lbl4">u/price</td>
                        <td class="f-lbl4">금액</td>
                        <td rowspan="5" style="border-right:0;border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="TOTALPRICE">
                                <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                                <xsl:attribute name="readonly">readonly</xsl:attribute>
                                <xsl:attribute name="value">
                                  <xsl:value-of select="//forminfo/maintable/TOTALPRICE" />
                                </xsl:attribute>
                              </input>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                      <tr>                        
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTRQT" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/INVESTRQT}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTRQT))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTPRICE1" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/INVESTPRICE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTPRICE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTPRICE2" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/INVESTPRICE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTPRICE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTPRICE3" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/INVESTPRICE3}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTPRICE3))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTPRICE4" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/INVESTPRICE4}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTPRICE4))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTYPE1" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/INVESTYPE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTYPE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTYPE2" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{//forminfo/maintable/INVESTYPE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTYPE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTUNITPRICE" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/INVESTUNITPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTUNITPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td>
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="INVESTPRICE5" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/INVESTPRICE5}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTPRICE5))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>                        
                      </tr>
                      <tr>
                        <td class="f-lbl4" colspan="4">개발용품비</td>
                        <td class="f-lbl4" rowspan="2">기타비용</td>
                        <td class="f-lbl4" colspan="4"> 인건비</td>                        
                      </tr>
                      <tr>
                        <td class="f-lbl4">Mock-up</td>
                        <td class="f-lbl4">QDM</td>
                        <td class="f-lbl4">개발소모품</td>
                        <td class="f-lbl4">기타<font size="1">(부품개발)</font></td>
                        <td class="f-lbl4" colspan="2">출장비</td>
                        <td class="f-lbl4">인건비</td>
                        <td class="f-lbl4">합계</td>
                      </tr>
                      <tr>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="MOCKUPPRICE" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/MOCKUPPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MOCKUPPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="QDMPRICE" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/QDMPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/QDMPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="USELESSPRICE" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/USELESSPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/USELESSPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ETCPRICE1" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/ETCPRICE1}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ETCPRICE1))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="ETCPRICE2" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/ETCPRICE2}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ETCPRICE2))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0" colspan="2">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="TRIPPRICE" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/TRIPPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="MANPRICE" class="txtCurrency" maxlength="15" data-inputmask="number;15;0" value="{//forminfo/maintable/MANPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MANPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                        <td style="border-bottom:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <input type="text" id="__mainfield" name="SUMPRICE" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/SUMPRICE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMPRICE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr>
                    </table>
                  </div>
                </td>
              </tr>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />

          <div>
            <table border="0" cellspacing="0" cellpadding="0" style="width:100%">
              <tr>
                <td style="width:100%">
                  <div class="fm">
                    <span class="f-option1">* LESSON LEARNED(개발진행을 통하여 나온 개선점 및 보완점)</span>                    
                  </div>
                  <div class="ff" />
                  <div class="fm">
                    <table class="ft" border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td style="border-bottom:0;border-right:0">
                          <xsl:choose>
                            <xsl:when test="$mode='new' or $mode='edit'">
                              <textarea id="__mainfield" name="LESSONLEARNED" style="height:70px" class="txaText bootstrap-maxlength" maxlength="2000">
                                <xsl:if test="$mode='edit'">
                                  <xsl:value-of select="//forminfo/maintable/LESSONLEARNED" />
                                </xsl:if>
                              </textarea>
                            </xsl:when>
                            <xsl:otherwise>
                              <div class="txaRead" style="min-height:70px">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LESSONLEARNED))" />
                              </div>
                            </xsl:otherwise>
                          </xsl:choose>
                        </td>
                      </tr> 
                    </table>
                  </div>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <!--<div class="fm">
            <span>* 검증부서 의견</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMMENT" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/COMMENT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="COMMENT" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMMENT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>              
            </table>
          </div>-->

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
