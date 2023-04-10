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
    <html xmlns:v="urn:schemas-microsoft-com:vml">
      <head>
        <title>전자결재</title>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <style type="text/css">
          <xsl:value-of select="phxsl:baseStyle()" />
          /* 화면 넓이, 에디터 높이, 양식명크기 */
          .m {width:1200px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter -spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:10%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}    .m .ft-sub .f-option2 {width:30%}

          /* 차트 - 2020-08-21 */
          .m .fm-chart {border:#666 1pt solid; height: 200px; padding: 16px 8px}
          .m .fm-chart .fc {width:100%;height:100%}
          .m .fm-chart .fc td,.m .fm-chart .fc input {font-size:12px;font-family:맑은 고딕}

          .m .fm-chart .fc td {position: relative; text-align: center;}
          .m .fm-chart .fc .fc-plus {}
          .m .fm-chart .fc td.fc-zero {font-size: 0; height: 0}
          .fc-zero.border {border-top: 1px solid #ddd; border-bottom: 1px solid #ddd}
          .fc-plus .bar, .fc-minus .bar {position: absolute; background-color: #5b9bd5; border: 1px solid #3482cb; width: 50%; margin-left: 25%; font-size: 0}
          .fc-plus .bar {bottom: 0; border-bottom: 0 }
          .fc-minus .bar {top: 0; border-top: 0}
          .fc-plus .bar.prev, .fc-minus .bar.prev {background-color: #ffc000; border: 1px solid #cc9900}
          .fc-plus .bar.now, .fc-minus .bar.now {background-color: #70ad47; border: 1px solid #466d2c}
          .fc-minus .lbl {position: absolute; top: 6px; width: 100%; margin-left: ; z-index: 1000; color: #666; font-weight: bold}

          .fc-plus .lbl-value, .fc-minus .lbl-value {position: absolute; width: 100%; margin-left: ; font-weight: bold}
          .fc-plus .lbl-value, .axis-y .plus, .axis-y .zero {color: #666;}
          .fc-minus .lbl-value, .axis-y .minus {color: red;}

          .axis-y .plus, .axis-y .zero, .axis-y .minus {position: absolute; width: 100%; margin-left: ; text-align: right; padding-right: 10px; border-bottom: 0 solid #333}

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
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="CORPORATION" style="width:70px;font-size:13pt" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CORPORATION}" />
                        <!--<button onclick="parent.fnOption('external.chartcentercode',180,140,70,122,'','CORPORATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 1px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="법인" onclick="_zw.formEx.optionWnd('external.chartcentercode',220,304,-100,0,'','CORPORATION','COERPID','COERPSUBID','WRBGONGSURATE');">
							  <i class="fas fa-angle-down"></i>
						  </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CORPORATION))" />
                      </xsl:otherwise>
                    </xsl:choose>&nbsp;
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <!--<input type="text" id="__mainfield" name="STATSYEAR" style="width:50px;font-size:13pt" class="txtYear" maxlength="4" data-inputmask="date;yyyy">
                          <xsl:attribute name="value">
                            <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />
                          </xsl:attribute>
                        </input>-->
						  <select id="__mainfield" name="STATSYEAR" class="custom-select d-inline-block" style="width:100px;font-size:13pt">
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionYear2(2015, substring(string(//currentinfo/@date),1,4), substring(string(//docinfo/createdate),1,4))" />
						  </select>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <!--<input type="text" id="__mainfield" name="STATSYEAR" style="width:50px;font-size:13pt" class="txtYear" maxlength="4" data-inputmask="date;yyyy" value="{//forminfo/maintable/STATSYEAR}" />-->
						  <select id="__mainfield" name="STATSYEAR" class="custom-select d-inline-block" style="width:100px;font-size:13pt">
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionYear2(2015, substring(string(//currentinfo/@date),1,4), string(//forminfo/maintable/STATSYEAR))" />
						  </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                      </xsl:otherwise>
                    </xsl:choose>년
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <!--<input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:13pt" class="txtMonth" maxlength="2" data-inputmask="number;2;0">
                          <xsl:attribute name="value">
                            <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))" />
                          </xsl:attribute>
                        </input>-->
						  <select id="__mainfield" name="STATSMONTH" class="custom-select d-inline-block" style="width:80px;font-size:13pt">
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionMonth(substring(string(//docinfo/createdate),6,2))" />
						  </select>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <!--<input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:13pt" class="txtMonth" maxlength="2" data-inputmask="number;2;0" value="{//forminfo/maintable/STATSMONTH}" />-->
						  <select id="__mainfield" name="STATSMONTH" class="custom-select d-inline-block" style="width:80px;font-size:13pt">
							  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionMonth(string(//forminfo/maintable/STATSMONTH))" />
						  </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                      </xsl:otherwise>
                    </xsl:choose>월
                    재고조사결과보고
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
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
				  <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '4', '합의부서')"/>
                </td>
				  <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
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
                <td style="width:37%">
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
            <table class="" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width: 24%">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border: 0">
                    <tr>
                      <td style="border: 0; padding-bottom: 4px">
                        <span>1. 재고조사일</span>
                      </td>
                    </tr>
                    <tr>
                      <td style="border: 0;">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPFROM" style="width:100px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TRIPFROM}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPFROM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;~&nbsp;
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPTO" style="width:100px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TRIPTO}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPTO))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>
                </td>
                <td>
                  <table class="" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="padding-bottom: 4px">
                        <span>2. 재고실사 실시율</span>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <table class="ft"  border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="f-lbl2" style="width: 17%; border-bottom:0">실사 대상 창고수</td>
                            <td style="width: 17%; border-bottom:0">
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="INVENTORYQU" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/INVENTORYQU}" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVENTORYQU))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td class="f-lbl2" style="width: 17%; border-bottom:0">실사 완료 창고수</td>
                            <td style="width: 17%; border-bottom:0">
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="COMPLETEINVEN" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/COMPLETEINVEN}" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETEINVEN))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td class="f-lbl2" style="width: 16%; border-bottom:0">실사 완료율</td>
                            <td style="width: 16%; border-right:0;border-bottom:0">
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="PERCENT1" class="txtRead" readonly="readonly" maxlength="20" value="{//forminfo/maintable/PERCENT1}" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PERCENT1))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>3. 재고조사 추이</span>
          </div>

          <div class="ff" />

          <div class="fm-chart">
            <table class="fc" border="0" cellspacing="0" cellpadding="0" id="__fc_chart">
              <colgroup>
                <col width="92px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
              </colgroup>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td class="axis-y"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class="fc-plus"></td>
                    <td class=""></td>
                  </tr>
                  <tr>
                    <td></td>
                    <td class="fc-zero border" colspan="14">&nbsp;</td>
                  </tr>
                  <tr>
                    <td class="axis-y" style="height: 50%">&nbsp;</td>
                    <td class="fc-minus">
                      <div class="lbl">전년</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">금년</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">1월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">2월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">3월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">4월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">5월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">6월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">7월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">8월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">9월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">10월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">11월</div>
                    </td>
                    <td class="fc-minus">
                      <div class="lbl">12월</div>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:renderChart('', 'chart', 168, //optioninfo/foption1, string(//forminfo/maintable/STATSYEAR))" />
                </xsl:otherwise>
              </xsl:choose>
            </table>
          </div>

          <div class="ff"></div>
          <div class="ff"></div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" id="__fc_table">
              <colgroup>
                <col width="100px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="78px" />
                <col width="86px" />
              </colgroup>
              <tr>
                <td class="f-lbl2">단위</td>
                <td class="f-lbl2">전년</td>
                <td class="f-lbl2">금년</td>
                <td class="f-lbl2">1월</td>
                <td class="f-lbl2">2월</td>
                <td class="f-lbl2">3월</td>
                <td class="f-lbl2">4월</td>
                <td class="f-lbl2">5월</td>
                <td class="f-lbl2">6월</td>
                <td class="f-lbl2">7월</td>
                <td class="f-lbl2">8월</td>
                <td class="f-lbl2">9월</td>
                <td class="f-lbl2">10월</td>
                <td class="f-lbl2">11월</td>
                <td class="f-lbl2" style="border-right:0">12월&nbsp;&nbsp;</td>
              </tr>
              <tr>
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <td style="text-align: center; border-bottom:0">USD</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0">&nbsp;</td>
                    <td style="text-align: center; border-bottom:0; border-right:0">&nbsp;</td>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderChart('', 'table', 168, //optioninfo/foption1, string(//forminfo/maintable/STATSYEAR))" />
                  </xsl:otherwise>
                </xsl:choose>
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
                      <span>4. 재고 조사 결과 및 차이</span>
                    </td>
                    <td class="fm-button">
                      <!--<button onclick="parent.fnChart('','',0,168,0);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_41.gif" />CHART
                      </button>-->
						<button class="btn btn-default btn-sm" data-toggle="tooltip" data-placement="bottom" title="차트 불러오기" onclick="_zw.formEx.chart('','',0,168,0);">
							<i class="fas fa-chart-bar text-success"></i>
							<span class="ml-1">차트</span>
						</button>
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
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
                      <span>4. 재고 조사 결과 및 차이</span>
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
                  <table id="__subtable1" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:3%"></col>
                      <col style="width:9%"></col>
                      <col style="width:9%"></col>
                      <col style="width:9%"></col>
                      <col style="width:8%"></col>
                      <col style="width:8%"></col>
                      <col style="width:9%"></col>
                      <col style="width:9%"></col>
                      <col style="width:8%"></col>
                      <col style="width:8%"></col>
                      <col style="width:%"></col>                    
                    </colgroup>
                    <tr style="">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2" >구분</td>
                      <td class="f-lbl-sub" style="valign:center;border-top:0" colspan="4">수량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="4">금액(USD)</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="">
                      <td class="f-lbl-sub" style="">ERP</td>
                      <td class="f-lbl-sub" style="">실물</td>
                      <td class="f-lbl-sub" style="">차이</td>
                      <td class="f-lbl-sub" style="">일치율</td>
                      <td class="f-lbl-sub" style="">ERP</td>
                      <td class="f-lbl-sub" style="">실물</td>
                      <td class="f-lbl-sub" >차이</td>
                      <td class="f-lbl-sub" style="">일치율</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td colspan="2" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0;text-align:right">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL1" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0:0;text-align:right">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL2" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0:0;text-align:right">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL3" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0:0;text-align:center">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL4" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;text-align:right">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL5" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;text-align:right">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL6" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;text-align:right">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL7" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;text-align:center">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTAL8" class="txtRead" readonly="readonly"  value="{//forminfo/maintable/TOTAL8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTAL8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        &nbsp;</td>
                      
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
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
                      <span style="width:520px">5. 재고차이 원인분석 및 대책</span>
                    </td>
                    <td class="fm-button">
                      <!--<button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
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
                      <span>5. 재고차이 원인분석 및 대책</span>
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
                  <table id="__subtable2" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:3%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:10%"></col>
                      <col style="width:10%"></col>
                      <col style="width:35%"></col>
                      <col style="width:%"></col>
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">창고명</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">차이</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">원인분석결과</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">대책</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub" style="">수량</td>
                      <td class="f-lbl-sub" style="">금액(USD)</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>


          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>6. 특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:100px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="ㅡㅑㅜ-height:100px">
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
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMTYPE" class="txtText" maxlength="100">
              <xsl:attribute name="value">
                <xsl:choose>
                  <xsl:when test="ROWSEQ[.='1']">원자재</xsl:when>
                  <xsl:when test="ROWSEQ[.='2']">반제품</xsl:when>
                  <xsl:when test="ROWSEQ[.='3']">완제품</xsl:when>
                  <xsl:when test="ROWSEQ[.='4']">외주</xsl:when>
                               
                  <xsl:otherwise>
                    <xsl:value-of select="ITEMTYPE" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMTYPE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ERPQUANTITY" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{ERPQUANTITY}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ERPQUANTITY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REALQUANTITY" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{REALQUANTITY}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REALQUANTITY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DIFFERENT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DIFFERENT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DIFFERENT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MATCHPERCENT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
              <xsl:value-of select="MATCHPERCENT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(MATCHPERCENT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ERPUSD" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{ERPUSD}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ERPUSD))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REALUSD" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{REALUSD}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REALUSD))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DIFFERENTUSD">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DIFFERENTUSD" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DIFFERENTUSD))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MATCHPERCENTUSD">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MATCHPERCENTUSD" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(MATCHPERCENTUSD))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ETC))" />
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
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMTYPE" class="txtText" maxlength="100">
              <xsl:attribute name="value">               
              <xsl:value-of select="ITEMTYPE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMTYPE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUBINVENTORY">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUBINVENTORY" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUBINVENTORY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DIQUANTITY" class="txtDollar" maxlength="20" data-inputmask="number;16;4;-" value="{DIQUANTITY}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DIQUANTITY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DIAMOUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4;-" value="{DIAMOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DIAMOUNT))" />&nbsp;
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="height:50px">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="CAUSERESUIT" style="height:95%" class="txaText bootstrap-maxlength" maxlength="1000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="CAUSERESUIT" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="height:">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSERESUIT))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="COUNTERMEASURE" style="height:95%" class="txaText bootstrap-maxlength" maxlength="1000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="COUNTERMEASURE" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="height:">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COUNTERMEASURE))" />
            </div>
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
