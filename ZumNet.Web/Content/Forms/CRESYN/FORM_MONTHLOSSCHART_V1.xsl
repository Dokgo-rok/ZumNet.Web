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
          .m {width:1300px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20pt;letter-spacing:1pt}
          .m .ft-sub label {font-size:13px}
          .fm1 h2 {font-size:20pt;letter-spacing:1pt;margin:0}

          /* 차트 */
          v\: * { behavior:url(#default#VML);display:inline-block }

          .m .fm-chart {border:windowtext 1pt solid}
          .m .fm-chart .fc {width:100%;height:100%}
          .m .fm-chart .fc td,.m .fm-chart .fc input {font-size:12px;font-family:맑은 고딕}
          .m .fm-chart .fc-lbl {vertical-align:top;text-align:right;padding-top:5px;padding-right:5px;border-right:1px solid windowtext}
          .m .fm-chart .fc-lbl1 {vertical-align:middle;text-align:center;border-right:1px solid windowtext;background-color:#eeeeee}
          .m .fm-chart .fc-axis-y {font-size:1px;border-right:1px solid windowtext;border-left:0px solid red}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:?} .m .ft .f-lbl2 {width:?}
          .m .ft .f-lbl3 {writing-mode:tb-rl}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:150px} .m .ft .f-option2 {width:70px} .m .ft-sub .f-option {width:100%;text-align:center}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:450px} .m .fm-chart .fc-lbl1 {background-color:#ffffff}}
        </style>
      </head>
      <body>
        <div class="m">
          <div class="fh">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="fh-l">
                  <img alt="">
                    <xsl:attribute name="src">
                      <xsl:choose>
                        <xsl:when test="$mode='read'">
                          <xsl:value-of select="//forminfo/maintable/LOGOPATH" />
                        </xsl:when>
                        <xsl:otherwise>
                          /Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </img>
                </td>
                <td class="fh-m">
                  <h1>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="CORPORATION" style="width:120px;font-size:19pt">
                          <xsl:attribute name="class">txtText_u</xsl:attribute>
                          <xsl:attribute name="readonly">readonly</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/CORPORATION" />
                          </xsl:attribute>
                        </input>
                        <button onclick="parent.fnOption('external.chartcentercode',180,140,70,122,'','CORPORATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0">
                            <xsl:attribute name="src">
                              /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                            </xsl:attribute>
                          </img>
                        </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CORPORATION))" />
                      </xsl:otherwise>
                    </xsl:choose>&nbsp;
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt">
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
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:35px;font-size:19pt">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:19pt">
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
                    손실비용발생현황
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
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:15%;border-bottom:0">
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

          <div class="fm-chart">
            <table class="fc" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:60px"></col>
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <col style="width:184px"></col>
                  </xsl:when>
                  <xsl:otherwise>
                    <col style="width:178px"></col>
                  </xsl:otherwise>
                </xsl:choose>
                <col style="width:960px"></col>
                <col style="width:90px"></col>
              </colgroup>
              <!--<colgroup>
                <col style="width:5%"></col>
                <col style="width:"></col>
                <col style="width:72%"></col>
                <col style="width:7%"></col>
              </colgroup>-->
              <tr>
                <td class="fc-lbl1">매출액<br />대비<br />손실비용<br />추이</td>
                <td class="fc-lbl">
                  매출액비(%)<br /><br />
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button id="btnChart" disabled="disabled" onclick="parent.fnChart('','',960,260,5);" onfocus="this.blur()" class="btn_bg" style="width:64px;margin-top:-6px">
                      <img alt="" class="blt01">
                        <xsl:attribute name="src">
                          /<xsl:value-of select="$root"/>/EA/Images/ico_41.gif
                        </xsl:attribute>
                      </img>CHART
                    </button>&nbsp;&nbsp;
                  </xsl:if>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CHATY" style="width:30px;height:21px;margin-top:2px">
                        <xsl:attribute name="class">txtDollar1</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="value">5.0</xsl:attribute>
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
                  </xsl:choose>
                  <br /><br />
                  <font color="red" align="left">*데이터 입력 후 ↑ 차트 버튼을 눌러 주어야 데이터 적용가능</font>
                </td>
                <td style="padding-top:40px">
                  <div id="panChart" style="position:relative;width:100%;height:260px;border:0px solid blue">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:renderLineChart(//chartinfo/fchart[@type='line']/chart, 960, 260, string(//forminfo/maintable/CHATY))"/>
                  </div>
                </td>
                <td>&nbsp;</td>
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
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:70px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                      기준통화 :
                      <input type="text" id="__mainfield" name="STDCURRENCY" style="width:40px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <xsl:attribute name="value">USD</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/STDCURRENCY" />
                            </xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </input>
                      환율일자 :
                      <input type="text" id="__mainfield" name="EXCHANGEDATE" style="width:90px;height:20px">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/EXCHANGEDATE" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>&nbsp;
                      적용환율 :
                      <input type="text" id="__mainfield" name="EXCHANGERATE" style="width:80px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/EXCHANGERATE" />
                        </xsl:attribute>
                      </input>&nbsp;&nbsp;
                      <!--단위 :
                        <input type="text" id="__mainfield" name="CURRENCYUNIT" style="width:100px;height:20px">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">10</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/CURRENCYUNIT" />
                          </xsl:attribute>
                        </input>&nbsp;-->
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <button onclick="parent.fnFormEvent();" onfocus="this.blur()" class="btn_bg">
                          <img alt="" class="blt01">
                            <xsl:attribute name="src">
                              /<xsl:value-of select="$root"/>/EA/Images/form.gif
                            </xsl:attribute>
                          </img>작성
                        </button>
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;&nbsp;
                      기준통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY))" />&nbsp;&nbsp;
                      환율일자 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGEDATE))" />&nbsp;&nbsp;
                      적용환율 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGERATE))" />&nbsp;
                      <!--단위 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCYUNIT))" />&nbsp;-->
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
                      <col style="width:60px"></col>
                      <col style="width:190px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:90px"></col>
                    </colgroup>
                    <!--<colgroup>
                      <col style="width:5%"></col>
                      <col style="width:14%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:7%"></col>
                    </colgroup>-->
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">손실항목</td>
                      <td class="f-lbl-sub" style="border-top:0">1월</td>
                      <td class="f-lbl-sub" style="border-top:0">2월</td>
                      <td class="f-lbl-sub" style="border-top:0">3월</td>
                      <td class="f-lbl-sub" style="border-top:0">4월</td>
                      <td class="f-lbl-sub" style="border-top:0">5월</td>
                      <td class="f-lbl-sub" style="border-top:0">6월</td>
                      <td class="f-lbl-sub" style="border-top:0">7월</td>
                      <td class="f-lbl-sub" style="border-top:0">8월</td>
                      <td class="f-lbl-sub" style="border-top:0">9월</td>
                      <td class="f-lbl-sub" style="border-top:0">10월</td>
                      <td class="f-lbl-sub" style="border-top:0">11월</td>
                      <td class="f-lbl-sub" style="border-top:0">12월</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">TOTAL</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row[position() &lt; 7]"/>
                    <tr>
                      <td class="f-lbl-sub">사내TOTAL</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES3">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES3" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES4">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES4" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES5">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES5" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES6">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES6" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES7">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES7" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES8">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES8" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES9">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES9" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES9))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES10">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES10" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES10))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES11">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES11" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES11))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="INEXPENSES12">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/INEXPENSES12" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INEXPENSES12))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALINEXPENSES">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALINEXPENSES" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALINEXPENSES))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row[position() &gt; 6]"/>
                    <tr>
                      <td class="f-lbl-sub">사외TOTAL</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES3">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES3" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES4">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES4" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES5">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES5" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES6">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES6" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES7">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES7" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES8">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES8" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES9">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES9" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES9))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES10">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES10" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES10))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES11">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES11" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES11))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OUTEXPENSES12">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OUTEXPENSES12" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTEXPENSES12))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALOUTEXPENSES">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALOUTEXPENSES" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALOUTEXPENSES))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2" class="f-lbl-sub">TOTAL</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT3">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT3" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT4">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT4" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT5">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT5" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT6">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT6" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT7">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT7" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT8">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT8" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT9">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT9" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT9))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT10">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT10" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT10))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT11">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT11" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT11))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="FAULT12">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/FAULT12" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULT12))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALFAULT">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALFAULT" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALFAULT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2" class="f-lbl-sub">매출액</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES3">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES3" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES4">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES4" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES5">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES5" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES6">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES6" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES7">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES7" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES8">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES8" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES9">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES9" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES9))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES10">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES10" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES10))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES11">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES11" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES11))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SALES12">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SALES12" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SALES12))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSALES">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSALES" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSALES))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>                    
                    <tr>
                      <td colspan="2" class="f-lbl-sub">매출액비(%)</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE3">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE3" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE4">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE4" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE5">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE5" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE6">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE6" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE7">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE7" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE8">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE8" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE9">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE9" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE9))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE10">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE10" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE10))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE11">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE11" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE11))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="SHARE12">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/SHARE12" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SHARE12))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSHARE">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSHARE" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSHARE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2" class="f-lbl-sub" style="border-bottom:0">WORST 3 개선대책 첨부</td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE1" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE1', this, 'WORSTFILE1')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE1),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE1),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE1),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE1">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE1" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE2" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE2', this, 'WORSTFILE2')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE2),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE2),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE2),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE2">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE2" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE3" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE3', this, 'WORSTFILE3')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE3),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE3),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE3),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE3">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE3" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE4" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE4', this, 'WORSTFILE4')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE4),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE4),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE4),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE4">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE4" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE5" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE5', this, 'WORSTFILE5')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE5),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE5),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE5),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE5">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE5" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE6" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE6', this, 'WORSTFILE6')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE6),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE6),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE6),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE6">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE6" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE7" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE7', this, 'WORSTFILE7')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE7),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE7),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE7),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE7">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE7" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE8" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE8', this, 'WORSTFILE8')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE8),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE8),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE8),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE8">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE8" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE9" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE9', this, 'WORSTFILE9')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE9),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE9),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE9),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE9">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE9" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE10" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE10', this, 'WORSTFILE10')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE10),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE10),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE10),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE10">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE10" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE11" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE11', this, 'WORSTFILE11')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE11),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE11),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE11),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE11">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE11" />
                          </xsl:attribute>
                        </input>
                      </td>
                      <td style="border-bottom:0">
                        <span class="f-option">
                          <input type="checkbox" name="ckbWORSTFILE12" value="Y" style="height:12px">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbWORSTFILE12', this, 'WORSTFILE12')</xsl:attribute>
                              <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/WORSTFILE12),'Y')">
                                <xsl:attribute name="disabled">disabled</xsl:attribute>
                              </xsl:if>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WORSTFILE12),'Y')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WORSTFILE12),'Y')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                        </span>
                        <input type="hidden" id="__mainfield" name="WORSTFILE12">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/WORSTFILE12" />
                          </xsl:attribute>
                        </input>
                      </td>                      
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div id="panWORST" class="fm1" style="page-break-before:always">
            <xsl:if test="($mode='new' or $mode='edit') and phxsl:isEqual(string(//forminfo/subtables/subtable2/row[position()=1]/WORSTITEM), '')">
              <xsl:attribute name="style">display:none</xsl:attribute>
            </xsl:if>
            <div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="text-align:center">
                  <h2>손실비용 WORST3 개선활동서</h2>
                </td>
              </tr>
              <tr>
                <td>
                  <table id="__subtable2" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:12%"></col>
                      <col style="width:8%"></col>
                      <col style="width:6%"></col>
                      <col style="width:33%"></col>
                      <col style="width:33%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">손실항목</td>
                      <td class="f-lbl-sub" style="border-top:0">손실금액</td>
                      <td class="f-lbl-sub" style="border-top:0">점유율(%)</td>
                      <td class="f-lbl-sub" style="border-top:0">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0">개선활동내용</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">완료시기</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row" />
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

        <!--<input type="hidden" id="RealExchangeRate" />-->
        <input type="hidden" id="__mainfield" name="RATETYPE">
          <xsl:attribute name="value">
            <xsl:choose>
              <xsl:when test="$mode='new'">Cost_Corporate</xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="//forminfo/maintable/RATETYPE" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="CURRENCYUNIT">
          <xsl:attribute name="value">
            <xsl:choose>
              <xsl:when test="$mode='new'"></xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="//forminfo/maintable/CURRENCYUNIT" />
              </xsl:otherwise>
            </xsl:choose>
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
    <tr class="sub_table_row">
      <td style="display:none">
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
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(ROWSEQ),'1')">
          <td rowspan="7" class="f-lbl-sub">사내</td>
        </xsl:when>
        <xsl:when test="phxsl:isEqual(string(ROWSEQ),'7')">
          <td rowspan="3" class="f-lbl-sub">사외</td>
        </xsl:when>
      </xsl:choose>    
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FAULTITEM">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item1', string(FAULTITEM))" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(FAULTITEM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES1">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES1" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES2">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES2" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES3">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES3" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES4">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES4" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES5">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES5" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES6">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES6" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES7">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES7" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES8">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES8" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES8))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES9">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES9" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES9))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES10">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES10" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES10))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES11">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES11" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES11))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSES12">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPENSES12" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSES12))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TOTALSUM">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="TOTALSUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TOTALSUM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
      <td style="display:none">
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
      <td style="height:200px">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WORSTITEM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WORSTITEM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(WORSTITEM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WORSTITEMEXPENSES">
              <xsl:attribute name="class">txtCurrency</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WORSTITEMEXPENSES" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(WORSTITEMEXPENSES))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WORSTITEMSHAARE">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">10</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WORSTITEMSHAARE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(WORSTITEMSHAARE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="CAUSE" style="height:196px">
              <xsl:attribute name="class">txaText</xsl:attribute>
              <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="CAUSE" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div name="DESCRIPTION" style="height:196px">
              <xsl:attribute name="class">txaRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="CONTENTS" style="height:196px">
              <xsl:attribute name="class">txaText</xsl:attribute>
              <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="CONTENTS" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div name="DESCRIPTION" style="height:196px">
              <xsl:attribute name="class">txaRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONTENTS))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EPPLANDATE">
              <xsl:attribute name="class">txtDate</xsl:attribute>
              <xsl:attribute name="maxlength">8</xsl:attribute>
              <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EPPLANDATE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EPPLANDATE))" />
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
