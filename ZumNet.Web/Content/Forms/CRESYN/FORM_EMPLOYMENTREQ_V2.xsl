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
          .m {width:740px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:24%} .m .ft .f-option1 {width:10%} .m .ft .f-option2 {width:15%}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:450px}}
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
                    <!--<xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield" name="DOCCLASS" style="font-size:16pt;font-weight:bold">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'채용충원')">
                              <option value="채용충원" selected="selected">채용충원</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="채용충원">채용충원</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'전보배치')">
                              <option value="전보배치" selected="selected">전보배치</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="전보배치">전보배치</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCCLASS))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    의뢰서-->
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
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '의뢰부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의부서', 'N')"/>
                </td>
                <td style="width:75px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[( @bizrole='last' and @actrole='_approver' ) and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">구분</td>
                <td style="border-bottom:0;border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbEMPLOYTYPE" value="채용">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbEMPLOYTYPE', this, 'EMPLOYTYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/EMPLOYTYPE),'채용')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/EMPLOYTYPE),'채용')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">채용</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="EMPLOYTYPE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/EMPLOYTYPE"></xsl:value-of>
                    </xsl:attribute>
                  </input>

				<span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbEMPLOYTYPEB" value="충원">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbEMPLOYTYPEB', this, 'EMPLOYTYPEB')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/EMPLOYTYPEB),'충원')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/EMPLOYTYPEB),'충원')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">충원</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="EMPLOYTYPEB">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/EMPLOYTYPEB"></xsl:value-of>
                    </xsl:attribute>
                  </input>

				<span class="f-option">
                    <input type="checkbox" id="ckb23" name="ckbEMPLOYTYPEC" value="채용충원">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbEMPLOYTYPEC', this, 'EMPLOYTYPEC')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/EMPLOYTYPEC),'채용충원')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/EMPLOYTYPEC),'채용충원')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">채용/충원</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="EMPLOYTYPEC">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/EMPLOYTYPEC"></xsl:value-of>
                    </xsl:attribute>
                  </input>

				<span class="f-option">
                    <input type="checkbox" id="ckb24" name="ckbEMPLOYTYPED" value="전보배치">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbEMPLOYTYPED', this, 'EMPLOYTYPED')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/EMPLOYTYPED),'전보배치')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/EMPLOYTYPED),'전보배치')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">전보배치</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="EMPLOYTYPED">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/EMPLOYTYPED"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>1. 자격요건 및 대상자</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">성별</td>
                <td style="width:35%">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbGENDER" value="남">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'남')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'남')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">남</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbGENDER" value="여">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'여')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'여')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">여</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbGENDER" value="무관">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'무관')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'무관')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">무관</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="GENDER">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/GENDER"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl">나이</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="AGE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">10</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/AGE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/AGE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">학력</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ACHIEVEMEN">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ACHIEVEMEN" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACHIEVEMEN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">전공</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAJORITY">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAJORITY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAJORITY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">경력</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CAREER" style="height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CAREER" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CAREER))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">자격 또는<br />대상자</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="QUALITY" style="height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/QUALITY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/QUALITY))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">수행예정직무</td>
                <td colspan="3" style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WORK">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/WORK" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/WORK))" />
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
            <span>2. 사유 및 근거</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">사유</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">인원 또는<br />대상자</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="WANTCOUNT" style="height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/WANTCOUNT" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/WANTCOUNT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">인원산출근거</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REMARK" style="height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REMARK" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REMARK))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">채용/충원 희망일</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EMPLOYDATE" style="width:100px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/EMPLOYDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EMPLOYDATE))" />
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
            <span>3. 특기사항&nbsp;<font size="2">(전보배치일 경우 세부발령일을 기재)</font>
          </span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:100px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:100px">
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
                <td style="width:320px">                  
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[(@bizrole='receive' and @actrole!='_approver') and @partid!='' and @step!='0'], '__si_Receive', '4', '검토부서')"/>
                </td>
				  <td></td>
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
