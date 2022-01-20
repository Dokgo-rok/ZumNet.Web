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
          .m {width:780px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:75px} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px} .m .ft .f-option3 {width:60px}
          .m .ft-sub .f-option {width:}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:600px}}
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
                <td style="width:236px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '요청부서')"/>
                </td>
                <td style="font-size:8px">&nbsp;</td>
                <td style="width:92px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='application' and @partid!='' and @step!='0'], '__si_Application', '1', '접수부서')"/>
                </td>
                <td style="font-size:8px">&nbsp;</td>
                <td style="width:164px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='gwichaek' and @actrole!='__r' and @partid!='' and @step!='0'], '__si_Form', '2', '귀책부서')"/>
                </td>
                <td style="font-size:8px">&nbsp;</td>
                <td style="width:164px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '2', '검토부서')"/>
                </td>
                <td style="font-size:8px">&nbsp;</td>
                <td style="width:92px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '최종승인')"/>
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
                <td style="width:38%">
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">제목</td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">고객명</td>
                <td style="width:38%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER" class="txtText"  style="width:92%"  value="{//forminfo/maintable/CUSTOMER}" />
                      <button onclick="parent.fnExternal('erp.customers',240,40,100,70,'','CUSTOMER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">발생일자</td>
                <td style="width:38%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPLAINDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/COMPLAINDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COMPLAINDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">품명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtRead" readonly="readonly" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">모델명</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" style="width:93%" c3ass="txtText"  value="{//forminfo/maintable/MODELNAME}" />
                      <button onclick="parent.fnExternal('erp.items',240,40,80,70,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <input type="hidden" id="__mainfield" name="BUYERID">
            <xsl:attribute name="value">
              <xsl:value-of select="//forminfo/maintable/BUYERID" />
            </xsl:attribute>
          </input>
          <input type="hidden" id="__mainfield" name="BUYERSITEID">
            <xsl:attribute name="value">
              <xsl:value-of select="//forminfo/maintable/BUYERSITEID" />
            </xsl:attribute>
          </input>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col width="12%" />
                <col width="13%" />
                <col width="12%" />
                <col width="13%" />
                <col width="12%" />
                <col width="13%" />
                <col width="12%" />
                <col width="13%" />
              </colgroup>
              <tr>
                <td class="f-lbl">출하공장</td>
                <td style="border-right:0" colspan="7">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="OUTFACTORY" style="width:120px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/OUTFACTORY}">
                        <button onclick="parent.fnOption('external.chartcentercode',200,140,100,120,'','OUTFACTORY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                        </button>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OUTFACTORY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">발생중요도</td>
                <td colspan="3">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb11" name="ckbBADPRIORITY" value="A">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADPRIORITY', this, 'BADPRIORITY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADPRIORITY),'A')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADPRIORITY),'A')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">A</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb12" name="ckbBADPRIORITY" value="B">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADPRIORITY', this, 'BADPRIORITY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADPRIORITY),'B')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADPRIORITY),'B')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">B</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb13" name="ckbBADPRIORITY" value="C">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADPRIORITY', this, 'BADPRIORITY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADPRIORITY),'C')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADPRIORITY),'C')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">C</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb14" name="ckbBADPRIORITY" value="기타">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADPRIORITY', this, 'BADPRIORITY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADPRIORITY),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADPRIORITY),'기타')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb14">기타</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="BADPRIORITY" value="{//forminfo/maintable/BADPRIORITY}" />
                </td>
                <td class="f-lbl">불만분류</td>
                <td style="border-right:0" colspan="3">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb21" name="ckbBADKIND" value="초회">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADKIND', this, 'BADKIND')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADKIND),'초회')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADKIND),'초회')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">초회</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb22" name="ckbBADKIND" value="재발">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADKIND', this, 'BADKIND')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADKIND),'재발')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADKIND),'재발')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">재발</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb23" name="ckbBADKIND" value="연속">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADKIND', this, 'BADKIND')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADKIND),'연속')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADKIND),'연속')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">연속</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb24" name="ckbBADKIND" value="기타">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADKIND', this, 'BADKIND')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADKIND),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/BADKIND),'기타')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">기타</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="BADKIND" value="{//forminfo/maintable/BADKIND}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl">입고수량</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOTCOUNT" class="txtNumberic" maxlength="10" value="{//forminfo/maintable/LOTCOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/LOTCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">검사수량</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CHECKCOUNT" class="txtVolume" maxlength="10" value="{//forminfo/maintable/CHECKCOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECKCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">불량수량</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BADCOUNT" class="txtVolume" maxlength="10" value="{//forminfo/maintable/BADCOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BADCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">불량율</td>
                <td style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BADRATE" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BADRATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BADRATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">출하일자</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="OUTDATE" class="txtNumberic" maxlength="10" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/OUTDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OUTDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">LOT번호</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOTNUM" class="txtText" maxlength="10" value="{//forminfo/maintable/LOTNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/LOTNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">반품수량</td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RECALLCOUNT" class="txtNumberic" maxlength="10" value="{//forminfo/maintable/RECALLCOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECALLCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">회신요청일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REPLYDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/REPLYDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REPLYDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">발생장소</td>
                <td colspan="3" style="border-bottom:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbOCCURRENCE" value="수입검사">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbOCCURRENCE', this, 'OCCURRENCE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/OCCURRENCE),'수입검사')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/OCCURRENCE),'수입검사')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">수입검사</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb32" name="ckbOCCURRENCE" value="공정">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbOCCURRENCE', this, 'OCCURRENCE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/OCCURRENCE),'공정')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/OCCURRENCE),'공정')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">공정</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb33" name="ckbOCCURRENCE" value="출하검사">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbOCCURRENCE', this, 'OCCURRENCE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/OCCURRENCE),'출하검사')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/OCCURRENCE),'출하검사')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb33">출하검사</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb34" name="ckbOCCURRENCE" value="시장">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbOCCURRENCE', this, 'OCCURRENCE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/OCCURRENCE),'시장')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/OCCURRENCE),'시장')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb34">시장</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="OCCURRENCE" value="{//forminfo/maintable/OCCURRENCE}" />
                </td>
                <td class="f-lbl" style="border-bottom:0">처리내역</td>
                <td colspan="3" style="border-right:0;border-bottom:0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb41" name="ckbHISTORY" value="반품">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbHISTORY', this, 'HISTORY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/HISTORY),'반품')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/HISTORY),'반품')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">반품</label>
                  </span>
                  <span class="f-option3">
                    <input type="checkbox" id="ckb42" name="ckbHISTORY" value="대용품">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbHISTORY', this, 'HISTORY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/HISTORY),'대용품')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/HISTORY),'대용품')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb42">대용품</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb43" name="ckbHISTORY" value="선별">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbHISTORY', this, 'HISTORY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/HISTORY),'선별')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/HISTORY),'선별')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb43">선별</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb44" name="ckbHISTORY" value="수리">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbHISTORY', this, 'HISTORY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/HISTORY),'수리')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/HISTORY),'수리')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb44">수리</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb45" name="ckbHISTORY" value="기타">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbHISTORY', this, 'HISTORY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/HISTORY),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/HISTORY),'기타')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb45">기타</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="HISTORY" value="{//forminfo/maintable/HISTORY}" />
                </td>
              </tr>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col width="12%" />
                <col width="13%" />
                <col width="12%" />
                <col width="13%" />
                <col width="12%" />
                <col width="13%" />
                <col width="12%" />
                <col width="13%" />
              </colgroup>              
              <tr>
                <td class="f-lbl">귀책공장</td>
                <td colspan="7" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="FAULTFACTORY" style="width:120px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/FAULTFACTORY}">
                        <button onclick="parent.fnOption('external.centercodethree',200,140,100,120,'','FAULTFACTORY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                        </button>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FAULTFACTORY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">불량샘플</td>
                <td>
                  <span class="f-option1" style="width:49%">
                    <input type="checkbox" id="ckb51" name="ckbBADSAMPLE" value="유">
                      <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADSAMPLE', this, 'BADSAMPLE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADSAMPLE),'유')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not(($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and phxsl:isDiff(string(//forminfo/maintable/BADSAMPLE),'유')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb51">유</label>
                  </span>
                  <span class="f-option1" style="width:49%">
                    <input type="checkbox" id="ckb52" name="ckbBADSAMPLE" value="무">
                      <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbBADSAMPLE', this, 'BADSAMPLE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/BADSAMPLE),'무')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not(($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and phxsl:isDiff(string(//forminfo/maintable/BADSAMPLE),'무')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb52">무</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="BADSAMPLE" value="{//forminfo/maintable/BADSAMPLE}" />
                </td>
                <td class="f-lbl" style="font-size:12px">불량샘플접수일</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="RECEIVEDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/RECEIVEDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RECEIVEDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">손실발생</td>
                <td>
                  <span class="f-option1" style="width:49%">
                    <input type="checkbox" id="ckb61" name="ckbLOSSYN" value="유">
                      <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbLOSSYN', this, 'LOSSYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LOSSYN),'유')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not(($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and phxsl:isDiff(string(//forminfo/maintable/LOSSYN),'유')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb61">유</label>
                  </span>
                  <span class="f-option1" style="width:49%">
                    <input type="checkbox" id="ckb62" name="ckbLOSSYN" value="무">
                      <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbLOSSYN', this, 'LOSSYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LOSSYN),'무')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not(($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and phxsl:isDiff(string(//forminfo/maintable/LOSSYN),'무')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb62">무</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="LOSSYN" value="{//forminfo/maintable/LOSSYN}" />
                </td>
                <td class="f-lbl">손실금액</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="LOSSAMOUNT" class="txtText" maxlength="20" value="{//forminfo/maintable/LOSSAMOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/LOSSAMOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">효과성검증일</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="CHECKDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/CHECKDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECKDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="font-size:12px">효과성확인수량</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="CHECKCOUNT2" class="txtNumberic" maxlength="10" value="{//forminfo/maintable/CHECKCOUNT2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECKCOUNT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="font-size:12px">효과성확인결과</td>
                <td style="border-right:0;" colspan="3">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="ETC" class="txtText" maxlength="100" value="{//forminfo/maintable/ETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;font-size:12px">고객대응완료일</td>
                <td colspan="3" style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="RESPONSEDATE" class="txtDate" style="width:96px" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/RESPONSEDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RESPONSEDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">비고</td>
                <td colspan="3"  style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <input type="text" id="__mainfield" name="BADCOUNT2" class="txtText" maxlength="20" value="{//forminfo/maintable/BADCOUNT2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BADCOUNT2))" />
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
            <span style="">
              <b> * 불만 세부 사항</b> (<font style="color:#f00;font-family:맑은고딕;font-size:12px">불만세부사항 파일첨부는 이미지 파일만 가능</font>)
            </span>            
          </div>

          <div class="ff"></div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">불만내용</td>
                <td style="width:38%;padding:1px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="BADNOTE" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/BADNOTE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="BADNOTE">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BADNOTE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">발생원인</td>
                <td style="width:38%;padding:1px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <textarea id="__mainfield" name="REASON" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/REASON" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REASON">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus != '700'">
                    <form id="upForm11" name="upForm11" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                      <xsl:if test="//forminfo/maintable/PHOTOLEFTA[.!=''] or $mode='read'">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="file" name="file1" style="width:79%;height:20px;font-size:11px" />
                      <button onclick="return parent.jsFileUpload(380, 'upForm11');" onfocus="this.blur()" class="btn_bg" style="margin-bottom:0px;width:20%">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />이미지첨부
                      </button>
                    </form>
                  </xsl:if>
                  <div style="padding:2px 4px 0 2px;border:0 solid red">
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTOLEFTA[.!='']">
                        <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTA,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTA,';')]"/>
                        <xsl:if test="$mode!='read'">
                          <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                            <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTA,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTA,';')]/@attachid}', '', 'upForm11');" />
                          </span>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div>
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTOLEFTA[.!='']">
                        <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTA,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTA,';')]/@filetype" />
                        <xsl:choose>
                          <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                            <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                            <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                              <xsl:attribute name="alt">
                                <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTA,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTA,';')]/filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTA,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTA,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTA,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTA,';')]/savedname"/></xsl:attribute>
                            </img>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <input type="hidden" id="__mainfield" name="PHOTOLEFTA" value="{//forminfo/maintable/PHOTOLEFTA}" />
                </td>
                <td colspan="2" style="border-right:0;vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus != '700'">
                    <form id="upForm12" name="upForm12" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                      <xsl:if test="//forminfo/maintable/PHOTORIGHTA[.!=''] or ($mode='new' or $mode='edit') or (not (($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and $mode='read')">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="file" name="file1" style="width:79%;height:20px;font-size:11px" />
                      <button onclick="return parent.jsFileUpload(380, 'upForm12');" onfocus="this.blur()" class="btn_bg" style="margin-bottom:0px;width:20%">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />이미지첨부
                      </button>
                    </form>
                  </xsl:if>
                  <div style="padding:2px 4px 0 2px;border:0 solid red">
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTORIGHTA[.!='']">
                        <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTA,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTA,';')]"/>
                        <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                          <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                            <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTA,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTA,';')]/@attachid}', '', 'upForm12');" />
                          </span>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div>
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTORIGHTA[.!='']">
                        <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTA,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTA,';')]/@filetype" />
                        <xsl:choose>
                          <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                            <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                            <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                              <xsl:attribute name="alt">
                                <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTA,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTA,';')]/filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTA,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTA,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTA,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTA,';')]/savedname"/></xsl:attribute>
                            </img>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <input type="hidden" id="__mainfield" name="PHOTORIGHTA" value="{//forminfo/maintable/PHOTORIGHTA}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl">불량현상</td>
                <td style="padding:1px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="BADDESC" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/BADDESC" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="BADDESC">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BADDESC))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">개선대책</td>
                <td style="padding:1px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <textarea id="__mainfield" name="STEPDESC" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/STEPDESC" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STEPDESC">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STEPDESC))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus != '700'">
                    <form id="upForm21" name="upForm21" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                      <xsl:if test="//forminfo/maintable/PHOTOLEFTB[.!=''] or $mode='read'">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="file" name="file1" style="width:79%;height:20px;font-size:11px" />
                      <button onclick="return parent.jsFileUpload(380, 'upForm21');" onfocus="this.blur()" class="btn_bg" style="margin-bottom:0px;width:20%">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />이미지첨부
                      </button>
                    </form>
                  </xsl:if>
                  <div style="padding:2px 4px 0 2px;border:0 solid red">
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTOLEFTB[.!='']">
                        <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTB,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTB,';')]"/>
                        <xsl:if test="$mode!='read'">
                          <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                            <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTB,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTB,';')]/@attachid}', '', 'upForm21');" />
                          </span>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div>
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTOLEFTB[.!='']">
                        <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTB,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTB,';')]/@filetype" />
                        <xsl:choose>
                          <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                            <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                            <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                              <xsl:attribute name="alt">
                                <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTB,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTB,';')]/filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTB,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTB,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTB,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTB,';')]/savedname"/></xsl:attribute>
                            </img>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <input type="hidden" id="__mainfield" name="PHOTOLEFTB" value="{//forminfo/maintable/PHOTOLEFTB}" />
                </td>
                <td colspan="2" style="border-right:0;vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus != '700'">
                    <form id="upForm22" name="upForm22" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                      <xsl:if test="//forminfo/maintable/PHOTORIGHTB[.!=''] or ($mode='new' or $mode='edit') or (not (($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and $mode='read')">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="file" name="file1" style="width:79%;height:20px;font-size:11px" />
                      <button onclick="return parent.jsFileUpload(380, 'upForm22');" onfocus="this.blur()" class="btn_bg" style="margin-bottom:0px;width:20%">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />이미지첨부
                      </button>
                    </form>
                  </xsl:if>
                  <div style="padding:2px 4px 0 2px;border:0 solid red">
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTORIGHTB[.!='']">
                        <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTB,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTB,';')]"/>
                        <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                          <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                            <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTB,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTB,';')]/@attachid}', '', 'upForm22');" />
                          </span>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div>
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTORIGHTB[.!='']">
                        <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTB,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTB,';')]/@filetype" />
                        <xsl:choose>
                          <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                            <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                            <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                              <xsl:attribute name="alt">
                                <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTB,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTB,';')]/filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTB,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTB,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTB,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTB,';')]/savedname"/></xsl:attribute>
                            </img>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <input type="hidden" id="__mainfield" name="PHOTORIGHTB" value="{//forminfo/maintable/PHOTORIGHTB}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl">조치사항</td>
                <td style="padding:1px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="ACTDESC" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/ACTDESC" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="ACTDESC">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACTDESC))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">수평전개</td>
                <td style="padding:1px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <textarea id="__mainfield" name="DEVDESC" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/DEVDESC" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEVDESC">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVDESC))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td colspan="2" style="vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus != '700'">
                    <form id="upForm31" name="upForm31" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                      <xsl:if test="//forminfo/maintable/PHOTOLEFTC[.!=''] or $mode='read'">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="file" name="file1" style="width:79%;height:20px;font-size:11px" />
                      <button onclick="return parent.jsFileUpload(380, 'upForm31');" onfocus="this.blur()" class="btn_bg" style="margin-bottom:0px;width:20%">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />이미지첨부
                      </button>
                    </form>
                  </xsl:if>
                  <div style="padding:2px 4px 0 2px;border:0 solid red">
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTOLEFTC[.!='']">
                        <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTC,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTC,';')]"/>
                        <xsl:if test="$mode!='read'">
                          <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                            <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTC,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTC,';')]/@attachid}', '', 'upForm31');" />
                          </span>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div>
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTOLEFTC[.!='']">
                        <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTC,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTC,';')]/@filetype" />
                        <xsl:choose>
                          <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                            <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                            <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                              <xsl:attribute name="alt">
                                <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTC,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTC,';')]/filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTC,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTC,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOLEFTC,';') and savedname=substring-after(//forminfo/maintable/PHOTOLEFTC,';')]/savedname"/></xsl:attribute>
                            </img>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <input type="hidden" id="__mainfield" name="PHOTOLEFTC" value="{//forminfo/maintable/PHOTORIGHTA}" />
                </td>
                <td colspan="2" style="border-right:0;vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus != '700'">
                    <form id="upForm32" name="upForm32" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                      <xsl:if test="//forminfo/maintable/PHOTORIGHTC[.!=''] or ($mode='new' or $mode='edit') or (not (($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')) and $mode='read')">
                        <xsl:attribute name="style">display:none</xsl:attribute>
                      </xsl:if>
                      <input type="file" name="file1" style="width:79%;height:20px;font-size:11px" />
                      <button onclick="return parent.jsFileUpload(380, 'upForm32');" onfocus="this.blur()" class="btn_bg" style="margin-bottom:0px;width:20%">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />이미지첨부
                      </button>
                    </form>
                  </xsl:if>
                  <div style="padding:2px 4px 0 2px;border:0 solid red">
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTORIGHTC[.!='']">
                        <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTC,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTC,';')]"/>
                        <xsl:if test="($bizrole='application' and $actrole='_approver' and $partid!='')  or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                          <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                            <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTC,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTC,';')]/@attachid}', '', 'upForm32');" />
                          </span>
                        </xsl:if>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <div>
                    <xsl:choose>
                      <xsl:when test="//forminfo/maintable/PHOTORIGHTC[.!='']">
                        <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTC,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTC,';')]/@filetype" />
                        <xsl:choose>
                          <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                            <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                            <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                              <xsl:attribute name="alt">
                                <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTC,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTC,';')]/filename"/>
                              </xsl:attribute>
                              <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTC,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTC,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTORIGHTC,';') and savedname=substring-after(//forminfo/maintable/PHOTORIGHTC,';')]/savedname"/></xsl:attribute>
                            </img>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">display:none;padding:2px;border:0 solid blue</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>
                  <input type="hidden" id="__mainfield" name="PHOTORIGHTC" value="{//forminfo/maintable/PHOTORIGHTC}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">기타사항</td>
                <td colspan="3" style="padding:1px;border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='_approver' and $partid!='') or ($bizrole='gwichaek' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='') or ($bizrole='receive' and ( $actrole='__r' or $actrole='_reviewer' ) and $partid!='')">
                      <textarea id="__mainfield" name="DESCRIPTION" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" style="height:60px">
                        <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DESCRIPTION">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
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
  <xsl:template match="//fileinfo/file[@isfile='N']">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:down2(string(//config/@web), string($root), string(virtualpath), string(savedname), string(filename))" />
      </xsl:attribute>
      <xsl:value-of select="filename" />
    </a>
  </xsl:template>
</xsl:stylesheet>
