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
          .m {width:1270px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}
          .m .ft-sub label {font-size:13px}


          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:?} .m .ft .f-lbl2 {width:?}
          .m .ft .f-lbl3 {writing-mode:tb-rl}
          .m .ft .f-option {width:20%} .m .ft .f-option1 {width:38%} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option1 {width:35%} .m .ft-sub .f-option2 {width:60%}

          /* 차트 - 2020-08-21 */
          .m .fm-chart {border:#666 1pt solid; height: 200px; padding: 16px 8px 8px 8px}
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
                        <input type="text" id="__mainfield" name="CORPORATION" style="width:80px;font-size:19pt" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CORPORATION}" />
                        <!--<button onclick="parent.fnOption('external.groupcode',100,200,60,162,'','CORPORATION','COERPID','COERPSUBID','WRBGONGSURATE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="법인" onclick="_zw.formEx.optionWnd('external.groupcode',140,334,-100,0,'','CORPORATION','COERPID','COERPSUBID','WRBGONGSURATE');">
							  <i class="fas fa-angle-down"></i>
						  </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CORPORATION))" />
                      </xsl:otherwise>
                    </xsl:choose>&nbsp;
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
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:395px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '5', '합의부서', 'N')"/>
                </td>
                <td style="width:75px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
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
          <div class="ff" />
          <div class="ff" />

          <xsl:choose>
            <xsl:when test="$bizrole='의견' and $partid!=''">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:88px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <textarea id="__mainfield" name="CONTENTS" style="height:60px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CONTENTS" />
                        </xsl:if>
                      </textarea>
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:when test="$bizrole='last' or ($bizrole='의견' and $mode='read')">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:88px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENTS))" />
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>          
          
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width: 37%">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border: 0">
                    <tr>
                      <td style="border: 0;"><span>1. 처리사유</span></td>
                    </tr>
                    <tr>
                      <td style="height: 68px;">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <textarea id="__mainfield" name="REASON" style="height:96%" class="txaText bootstrap-maxlength" maxlength="500">
                              <xsl:value-of select="//forminfo/maintable/REASON" />
                            </textarea>
                          </xsl:when>
                          <xsl:otherwise>
                            <div class="txaRead" style="height:100%; padding: 4px">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>
                </td>
                <td style="width: 13%">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border: 0">
                    <tr>
                      <td style="border: 0; padding-left: 42px">
                        <span>2. 발생기간</span>
                      </td>
                    </tr>
                    <tr>
                      <td style="height: 50px; border: 0">
                        <div>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<xsl:attribute name="style">font-weight: bold; padding-left: 20px; margin-bottom: 4px; font-size: 14px</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="style">font-weight: bold; padding-left: 40px; margin-bottom: 4px; font-size: 14px</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
                          (&nbsp;<xsl:choose>
                            <xsl:when test="$mode='new'">
                              <!--<input type="text" id="__mainfield" name="STATSYEAR" style="width:40px" class="txtYear" maxlength="4" value="{substring(string(//docinfo/createdate),1,4)}" />-->
								<select id="__mainfield" name="STATSYEAR" class="custom-select d-inline-block" style="width:90px" onchange="_zw.formEx.change(this)">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:optionYear2(2015, substring(string(//currentinfo/@date),1,4), substring(string(//docinfo/createdate),1,4))" />
								</select>
                            </xsl:when>
                            <xsl:when test="$mode='edit'">
                              <!--<input type="text" id="__mainfield" name="STATSYEAR" style="width:40px" class="txtYear" maxlength="4" value="{//forminfo/maintable/STATSYEAR}" />-->
							<select id="__mainfield" name="STATSYEAR" class="custom-select" style="width:90px" onchange="_zw.formEx.change(this)">
							  <xsl:value-of select="phxsl:optionYear2(2015, substring(string(//currentinfo/@date),1,4), string(//forminfo/maintable/STATSYEAR))" />
						  </select>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                            </xsl:otherwise>
                          </xsl:choose>&nbsp;)&nbsp;년
                        </div>
                        <div>
							<xsl:choose>
								<xsl:when test="$mode='new' or $mode='edit'">
									<xsl:attribute name="style">font-weight: bold; padding-left: 40px; margin-bottom: 4px; font-size: 14px</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="style">font-weight: bold; padding-left: 64px; margin-bottom: 4px; font-size: 14px</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
                          (&nbsp;<xsl:choose>
                            <xsl:when test="$mode='new'">
                              <!--<input type="text" id="__mainfield" name="STATSMONTH" style="width:18px" class="txtMonth" maxlength="2" value="{phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))}" />-->
						        <select id="__mainfield" name="STATSMONTH" class="custom-select d-inline-block" style="width:70px" onchange="_zw.formEx.change(this)">
							        <xsl:value-of disable-output-escaping="yes" select="phxsl:optionMonth(substring(string(//docinfo/createdate),6,2))" />
						        </select>
                            </xsl:when>
                            <xsl:when test="$mode='edit'">
                              <!--<input type="text" id="__mainfield" name="STATSMONTH" style="width:18px" class="txtMonth" maxlength="2" value="{//forminfo/maintable/STATSMONTH}" />-->
								<select id="__mainfield" name="STATSMONTH" class="custom-select d-inline-block" style="width:70px" onchange="_zw.formEx.change(this)">
									<xsl:value-of disable-output-escaping="yes" select="phxsl:optionMonth(string(//forminfo/maintable/STATSMONTH))" />
								</select>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                            </xsl:otherwise>
                          </xsl:choose>&nbsp;)&nbsp;월
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td style="border:0"></td>
                    </tr>
                  </table>                  
                </td>
                <td style="width: 50%">
                  <table class="" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td>                        
                          <span style="width:48%">3. 생산 자재금액 대비 작불 자재 금액 비율</span>
                          <span style="width:50%;text-align:right;padding-right:4px">
                            통화&nbsp;:&nbsp;
                            (&nbsp;<xsl:choose>
                              <xsl:when test="$mode='new' or $mode='edit'">
                                <input type="text" id="__mainfield" name="CURRENCY" class="txtRead" readonly="readonly" style="width:40px" value="USD" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                              </xsl:otherwise>
                            </xsl:choose>&nbsp;)
                          </span>
                      </td>
                    </tr>
                    <tr>
                      <td style="height: 50px">
                        <table class="ft" border="0" cellspacing="0" cellpadding="0">
                          <tr>
                            <td class="f-lbl" style="width:200px">당월 생산 사용 자재 금액</td>
                            <td class="f-lbl" style="width:200px">당월 작업불량 자재 금액</td>
                            <td class="f-lbl" style="width:300px;border-right:0">생산 자재금액 대비 작불 자재 금액 비율</td>
                          </tr>
                          <tr>
                            <td style="border-bottom: 0">
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="BUYSUM" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/BUYSUM}" />
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of select="//forminfo/maintable/BUYSUM" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td style="border-bottom: 0">
                              <input type="text" id="__mainfield" name="OCCURSUMQ" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/OCCURSUMQ}" />
                            </td>
                            <td style="border-bottom: 0; border-right:0">
                              <input type="text" id="__mainfield" name="RATE1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/RATE1}" />
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td style="height: 18px">
                        <span style="padding-left: 6px; font-size: 13px">(VW : 압출 생산실적금액 대비 작업불량 금액 비율)</span>
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
            <span>4. 월별 작업 불량 추이</span>
          </div>
          
          <div class="ff" />

          <div class="fm-chart">
            <table class="fc" border="0" cellspacing="0" cellpadding="0" id="__fc_chart">
              <colgroup>
                <col width="106px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
              </colgroup>
              <tr>
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
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
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderChart('MONTHFAULTYGOODS', 'chart', 176, //optioninfo/foption1, string(//forminfo/maintable/STATSYEAR), string(//forminfo/maintable/CORPORATION))" />
                  </xsl:otherwise>
                </xsl:choose>
              </tr>
              <tr>
                <td></td>
                <td class="fc-zero border" colspan="14">&nbsp;</td>
              </tr>
              <!--<tr>
                <td class="axis-y" style="height: 24px">&nbsp;</td>
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
              </tr>-->
            </table>
          </div>

          <div class="ff"></div>
          <div class="ff"></div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" id="__fc_table">
              <colgroup>
                <col width="113px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="82px" />
                <col width="91px" />
              </colgroup>
              <tr>
                <td class="f-lbl1">단위</td>
                <td class="f-lbl1">전년</td>
                <td class="f-lbl1">금년</td>
                <td class="f-lbl1">1월</td>
                <td class="f-lbl1">2월</td>
                <td class="f-lbl1">3월</td>
                <td class="f-lbl1">4월</td>
                <td class="f-lbl1">5월</td>
                <td class="f-lbl1">6월</td>
                <td class="f-lbl1">7월</td>
                <td class="f-lbl1">8월</td>
                <td class="f-lbl1">9월</td>
                <td class="f-lbl1">10월</td>
                <td class="f-lbl1">11월&nbsp;</td>
                <td class="f-lbl1" style="border-right:0">12월&nbsp;&nbsp;</td>
              </tr>
              <tr>
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <td style="text-align: center; border-bottom:0">K USD</td>
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
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderChart('MONTHFAULTYGOODS', 'table', 176, //optioninfo/foption1, string(//forminfo/maintable/STATSYEAR), string(//forminfo/maintable/CORPORATION))" />
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
            <span>5. 작업불량 및 불용재고 발생내역</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>
                        5-1-1 작업불량 창고(WRB,DISUSE)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
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
                      <span>
                        5-1-1 작업불량 창고(WRB,DISUSE)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;                     
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
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
                      <col width="2%"></col>
                      <col width="14%"></col><!--7%-->
                      <col width="5%"></col>
                      <col width="13%"></col><!--9%-->
                      <col width="9%"></col><!--8%-->
                      <col width="8%"></col>
                      <col width="8%"></col>
                      <!--<col width="4%"></col>
                      <col width="8%"></col>-->
                      <col width="6%"></col>
                      <col width="8%"></col>
                      <col width="8%"></col>
                      <col width="11%"></col>
                      <col width="%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <!--<td class="f-lbl-sub" style="border-top:0" colspan="2">작업불량공수손실</td>-->
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <!--<td class="f-lbl-sub">공수</td>
                      <td class="f-lbl-sub">금액</td>-->
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td colspan="4" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBCNT1" class="txtRead_Right" readonly="readonly" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WRBCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBCNT2" class="txtRead_Right" readonly="readonly" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WRBCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBSUM1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WRBSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="display:none">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTLOSSGONGSU" class="txtDollar" maxlength="20" value="{//forminfo/maintable/TOTLOSSGONGSU}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTLOSSGONGSU))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;display:none">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTLOSSMONEY" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/TOTLOSSMONEY}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTLOSSMONEY))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
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
            <span style="width:30%">5-1-2 작업불량 공수</span>
            <span style="width:70%;text-align:right;padding-right:4px">
              임율&nbsp;:&nbsp;
              (&nbsp;<xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" id="__mainfield" name="WRBGONGSURATE" class="txtRead" readonly="readonly" style="width:40px" value="{//forminfo/maintable/WRBGONGSURATE}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="//forminfo/maintable/WRBGONGSURATE" />
                </xsl:otherwise>
              </xsl:choose>&nbsp;)
              통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
            </span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col width="10%" />
                <col width="15%" />
                <col width="15%" />
                <col width="15%" />
                <col width="15%" />
                <col width="30%" />
              </colgroup>
              <tr>
                <td class="f-lbl1">&nbsp;</td>
                <td class="f-lbl1">공정불량</td>
                <td class="f-lbl1">재작업</td>
                <td class="f-lbl1">수리</td>
                <td class="f-lbl1">합계</td>
                <td class="f-lbl1" style="border-right:0">비고</td>
              </tr>
              <tr>
                <td class="f-lbl1">공수</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WRBGONGSU1" class="txtRead_Right" readonly="readonly" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WRBGONGSU1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBGONGSU1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WRBGONGSU2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WRBGONGSU2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBGONGSU2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WRBGONGSU3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WRBGONGSU3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBGONGSU3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTLOSSGONGSU2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTLOSSGONGSU2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTLOSSGONGSU2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td rowspan="2" style="border-right;0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="WRBGONGSUETC" style="height:40px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);">
                        <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WRBGONGSUETC" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/WRBGONGSUETC))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">금액</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WRBGONGSUCOST1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBGONGSUCOST1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBGONGSUCOST1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WRBGONGSUCOST2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBGONGSUCOST2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBGONGSUCOST2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="WRBGONGSUCOST3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBGONGSUCOST3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBGONGSUCOST3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTLOSSMONEY2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTLOSSMONEY2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTLOSSMONEY2))" />
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
                    <td>
                      <span>
                        5-2 자재 불용재고 창고(WAR)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
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
                      <span>
                        5-2 자재 불용재고 창고(WAR)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;                     
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
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
                      <col width="2%"></col>
                      <col width="14%"></col>
                      <col width="13%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="6%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="11%"></col>
                      <col width="10%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr>
                      <td colspan="3" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <!--class="txtRead_Right" readonly="readonly"-->
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARCNT1" class="txtDollar" maxlength="20" data-inputmask="number;16;4"  value="{//forminfo/maintable/WARCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARCNT2" class="txtDollar" maxlength="20" data-inputmask="number;16;4"  value="{//forminfo/maintable/WARCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARSUM1" class="txtDollar" maxlength="20" data-inputmask="number;16;4"  value="{//forminfo/maintable/WARSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WARCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WARSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
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
                      <span>
                        5-3 반제품 불용재고 창고(WAS)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <!--<button onclick="parent.fnAddChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
					<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable3');">
	                    <i class="fas fa-plus"></i>
                    </button>
                    <button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable3');">
	                    <i class="fas fa-minus"></i>
                    </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        5-3 반제품 불용재고 창고(WAS)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable3" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="2%"></col>
                      <col width="14%"></col>
                      <col width="13%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="6%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="11%"></col>
                      <col width="10%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
                    <tr>
                      <td colspan="3" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASCNT1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WASCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASCNT2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WASCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASSUM1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WASSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WASCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WASSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
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
                      <span>
                        5-4 완제품 불용재고 창고(WAF)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <!--<button onclick="parent.fnAddChkRow('__subtable4');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable4');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable4');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable4');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        5-4 완제품 불용재고 창고(WAF)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;                      
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable4" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="2%"></col>
                      <col width="14%"></col>
                      <col width="13%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="6%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="11%"></col>
                      <col width="10%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable4/row"/>
                    <tr>
                      <td colspan="3" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFCNT1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WAFCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFCNT2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WAFCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFSUM1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/WAFSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WAFCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WAFSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>
                        6. 당월 IS UNIT 원불 발생현황
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <!--<button onclick="parent.fnAddChkRow('__subtable5');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable5');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable5');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable5');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        6. 당월 IS UNIT 원불 발생현황
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;                     
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable5" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="2%"></col>
                      <col width="12%"></col>
                      <col width="11%"></col>
                      <col width="11%"></col>
                      <col width="8%"></col>
                      <col width="12%"></col>
                      <col width=""></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">품번</td>
                      <td class="f-lbl-sub" style="border-top:0">총사용량</td>
                      <td class="f-lbl-sub" style="border-top:0">불량수량</td>
                      <td class="f-lbl-sub" style="border-top:0">불량율(%)</td>
                      <td class="f-lbl-sub" style="border-top:0">누적불량수량</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">처리방안</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable5/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <!--<div class="fm">
            <span>6. 월별추이</span>
          </div>

          <div class="ff" />

          <div class="fm-chart">
            <table class="fc" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
              <colgroup>
                <col width="190px"></col>
                <col width="10px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="110px"></col>
              </colgroup>
              <tr>
                <td class="fc-lbl">
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button onclick="parent.fnChart('','',960,150,3);" onfocus="this.blur()" class="btn_bg" style="width:64px;margin-top:-6px">
                      <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_41.gif" />CHART
                    </button>&nbsp;&nbsp;
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CHATY" style="width:30px;height:21px;margin-top:2px">
                        <xsl:attribute name="class">txtDollar1</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="value">3.0</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/CHATY" />
                            </xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHATY))" />
                    </xsl:otherwise>
                  </xsl:choose>%
                </td>
                <td class="fc-axis-y">&nbsp;</td>
                <td colspan="12" style="padding-top:5px">
                  <div id="panChart" style="position:relative;width:960px;height:150px;border:0px solid blue">--><!--//tw, th, tc, tsc, tdt, tls, tsw, lw, lc, ldt--><!--
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderLineSpecialChart(phxsl:cvtChartData('mg_r1', //optioninfo), 960, 150, string(//forminfo/maintable/CHATY), '', '', '', '', '', '', '', '', '', '')"/>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderLineSpecialChart(phxsl:cvtChartData('mg_r2', //optioninfo), 960, 150, string(//forminfo/maintable/CHATY), '', '', '#0ff', 'blue', '', '', '', '', 'blue', 'longdashdotdot')"/>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderLineSpecialChart(phxsl:cvtChartData('mg_r3', //optioninfo), 960, 150, string(//forminfo/maintable/CHATY), '', '', '', 'green', '', '', '', '', 'green', 'solid')"/>
                  </div>
                </td>
                <td>
                  <div id="panChartTot" style="position:relative;width:110px;height:150px">
                    <xsl:if test="//optioninfo/foption1[@cd='13']/rate1[.!='']">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(phxsl:calcTop(150, string(//forminfo/maintable/CHATY), string(//optioninfo/foption1[@cd='13']/rate1)), 55, '', '', '', '', '', '', '', '')" />
                    </xsl:if>
                    <xsl:if test="//optioninfo/foption1[@cd='13']/rate2[.!='']">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(phxsl:calcTop(150, string(//forminfo/maintable/CHATY), string(//optioninfo/foption1[@cd='13']/rate2)), 55, '', '', '#0ff', 'blue', '', '', '', '')" />
                    </xsl:if>
                    <xsl:if test="//optioninfo/foption1[@cd='13']/rate3[.!='']">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(phxsl:calcTop(150, string(//forminfo/maintable/CHATY), string(//optioninfo/foption1[@cd='13']/rate3)), 55, '', '', '', 'green', '', '', '', '')" />
                    </xsl:if>
                  </div>
                </td>
              </tr>
            </table>
          </div>
          <div class="fm">
            <table id="panChartTbl" class="ft" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
              <colgroup>
                <col width="70px"></col>
                <col width="70px"></col>
                <col width="60px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="80px"></col>
                <col width="110px"></col>
              </colgroup>
              <tr>
                <td class="f-lbl1" colspan="2">&nbsp;</td>
                <td class="f-lbl1">단위</td>
                <td class="f-lbl1">1월</td>
                <td class="f-lbl1">2월</td>
                <td class="f-lbl1">3월</td>
                <td class="f-lbl1">4월</td>
                <td class="f-lbl1">5월</td>
                <td class="f-lbl1">6월</td>
                <td class="f-lbl1">7월</td>
                <td class="f-lbl1">8월</td>
                <td class="f-lbl1">9월</td>
                <td class="f-lbl1">10월</td>
                <td class="f-lbl1">11월</td>
                <td class="f-lbl1">12월</td>
                <td class="f-lbl1" style="border-right:0">TOTAL</td>
              </tr>
              <tr>
                <td class="f-lbl1" rowspan="3">작불대<br />매출비
                  <div style="position:relative;vertical-align:middle;height:20px;border:0 solid blue">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 16, '', '', '', '', '', '', '', '')" />
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('-9,10', '24,10', '', '', '', '', '','')" />
                  </div>
                </td>
                <td class="f-lbl1">매출액</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">USD</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/sale)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/sale)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">발생금액</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">USD</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/suma)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/suma)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">발생율</td>
                <td class="f-lbl1">%</td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/rate1)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/rate1)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/rate1)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" rowspan="3">
                  작불대<br />매입비
                  <div style="position:relative;vertical-align:middle;height:20px;border:0 solid blue">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 16, '', '', '#0ff', 'blue', '', '', '', '')" />
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('-9,10', '24,10', '', 'blue', '', '', 'longdashdotdot','')" />
                  </div>
                </td>
                <td class="f-lbl1">매입액</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">USD</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/buy)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/buy)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/buy)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">발생금액</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">USD</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/suma)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/suma)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/suma)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">발생율</td>
                <td class="f-lbl1">%</td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/rate2)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/rate2)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/rate2)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" rowspan="3" style="border-bottom:0">
                  총불용대<br />매출비
                  <div style="position:relative;vertical-align:middle;height:20px;border:0 solid blue">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 16, '', '', '', 'green', '', '', '', '')" />
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('-9,10', '24,10', '', 'green', '', '', 'solid','')" />
                    <v:line></v:line>
                  </div>
                </td>
                <td class="f-lbl1">매출액</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">USD</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/sale)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/sale)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/sale)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">&nbsp;</td>
              </tr>
              <tr>
                <td class="f-lbl1">발생금액</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">USD</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/sumb)))" />
                </td>
                <td class="tdRead_Right">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/sumb)))" />
                </td>
                <td class="tdRead_Right" style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/sumb)))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">발생율</td>
                <td class="f-lbl1" style="border-bottom:0">%</td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='1']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='2']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='3']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='4']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='5']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='6']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='7']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='8']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='9']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='10']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='11']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='12']/rate3)))" />
                </td>
                <td class="tdRead_Right" style="border-bottom:0;border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//optioninfo/foption1[@cd='13']/rate3)))" />
                </td>
              </tr>
            </table>
          </div>-->

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>7. 특기사항</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:60px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:60px; padding: 4px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
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

        <!-- Hidden Field -->
        <input type="hidden" id="__mainfield" name="COERPID" value="{//forminfo/maintable/COERPID}" />
        <input type="hidden" id="__mainfield" name="COERPSUBID" value="{//forminfo/maintable/COERPSUBID}" />

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
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CTCLASS1" class="txtText" maxlength="50" value="{CTCLASS1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <select name="DTCLASS1" class="form-control">
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DTCLASS1),'')">
                  <option value="" selected="selected">선택</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="">선택</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DTCLASS1),'내부')">
                  <option value="내부" selected="selected">내부</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="내부">내부</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DTCLASS1),'외부')">
                  <option value="외부" selected="selected">외부</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="외부">외부</option>
                </xsl:otherwise>
              </xsl:choose>              
            </select>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DTCLASS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS1" class="txtText" maxlength="50" value="{ITEMCLASS1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td style="display:none">&nbsp;</td>
      <td style="display:none">&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE1" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE1}" />
            <!--<button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="발생원인" onclick="_zw.formEx.optionWnd('external.wastereason',130,184,-100,0,'etc','CAUSE1');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT13" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{COUNT13}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT13))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM12" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{SUM12}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM12))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD1" id="ckb.{ROWSEQ}.11" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD1', this, 'METHOD1')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD1),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD1),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.11" style="margin-left:2px">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD1" id="ckb.{ROWSEQ}.12" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD1', this, 'METHOD1')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD1),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD1),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.12" style="margin-left:2px">대금회수</label>
        </span>
        <input type="hidden" name="METHOD1" value="{METHOD1}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC1" class="txtText" maxlength="50" value="{ETC1}" />
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
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS2" class="txtText" maxlength="50" value="{CTCLASS2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS2" class="txtText" maxlength="50" value="{ITEMCLASS2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE2" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE2}" />
            <!--<button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="발생원인" onclick="_zw.formEx.optionWnd('external.wastereason',130,184,-100,0,'etc','CAUSE2');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT23" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{COUNT23}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT23))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM22" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{SUM22}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM22))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD2" id="ckb.{ROWSEQ}.21" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD2', this, 'METHOD2')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD2),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD2),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.21" style="margin-left:2px">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD2" id="ckb.{ROWSEQ}.22" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD2', this, 'METHOD2')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD2),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD2),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.22" style="margin-left:2px">대금회수</label>
        </span>
        <input type="hidden" name="METHOD2" value="{METHOD2}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC2" class="txtText" maxlength="50" value="{ETC2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable3/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS3" class="txtText" maxlength="50" value="{CTCLASS3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS3" class="txtText" maxlength="50" value="{ITEMCLASS3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE3" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE3}" />
            <!--<button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="발생원인" onclick="_zw.formEx.optionWnd('external.wastereason',130,184,-100,0,'etc','CAUSE3');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT33" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{COUNT33}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT33))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM32" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{SUM32}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM32))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD3" id="ckb.{ROWSEQ}.31" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD3', this, 'METHOD3')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD3),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD3),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.31" style="margin-left:2px">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD3" id="ckb.{ROWSEQ}.32" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD3', this, 'METHOD3')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD3),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD3),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.32" style="margin-left:2px">대금회수</label>
        </span>
        <input type="hidden" name="METHOD3" value="{METHOD3}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC3" class="txtText" maxlength="50" value="{ETC3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable4/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS4" class="txtText" maxlength="50" value="{CTCLASS4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS4" class="txtText" maxlength="50" value="{ITEMCLASS4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE4" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE4}" />
            <!--<button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="발생원인" onclick="_zw.formEx.optionWnd('external.wastereason',130,184,-100,0,'etc','CAUSE4');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT43" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{COUNT43}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT43))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM42" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{SUM42}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM42))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD4" id="ckb.{ROWSEQ}.41" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD4', this, 'METHOD4')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD4),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD4),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.41" style="margin-left:2px">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD4" id="ckb.{ROWSEQ}.42" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD4', this, 'METHOD4')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD4),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD4),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.42" style="margin-left:2px">대금회수</label>
        </span>
        <input type="hidden" name="METHOD4" value="{METHOD4}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC4" class="txtText" maxlength="50" value="{ETC4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable5/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="ITEMNO" class="txtText" maxlength="100" value="{ITEMNO}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TOTAMOUNT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{TOTAMOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TOTAMOUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FLAWAMOUNT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{FLAWAMOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(FLAWAMOUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FLAWRATE" class="txtCurrency"  readonly="readonly" value="{FLAWRATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(FLAWRATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TOTFLAW" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{TOTFLAW}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TOTFLAW))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REMEDY" class="txtText" maxlength="300" value="{REMEDY}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REMEDY))" />
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
