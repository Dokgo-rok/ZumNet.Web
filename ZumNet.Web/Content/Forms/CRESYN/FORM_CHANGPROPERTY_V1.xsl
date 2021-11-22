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
          .m {width:1100px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}

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
                <td style="width:475px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '6', '인계부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:475px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'distribution', '__si_Distribution', '6', '인수부서')"/>
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0;">제목</td>
                <td style="border-bottom:0;width:70%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield">
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
                <td class="f-lbl" style="border-bottom:0;">
                  발생일자
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MADEDATE" style="width:150px">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MADEDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MADEDATE))" />
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
              <tr>
                <td>
                  <span>구분 : </span>
                </td>
                <TD style="text-align:left">
                  <input type="checkbox" id="ckb15" name="ckbCHANGEDETAIL" value="신규">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL', this, 'CHANGEDETAIL')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL),'신규')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL),'신규')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb15">신규</label>&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type="checkbox" id="ckb16" name="ckbCHANGEDETAIL" value="이관">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL', this, 'CHANGEDETAIL')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL),'이관')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL),'이관')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb16">이관</label>&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type="checkbox" id="ckb17" name="ckbCHANGEDETAIL" value="반납">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL', this, 'CHANGEDETAIL')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL),'반납')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL),'반납')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb17">반납</label>&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type="checkbox" id="ckb18" name="ckbCHANGEDETAIL" value="판매">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL', this, 'CHANGEDETAIL')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL),'판매')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL),'판매')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb18">판매</label>&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type="checkbox" id="ckb19" name="ckbCHANGEDETAIL" value="폐기">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL', this, 'CHANGEDETAIL')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL),'폐기')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL),'폐기')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb19">폐기</label>
                </TD>
                <td class="fm-button">
                  <xsl:if test="$mode='new' or $mode='edit'">
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
                  </xsl:if>
                </td>
              </tr>
              <input type="hidden" id="__mainfield" name="CHANGEDETAIL">
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL"></xsl:value-of>
                </xsl:attribute>
              </input>
              <tr>
                <td colspan="3">
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="3">
                  <table id="__subtable1" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:3%"></col>
                      <col style="width:11%"></col>
                      <col style="width:10%"></col>
                      <col style="width:6%"></col>
                      <col style="width:10%"></col>
                      <col style="width:10%"></col>
                      <col style="width:25%"></col>
                      <col style="width:10%"></col>
                      <col style="width:15%"></col>
                    </colgroup>
                    <tr style="height:20px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품명</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">재산등록 NO.</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">수량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">
                        인계인수 부서명
                      </td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">사유</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">금액</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub">
                        FROM
                      </td>
                      <td class="f-lbl-sub">
                        TO
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table>
              <tr>
                <Td style="text-align:left">
                  <font size="2" color="red">
                    주) 1. 금액란은 신규 또는 판매시에만 부가세 제외 금액으로 기재하여 주십시요. <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    2. 신규구입 및 판매 시 발생일자는 세금계산서상의 작성일자와 동일하게 기재하여 주시고, 이외 변동사항은 실재 재산 변동이 발생된 일자로 기재하여 주십시요.
                  </font>
                </Td>
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
      <td style="text-align:center">
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
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ITEMNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REGINUM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REGINUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REGINUM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="QTY">
              <xsl:attribute name="class">txtNumberic</xsl:attribute>
              <xsl:attribute name="maxlength">10</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="QTY" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(QTY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FROMDEPT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="FROMDEPT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FROMDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TODEPT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="TODEPT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TODEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REASON">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REASON" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REASON))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PRICE">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="PRICE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRICE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
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
