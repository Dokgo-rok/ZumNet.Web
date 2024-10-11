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
			.m {width:1000px} .m .fm-editor {height:550px;min-height:550px;border:windowtext 1pt solid}
			.fh h1 {font-size:20.0pt;letter-spacing:0pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
			.m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
			.m .ft-sub .f-option {width:49%}

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:550px;min-height:550px}}
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
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt" data-inputmask="date;yyyy">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt" data-inputmask="date;yyyy">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                      </xsl:otherwise>
                    </xsl:choose>년
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:35px;font-size:19pt" data-inputmask="month">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:19pt" data-inputmask="month">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                      </xsl:otherwise>
                    </xsl:choose>월
                    외주정산서
                    <!--<xsl:value-of select="//docinfo/docname" />-->
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
                <td style="width:395px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '수신부서')"/>
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:17%;border-bottom:0">
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>1. 외주정산 금액</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY1" style="width:70px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY1" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY1');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-70,0,'etc','CURRENCY1');">
							<i class="fas fa-angle-down"></i>
						</button>
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
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
                      <span>1. 외주정산 금액</span>
                    </td>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />&nbsp;
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
                  <table id="__subtable1" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:30px"></col>
                      <col style="width:101px"></col>
                      <col style="width:102px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:105px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="width:20px;border-top:0" rowspan="2">NO</td>

                      <td class="f-lbl-sub" style="border-top:0" colspan="3">당월정산액</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">
                        금년 누적<br />정산액
                      </td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">
                        전년도 동기<br />누적 정산액
                      </td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">
                        전년대비 금년<br />누적정산 증감액
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">Local</td>
                      <td class="f-lbl-sub">해외</td>
                      <td class="f-lbl-sub">T/T</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td class="f-lbl-sub">T/T</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM3">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM3" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM4">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM4" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
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
                    <td>
                      <span>2. 정산금액 Big5 업체 현황</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY2" style="width:70px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY2" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-70,0,'etc','CURRENCY2');">
							<i class="fas fa-angle-down"></i>
						</button>
                      <!--<button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
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
                    <td>
                      <span>2. 정산금액 Big5 업체 현황</span>
                    </td>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />&nbsp;
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
                  <table id="__subtable2" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:204px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:105px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="width:20px;border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">업체명</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">금년 누적</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">정산액</td>
                      <td class="f-lbl-sub">점유율(%)</td>
                      <td class="f-lbl-sub">정산액</td>
                      <td class="f-lbl-sub">점유율(%)</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="2">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM5">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM5" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM6">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM6" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM7">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM7" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM8">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM8" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <span>3. 당월 작불대금 공제현황</span>
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__mainfield" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:200px"></col>
                      <col style="width:200px"></col>
                      <col style="width:200px"></col>
                      <col style="width:200px"></col>                      
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">대금공제현황</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">미처리현황</td>
                    </tr>                    
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub" style="border-right:0">금액</td>
                    </tr>
                    <tr>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="QUANTITY1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/QUANTITY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/QUANTITY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MONEY1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/MONEY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MONEY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="QUANTITY2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/QUANTITY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/QUANTITY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MONEY2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/MONEY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MONEY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
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
            <span>4. 특기사항</span>
          </div>

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

  <xsl:template match="//forminfo/subtables/subtable1/row">
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST1" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST2" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM1">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUM1" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST3" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST4" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM2">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUM2" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMPANY" style="width:90%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COMPANY" />
              </xsl:attribute>
            </input>
            <!--<button onclick="parent.fnExternal('erp.vendors',240,40,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="업체명" onclick="_zw.formEx.externalWnd('erp.vendors',240,40,100,70,'','COMPANY');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMPANY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST5" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST5}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST6" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST6}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST7" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST7}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST8" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{UNITCOST8}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST8))" />
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
