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
          .m {width:700px} .m .fm-editor {height:350px;min-height:350px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt;}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:6%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:350px;min-height:350px}}
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
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Site', '3', '처리부서')"/>
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" text-align="center">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:20%"></col>
                <col style="width:15%"></col>
                <col style="width:15%"></col>
                <col style="width:15%"></col>
                <col style="width:"></col>
              </colgroup>
              <tr>
                <td class="f-lbl4">품명</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText" maxlength="100" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">모델명</td>
                <td colspan="2"  style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText" style="width:91%; margin-right: 2px" value="{//forminfo/maintable/MODELNAME}" />
                      <!--<button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
					    <button type="button" class="btn btn-outline-secondary btn-18" title="모델명" onclick="_zw.formEx.externalWnd('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME','ITEMNAME');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">개발단계</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STEP" style="width:86%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STEP" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.devstep',140,120,130,70,'etc','STEP');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
					    <button type="button" class="btn btn-outline-secondary btn-18" title="개발단계" onclick="_zw.formEx.optionWnd('external.devstep',140,214,-120,0,'etc','STEP');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STEP))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">고객명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
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
                <td class="f-lbl4">검토일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEWDAY" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/REVIEWDAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEWDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">생산지</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCTCENTER" style="width:86%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PRODUCTCENTER" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.centercode',200,140,50,90,'','PRODUCTCENTER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
					    <button type="button" class="btn btn-outline-secondary btn-18" title="생산지" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-130,0,'','PRODUCTCENTER');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTCENTER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">제작수량</td>
                <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="COUNT1" class="txtNumberic" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/COUNT1}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COUNT1))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                <td class="f-lbl4">검토수량</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNT2" class="txtNumberic" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/COUNT2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COUNT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">
                  검토부서
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <!--<button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">
                          /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                        </xsl:attribute>
                      </img>
                    </button>-->
				    <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="검토부서" onclick="_zw.fn.org('user','n');">
						  <i class="fas fa-angle-down"></i>
					  </button>
                  </xsl:if>
                </td>
                <td colspan="2" style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEPT">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEPT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" style="border-bottom:0">담당자</td>
                <td colspan="2"  style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MANAGER">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MANAGER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MANAGER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>


          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>문제점 발생현황</span>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:15%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl4" colspan="2">구분</td>
                <td class="f-lbl4">기구</td>
                <td class="f-lbl4">회로</td>
                <td class="f-lbl4">음향</td>
                <td class="f-lbl4">공정</td>
                <td class="f-lbl4">환경</td>
                <td class="f-lbl4">기타</td>
                <td class="f-lbl4" style="border-right:0">합계</td>
              </tr>
              <tr>
                <td class="f-lbl4" rowspan="4">CRITICAL</td>
                <td class="f-lbl4">발생</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="A1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/A1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/A1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="A2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/A2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/A2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="A3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/A3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/A3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="A4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/A4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/A4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="A5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/A5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/A5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="A6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/A6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/A6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMA">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMA" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMA))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">완료</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="B1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/B1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/B1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="B2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/B2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/B2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="B3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/B3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/B3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="B4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/B4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/B4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="B5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/B5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/B5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="B6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/B6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/B6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMB">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMB" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMB))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">미결</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="C1">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/C1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/C1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="C2">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/C2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/C2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="C3">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/C3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/C3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="C4">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/C4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/C4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="C5">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/C5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/C5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="C6">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/C6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/C6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMC">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">완료율(%)</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="D1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/D1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/D1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="D2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/D2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/D2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="D3">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/D3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/D3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="D4">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/D4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/D4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="D5">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/D5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/D5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="D6">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/D6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/D6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMD">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMD" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMD))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" rowspan="4">MAJOR</td>
                <td class="f-lbl4">발생</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="E1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/E1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/E1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="E2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/E2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/E2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="E3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/E3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/E3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="E4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/E4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/E4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="E5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/E5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/E5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="E6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/E6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/E6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUME">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">완료</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="F1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/F1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/F1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="F2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/F2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/F2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="F3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/F3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/F3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="F4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/F4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/F4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="F5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/F5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/F5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="F6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/F6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/F6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMF">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMF" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMF))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">미결</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="G1">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/G1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/G1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="G2">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/G2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/G2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="G3">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/G3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/G3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="G4">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/G4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/G4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="G5">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/G5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/G5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="G6">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/G6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/G6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMG">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMG" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMG))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">완료율(%)</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="H1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/H1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/H1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="H2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/H2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/H2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="H3">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/H3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/H3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="H4">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/H4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/H4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="H5">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/H5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/H5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="H6">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/H6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/H6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMH">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMH" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMH))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" rowspan="4" style="border-bottom:0">MINOR</td>
                <td class="f-lbl4" >발생</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="I1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/I1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/I1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="I2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/I2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/I2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="I3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/I3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/I3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="I4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/I4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/I4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="I5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/I5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/I5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="I6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/I6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/I6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMI">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMI" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMI))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">완료</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="J1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/J1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/J1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="J2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/J2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/J2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="J3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/J3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/J3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="J4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/J4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/J4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="J5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/J5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/J5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="J6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/J6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/J6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMJ">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMJ" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMJ))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">미결</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="K1">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/K1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/K1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="K2">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/K2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/K2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="K3">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/K3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/K3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="K4">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/K4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/K4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="K5">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/K5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/K5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="K6">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/K6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/K6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUMK">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUMK" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUMK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">완료율(%)</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="L1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/L1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/L1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="L2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/L2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/L2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="L3">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/L3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/L3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="L4">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/L4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/L4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="L5">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/L5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/L5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="L6">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/L6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/L6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($partid!='' and $bizrole='confirm' and $actrole='_approver')">
                      <input type="text" id="__mainfield" name="SUML">
                        <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUML" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUML))" />
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
            <span>특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm-editor">
            <xsl:if test="$mode!='new' and $mode!='edit'">
                <xsl:attribute name="class">fm-editor h-auto</xsl:attribute>
            </xsl:if>
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
                <!--<iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no">
                  <xsl:attribute name="src">
                    /<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx
                  </xsl:attribute>
                </iframe>-->
			  <div class="h-100" id="__DextEditor"></div>
              </xsl:otherwise>
            </xsl:choose>
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
