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
          .m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:8%} .m .ft .f-lbl2 {width:6.6%} .m .ft .f-lbl3 {width:19.8%}
          .m .ft .f-option {width:20px} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
          .m .ft-sub .f-option {width:49%}
          .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '결재')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
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
                <td class="f-lbl">작성일</td>
                <td style="width:20%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl">Rev.</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAINREVISION" tabindex="1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
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
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
                <td class="f-lbl" style="border-bottom:0">개발단계</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STEP" value="EP">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STEP))" />
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">사업장</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ORGCODE" style="width:30%" tabindex="2">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ORGCODE" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','ORGCODE', 'ORGID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
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
              </tr>
              <tr>
                <td class="f-lbl">제목</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" tabindex="4">
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
              <tr>
                <td class="f-lbl" style="border-bottom:0;">요약</td>
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
							  <div class="txaRead" style="min-height:80px">
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

          <div class="fm">
            <span>* 금형 개요</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table id="__maintable1" class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%"></col>
                <col style="width:38%"></col>
                <col style="width:12%"></col>
                <col style="width:38%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">금형번호</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOOLINGNUMBER" style="width:39%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOOLINGNUMBER" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOpen('/BizForce/EA/ReportSheet.aspx?M=&amp;ft=REGISTER_TOOLING&amp;Lc=%uAE08%uD615%uB300%uC7A5',840,700,'resize','main',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="금형번호" onclick="_zw.formEx.reportWnd('REGISTER_TOOLING');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <a target="_blank">
                        <xsl:attribute name="href">/<xsl:value-of select="$root"/>/EA/Forms/XFormMain.aspx?M=read&amp;xf=tooling&amp;fi=REGISTER_TOOLING&amp;mi=<xsl:value-of select="//forminfo/maintable/TOOLINGNUMBER"/></xsl:attribute>
                        <xsl:attribute name="title">
                          <xsl:value-of select="//forminfo/maintable/TOOLINGNUMBER"/>
                        </xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/TOOLINGNUMBER"/>
                      </a>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">적용모델</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText_u" style="width:92%" value="{//forminfo/maintable/MODELNAME}" />
                      <!--<button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="적용모델" onclick="_zw.formEx.externalWnd('report.SEARCH_NEWDEVREQMODEL',240,40,20,70,'','MODELNAME');">
	                    <i class="fas fa-angle-down"></i>
                    </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">모델명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNM">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MODELNM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">부품</td>
                <td colspan="3" style="border-right:0">
                  <div class="subtbl_div">
                    <div>
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="PARTNO1" style="width:255px">
                            <xsl:attribute name="class">txtRead</xsl:attribute>
                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/PARTNO1" /></xsl:attribute>
                          </input>&nbsp;(
                          <input type="text" id="__mainfield" name="PARTNM1" style="width:335px">
                            <xsl:attribute name="class">txtRead</xsl:attribute>
                            <xsl:attribute name="readonly">readonly</xsl:attribute>
                            <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/PARTNM1" /></xsl:attribute>
                          </input>)
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:choose>
                            <xsl:when test="//forminfo/maintable/PARTOID1!=''">
                              <a target="_blank">
                                <xsl:attribute name="href">
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID1))" />
                                </xsl:attribute>
                                <xsl:value-of select="//forminfo/maintable/PARTNO1" />
                              </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM1))" />)
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO1))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM1))" />)
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>
                      <input type="hidden" id="__mainfield" name="PARTOID1">
                        <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/PARTOID1" /></xsl:attribute>
                      </input>
                    </div>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO2),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO2" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO2" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM2" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM2" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID2!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID2))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO2" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM2))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO2))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM2))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID2">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID2" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO3),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO3" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO3" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM3" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM3" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID3!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID3))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO3" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM3))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO3))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM3))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID3">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID3" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO4),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO4" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO4" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM4" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM4" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID4!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID4))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO4" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM4))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO4))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM4))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID4">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID4" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO5),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO5" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO5" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM5" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM5" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID5!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID5))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO5" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM5))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO5))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM5))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID5">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID5" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO6),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO6" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO6" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM6" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM6" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID6!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID6))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO6" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM6))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO6))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM6))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID6">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID6" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO7),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO7" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO7" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM7" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM7" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID7!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID7))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO7" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM7))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO7))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM7))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID7">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID7" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO8),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO8" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO8" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM8" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM8" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID8!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID8))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO8" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM8))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO8))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM8))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID8">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID8" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO9),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO9" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO9" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM9" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM9" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID9!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID9))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO9" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM9))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO9))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM9))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID9">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID9" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                    <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/PARTNO10),'')">
                      <div>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PARTNO10" style="width:255px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNO10" />
                              </xsl:attribute>
                            </input>&nbsp;(
                            <input type="text" id="__mainfield" name="PARTNM10" style="width:335px">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/PARTNM10" />
                              </xsl:attribute>
                            </input>)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:choose>
                              <xsl:when test="//forminfo/maintable/PARTOID10!=''">
                                <a target="_blank">
                                  <xsl:attribute name="href">
                                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(//forminfo/maintable/PARTOID10))" />
                                  </xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/PARTNO10" />
                                </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM10))" />)
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNO10))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNM10))" />)
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                        <input type="hidden" id="__mainfield" name="PARTOID10">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/PARTOID10" />
                          </xsl:attribute>
                        </input>
                      </div>
                    </xsl:if>
                  </div>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">고객명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="BUYERID">
                    <xsl:attribute name="value"><xsl:value-of select="BUYERID" /></xsl:attribute>
                  </input>
                  <input type="hidden" id="__mainfield" name="BUYERSITEID">
                    <xsl:attribute name="value"><xsl:value-of select="BUYERSITEID" /></xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl">제작처</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKESUPPLIER">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAKESUPPLIER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKESUPPLIER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="MAKESUPPLIERID">
                    <xsl:attribute name="value"><xsl:value-of select="MAKESUPPLIERID" /></xsl:attribute>
                  </input>
                  <input type="hidden" id="__mainfield" name="MAKESUPPLIERSITEID">
                    <xsl:attribute name="value"><xsl:value-of select="MAKESUPPLIERSITEID" /></xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">제작일자</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPLETEDATE">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPLETEDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETEDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">제작구분</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKEKIND">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAKEKIND" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKEKIND))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">CAVITY</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CAVITYA" class="txtRead" style="width:60px" readonly="readonly" value="{//forminfo/maintable/CAVITYA}" />
                      &nbsp;*&nbsp;
                      <input type="text" id="__mainfield" name="CAVITY" class="txtRead" style="width:60px" readonly="readonly" value="{//forminfo/maintable/CAVITY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CAVITYA))" />
                      &nbsp;*&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CAVITY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">형구조</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TYPESTRUCTURE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TYPESTRUCTURE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TYPESTRUCTURE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">형 SIZE</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TYPESIZE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TYPESIZE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TYPESIZE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">언더컷처리</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="UNDERCUT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/UNDERCUT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/UNDERCUT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">GATE</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GATE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">EJECT방식</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EJECTTYPE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/EJECTTYPE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EJECTTYPE))" />
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
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>* TRY 내역</span>
                    </td>
                    <td class="fm-button">
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
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
                      <span>* TRY 내역</span>
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
                  <table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:80px"></col>
                      <col style="width:120px"></col>
                      <col style="width:350px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">차수</td>
                      <td class="f-lbl-sub" style="border-top:0">항목</td>
                      <td class="f-lbl-sub" style="border-top:0">세부 내용</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
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

  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
      <td style="text-align:center;border-right:0">
        <!--<xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>TRY
          </xsl:when>
          <xsl:otherwise>
            TRY
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>-->
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
            <!--<label style="width:100%;text-align:center">
              <xsl:value-of select="ROWSEQ"/>
            </label>-->
          </xsl:when>
          <xsl:otherwise>
            <input type="text" name="ROWSEQ" value="{ROWSEQ}" class="txtRead_Center" readonly="readonly" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td colspan="3" style="border-left:0;border-right:0;padding:0">
        <table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
          <xsl:if test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
          </xsl:if>
          <colgroup>
            <col style="width:120px"></col>
            <col style="width:350px"></col>
            <col style="width:"></col>
          </colgroup>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="border-top:0">실시일자</td>
			  <td style="border-top:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL1" style="width:100px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{DETAIL1}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL1))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-top:0;border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC1">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC1" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC1))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">성형업체</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL2">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL2" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL2))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC2">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC2" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC2))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">성형제조</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL3">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL3" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL3))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC3">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC3" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC3))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">색상(재료)</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL4">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL4" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL4))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC4">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC4" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC4))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">성형기계</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL5">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL5" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL5))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC5">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC5" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC5))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">온도조절</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL6">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL6" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL6))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC6">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC6" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC6))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">성형시간</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL7">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL7" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL7))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC7">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC7" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC7))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">성형압력</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL8">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL8" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL8))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC8">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC8" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC8))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">제품중량</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL9">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL9" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL9))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC9">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC9" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC9))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">검토결과</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL10">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL10" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL10))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC12">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC2" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC2))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">판정</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL11">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL11" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL11))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC11">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC11" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC11))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">참석자</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL12">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL12" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL12))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC12">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC12" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC12))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="border-bottom:0">특기사항</td>
            <td style="border-bottom:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DETAIL13">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="DETAIL13" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAIL13))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="border-bottom:0;border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC13">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">50</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="ETC13" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC13))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
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
