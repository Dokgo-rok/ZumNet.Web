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
          .m {width:1250px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:10%} .m .ft .f-lbl1 {width:6%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}   .m .ft .f-option2 {width:30%}
          .m .ft-sub .f-option {width:49%}

          /* 폰트 작게 */
          .si-tbl td,.m .fm-lines .si-list td,.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div {font-size:12px}
          .m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div {font-size:12px}
          .m .fm span,.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:12px}

          .m .ft td,.m .ft-sub td {height:21px;padding-top:1px;padding-left:1px;padding-right:1px;padding-bottom:1px}
          .m .ft input, .m .ft-sub input {height:18px}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:450px}}
        </style>
      </head>
      <body>
        <div class="m">
          <div class="ff" />
          
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
                <td class="fh-r" style="width:482px">
                  <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="font-size:47px">&nbsp;</td>
                      <td style="width:245px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '신청부서')"/>
                      </td>
                      <td style="font-size:20px">&nbsp;</td>
                      <td style="width:170px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '2', '주관부서')"/>
                      </td>
                    </tr>
                  </table>
                </td>
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
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:38%;vertical-align:top">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="height:140px">
                    <colgroup>
                      <col width="15%" />
                      <col width="10%" />
                      <col width="25%" />
                      <col width="15%" />
                      <col width="35%" />
                    </colgroup>
                    <tr>
                      <td class="f-lbl2">문서번호</td>
                      <td colspan="2">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                      </td>
                      <td class="f-lbl2">작성자</td>
                      <td style="border-right:0">
                        <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />-->
                        <xsl:value-of select="//creatorinfo/name" />
                      </td>
                    </tr>                   
                    <tr>
                      <td class="f-lbl2" rowspan="3">
                        출장자
                        <xsl:if test="$mode='new' or $mode='edit'">
                          <!--<button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                            <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                          </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="Contacts" onclick="_zw.fn.org('user','n');">
						        <i class="fas fa-angle-down"></i>
					        </button>
                        </xsl:if>
                      </td>
                      <td class="f-lbl2">부서</td>
                      <td colspan="3" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" id="__mainfield" name="TRIPPERSONDEPT" class="txtRead" readonly="readonly" value="{//creatorinfo/department}"/>
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPPERSONDEPT" class="txtRead" readonly="readonly" value="{//forminfo/maintable/TRIPPERSONDEPT}"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSONDEPT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2">직위</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" id="__mainfield" name="TRIPPERSONGRADE" class="txtRead" readonly="readonly" value="{//creatorinfo/grade}"/>
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPPERSONGRADE" class="txtRead" readonly="readonly" value="{//forminfo/maintable/TRIPPERSONGRADE}"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSONGRADE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2">성명</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" id="__mainfield" name="TRIPPERSON" class="txtRead" readonly="readonly" value="{//creatorinfo/name}"/>
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPPERSON" class="txtRead" readonly="readonly" value="{//forminfo/maintable/TRIPPERSON}"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSON))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2">출장지</td>
                      <td colspan="4" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="LOCATION" style="width:94%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/LOCATION}" />
                            <!--<button onclick="parent.fnView('external.centercode2',300,180,80,140,'etc','LOCATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="출장지" onclick="_zw.formEx.optionWnd('external.centercode2',300,180,80,140,'etc','LOCATION');">
							<i class="fas fa-angle-down"></i>
						</button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOCATION))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" style="">출장기간</td>
                      <td colspan="4" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPFROM" style="width:80px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TRIPFROM}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPFROM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;~&nbsp;
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TRIPTO" style="width:80px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TRIPTO}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPTO))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;(
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STAY" class="txtNumberic" readonly="readonly" style="width:25px" maxlength="3" data-inputmask="number;3;0" value="{//forminfo/maintable/STAY}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STAY))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;박&nbsp;
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DAY" class="txtNumberic" readonly="readonly" style="width:25px" maxlength="3" data-inputmask="number;3;0" value="{//forminfo/maintable/DAY}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DAY))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;일&nbsp;)
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" style="">일본출장</td>
                      <td colspan="4" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="JPTRIPFROM" style="width:80px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/JPTRIPFROM}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/JPTRIPFROM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;~&nbsp;
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="JPTRIPTO" style="width:80px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/JPTRIPTO}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/JPTRIPTO))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;(
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="JPSTAY" class="txtNumberic"  readonly="readonly" style="width:25px" maxlength="3" data-inputmask="number;3;0" value="{//forminfo/maintable/JPSTAY}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/JPSTAY))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;박&nbsp;
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="JPDAY" class="txtNumberic"  readonly="readonly" style="width:25px" maxlength="3" data-inputmask="number;3;0" value="{//forminfo/maintable/JPDAY}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/JPDAY))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        &nbsp;일&nbsp;)
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" style="border-bottom:0">일비여부<!--<img  title="일비있음: 주재국외출장&#13;일비없음: 박람회, 주재국내 출장, 본국출장" alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/help.gif" />-->
                      </td>
                      <td colspan="4" style="border-bottom:0;border-right:0">
                        <span class="f-option2">
                          <input type="checkbox" id="ckb31" name="ckbPAYCHECK" class="mt-0" value="일비있음">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">_zw.form.checkYN('ckbPAYCHECK', this, 'PAYCHECK')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PAYCHECK),'일비있음')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PAYCHECK),'일비있음')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb31">일비있음</label>
                        </span>
                        <span class="f-option2">
                          <input type="checkbox" id="ckb31" name="ckbPAYCHECK" class="mt-0" value="일비50">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">_zw.form.checkYN('ckbPAYCHECK', this, 'PAYCHECK')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PAYCHECK),'일비50')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PAYCHECK),'일비50')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb31">일비 50%</label>
                        </span>
                        <span class="f-option2">
                          <input type="checkbox" id="ckb32" name="ckbPAYCHECK" class="mt-0" value="일비없음">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">_zw.form.checkYN('ckbPAYCHECK', this, 'PAYCHECK')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/PAYCHECK),'일비없음')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/PAYCHECK),'일비없음')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb32">일비없음</label>
                        </span>
                                                  
                      </td>
                    </tr>
                  </table>
                </td>
                <td style="width:6%"></td>
                <td style="width:56%">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
                    <colgroup>
                      <col width="9%" />
                      <col width="6%" />
                      <col width="7%" />
                      <col width="6%" />
                      <col width="7%" />
                      <col width="6%" />
                      <col width="7%" />
                      <col width="6%" />
                      <col width="7%" />
                      <col width="6%" />
                      <col width="7%" />
                      <col width="6%" />
                      <col width="7%" />
                      <col width="6%" />
                      <col width="7%" />
                    </colgroup>
                    <tr>
                      <td class="f-lbl2" rowspan="3">정산금액</td>
                      <td class="f-lbl2" colspan="3">회사법인카드(\)</td>
                      <td colspan="4" style="padding-right:6px">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTCARDCORP1" style="color:blue;font-weight:bold" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTCARDCORP1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTCARDCORP1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="3">개인형법인카드(\)</td>
                      <td colspan="4" style="border-right:0;padding-right:6px">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTCARDCORP2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTCARDCORP2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTCARDCORP2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" colspan="3">개인경비합계(\)</td>
                      <td colspan="4" style="padding-right:6px">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTSUM" style="color:red;font-weight:bold" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTSUM}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTSUM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="3">개인소지카드(\)</td>
                      <td colspan="4" style="padding-right:6px;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTCARDPERSON" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTCARDPERSON}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTCARDPERSON))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" colspan="3">경비합계(\)</td>
                      <td colspan="4" style="padding-right:6px">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTCOST" style="font-weight:bold" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="3">개인현금(\)</td>
                      <td colspan="4" style="border-right:0;padding-right:6px">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTCASH" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/TOTCASH}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTCASH))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" rowspan="2">기준환율</td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY2" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">USD</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY2" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY3" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">JPY</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY3" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY4" class="txtRead_Center" readonly="readonly" >
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">CNY</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY4" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY5" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">HKD</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY5" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY6" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">IDR</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY6" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY7" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">EUR</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY7" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDCURRENCY8" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">VND</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/STDCURRENCY8" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDCURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE2" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE3" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE4" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE5" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE6" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE7" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STDEXCHANGE8" class="txtRead_Center" readonly="readonly" value="{//forminfo/maintable/STDEXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDEXCHANGE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" rowspan="2" style="border-bottom:0">적용환율</td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY2" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">USD</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY2" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY3" class="txtRead_Center" readonly="readonly">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">JPY</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY3" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY4" class="txtText_u" readonly="readonly" style="width:76%;text-align:center">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">CNY</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY4" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                            <!--<button onclick="parent.fnOption('iso.currency',160,140,60,115,'etc','CURRENCY4');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,274,-100,0,'etc','CURRENCY4');">
		                        <i class="fas fa-angle-down"></i>
	                        </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY5" class="txtText_u" readonly="readonly" style="width:76%;text-align:center">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">HKD</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY5" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                            <!--<button onclick="parent.fnOption('iso.currency',160,140,60,115,'etc','CURRENCY5');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,274,-100,0,'etc','CURRENCY5');">
		                        <i class="fas fa-angle-down"></i>
	                        </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY6" class="txtText_u" readonly="readonly" style="width:76%;text-align:center">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">IDR</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY6" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                            <!--<button onclick="parent.fnOption('iso.currency',160,140,20,115,'etc','CURRENCY6');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,274,-100,0,'etc','CURRENCY6');">
		                        <i class="fas fa-angle-down"></i>
	                        </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY7" class="txtText_u" readonly="readonly" style="width:76%;text-align:center">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">EUR</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY7" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                            <!--<button onclick="parent.fnOption('iso.currency',160,140,20,115,'etc','CURRENCY7');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,274,-100,0,'etc','CURRENCY7');">
		                        <i class="fas fa-angle-down"></i>
	                        </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl2" colspan="2" style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CURRENCY8" class="txtText_u" readonly="readonly" style="width:76%;text-align:center">
                              <xsl:attribute name="value">
                                <xsl:choose>
                                  <xsl:when test="$mode='new'">VND</xsl:when>
                                  <xsl:otherwise>
                                    <xsl:value-of select="//forminfo/maintable/CURRENCY8" />
                                  </xsl:otherwise>
                                </xsl:choose>
                              </xsl:attribute>
                            </input>
                            <!--<button onclick="parent.fnOption('iso.currency',160,140,20,115,'etc','CURRENCY8');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,274,-30,0,'etc','CURRENCY8');">
		                        <i class="fas fa-angle-down"></i>
	                        </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td style="border-bottom:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE5" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE6" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE7" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0" colspan="2">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EXCHANGE8" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/EXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE8))" />
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
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>1. 숙박비</span>
                    </td>
                    <td class="fm-button">
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
                      <span>1. 숙박비</span>
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
                      <col style="width:2%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:12%"></col>
                      <col style="width:12%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">숙박일</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">숙박지</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">호텔명</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="KRW" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="{//forminfo/maintable/CURRENCY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="USD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="{//forminfo/maintable/CURRENCY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="JPY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="{//forminfo/maintable/CURRENCY3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="CNY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="{//forminfo/maintable/CURRENCY4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="HKD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="{//forminfo/maintable/CURRENCY5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="IDR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="{//forminfo/maintable/CURRENCY6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="EUR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="{//forminfo/maintable/CURRENCY7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="VND" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="{//forminfo/maintable/CURRENCY8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:18px">
                      <td class="f-lbl-sub">시작</td>
                      <td class="f-lbl-sub">종료</td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="1" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="{//forminfo/maintable/EXCHANGE1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_2" readonly="readonly" value="{//forminfo/maintable/EXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_3" readonly="readonly" value="{//forminfo/maintable/EXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_4" readonly="readonly" value="{//forminfo/maintable/EXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_5" readonly="readonly" value="{//forminfo/maintable/EXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_6" readonly="readonly" value="{//forminfo/maintable/EXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_7" readonly="readonly" value="{//forminfo/maintable/EXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_8" readonly="readonly" value="{//forminfo/maintable/EXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" colspan="6">합 계(\)</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM5" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM6" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM7" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ASUM8" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ASUM8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ASUM8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ATOTAL" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ATOTAL}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ATOTAL))" />
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>2. 교통비</span>
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
                      <span>2. 교통비</span>
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
                      <col style="width:2%"></col>
                      <col style="width:6%"></col>
                      <col style="width:13%"></col>
                      <col style="width:17%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">지출일</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">교통수단</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구간</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="KRW" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="{//forminfo/maintable/CURRENCY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="USD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="{//forminfo/maintable/CURRENCY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="JPY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="{//forminfo/maintable/CURRENCY3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="CNY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="{//forminfo/maintable/CURRENCY4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="HKD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="{//forminfo/maintable/CURRENCY5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="IDR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="{//forminfo/maintable/CURRENCY6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="EUR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="{//forminfo/maintable/CURRENCY7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="VND" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="{//forminfo/maintable/CURRENCY8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:18px">
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="1" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="{//forminfo/maintable/EXCHANGE1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_2" readonly="readonly" value="{//forminfo/maintable/EXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_3" readonly="readonly" value="{//forminfo/maintable/EXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_4" readonly="readonly" value="{//forminfo/maintable/EXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_5" readonly="readonly" value="{//forminfo/maintable/EXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_6" readonly="readonly" value="{//forminfo/maintable/EXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_7" readonly="readonly" value="{//forminfo/maintable/EXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_8" readonly="readonly" value="{//forminfo/maintable/EXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" colspan="5">합 계(\)</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM5" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM6" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM7" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BSUM8" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BSUM8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BSUM8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BTOTAL" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/BTOTAL}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BTOTAL))" />
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>3. 식비 (1식한도 갑지1 $24, 갑지2 $12, 을지 $12, 일본 1,500엔) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(*갑지1: 미국, 유럽 &nbsp;&nbsp;&nbsp;갑지2: 홍콩, 싱가폴, 중국, 베트남 &nbsp;&nbsp;&nbsp;을지: 동남아, 인도네시아)</span>
                    </td>
                    <td class="fm-button">
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
                      <span>3. 식비 (1식한도 갑지1 $24, 갑지2 $12, 을지 $10, 일본 1,500엔) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(*갑지1: 미국, 유럽 &nbsp;&nbsp;&nbsp;갑지2: 홍콩, 싱가폴, 중국, 베트남 &nbsp;&nbsp;&nbsp;을지: 동남아, 인도네시아)</span>
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
                  <table id="__subtable3" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:2%"></col>
                      <col style="width:8%"></col>
                      <col style="width:11%"></col>
                      <col style="width:5%"></col>
                      <col style="width:3%"></col>
                      <col style="width:9%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">지출일</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">지출장소</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">식비<br />구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">본사<br />인원</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">내역</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="KRW" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="{//forminfo/maintable/CURRENCY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="USD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="{//forminfo/maintable/CURRENCY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="JPY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="{//forminfo/maintable/CURRENCY3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="CNY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="{//forminfo/maintable/CURRENCY4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="HKD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="{//forminfo/maintable/CURRENCY5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="IDR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="{//forminfo/maintable/CURRENCY6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="EUR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="{//forminfo/maintable/CURRENCY7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="VND" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="{//forminfo/maintable/CURRENCY8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:18px">
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="1" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="{//forminfo/maintable/EXCHANGE1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_2" readonly="readonly" value="{//forminfo/maintable/EXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_3" readonly="readonly" value="{//forminfo/maintable/EXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_4" readonly="readonly" value="{//forminfo/maintable/EXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_5" readonly="readonly" value="{//forminfo/maintable/EXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_6" readonly="readonly" value="{//forminfo/maintable/EXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_7" readonly="readonly" value="{//forminfo/maintable/EXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_8" readonly="readonly" value="{//forminfo/maintable/EXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" colspan="7">합 계(\)</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM5" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM6" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM7" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CSUM8" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CSUM8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CSUM8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CTOTAL" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/CTOTAL}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTOTAL))" />
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>4. 접대비</span>
                    </td>
                    <td class="fm-button">
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
                      <span>4. 접대비</span>
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
                  <table id="__subtable4" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:2%"></col>
                      <col style="width:6%"></col>
                      <col style="width:13%"></col>
                      <col style="width:17%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">지출일</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">지출장소</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">내역</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="KRW" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="{//forminfo/maintable/CURRENCY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="USD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="{//forminfo/maintable/CURRENCY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="JPY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="{//forminfo/maintable/CURRENCY3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="CNY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="{//forminfo/maintable/CURRENCY4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="HKD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="{//forminfo/maintable/CURRENCY5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="IDR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="{//forminfo/maintable/CURRENCY6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="EUR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="{//forminfo/maintable/CURRENCY7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="VND" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="{//forminfo/maintable/CURRENCY8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:18px">
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="1" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="{//forminfo/maintable/EXCHANGE1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_2" readonly="readonly" value="{//forminfo/maintable/EXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_3" readonly="readonly" value="{//forminfo/maintable/EXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_4" readonly="readonly" value="{//forminfo/maintable/EXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_5" readonly="readonly" value="{//forminfo/maintable/EXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_6" readonly="readonly" value="{//forminfo/maintable/EXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_7" readonly="readonly" value="{//forminfo/maintable/EXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_8" readonly="readonly" value="{//forminfo/maintable/EXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable4/row"/>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" colspan="5">합 계(\)</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM5" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM6" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM7" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DSUM8" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DSUM8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DSUM8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DTOTAL" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/DTOTAL}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DTOTAL))" />
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td style="white-space:nowrap">
                      <span style="width:5%">5. 기타</span>
                      <span style="width:95%;padding-left:10px"><input type="hidden" id="__mainfield" name="DAILYPAY" class="txtText_u" readonly="readonly" style="width:60px" value="{//forminfo/maintable/DAILYPAY}" /></span>
                    </td>
                    <td class="fm-button">
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
                    <td style="white-space:nowrap">
                      <span style="width:5%">5. 기타</span>
                      <span style="width:95%;padding-left:10px"></span>
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
                  <table id="__subtable5" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:2%"></col>
                      <col style="width:6%"></col>
                      <col style="width:13%"></col>
                      <col style="width:17%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:6%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">지출일</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">지출장소</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">내역</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="KRW" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_1" readonly="readonly" value="{//forminfo/maintable/CURRENCY1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="USD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_2" readonly="readonly" value="{//forminfo/maintable/CURRENCY2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="JPY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_3" readonly="readonly" value="{//forminfo/maintable/CURRENCY3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="CNY" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_4" readonly="readonly" value="{//forminfo/maintable/CURRENCY4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="HKD" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_5" readonly="readonly" value="{//forminfo/maintable/CURRENCY5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="IDR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_6" readonly="readonly" value="{//forminfo/maintable/CURRENCY6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="EUR" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_7" readonly="readonly" value="{//forminfo/maintable/CURRENCY7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="VND" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="CURRENCY_8" readonly="readonly" value="{//forminfo/maintable/CURRENCY8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:18px">
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="1" />
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_1" readonly="readonly" value="{//forminfo/maintable/EXCHANGE1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_2" readonly="readonly" value="{//forminfo/maintable/EXCHANGE2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_3" readonly="readonly" value="{//forminfo/maintable/EXCHANGE3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_4" readonly="readonly" value="{//forminfo/maintable/EXCHANGE4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_5" readonly="readonly" value="{//forminfo/maintable/EXCHANGE5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_6" readonly="readonly" value="{//forminfo/maintable/EXCHANGE6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_7" readonly="readonly" value="{//forminfo/maintable/EXCHANGE7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" class="txtRead_Center" name="EXCHANGE_8" readonly="readonly" value="{//forminfo/maintable/EXCHANGE8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGE8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable5/row"/>
                    <tr style="height:18px">
                      <td class="f-lbl-sub" colspan="5">합 계(\)</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM5" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM5}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM5))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM6" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM6}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM6))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM7" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM7}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM7))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ESUM8" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ESUM8}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ESUM8))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ETOTAL" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/ETOTAL}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ETOTAL))" />
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

        <!-- 양식숨은필드 -->
        <input type="hidden" id="__mainfield" name="PAYCHECK" value="{//forminfo/maintable/PAYCHECK}" />

        <!-- 필수 양식정보 -->
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="STDCURRENCY1" value="KRW" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="STDCURRENCY1" value="{//forminfo/maintable/STDCURRENCY1}" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="STDEXCHANGE1" value="1" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="STDEXCHANGE1" value="{//forminfo/maintable/STDEXCHANGE1}" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="CURRENCY1" value="KRW" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="CURRENCY1" value="{//forminfo/maintable/CURRENCY1}" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="EXCHANGE1" value="1" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="EXCHANGE1" value="{//forminfo/maintable/EXCHANGE1}" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="TRIPPERSONDEPTID" value="{//creatorinfo/@deptid}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="TRIPPERSONDEPTID" value="{//forminfo/maintable/TRIPPERSONDEPTID}" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="TRIPPERSONID" value="{//creatorinfo/@uid}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="TRIPPERSONID" value="{//forminfo/maintable/TRIPPERSONID}" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$mode='new'">
            <input type="hidden" id="__mainfield"  name="TRIPPERSONEMPID" value="{//creatorinfo/empno}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield"  name="TRIPPERSONEMPID" value="{//forminfo/maintable/TRIPPERSONEMPID}" />
          </xsl:otherwise>
        </xsl:choose>
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FROMDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{FROMDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FROMDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TODATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{TODATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TODATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="LOCATION" class="txtText" maxlength="100" value="{LOCATION}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(LOCATION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="HOTEL" class="txtText" maxlength="100" value="{HOTEL}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(HOTEL))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='expensetype'], 'EXPENSETYPECODE', string(EXPENSETYPECODE), 'EXPENSETYPE', string(EXPENSETYPE))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSETYPE))" />
            <input type="hidden" name="EXPENSETYPECODE" value="{EXPENSETYPECODE}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="string(EXPENSETYPECODE)=''">
                <input type="text" name="AEXPENSE1" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:when>
              <xsl:otherwise>                
                <input type="text" name="AEXPENSE1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE1}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE2}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE2" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE3}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE3" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE4}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE4" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE5" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE5}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE5" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE6" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE6}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE6" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE7" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE7}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE7" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="AEXPENSE8" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{AEXPENSE8}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="AEXPENSE8" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AEXPENSE8))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{EXPENSEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPENSEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <!--<xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VEHICLES" class="txtText" maxlength="100" value="{VEHICLES}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(VEHICLES))" />
          </xsl:otherwise>
        </xsl:choose>-->
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VEHICLES" style="width:85%" class="txtText_u" readonly="readonly" value="{VEHICLES}" />
            <!--<button onclick="parent.fnOption('external.vehicle',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
		    <button type="button" class="btn btn-outline-secondary btn-18" title="교통수단" onclick="_zw.formEx.optionWnd('external.vehicle',160,184,-136,0,'etc','VEHICLES');">
		        <i class="fas fa-angle-down"></i>
	        </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(VEHICLES))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SECTION" class="txtText" maxlength="100" value="{SECTION}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SECTION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='expensetype'], 'EXPENSETYPECODE', string(EXPENSETYPECODE), 'EXPENSETYPE', string(EXPENSETYPE))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSETYPE))" />
            <input type="hidden" name="EXPENSETYPECODE" value="{EXPENSETYPECODE}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="string(EXPENSETYPECODE)=''">
                <input type="text" name="BEXPENSE1" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE1}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE2}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE2" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE3}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE3" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE4}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE4" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE5" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE5}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE5" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE6" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE6}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE6" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE7" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE7}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE7" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="BEXPENSE8" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{BEXPENSE8}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="BEXPENSE8" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BEXPENSE8))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{EXPENSEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPENSEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="LOCATION" class="txtText" maxlength="100" value="{LOCATION}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(LOCATION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='foodpay'], 'EXPENSERULE', string(EXPENSERULE))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSERULE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT" class="txtNo" maxlength="3" style="width:20px" value="{COUNT}" />명
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT))" />
            <xsl:if test="COUNT!=''">명</xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <!--<xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMMENT" class="txtText" maxlength="100" value="{COMMENT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMMENT))" />
          </xsl:otherwise>
        </xsl:choose>-->
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMMENT" style="width:80%" class="txtText_u" readonly="readonly" value="{COMMENT}" />
            <!--<button onclick="parent.fnOption('external.comment',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
		    <button type="button" class="btn btn-outline-secondary btn-18" title="교통수단" onclick="_zw.formEx.optionWnd('external.comment',130,124,-105,0,'etc','COMMENT');">
		        <i class="fas fa-angle-down"></i>
	        </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMMENT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='expensetype'], 'EXPENSETYPECODE', string(EXPENSETYPECODE), 'EXPENSETYPE', string(EXPENSETYPE))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSETYPE))" />
            <input type="hidden" name="EXPENSETYPECODE" value="{EXPENSETYPECODE}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="string(EXPENSETYPECODE)=''">
                <input type="text" name="CEXPENSE1" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE1}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE2}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE2" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE3}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE3" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE4}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE4" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE5" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE5}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE5" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE6" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE6}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE6" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE7" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE7}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE7" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="CEXPENSE8" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{CEXPENSE8}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="CEXPENSE8" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CEXPENSE8))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{EXPENSEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPENSEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="LOCATION" class="txtText" maxlength="100" value="{LOCATION}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(LOCATION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMMENT" class="txtText" maxlength="100" value="{COMMENT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMMENT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='expensetype'], 'EXPENSETYPECODE', string(EXPENSETYPECODE), 'EXPENSETYPE', string(EXPENSETYPE))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSETYPE))" />
            <input type="hidden" name="EXPENSETYPECODE" value="{EXPENSETYPECODE}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="string(EXPENSETYPECODE)=''">
                <input type="text" name="DEXPENSE1" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE1}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE2}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE2" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE3}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE3" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE4}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE4" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE5" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE5}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE5" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE6" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE6}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE6" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE7" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE7}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE7" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="EXPENSETYPECODE[.='CASH']">
                <input type="text" name="DEXPENSE8" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEXPENSE8}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="DEXPENSE8" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEXPENSE8))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
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
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="ROWSEQ" value="{ROWSEQ}" readonly="readonly" style="text-align:center;border:0;width:100%" />
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EXPENSEDATE" class="txtRead" readonly="readonly" value="{EXPENSEDATE}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="EXPENSEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{EXPENSEDATE}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EXPENSEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="LOCATION" class="txtRead" readonly="readonly" value="{LOCATION}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="LOCATION" class="txtText" maxlength="100" value="{LOCATION}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(LOCATION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="COMMENT" class="txtRead" readonly="readonly" value="{COMMENT}" />
              </xsl:when>
              <xsl:otherwise>
                <input type="text" name="COMMENT" class="txtText" maxlength="100" value="{COMMENT}" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMMENT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='expensetype'], 'EXPENSETYPECODE', string(EXPENSETYPECODE), 'EXPENSETYPE', string(EXPENSETYPE))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSETYPE))" />
            <input type="hidden" name="EXPENSETYPECODE" value="{EXPENSETYPECODE}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE1" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE1}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="string(EXPENSETYPECODE)=''">
                    <input type="text" name="EEXPENSE1" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE1" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE1}" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE2" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE2}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE2" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE2}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE2" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE3" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE3}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE3" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE3}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE3" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE4" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE4}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE4" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE4}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE4" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE5" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE5}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE5" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE5}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE5" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE5))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE6" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE6}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE6" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE6}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE6" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE6))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE7" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE7}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE7" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE7}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE7" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE7))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:choose>
              <xsl:when test="position()=1">
                <input type="text" name="EEXPENSE8" class="txtRead_Right" readonly="readonly" data-inputmask="number;16;4" value="{EEXPENSE8}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="EXPENSETYPECODE[.='CASH']">
                    <input type="text" name="EEXPENSE8" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EEXPENSE8}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <input type="text" name="EEXPENSE8" class="txtRead_Right" maxlength="20" data-inputmask="number;16;4" readonly="readonly" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EEXPENSE8))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
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
