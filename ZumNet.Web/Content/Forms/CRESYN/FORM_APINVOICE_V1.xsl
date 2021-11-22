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
          .m {width:1100px} .m .fm-editor {height:360px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:13%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:17%}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:340px}}
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
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
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
                <td class="f-lbl1" style="border-bottom:0">문서번호</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl1" style="border-bottom:0">작성일자</td>
                <td style="width:13%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl1" style="border-bottom:0">작성부서</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl1" style="border-bottom:0">작성자</td>
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">송장일자<br />(Invoice Date)</td>
                <td style="width:37%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INVOICEDATE" style="width:90px" tabindex="1">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVOICEDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                                                                                                                                                                                                                     
                <td class="f-lbl2">송장번호<br />(Invoice Number)</td>
                <td style="width:33%;border-right:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVOICENUMBER))" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">실제총액<br />(Invoice Total)</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="INVOICETOTAL">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVOICETOTAL" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVOICETOTAL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom:0">분배총액<br />(Distribution Total)</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DISTRIBUTIONTOTAL">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DISTRIBUTIONTOTAL" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DISTRIBUTIONTOTAL))" />
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
                <td class="f-lbl">유형<br />(Invoice Type)</td>
                <td style="width:14%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="INVOICETYPE" tabindex="3">                        
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/INVOICETYPE),'STANDARD')">
                            <option value="STANDARD" selected="selected">STANDARD</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="STANDARD">STANDARD</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/INVOICETYPE),'CREDIT')">
                            <option value="CREDIT" selected="selected">CREDIT</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="CREDIT">CREDIT</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVOICETYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">조직<br />(Organization)</td>
                <td style="width:13%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ORGCODE" style="width:86%" tabindex="5">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ORGCODE" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('erp.organization',100,140,80,100,'','ORGCODE','ORGID','STDCURRENCY','IVCCURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ORGCODE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">공급자<br />(Supplier Name)</td>
                <td colspan="3" style="width:33%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="VENDOR" style="width:94%" tabindex="7">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/VENDOR" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.supplier',240,40,200,70,'','VENDOR','VENDORID','VENDORSITEID','VENDORSITECODE','SEGMENT1','SEGDESC1','SEGMENT2','SEGDESC2','SEGMENT3','SEGDESC3','PAYMENTTERM','TERMSID','LIABLILITYDESC','LIABLILITYACCOUNT');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/VENDOR))" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </td>
              </tr>
              <tr>
                <td class="f-lbl">송장통화<br />(Invoice Currency)</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="IVCCURRENCY" style="width:89px;height:16px" tabindex="9" class="txtText_u">                        
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/IVCCURRENCY" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('erp.currency',180,140,80,115,'etc','IVCCURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/IVCCURRENCY))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">환율유형<br />(Rate Type)</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RATETYPE" style="width:86%" tabindex="11">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/RATETYPE" />
                        </xsl:attribute>
                      </input>
                      <button id="btnRATETYPE"  onclick="parent.fnOption('erp.ratetype',140,86,76,90,'','RATETYPE');" onfocus="this.blur()" class="btn_bg" style="height:16px">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RATETYPE))" />&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">환율일자<br />(Exchange Date)</td>
                <td style="width:12%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXCHANGEDATE" style="width:90px" tabindex="13">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/EXCHANGEDATE" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGEDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">환율<br />(Exchange Rate)</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXCHANGERATE" tabindex="15">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/EXCHANGERATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EXCHANGERATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">송장금액<br />(Invoice Amount)</td>
                <td colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="AMOUNT" tabindex="17">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">30</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/AMOUNT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/AMOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">기준통화금액<br />(Functional Currency Amount)</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FUNCTIONALAMOUNT" tabindex="19">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">30</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FUNCTIONALAMOUNT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FUNCTIONALAMOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">내용<br />(Description)</td>
                <td colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DESCRIPTION" tabindex="21">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">지급그룹<br />(Liability Account)</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LIABLILITYACCOUNT" style="width:85%" tabindex="23">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LIABLILITYACCOUNT" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnView('erp.accountlist',350,122,180,100, '', 'LIABLILITYACCOUNT');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                      <button id="vwDFF" onclick="parent.fnView('erp.attribute',550,122,0,100, '', '');" onfocus="this.blur()" class="btn_bg" style="height:18px;width:30px">DFF</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LIABLILITYACCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">지급내용<br />(Liability Description)</td>
                <td colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LIABLILITYDESC" tabindex="24">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LIABLILITYDESC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LIABLILITYDESC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2">조건일자<br />(Terms Date)</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TERMSDATE" style="width:90px" tabindex="25">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TERMSDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">조건<br />(Payment Term)</td>
                <td colspan="3" style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PAYMENTTERM" style="width:95%" tabindex="27">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PAYMENTTERM" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('erp.termname',350,240,180,100,'','PAYMENTTERM','TERMSID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAYMENTTERM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom:0">결재방법<br />(Payment Method)</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PAYMENTMETHOD" style="width:94%" tabindex="29">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="phxsl:isDiff(string(//forminfo/maintable/PAYMENTMETHOD),'')">
                              <xsl:value-of select="//forminfo/maintable/PAYMENTMETHOD" />
                            </xsl:when>
                            <xsl:otherwise>Check payment</xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('erp.paymentmethod',220,110,160,100,'','PAYMENTMETHOD','METHODCODE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAYMENTMETHOD))" />
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
                      <span></span>
                    </td>
                    <td style="text-align:right">
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span></span>
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
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">                    
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:58px"></col>
                      <col style="width:100px"></col>
                      <col style="width:132px"></col>
                      <col style="width:85px"></col>
                      <col style="width:140px"></col>
                      <col style="width:274px"></col>
                      <col style="width:26px"></col>
                      <col style="width:260px"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">No</td>
                      <td class="f-lbl-sub" style="border-top:0;">유형<br />(Type)</td>
                      <td class="f-lbl-sub" style="border-top:0;">금액<br />(Amount)</td>
                      <td class="f-lbl-sub" style="border-top:0;">세금코드<br />(Tax Code)</td>
                      <td class="f-lbl-sub" style="border-top:0;">GL Date</td>
                      <td class="f-lbl-sub" style="border-top:0;">계정<br />(Account)</td>
                      <td class="f-lbl-sub" style="border-top:0;">계정내용<br />(Account Description)</td>
                      <td class="f-lbl-sub" style="border-top:0;">DFF</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">내용<br />(Description)</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
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

        <!-- Main Table Hidden Field 01 -->
        <input type="hidden" id="__mainfield" name="ORGID">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ORGID" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="STDCURRENCY">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/STDCURRENCY" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="VENDORID">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/VENDORID" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="VENDORSITEID">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/VENDORSITEID" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="VENDORSITECODE">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/VENDORSITECODE" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="TERMSID">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/TERMSID" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="METHODCODE">
          <xsl:attribute name="value">
            <xsl:choose>
              <xsl:when test="phxsl:isDiff(string(//forminfo/maintable/METHODCODE),'')">
                <xsl:value-of select="//forminfo/maintable/METHODCODE" />
              </xsl:when>
              <xsl:otherwise>CHECK</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="SEGMENT1">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SEGMENT1" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="SEGDESC1">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SEGDESC1" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="SEGMENT2">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SEGMENT2" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="SEGDESC2">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SEGDESC2" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="SEGMENT3">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SEGMENT3" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="SEGDESC3">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SEGDESC3" /></xsl:attribute>
        </input>
        <!-- Main Table Hidden Field 02 : ATTRCOL -->
        <input type="hidden" id="__mainfield" name="ATTRCOL01">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL01" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL02">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL02" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL03">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL03" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL04">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL04" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL05">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL05" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL06">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL06" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL07">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL07" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL08">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL08" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL09">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL09" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL10">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL10" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL11">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL11" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL12">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL12" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL13">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL13" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL14">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL14" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCOL15">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCOL15" /></xsl:attribute>
        </input>
        <!-- Main Table Hidden Field 03 : ATTRCODE -->
        <input type="hidden" id="__mainfield" name="ATTRCODE01">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE01" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE02">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE02" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE03">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE03" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE04">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE04" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE05">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE05" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE06">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE06" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE07">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE07" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE08">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE08" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE09">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE09" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE10">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE10" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE11">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE11" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE12">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE12" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE13">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE13" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE14">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE14" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRCODE15">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRCODE15" /></xsl:attribute>
        </input>
        <!-- Main Table Hidden Field 03 : ATTRDESC -->
        <input type="hidden" id="__mainfield" name="ATTRDESC01">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC01" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC02">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC02" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC03">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC03" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC04">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC04" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC05">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC05" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC06">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC06" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC07">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC07" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC08">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC08" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC09">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC09" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC10">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC10" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC11">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC11" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC12">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC12" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC13">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC13" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC14">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC14" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="ATTRDESC15">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ATTRDESC15" /></xsl:attribute>
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
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">height:10px</xsl:attribute>
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
            <select name="IVCTYPE" onchange="parent.fnSelectChange(this);">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />01</xsl:attribute>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(IVCTYPE),'')">
                  <option value="" selected="selected">선택</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="">선택</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(IVCTYPE),'ITEM')">
                  <option value="ITEM" selected="selected">ITEM</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="ITEM">ITEM</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(IVCTYPE),'TAX')">
                  <option value="TAX" selected="selected">TAX</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="TAX">TAX</option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(IVCTYPE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
            <input type="text" name="INVAMOUNT">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />03</xsl:attribute>
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">30</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="INVAMOUNT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(INVAMOUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
            <input type="text" name="TAXCODE" style="width:84%">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />05</xsl:attribute>
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="TAXCODE" />
              </xsl:attribute>
            </input>
            <button onclick="parent.fnOption('erp.taxcode',150,180,80,140,'',this,'SUBDESCRIPTION','ACCOUNT','SUBSEGMENT1','SUBSEGDESC1','SUBSEGMENT2','SUBSEGDESC2','SUBSEGMENT3','SUBSEGDESC3','ACCOUNTDESC');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <!--<xsl:if test="phxsl:isEqual(string(IVCTYPE),'TAX')">
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:if>-->
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TAXCODE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
            <input type="text" name="GLDATE">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />07</xsl:attribute>
              <xsl:attribute name="class">txtDate</xsl:attribute>
              <xsl:attribute name="maxlength">8</xsl:attribute>
              <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="GLDATE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(GLDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ACCOUNT" style="width:85%">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />09</xsl:attribute>
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ACCOUNT" />
              </xsl:attribute>
            </input>
            <button onclick="parent.fnView('erp.accountlist',350,122,100,110, '', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
              </img>
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACCOUNT))" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="SUBSEGMENT1">
          <xsl:attribute name="value"><xsl:value-of select="SUBSEGMENT1" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBSEGDESC1">
          <xsl:attribute name="value"><xsl:value-of select="SUBSEGDESC1" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBSEGMENT2">
          <xsl:attribute name="value"><xsl:value-of select="SUBSEGMENT2" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBSEGDESC2">
          <xsl:attribute name="value"><xsl:value-of select="SUBSEGDESC2" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBSEGMENT3">
          <xsl:attribute name="value"><xsl:value-of select="SUBSEGMENT3" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBSEGDESC3">
          <xsl:attribute name="value"><xsl:value-of select="SUBSEGDESC3" /></xsl:attribute>
        </input>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ACCOUNTDESC">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />11</xsl:attribute>
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ACCOUNTDESC" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACCOUNTDESC))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <button onclick="parent.fnView('erp.attribute',550,122,0,100, '', this);" onfocus="this.blur()" class="btn_bg" style="height:18px;width:20px">..</button>
          </xsl:when>
          <xsl:otherwise>&nbsp;
          </xsl:otherwise>
        </xsl:choose>
        <!-- Sub Table Hidden Field 01 : SUBATTRCOL -->
        <input type="hidden" name="SUBATTRCOL01">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL01" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL02">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL02" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL03">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL03" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL04">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL04" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL05">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL05" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL06">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL06" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL07">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL07" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL08">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL08" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL09">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL09" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL10">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL10" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL11">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL11" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL12">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL12" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL13">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL13" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL14">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL14" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCOL15">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCOL15" /></xsl:attribute>
        </input>
        <!-- Sub Table Hidden Field 02 : SUBATTRCODE -->
        <input type="hidden" name="SUBATTRCODE01">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE01" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE02">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE02" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE03">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE03" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE04">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE04" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE05">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE05" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE06">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE06" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE07">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE07" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE08">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE08" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE09">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE09" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE10">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE10" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE11">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE11" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE12">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE12" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE13">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE13" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE14">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE14" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRCODE15">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRCODE15" /></xsl:attribute>
        </input>
        <!-- Sub Table Hidden Field 03 : SUBATTRDESC -->
        <input type="hidden" name="SUBATTRDESC01">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC01" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC02">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC02" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC03">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC03" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC04">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC04" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC05">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC05" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC06">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC06" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC07">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC07" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC08">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC08" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC09">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC09" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC10">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC10" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC11">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC11" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC12">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC12" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC13">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC13" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC14">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC14" /></xsl:attribute>
        </input>
        <input type="hidden" name="SUBATTRDESC15">
          <xsl:attribute name="value"><xsl:value-of select="SUBATTRDESC15" /></xsl:attribute>
        </input>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUBDESCRIPTION">
              <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />13</xsl:attribute>
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUBDESCRIPTION" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUBDESCRIPTION))" />
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
            <xsl:when test="phxsl:isEqual(string(@xfalias),'pdm')">
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
          <xsl:value-of disable-output-escaping="yes" select="phxsl:fileDown(string(//config/@web), string($root), string(vikrtualpath), string(savedname), string(filename))" />
        </xsl:attribute>
        <xsl:value-of select="filename" />
      </a>
    </div>
  </xsl:template>
</xsl:stylesheet>
