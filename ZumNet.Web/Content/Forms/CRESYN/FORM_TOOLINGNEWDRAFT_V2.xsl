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
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:20px} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
          .m .ft-sub {border:1px solid windowtext;border-top:0}
          .m .ft-sub .ft-sub-sub td {border:0;border-right:windowtext 1pt dotted;border-bottom:windowtext 1pt dotted}
          .m .ft-sub .f-option {width:49%} .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

          /* 하위테이블 추가삭제 버튼 */
          .subtbl_div button {height:16px;width:16px}

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
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                </td>
                <td style="width:20px;font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '검토부서')"/>
                </td>
                <td style="width:20px;font-size:1px">&nbsp;</td>
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
                      <input type="text" id="__mainfield" name="MAINREVISION" tabindex="1">
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">사업장</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ORGCODE" style="width:60%" tabindex="2">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ORGCODE" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','ORGCODE', 'ORGID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
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
                <td class="f-lbl">BUYER</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYER" style="width:92%" tabindex="3">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYER" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'BUYER','BUYER','BUYERID','BUYERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">제목</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
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
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>1. 신작현황</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">적용모델</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FMODELNO" style="width:92%">                                           
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FMODELNO" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdmproduct','FMODELNO','FMODELNM','FMODELOID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="FMODELOID!=''">
                          <a target="_blank">
                            <xsl:attribute name="href">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(FMODELOID))" />
                            </xsl:attribute>
                            <xsl:value-of select="FMODELNO" />                        
                          </a>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FMODELNO))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="FMODELOID">
                    <xsl:attribute name="value">
                      <xsl:value-of select="FMODELOID" />
                    </xsl:attribute>
                  </input>
                  <input type="hidden" name="FMODELNM">
                    <xsl:attribute name="value">
                      <xsl:value-of select="FMODELNM" />
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl">금형제작처</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FSUPPLIER" style="width:92%">                        
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FSUPPLIER" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,136,74,'VENDOR','FSUPPLIER','FSUPPLIERID','FSUPPLIERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FSUPPLIER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="FSUPPLIERID">
                    <xsl:attribute name="value">
                      <xsl:value-of select="FSUPPLIERID" />
                    </xsl:attribute>
                  </input>
                  <input type="hidden" name="FSUPPLIERSITEID">
                    <xsl:attribute name="value">
                      <xsl:value-of select="FSUPPLIERSITEID" />
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">신작사유</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKEREASON">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAKEREASON" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKEREASON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">금형비부담</td>
                <td style="width:35%;text-align:center;border-bottom:0">
                  <span style="width:100px">
                    <input type="checkbox" id="ckb21" name="ckbMONEY" value="당사">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMONEY', this, 'WHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'당사')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WHOMONEY),'당사')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">당사</label>
                  </span>
                  <span style="width:50px">
                    <input type="checkbox" id="ckb22" name="ckbMONEY" value="고객">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMONEY', this, 'WHOMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'고객')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/WHOMONEY),'고객')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">고객</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="WHOMONEY">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/WHOMONEY"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl" style="border-bottom:0">비용지급예정일</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MONEYDATE" style="width:100px">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MONEYDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MONEYDATE))" />
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
                      <span>2. 금형비내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : USD&nbsp;&nbsp;
                      <!--<input type="text" id="__mainfield" name="CURRENCY" style="width:60px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
                      <button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
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
                      <span>2. 금형비내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : USD&nbsp;&nbsp;
                      <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;-->
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
                  <table id="__subtable2" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:140px"></col>
                      <col style="width:70px"></col>
                      <col style="width:70px"></col>
                      <col style="width:90px"></col>
                      <col style="width:100px"></col>                      
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:25">
                      <td class="f-lbl-sub" style="">NO</td>
                      <td class="f-lbl-sub" style="">부품명</td>
                      <td class="f-lbl-sub" style="">벌수</td>
                      <td class="f-lbl-sub" style="">CAVITY</td>
                      <td class="f-lbl-sub" style="">금형단가</td>
                      <td class="f-lbl-sub" style="">제작비용</td>                      
                      <td class="f-lbl-sub" style="border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="2">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALBUL">
                              <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALBUL" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALBUL))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" style="border-bottom:0">
                        &nbsp;
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        (VAT 
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="VATVALUE">
                              <xsl:attribute name="class">txtDollar</xsl:attribute>
                              <xsl:attribute name="style">width:30px</xsl:attribute>
                              <xsl:attribute name="maxlength">4</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/VATVALUE" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/VATVALUE))" />
                          </xsl:otherwise>
                      </xsl:choose>%)
                        
                        <input type="checkbox" id="ckb31" name="ckbINCLUDE" value="포함">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">parent.fnCheckYN('ckbINCLUDE', this, 'INCLUDE')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INCLUDE),'포함')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/INCLUDE),'포함')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </input>
                        <label for="ckb31">포함</label>                        
                        
                          <input type="checkbox" id="ckb32" name="ckbINCLUDE" value="미포함">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbINCLUDE', this, 'INCLUDE')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INCLUDE),'미포함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/INCLUDE),'미포함')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb32">미포함</label>
                        
                        <input type="hidden" id="__mainfield" name="INCLUDE">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/INCLUDE"></xsl:value-of>
                          </xsl:attribute>
                        </input>
                      
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
            <span>3. 특기사항</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>                
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:80px" tabindex="5">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="DESCRIPTION" style="height:80px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
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

          <div class="fm">
            <span>4. 同고객 금형보유현황</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1" style="width:12%">소유구분</td>
                <td class="f-lbl1" style="width:12%">수량</td>
                <td class="f-lbl1" style="width:18%">금액(USD)</td>
                <td class="f-lbl1" style="width:58%;border-right:0">비고</td>
              </tr>
              <tr>
                <td class="f-lbl1">당사</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYSTOCKQTY">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANYSTOCKQTY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYSTOCKQTY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYCOSTUSD">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANYCOSTUSD" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYCOSTUSD))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYETC" tabindex="6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANYETC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">고객</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERSTOCKQTY">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERSTOCKQTY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERSTOCKQTY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCOSTUSD">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERCOSTUSD" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERCOSTUSD))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERETC" tabindex="7">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERETC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>5. 同고객 금형대금회수현황</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col width="12%" />
                <col width="12%" />
                <col width="18%" />
                <col width="12%" />
                <col width="12%" />
                <col width="17%" />
                <col width="17%" />
              </colgroup>
              <tr>
                <td class="f-lbl1" rowspan="2">재고(고객)</td>
                <td class="f-lbl1" rowspan="2">청구벌수</td>
                <td class="f-lbl1" rowspan="2">청구금액(USD)</td>
                <td class="f-lbl1" colspan="2">회수여부</td>
                <td class="f-lbl1" colspan="2" style="border-right:0">금액(USD)</td>
              </tr>
              <tr>
                <td class="f-lbl1">회수벌수</td>
                <td class="f-lbl1">미회수벌수</td>
                <td class="f-lbl1">회수금액</td>
                <td class="f-lbl1" style="border-right:0">미회수금액</td>
              </tr>
              <tr>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTSTOCKQTY">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTSTOCKQTY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOTSTOCKQTY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCHARGETYPE">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERCHARGETYPE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERCHARGETYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCHARGESUM">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERCHARGESUM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERCHARGESUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALCNT1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALCNT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALCNT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALCNT2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALCNT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALCNT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALSUM1">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALSUM1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALSUM1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERRETRIEVALSUM2">
                        <xsl:attribute name="class">txtRead_Center</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BUYERRETRIEVALSUM2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYERRETRIEVALSUM2))" />
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
                      <span>6. 금형상세내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : USD&nbsp;&nbsp;
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
                      <span>6. 금형상세내역</span>
                    </td>
                    <td class="fm-button">통화 : USD&nbsp;</td>
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
                  <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:96%"></col>
                    </colgroup>
                    <!--<tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">금형정보</td>
                    </tr>-->
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
        <input type="hidden" id="__mainfield" name="BUYERID">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/BUYERID" /></xsl:attribute>
        </input>
        <input type="hidden" id="__mainfield" name="BUYERSITEID">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/BUYERSITEID" /></xsl:attribute>
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
      <td style="border:0;border-top:1px solid windowtext;border-right:1px dotted windowtext">
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
      <td style="border:0;border-top:1px solid windowtext;padding:0;height:220px">
        <table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
          <xsl:if test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">table-layout:</xsl:attribute>
          </xsl:if>
          <colgroup>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
          </colgroup>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">금형분류</td>
            <td colspan="3" style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingcls'],'CLSCODE',string(CLSCODE),'CLSNM',string(CLSNM),'120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CLSNM))" />
                  <input type="hidden" name="CLSCODE">
                    <xsl:attribute name="value"><xsl:value-of select="CLSCODE" /></xsl:attribute>
                  </input>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">적용모델</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNO" style="width:92%">
                    <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />02</xsl:attribute>
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNO" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdmproduct',this,'MODELNM','MODELOID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="MODELOID!=''">
                      <a target="_blank">
                        <xsl:attribute name="href">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(MODELOID))" />
                        </xsl:attribute>
                        <xsl:value-of select="MODELNO" />
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="MODELOID">
                <xsl:attribute name="value"><xsl:value-of select="MODELOID" /></xsl:attribute>
              </input>
            </td>
            <td class="f-lbl-sub">모델명</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNM">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNM" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNM))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">부품</td>
            <td colspan="3" style="border-right:0">
              <div class="subtbl_div" max="5" min="1" fld="PARTNO^PARTNM^PARTOID">
                <div>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="PARTNO1" style="width:230px">
                        <xsl:attribute name="tabindex"><xsl:value-of select="ROWSEQ" />03</xsl:attribute>
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO1" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM1" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM1" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 1)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg" style="display:none">
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="PARTOID1!=''">
                          <a target="_blank">
                            <xsl:attribute name="href">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID1))" />
                            </xsl:attribute>
                            <xsl:value-of select="PARTNO1" />
                          </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO1))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="PARTOID1">
                    <xsl:attribute name="value"><xsl:value-of select="PARTOID1" /></xsl:attribute>
                  </input>
                </div>
                <xsl:if test="phxsl:isDiff(string(PARTNO2),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO2" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO2" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM2" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM2" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 2)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 2)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID2!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID2))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO2" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO2))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID2">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID2" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO3),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO3" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO3" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM3" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM3" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 3)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 3)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID3!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID3))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO3" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM3))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO3))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM3))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID3">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID3" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO4),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO4" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO4" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM4" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM4" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 4)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 4)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID4!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID4))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO4" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM4))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO4))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM4))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID4">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID4" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO5),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO5" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO5" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM5" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM5" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 5)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 5)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID5!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID5))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO5" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM5))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO5))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM5))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID5">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID5" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO6),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO6" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO6" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM6" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM6" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 6)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 6)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID6!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID6))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO6" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM6))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO6))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM6))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID6">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID6" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO7),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO7" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO7" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM7" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM7" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 7)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 7)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID7!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID7))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO7" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM7))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO7))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM7))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID7">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID7" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO8),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO8" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO8" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM8" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM8" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 8)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 8)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID8!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID8))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO8" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM8))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO8))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM8))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID8">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID8" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO9),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO9" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO9" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM9" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM9" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 9)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <xsl:if test="phxsl:isGt(string(PARTCNT), 9)">
                          <xsl:attribute name="style">display:none</xsl:attribute>
                        </xsl:if>
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID9!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID9))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO9" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM9))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO9))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM9))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID9">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID9" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
                <xsl:if test="phxsl:isDiff(string(PARTNO10),'')">
                  <div>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="PARTNO10" style="width:230px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNO10" /></xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>&nbsp;(
                      <input type="text" name="PARTNM10" style="width:278px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value"><xsl:value-of select="PARTNM10" /></xsl:attribute>
                      </input>)
                      <button onclick="parent.fnAddDiv(this,10);" onfocus="this.blur()" class="btn_bg" style="display:none">
                        <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnDelDiv(this,1);" onfocus="this.blur()" class="btn_bg">
                        <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>
                      </button>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="PARTOID10!=''">
                            <a target="_blank">
                              <xsl:attribute name="href">
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID10))" />
                              </xsl:attribute>
                              <xsl:value-of select="PARTNO10" />
                            </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM10))" />)
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO10))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM10))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                    <input type="hidden" name="PARTOID10">
                      <xsl:attribute name="value"><xsl:value-of select="PARTOID10" /></xsl:attribute>
                    </input>
                  </div>
                </xsl:if>
              </div>
              <input type="hidden" name="PARTCNT">
                <xsl:attribute name="value"><xsl:value-of select="PARTCNT" /></xsl:attribute>
              </input>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">소유구분</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpos'],'POSTYPE',string(POSTYPE),'','','120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(POSTYPE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">공용구분</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpub'],'CMNTYPE',string(CMNTYPE),'','','120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CMNTYPE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>          
          <!--<tr class="subsub_table_row">
            <td class="f-lbl-sub">부품번호</td>
            <td style="height:40">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PARTNO1" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTNO1" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnExternal('erp.items',240,40,136,74,'',this,'PARTNM1');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO1))" />
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PARTNO2" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTNO2" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnExternal('erp.items',240,40,136,74,'',this,'PARTNM2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO2))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">부품명</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PARTNM1">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTNM1" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PARTNM2">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTNM2" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM2))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>-->
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">CAVITY</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="CAVITY" style="width:60px">
                    <xsl:attribute name="class">txtNumberic</xsl:attribute>
                    <xsl:attribute name="maxlength">3</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="CAVITY" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">만기SHOT</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="EXPIREDSHOT">
                    <xsl:attribute name="class">txtCurrency</xsl:attribute>
                    <xsl:attribute name="maxlength">20</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="EXPIREDSHOT" /></xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPIREDSHOT))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">제작벌수</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="TOOLREQQTY" style="width:60px">
                    <xsl:attribute name="class">txtVolume</xsl:attribute>
                    <xsl:attribute name="maxlength">3</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="TOOLREQQTY" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOOLREQQTY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <!--<td class="f-lbl-sub">예상투자비</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="EXPECTCOSTCURRENCY" style="width:35px">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                  <input type="text" name="EXPECTCOST" style="width:110px">
                    <xsl:attribute name="class">txtDollar</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="onblur">parent.fnFormEvent(this)</xsl:attribute>
                  </input>
                  <input type="text" name="CONVEXPECTCOST" style="width:110px">
                    <xsl:attribute name="class">txtDollar</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPECTCOSTCURRENCY))" />)&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPECTCOST))" />
                  &nbsp;=>&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONVEXPECTCOST))" />
                </xsl:otherwise>
              </xsl:choose>              
            </td>-->
            <td class="f-lbl-sub">제작단가</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PRODUCTCOSTCURRENCY" style="width:35px;height:16px">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="PRODUCTCOSTCURRENCY" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>
                  <input type="text" name="PRODUCTCOST" style="width:100px">
                    <xsl:attribute name="class">txtDollar</xsl:attribute>
                    <xsl:attribute name="maxlength">20</xsl:attribute>
                  </input>
                  <input type="text" name="CONVPRODUCTCOST" style="width:100px">
                    <xsl:attribute name="class">txtDollar</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOSTCURRENCY))" />)&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOST))" />
                  &nbsp;=>&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONVPRODUCTCOST))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">제작비용</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="PRODUCTCOSTSUM" style="width:100px">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                  <input type="text" name="CONVPRODUCTCOSTSUM" style="width:100px">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOSTCURRENCY))" />)&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRODUCTCOSTSUM))" />
                  &nbsp;=>&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONVPRODUCTCOSTSUM))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <!--<td class="f-lbl-sub">차이금액</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MARGIN">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MARGIN))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>-->
            <td class="f-lbl-sub">결제조건</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingsettl'],'SETTLEMENTCODE',string(SETTLEMENTCODE),'SETTLEMENT',string(SETTLEMENT),'120px')"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">tdRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SETTLEMENT))" />
                  <input type="hidden" name="SETTLEMENTCODE">
                    <xsl:attribute name="value"><xsl:value-of select="SETTLEMENTCODE" /></xsl:attribute>
                  </input>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>          
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">제작처</td>
            <td>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="SUPPLIER" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="SUPPLIER" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,136,74,'VENDOR',this,'SUPPLIERID','SUPPLIERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUPPLIER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="SUPPLIERID">
                <xsl:attribute name="value"><xsl:value-of select="SUPPLIERID" /></xsl:attribute>
              </input>
              <input type="hidden" name="SUPPLIERSITEID">
                <xsl:attribute name="value"><xsl:value-of select="SUPPLIERSITEID" /></xsl:attribute>
              </input>
            </td>
            <td class="f-lbl-sub">소유처</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="OWNER" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="OWNER" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,136,74,'VENDOR',this,'OWNERID','OWNERSITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(OWNER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="OWNERID">
                <xsl:attribute name="value"><xsl:value-of select="OWNERID" /></xsl:attribute>
              </input>
              <input type="hidden" name="OWNERSITEID">
                <xsl:attribute name="value"><xsl:value-of select="OWNERSITEID" /></xsl:attribute>
              </input>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="border-bottom:0">재질</td>
            <td style="border-bottom:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="TOOLSPEC">
                    <xsl:attribute name="class">txtText</xsl:attribute>
                    <xsl:attribute name="maxlength">100</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="TOOLSPEC" /></xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(TOOLSPEC))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub" style="border-bottom:0">영업담당</td>
            <td style="border-right:0;border-bottom:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" style="width:92%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="CHARGEDEPT" /> <xsl:value-of select="CHARGEUSER" /></xsl:attribute>
                  </input>
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                      </img>
                    </button>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CHARGEDEPT))" />&nbsp;
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CHARGEUSER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="CHARGEDEPT">
                <xsl:attribute name="value"><xsl:value-of select="CHARGEDEPT" /></xsl:attribute>
              </input>
              <input type="hidden" name="CHARGEDEPTCD">
                <xsl:attribute name="value"><xsl:value-of select="CHARGEDEPTCD" /></xsl:attribute>
              </input>
              <input type="hidden" name="CHARGEUSER">
                <xsl:attribute name="value"><xsl:value-of select="CHARGEUSER" /></xsl:attribute>
              </input>              
              <input type="hidden" name="CHARGEUSERID">
                <xsl:attribute name="value"><xsl:value-of select="CHARGEUSERID" /></xsl:attribute>
              </input>
              <input type="hidden" name="CHARGEUSEREMPID">
                <xsl:attribute name="value"><xsl:value-of select="CHARGEUSEREMPID" /></xsl:attribute>
              </input>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
      <td>
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
            <input type="text" name="ITEMNAME">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT">
              <xsl:attribute name="class">txtVolume</xsl:attribute>
              <xsl:attribute name="maxlength">10</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COUNT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAVITYS">
              <xsl:attribute name="class">txtCurrency</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="CAVITYS" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITYS))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNIT">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="UNIT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNIT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
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
