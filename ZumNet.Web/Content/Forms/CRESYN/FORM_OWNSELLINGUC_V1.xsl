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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 1pt solid}
          .fh h1 {font-size:18.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:11%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:25%} .m .ft .f-option1 {width:62px} .m .ft .f-option2 {width:90px} .m .ft .f-option4 {width:50px} .m .ft .f-option5 {width:47px}

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
                    <xsl:value-of select="//docinfo/docname" />
                  </h1>
                </td>
                <td class="fh-r">&nbsp;</td>
              </tr>
            </table>
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <input type="hidden" id="__mainfield" name="LOGOPATH">
                  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/LOGOPATH" /></xsl:attribute>
                </input>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" id="__mainfield" name="LOGOPATH">
                  <xsl:attribute name="value">/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" /></xsl:attribute>
                </input>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:305px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:243px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의', 'N')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:92px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">관리번호</td>
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
                <td style="border-bottom:0;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <xsl:choose>
            <xsl:when test="$bizrole='의견' and $partid!=''">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:100px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <textarea id="__mainfield" name="CONTENTS" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
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
                    <td class="f-lbl" style="border-bottom:0;width:100px">
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

          <div class="fm">
            <span>1. 제품사양</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">기획수량</td>
                <td style="text-align:right" colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCNT" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/PLANCNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="PLANCNT" readonly="readonly" style="text-align:right"   class="txtText_u" value="{//forminfo/maintable/PLANCNT}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="height:35px;font-size:11px">
                  기획수량<br />조정비율
                </td>
                <td style="border-right:0;text-align:center">
                  <span class="f-option4">
                    <input type="checkbox" id="ckb91" name="ckbCOUNTPERCENT" value="칠십">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCOUNTPERCENT', this, 'COUNTPERCENT')</xsl:attribute>
                    </input>
                    <label for="ckb91">75%</label>
                  </span>
                  <span class="f-option4">
                    <input type="checkbox" id="ckb92" name="ckbCOUNTPERCENT" value="오십">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCOUNTPERCENT', this, 'COUNTPERCENT')</xsl:attribute>
                    </input>
                    <label for="ckb92">50%</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="COUNTPERCENT"  value="{//forminfo/maintable/COUNTPERCENT}" />                  
                  <input type="text" id="__mainfield" name="COUNTPERCENT2"  class="txtDollar" readonly="readonly"  style="display:none;width:0px"  value="{//forminfo/maintable/COUNTPERCENT2}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl">품명</td>
                <td style="width:20%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ITEMNAME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">품번</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ITEMNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">고객명</td>
                <td style="width:20%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CLIENT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CLIENT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLIENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">변동요인</td>
                <td colspan="3" style="text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbCHANGECAUSE" value="신규설정">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGECAUSE', this, 'CHANGECAUSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGECAUSE),'신규설정')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGECAUSE),'신규설정')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">신규설정</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbCHANGECAUSE" value="단가인상">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGECAUSE', this, 'CHANGECAUSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGECAUSE),'단가인상')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGECAUSE),'단가인상')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">단가인상</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbCHANGECAUSE" value="단가인하">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGECAUSE', this, 'CHANGECAUSE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGECAUSE),'단가인하')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGECAUSE),'단가인하')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">단가인하</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHANGECAUSE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHANGECAUSE"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl1">단계</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STEP" style="width:80%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STEP" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.productstep',140,120,80,110,'','STEP');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STEP))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">생산지</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="PRODUCTCENTER"  class="txtText_u" readonly="readonly" style="width:90px"  value="{//forminfo/maintable/PRODUCTCENTER}" />                      
                      <button onclick="parent.fnOption('external.chartcentercode',180,140,70,122,'','PRODUCTCENTER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODUCTCENTER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">유사모델</td>
                <td style="border-bottom:0;border-right:0" colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SIMILARMODEL" style="width:90%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SIMILARMODEL" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,140,68,'','SIMILARMODEL');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SIMILARMODEL))" />
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
            <table>
              <tr>
                <td style="width:50%">
                  <span>2. 판매손익</span>
                </td>
                <td class="fm-button">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      &nbsp;
                    </xsl:when>
                    <xsl:otherwise>
                      통화&nbsp;:&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />
                      &nbsp;&nbsp;기준환율&nbsp;:&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGERATE))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'  or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:22%"></col>
                <col style="width:11%"></col>
                <col style="width:22%"></col>
                <col style="width:11%"></col>
                <col style="width:%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl" style="height:35px;font-weight:bold">
                  총원가 (a+<br />e+f+g+h+i+j)
                </td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTWONGA" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/TOTWONGA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="TOTWONGA" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/TOTWONGA}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">개당이익</td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EACHWONGA" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/EACHWONGA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="EACHWONGA" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/EACHWONGA}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">영업이익율</td>
                <td style="border-right:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SALEWONGA" readonly="readonly"  class="txtText_u" style="text-align:right;width:110px"  value="{//forminfo/maintable/SALEWONGA}" />%
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="SALEWONGA" readonly="readonly"  class="txtText_u" style="text-align:right;width:110px"  value="{//forminfo/maintable/SALEWONGA}" />%
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0" >월별납품예상량</td>
                <td style="border-bottom:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="AMOUNT" maxlength="50"  class="txtText" value="{//forminfo/maintable/AMOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="AMOUNT"  readonly="readonly" style="text-align:right"   class="txtText_u" value="{//forminfo/maintable/AMOUNT}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">예상매출액</td>
                <td style="border-bottom:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PREDICTMONEY" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/PREDICTMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="PREDICTMONEY" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/PREDICTMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="font-size:11px;border-bottom:0">예상매출이익</td>
                <td style="border-bottom:0;border-right:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PREDICTFOR" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/PREDICTFOR}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="PREDICTFOR" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/PREDICTFOR}" />
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
            <table>
              <tr>
                <td style="width:50%">
                  <span>3. 공장투자비용 및 손익</span>
                </td>
                <td class="fm-button">
                  통화&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:60px;height:16px"  class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CURRENCY}" />
                      <button onclick="parent.fnOption('iso.currency',160,140,60,60,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;&nbsp;기준환율&nbsp;:&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="EXCHANGERATE" style="width:100px;height:16px"  class="txtText_u" readonly="readonly" value="{//forminfo/maintable/EXCHANGERATE1}" />
                      <button onclick="parent.fnExternal('erp.exchangerate',240,40,80,70,'KRW','EXCHANGERATE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGERATE))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">금형비</td>
                <td style="width:22%;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOOLMONEY"  class="txtDollar" value="{//forminfo/maintable/TOOLMONEY}" />                      
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="TOOLMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u" value="{//forminfo/maintable/TOOLMONEY}" />                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">설비/치공구</td>
                <td style="text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="JIGMONEY"  class="txtDollar" value="{//forminfo/maintable/JIGMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="JIGMONEY" readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/JIGMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">기타비용</td>
                <td style="width:22%;border-right:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ETCMONEY"  class="txtDollar" value="{//forminfo/maintable/ETCMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="ETCMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/ETCMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">금형비회수</td>
                <td colspan="5" style="text-align:center;border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb23" name="ckbTOOLMONEY" value="당사부담">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTOOLMONEY', this, 'TOOLWHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TOOLWHOMONEY),'당사부담')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TOOLWHOMONEY),'당사부담')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">당사부담</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbTOOLMONEY" value="고객청구">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTOOLMONEY', this, 'TOOLWHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TOOLWHOMONEY),'고객청구')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TOOLWHOMONEY),'고객청구')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">고객</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb22" name="ckbTOOLMONEY" value="판매가포함">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTOOLMONEY', this, 'TOOLWHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TOOLWHOMONEY),'판매가포함')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TOOLWHOMONEY),'판매가포함')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">판매가 포함</label>
                  </span>
                  (개당(f):                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PERMONEY"  class="txtDollar" style="display:none;width:100px"  value="{//forminfo/maintable/PERMONEY}" />    
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PERMONEY))" />
                      <input type="text" id="__mainfield" name="PERMONEY"  class="txtDollar" readonly="readonly"  style="display:none;width:100px"  value="{//forminfo/maintable/PERMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="TOOLWHOMONEY"  value="{//forminfo/maintable/TOOLWHOMONEY}" />                  
                </td>
              </tr>
              <tr>
                <td class="f-lbl">금형감가</td>
                <td style="text-align:center" colspan="2">
                  <span class="f-option5">
                    <input type="checkbox" id="ckb31" name="ckbTOOLGAMGA" value="완료">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTOOLGAMGA', this, 'TOOLGAMGA')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TOOLGAMGA),'완료')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TOOLGAMGA),'완료')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">완료</label>
                  </span>
                  <span class="f-option5">
                    <input type="checkbox" id="ckb32" name="ckbTOOLGAMGA" value="진행">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTOOLGAMGA', this, 'TOOLGAMGA')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TOOLGAMGA),'진행')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TOOLGAMGA),'진행')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">진행</label>
                  </span>
                  (개당(j):
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOOLGAMGADETAIL"  class="txtDollar" readonly="readonly" style="display:none;width:70px"  value="{//forminfo/maintable/TOOLGAMGADETAIL}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOOLGAMGADETAIL))" />
                      <input type="text" id="__mainfield" name="TOOLGAMGADETAIL"  class="txtDollar" readonly="readonly"  style="display:none;width:70px"  value="{//forminfo/maintable/TOOLGAMGADETAIL}" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="TOOLGAMGA"  value="{//forminfo/maintable/TOOLGAMGA}" />                  
                </td>
                <td class="f-lbl">비고</td>
                <td colspan="2"  style="border-right:0">                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ETCTEXT"  class="txtText"   value="{//forminfo/maintable/ETCTEXT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETCTEXT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:35px">투자 TOTAL비용</td>
                <td style="width:22%;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INVESTTOTMONEY"  class="txtText_u" readonly="readonly" style="text-align:right" value="{//forminfo/maintable/INVESTTOTMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="INVESTTOTMONEY"  class="txtText_u" readonly="readonly" style="text-align:right" value="{//forminfo/maintable/INVESTTOTMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="font-size:11px;text-align:center">
                  투자단가(b)<br />(개당)</td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INVESTMONEY"  class="txtText_u" readonly="readonly" style="text-align:right" value="{//forminfo/maintable/INVESTMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="INVESTMONEY"  class="txtText_u" readonly="readonly" style="text-align:right" value="{//forminfo/maintable/INVESTMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">공장출하가</td>
                <td style="width:22%;border-right:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FACTOUTMONEY"  class="txtDollar" value="{//forminfo/maintable/FACTOUTMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="FACTOUTMONEY"   readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/FACTOUTMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:35px;font-size:11px">
                  제조원가(c)<br />(재료비 + 가공비)
                </td>
                <td style="width:22%;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODMONEY"  class="txtDollar" value="{//forminfo/maintable/PRODMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="PRODMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/PRODMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">공장판관비(d)</td>
                <td style="text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FACTSELLMONEY"  class="txtDollar" value="{//forminfo/maintable/FACTSELLMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="FACTSELLMONEY"   readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/FACTSELLMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="height:35px;font-size:11px;font-weight:bold">공장총원가(a)<br />(b+c+d)                  
                </td>
                <td style="width:22%;border-right:0;text-align:right">
                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FACTTOTMONEY" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/FACTTOTMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="FACTTOTMONEY" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/FACTTOTMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">개당이익</td>
                <td style="width:22%;border-bottom:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PERGETMONEY"  class="txtText_u" readonly="readonly" style="text-align:right"   value="{//forminfo/maintable/PERGETMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="PERGETMONEY"  class="txtText_u" readonly="readonly" style="text-align:right"   value="{//forminfo/maintable/PERGETMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">공장이익율</td>
                <td style="border-bottom:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FACTPERCENT"  class="txtText_u" readonly="readonly" style="text-align:right;width:110px"  value="{//forminfo/maintable/FACTPERCENT}" />%
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="FACTPERCENT"  class="txtText_u" readonly="readonly" style="text-align:right;width:110px"  value="{//forminfo/maintable/FACTPERCENT}" />%
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="font-size:11px;border-bottom:0">공장매출이익</td>
                <td style="width:22%;border-right:0;border-bottom:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FACTREALMONEY" readonly="readonly"  class="txtText_u" style="text-align:right" value="{//forminfo/maintable/FACTREALMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="FACTREALMONEY" readonly="readonly"  class="txtText_u" style="text-align:right" value="{//forminfo/maintable/FACTREALMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />                   

          <div class="fm">
            <table>
              <tr>
                <td style="width:50%">
                  <span>4. 제품판매가 및 본사 투자비용</span>
                </td>
                <td class="fm-button">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      &nbsp;
                    </xsl:when>
                    <xsl:otherwise>
                      통화&nbsp;:&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />
                      &nbsp;&nbsp;기준환율&nbsp;:&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGERATE))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>               
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'  or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:10%"></col>
                <col style="width:12%"></col>
                <col style="width:11%"></col>
                <col style="width:19%"></col>
                <col style="width:11%"></col>
                <col style="width:10%"></col>
                <col style="width:12%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl" style="font-weight:bold">최종납품가</td>
                <td style="text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRICE1" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/PRICE1}" />                      
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="PRICE1"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/PRICE1}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">선적조건</td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="SHIPCONDITION" readonly="readonly" style="width:72%"  class="txtText_u" value="{//forminfo/maintable/SHIPCONDITION}" />
                      <button onclick="parent.fnOption('external.shipmentcond',140,200,80,100,'','SHIPCONDITION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SHIPCONDITION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">적용시기</td>
                <td style="border-right:0" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="APPLYPOINT" maxlength="50"  class="txtText" value="{//forminfo/maintable/APPLYPOINT}" />                      
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLYPOINT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">결제조건</td>
                <td style="" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="CONDITIONPAY" maxlength="50"  class="txtText" value="{//forminfo/maintable/CONDITIONPAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CONDITIONPAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">MC율</td>
                <td style="text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="MCPERCENT" maxlength="20"  class="txtDollar" style="width:115px"  value="{//forminfo/maintable/MCPERCENT}" />%
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MCPERCENT))" />%
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">경쟁사단가</td>
                <td style="border-right:0;text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                     
                      <input type="text" id="__mainfield" name="PRICE7" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/PRICE7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRICE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">디자인비</td>
                <td style=";text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DESIGNMONEY" maxlength="100"  class="txtDollar" value="{//forminfo/maintable/DESIGNMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="DESIGNMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/DESIGNMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">MOCK비</td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MOCKMONEY" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/MOCKMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="MOCKMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/MOCKMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">제품인증비</td>
                <td style="border-right:0;text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CERTIMONEY" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/CERTIMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="CERTIMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/CERTIMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">샘플구입비</td>
                <td style=";text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SAMPLEMONEY" maxlength="100"  class="txtDollar" value="{//forminfo/maintable/SAMPLEMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="SAMPLEMONEY" readonly="readonly" style="text-align:right"   class="txtText_u" value="{//forminfo/maintable/SAMPLEMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="font-size:11px;">마케팅인건비</td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MARKETINGMONEY" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/MARKETINGMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="MARKETINGMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/MARKETINGMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="height:35px">광고선전비(i)</td>                
                <td style="text-align:right">                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select name="DOCSECURE" id="__mainfield" style="width:60px">
                        <xsl:attribute name="onChange">parent.fnCalc('1')</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(DOCSECURE),'7.2')">
                            <option value="SEVEN" selected="selected">7.2%</option>                                                        
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="7.2">7.2%</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(DOCSECURE),'0')">
                            <option value="ZERO" selected="selected">0%</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="0">0%</option>
                          </xsl:otherwise>
                        </xsl:choose>                       
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOCSECURE))" />
                      <input type="text" id="__mainfield" name="DOCSECURE"  readonly="readonly" style="text-align:right;width:80%"   class="txtText_u"   value="{//forminfo/maintable/DOCSECURE}" />%
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ADVERMONEY" readonly="readonly" style="text-align:right"  class="txtText_u" value="{//forminfo/maintable/ADVERMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="ADVERMONEY"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/ADVERMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:35px">물류통관비(g)</td>
                <td style="text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MULRYUPER" maxlength="100"  class="txtDollar" style="width:50px"  value="{//forminfo/maintable/MULRYUPER}" />%
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="MULRYUPER"  readonly="readonly" style="text-align:right;width:80%"   class="txtText_u"   value="{//forminfo/maintable/MULRYUPER}" />%
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MULRYUPERDETAIL" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/MULRYUPERDETAIL}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="MULRYUPERDETAIL" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/MULRYUPERDETAIL}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">개발인건비</td>
                <td style=";text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVPERSONMON" maxlength="20"  class="txtDollar" value="{//forminfo/maintable/DEVPERSONMON}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="DEVPERSONMON" readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/DEVPERSONMON}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="font-size:11px">본사<br />일반관리비(h)</td>
                <td style="text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="HEADOFFICEMON" maxlength="100"  class="txtDollar" style="width:50px" value="{//forminfo/maintable/HEADOFFICEMON}" />%
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="HEADOFFICEMON"  readonly="readonly" style="text-align:right;width:80%"   class="txtText_u"  value="{//forminfo/maintable/HEADOFFICEMON}" />%
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="HEADOFFICEMONDETAIL" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/HEADOFFICEMONDETAIL}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="HEADOFFICEMONDETAIL"  readonly="readonly" style="text-align:right"   class="txtText_u"   value="{//forminfo/maintable/HEADOFFICEMONDETAIL}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:35px;border-bottom:0">기타비용</td>
                <td style="border-bottom:0;text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ETCMONEYDETAIL" maxlength="100"  class="txtDollar" value="{//forminfo/maintable/ETCMONEYDETAIL}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="ETCMONEYDETAIL"  readonly="readonly" style="text-align:right"   class="txtText_u"  value="{//forminfo/maintable/ETCMONEYDETAIL}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="font-size:11px;border-bottom:0">투자Total비용</td>
                <td style="border-bottom:0;text-align:right">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ALLMONEY" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/ALLMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="ALLMONEY" readonly="readonly"  class="txtText_u" style="text-align:right"  value="{//forminfo/maintable/ALLMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">투자단가(e)<br />(개당)</td>
                <td style="border-right:0;border-bottom:0;text-align:right" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ALLDETAILMONEY" readonly="readonly" class="txtText_u" style="text-align:right" value="{//forminfo/maintable/ALLDETAILMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="ALLDETAILMONEY" readonly="readonly" class="txtText_u" style="text-align:right" value="{//forminfo/maintable/ALLDETAILMONEY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

         

          <div class="fm">
            <span>5. 특기사항(가격변동요인, 배경, 경쟁사정보, 전개 MODEL, 향후 전망 등)</span>
          </div>

          <div class="ff" />

          <div class="fm-editor">
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
                <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no">
                  <xsl:attribute name="src">
                    /<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx
                  </xsl:attribute>
                </iframe>
              </xsl:otherwise>
            </xsl:choose>
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