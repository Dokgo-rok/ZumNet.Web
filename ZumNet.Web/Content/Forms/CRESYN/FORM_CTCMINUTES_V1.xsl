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
          .m {width:780px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:} .m .ft .f-option2 {width:}
          .m .ft-sub .f-option {width:49%}

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
                    <xsl:value-of select="//maintable/STEP" /><xsl:value-of select="//docinfo/docname" />
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='' and @step!='0'], '__si_Normal', '1', '작성')"/>
                </td>
                <td style="font-size:1px;width:">&nbsp;</td>
                <td style="width:470px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '6', '검토부서')"/>
                </td>
                <td style="width:;font-size:1px;width:">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='' and @step!='0'], '__si_Attr', '1', '승인', '', '', 'biz=normal act=_approver')"/>
                </td>
                <td style="width:;font-size:1px;width:">&nbsp;</td>
                <td style="width:95px">
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
                <td style="border-right:0;border-bottom:0">
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
            <span>1. 신모델 현황</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:49%;vertical-align:top">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="height:144px">
                    <colgroup>
                      <col width="30%" />
                      <col width="70%" />
                    </colgroup>
                    <tr>
                      <td class="f-lbl1">품종</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="ITEMKIND" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/ITEMKIND}" />
                            <button onclick="parent.fnOption('external.itemnamecode',140,190,190,140,'etc','ITEMKIND');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMKIND))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">고객명</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="CUSTOMER" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/CUSTOMER}" />
                            <button onclick="parent.fnOption('external.customecode',140,252,190,160,'etc','CUSTOMER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CUSTOMER))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">모델명</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/MODELNAME}" />
                            <button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,140,64,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">개발등급</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="DEVCLASS" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/DEVCLASS}" />
                            <button onclick="parent.fnOption('external.devclass',60,120,230,100,'etc','DEVCLASS');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCLASS))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">개발단계</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="STEP" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/STEP}" />
                            <button onclick="parent.fnOption('external.devstep',100,142,210,114,'etc','STEP');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STEP))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1" style="border-bottom:0">생산지</td>
                      <td style="border-right:0;border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PRODUCTCENTER" class="txtRead" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/PRODUCTCENTER}" />
                            <button onclick="parent.fnOption('external.centercode',220,230,150,150,'etc','PRODUCTCENTER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODUCTCENTER))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>

                  <div class="ff" />
                  <div class="ff" />

                  <table border="0" cellspacing="0" cellpadding="0" style="height:120px">
                    <tr>
                      <td style="width:46px;background-color:#eeeeee;border:1px solid windowtext;border-right:0">
                        <span style="font-size:13px;text-align:center">담당</span>
                      </td>
                      <td>
                        <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="border-top:0">
                          <colgroup>
                            <col width="20%" />
                            <col width="80%" />
                          </colgroup>
                          <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                        </table>
                      </td>
                    </tr>
                  </table>
                </td>
                <td style="width:1%;font-size:1px">&nbsp;</td>
                <td style="width:50%;vertical-align:top;border:1px solid windowtext">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="height:50px;border:0">
                    <tr>
                      <td class="f-lbl1" style="height:24px;border-right:0">제품사진</td>
                    </tr>
                    <tr>
                      <td style="vertical-align:top;border-right:0;border-bottom:0">
                        <xsl:if test="//bizinfo/@docstatus != '700'">
                          <form id="upForm11" name="upForm11" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
                            <xsl:if test="//forminfo/maintable/PHOTOA[.!=''] or $mode='read'">
                              <xsl:attribute name="style">display:none</xsl:attribute>
                            </xsl:if>
                            <input type="file" name="file1" style="width:79%;height:22px;font-size:12px" />
                            <button onclick="return parent.jsFileUpload(380, 'upForm11');" onfocus="this.blur()" class="btn_bg" style="margin-top:-4px;width:20%">이미지첨부</button>
                          </form>
                        </xsl:if>
                        <div style="padding:2px 4px 0 2px;border:0 solid red">
                          <xsl:choose>
                            <xsl:when test="//forminfo/maintable/PHOTOA[.!='']">
                              <xsl:apply-templates select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOA,';') and savedname=substring-after(//forminfo/maintable/PHOTOA,';')]"/>
                              <xsl:if test="$mode!='read'">
                                <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                                  <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOA,';') and savedname=substring-after(//forminfo/maintable/PHOTOA,';')]/@attachid}', '', 'upForm11');" />
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
                            <xsl:when test="//forminfo/maintable/PHOTOA[.!='']">
                              <xsl:variable name="ext" select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOA,';') and savedname=substring-after(//forminfo/maintable/PHOTOA,';')]/@filetype" />
                              <xsl:choose>
                                <xsl:when test="$ext='gif' or $ext='bmp' or $ext='jpg' or $ext='png' or $ext='GIF' or $ext='BMP' or $ext='JPG' or $ext='PNG'">
                                  <xsl:attribute name="style">padding:2px;border:0 solid blue</xsl:attribute>
                                  <img onload="if(this.offsetWidth>380)this.style.width='380px'">
                                    <xsl:attribute name="alt">
                                      <xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOA,';') and savedname=substring-after(//forminfo/maintable/PHOTOA,';')]/filename"/>
                                    </xsl:attribute>
                                    <xsl:attribute name="src">http://<xsl:value-of select="//config/@web"/><xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOA,';') and savedname=substring-after(//forminfo/maintable/PHOTOA,';')]/virtualpath"/>/<xsl:value-of select="//fileinfo/file[filename=substring-before(//forminfo/maintable/PHOTOA,';') and savedname=substring-after(//forminfo/maintable/PHOTOA,';')]/savedname"/></xsl:attribute>
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
                        <input type="hidden" id="__mainfield" name="PHOTOA" value="{//forminfo/maintable/PHOTOA}" />
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
            <span>2. STEP별 생산 현황</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table id="__subtable2" class="ft-sub" header="0" progdir="col" border="0" cellspacing="0" cellpadding="0" style="border-top:0;border-right:0;table-layout:fixed">
              <colgroup>
                <col width="6%" />
                <col width="9%" />
                <col width="14%" />
                <col width="14%" />
                <col width="14%" />
                <col width="14%" />
                <col width="14%" />
                <col width="15%" />
              </colgroup>
              <tr class="sub_table_row">
                <td class="f-lbl-sub" colspan="2">항목</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td style="text-align:center">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item2', 'CLSFN', string(CLSFN), '50')" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CLSFN))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row" cstt="1">
                <td class="f-lbl-sub" rowspan="3">일정</td>
                <td class="f-lbl-sub">계획</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2DT1" class="txtDate" maxlength="8" value="{S2DT1}" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2DT1))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub">실적</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2DT2" class="txtDate" maxlength="8" value="{S2DT2}" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2DT2))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub">차이(일)</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2DIFF" class="txtRead_Center" readonly="readonly" value="{S2DIFF}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2DIFF))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub" colspan="2">투입</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2CNT1" class="txtCurrency" maxlength="20" value="{S2CNT1}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2CNT1))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub" colspan="2">양품</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2CNT2" class="txtCurrency" maxlength="20" value="{S2CNT2}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2CNT2))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row" cstt="1">
                <td class="f-lbl-sub" rowspan="3">불량</td>
                <td class="f-lbl-sub">동작</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2CNT3" class="txtCurrency" maxlength="20" value="{S2CNT3}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2CNT3))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub">외관</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2CNT4" class="txtCurrency" maxlength="20" value="{S2CNT4}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2CNT4))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub">불량률(%)</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2RATE1" class="txtRead_Center" readonly="readonly" value="{S2RATE1}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2RATE1))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub" colspan="2">목표불량률(%)</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2RATE2" class="txtDollar" maxlength="20" value="{S2RATE2}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2RATE2))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub" colspan="2">목표달성률(%)</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="S2RATE3" class="txtDollar" maxlength="20" value="{S2RATE3}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(S2RATE3))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
              </tr>
              <tr class="sub_table_row">
                <td class="f-lbl-sub" colspan="2">지연사유</td>
                <xsl:for-each select="//forminfo/subtables/subtable2/row">
                  <td style="height:46px">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea name="S2RSN" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);" style="height:96%;width:100%">
                          <xsl:value-of select="S2RSN" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div class="txaRead" style="">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(S2RSN))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </xsl:for-each>
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
                      <span>3. STEP별 문제점 해결 현황</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>3. STEP별 문제점 해결 현황</span>
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
                      <col width="4%" />
                      <col width="11%" />
                      <col width="10%" />
                      <col width="9%" />
                      <col width="9%" />
                      <col width="10%" />
                      <col width="9%" />
                      <col width="9%" />
                      <col width="10%" />
                      <col width="10%" />
                      <col width="9%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="3">EP</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="3">PP</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="3">PMP</td>
                    </tr>
                    <tr style="height:22px">
                      <td class="f-lbl-sub">등록건수</td>
                      <td class="f-lbl-sub">해결건수</td>
                      <td class="f-lbl-sub">해결률(%)</td>
                      <td class="f-lbl-sub">등록건수</td>
                      <td class="f-lbl-sub">해결건수</td>
                      <td class="f-lbl-sub">해결률(%)</td>
                      <td class="f-lbl-sub">등록건수</td>
                      <td class="f-lbl-sub">해결건수</td>
                      <td class="f-lbl-sub" style="border-right:0">해결률(%)</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" colspan="2">합계</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EPSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/EPSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EPSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EPSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/EPSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EPSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="EPTOTRATE" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/EPTOTRATE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EPTOTRATE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PPSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/PPSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PPSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PPSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/PPSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PPSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PPTOTRATE" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/PPTOTRATE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PPTOTRATE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PMPSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/PMPSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PMPSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PMPSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/PMPSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PMPSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="PMPTOTRATE" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/PMPTOTRATE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PMPTOTRATE))" />
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
              <colgroup>
                <col width="25%" />
                <col width="24%" />
                <col width="1%" />
                <col width="50%" />
              </colgroup>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>4. 환경 문제점 현황</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable4');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable4');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span colspan="2">4. 환경 문제점 현황</span>
                    </td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
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
                  <table id="__subtable4" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="8%" />
                      <col width="23%" />
                      <col width="23%" />
                      <col width="23%" />
                      <col width="23%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">판정</td>
                      <td class="f-lbl-sub" style="border-top:0">측정건수</td>
                      <td class="f-lbl-sub" style="border-top:0">불량건수</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">판정</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable4/row"/>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" colspan="2">합계</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/MSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/MSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <span class="f-option" >
                          <input type="checkbox" id="ckb31" name="ckbMSUMDCN" value="OK">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbMSUMDCN', this, 'MSUMDCN')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/MSUMDCN),'OK')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/MSUMDCN),'OK')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb31">OK</label>
                        </span>
                        <span class="f-option">
                          <input type="checkbox" id="ckb32" name="ckbMSUMDCN" value="NO">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbMSUMDCN', this, 'MSUMDCN')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/MSUMDCN),'NO')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/MSUMDCN),'NO')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb32">NO</label>
                        </span>
                        <input type="hidden" id="__mainfield" name="MSUMDCN" value="{//forminfo/maintable/MSUMDCN}" />
                      </td>
                    </tr>
                  </table>
                </td>
                <td>&nbsp;</td>
                <td>
                  <table border="0" cellspacing="0" cellpadding="0" style="border:1px solid windowtext">
                    <tr>
                      <td class="f-lbl1" style="height:25px;background-color:#eeeeee;border-bottom:1px solid windowtext">
                        <span style="font-size:13px;text-align:center">특이사항</span>
                      </td>
                    </tr>
                    <tr>
                      <td style="padding:2px">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <textarea id="__mainfield" name="DESCRIPTION" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);" style="height:99%;width:100%">
                              <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                            </textarea>
                          </xsl:when>
                          <xsl:otherwise>
                            <div name="DESCRIPTION" class="txaRead" style="height:98%;font-size:13px;font-family:맑은 고딕">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                            </div>
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
                      <span>5. 부서별 최종 검증 결과</span>
                    </td>
                    <td class="fm-button">
                      <!--<button onclick="parent.fnAddChkRow('__subtable5');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable5');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>5. 부서별 최종 검증 결과</span>
                    </td>
                    <td class="fm-button">
                      <xsl:if test="//optioninfo/foption1">
                        <a target="_blank">
                          <xsl:attribute name="href">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:linkForm(string(//config/@web), string($root), string(//optioninfo/foption1/@cd))" />
                          </xsl:attribute>
                          해당 개발산출물리스트
                        </a>
                      </xsl:if>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td colspan="2">
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable5" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <colgroup>
                      <col width="4%" />
                      <col width="14%" />
                      <col width="20%" />
                      <col width="44%" />
                      <col width="18%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">부서</td>
                      <td class="f-lbl-sub" style="border-top:0">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">의견</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">첨부자료</td>
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

          <div class="fm">
            <span>6. 이관승인 의견</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl1" style="width:20%;border-bottom:0">이관결정<br />(기술부문장/공장장)</td>
                <td style="width:10%;border-bottom:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbMDCN1" value="OK">
                      <xsl:if test="$bizrole='normal' and $actrole='_approver' and $partid!=''">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMDCN1', this, 'MDCN1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/MDCN1),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not ($bizrole='normal' and $actrole='_approver' and $partid!='') and phxsl:isDiff(string(//forminfo/maintable/MDCN1),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">OK</label>
                  </span>
                  <br />
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbMDCN1" value="NO">
                      <xsl:if test="$bizrole='normal' and $actrole='_approver' and $partid!=''">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMDCN1', this, 'MDCN1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/MDCN1),'NO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not ($bizrole='normal' and $actrole='_approver' and $partid!='') and phxsl:isDiff(string(//forminfo/maintable/MDCN1),'NO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="MDCN1" value="{//forminfo/maintable/MDCN1}" />
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='normal' and $actrole='_approver' and $partid!=''">
                      <textarea id="__mainfield" name="MOPN1" class="txaText" onkeyup="parent.checkTextAreaLength(this, 200);" style="height:40px">
                        <xsl:value-of select="//forminfo/maintable/MOPN1" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="MOPN1" class="txaRead" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MOPN1))" />
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

          <div class="fm">
            <span>7. 최종 의견</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl1" style="width:20%;border-bottom:0">최종의견</td>
                <td style="width:10%;border-bottom:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbMDCN2" value="OK">
                      <xsl:if test="$bizrole='last' and $actrole='_approver' and $partid!=''">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMDCN2', this, 'MDCN2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/MDCN2),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not ($bizrole='last' and $actrole='_approver' and $partid!='') and phxsl:isDiff(string(//forminfo/maintable/MDCN2),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">OK</label>
                  </span>
                  <br />
                  <span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbMDCN2" value="NO">
                      <xsl:if test="$bizrole='last' and $actrole='_approver' and $partid!=''">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbMDCN2', this, 'MDCN2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/MDCN2),'NO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="not ($bizrole='last' and $actrole='_approver' and $partid!='') and phxsl:isDiff(string(//forminfo/maintable/MDCN2),'NO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="MDCN2" value="{//forminfo/maintable/MDCN2}" />
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='last' and $actrole='_approver' and $partid!=''">
                      <textarea id="__mainfield" name="MOPN2" class="txaText" onkeyup="parent.checkTextAreaLength(this, 200);" style="height:40px">
                        <xsl:value-of select="//forminfo/maintable/MOPN2" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="MOPN1" class="txaRead" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MOPN2))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
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
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item1', 'CLSFN', string(CLSFN), '50')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CLSFN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MGRNM" class="txtText" maxlength="100" value="{MGRNM}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MGRNM))" />
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item3', 'CLSFN', string(CLSFN), '50')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CLSFN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EPCNT1" class="txtCurrency" maxlength="20" value="{EPCNT1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EPCNT1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EPCNT2" class="txtCurrency" maxlength="20" value="{EPCNT2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EPCNT2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EPRATE" class="txtRead_Right" readonly="readonly" value="{EPRATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EPRATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PPCNT1" class="txtCurrency" maxlength="20" value="{PPCNT1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PPCNT1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PPCNT2" class="txtCurrency" maxlength="20" value="{PPCNT2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PPCNT2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PPRATE" class="txtRead_Right" readonly="readonly" value="{PPRATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PPRATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PMPCNT1" class="txtCurrency" maxlength="20" value="{PMPCNT1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PMPCNT1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PMPCNT2" class="txtCurrency" maxlength="20" value="{PMPCNT2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PMPCNT2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PMPRATE" class="txtRead_Right" readonly="readonly" value="{PMPRATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PMPRATE))" />
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item4', 'CLSFN', string(CLSFN), '50')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CLSFN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="S4CNT1" class="txtCurrency" maxlength="20" value="{S4CNT1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(S4CNT1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="S4CNT2" class="txtCurrency" maxlength="20" value="{S4CNT2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(S4CNT2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <span class="f-option">
          <input type="checkbox" id="ckb.4{ROWSEQ}.1"  name="ckbS4DCN" value="OK">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS4DCN', this, 'S4DCN')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(S4DCN),'OK')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(S4DCN),'OK')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.4{ROWSEQ}.1">OK</label>
        </span>
        <span class="f-option">
          <input type="checkbox" id="ckb.4{ROWSEQ}.2" name="ckbS4DCN" value="NO">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS4DCN', this, 'S4DCN')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(S4DCN),'NO')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(S4DCN),'NO')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.4{ROWSEQ}.2">NO</label>
        </span>
        <input type="hidden" name="S4DCN" value="{S4DCN}" />
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="//forminfo/subtables/subtable5/row">
    <tr class="sub_table_row">
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                <input type="text" name="ROWSEQ" class="txtRead_Center"  readonly="readonly" value="{ROWSEQ}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" class="txtRead" readonly="readonly" name="PTDP" value="{PTDP}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PTDP))" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="PTDPID" value="{PTDPID}" />
      </td>
      <td colspan="2" style="padding:0">
        <table border="0" cellspacing="0" cellpadding="0" style="border:0">
          <colgroup>
            <col width="52px" />
            <col width="94px" />
            <col width="" />
          </colgroup>
          <tr>
            <td class="f-lbl-sub" style="border-top:0" >담당</td>
            <td style="border-top:0">
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.11"  name="ckbS5DCN1" value="합격">
                  <xsl:if test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'합격')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'합격')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.11">합격</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.12" name="ckbS5DCN1" value="불합격">
                  <xsl:if test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'불합격')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'불합격')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.12">불합격</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.13" name="ckbS5DCN1" value="조건부합격">
                  <xsl:if test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'조건부합격')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'조건부합격')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.13">조건부합격</label>
              </span>
              <input type="hidden" name="S5DCN1" value="{S5DCN1}" />
            </td>
            <td style="vertical-align:top;border-top:0;border-right:0">
              <xsl:choose>
                <xsl:when test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                  <textarea name="S5OPN1" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);" style="height:96%;width:100%">
                    <xsl:value-of select="S5OPN1" />
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div class="txaRead" style="">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(S5OPN1))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr>
            <td class="f-lbl-sub" style="">팀장</td>
            <td style="">
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.21"  name="ckbS5DCN2" value="합격">
                  <xsl:if test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'합격')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'합격')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.21">합격</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.22" name="ckbS5DCN2" value="불합격">
                  <xsl:if test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'불합격')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'불합격')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.22">불합격</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.33" name="ckbS5DCN2" value="조건부합격">
                  <xsl:if test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'조건부합격')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'조건부합격')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.33">조건부합격</label>
              </span>
              <input type="hidden" name="S5DCN2" value="{S5DCN2}" />
            </td>
            <td style="vertical-align:top;border-right:0">
              <xsl:choose>
                <xsl:when test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
                  <textarea name="S5OPN2" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);" style="height:96%;width:100%">
                    <xsl:value-of select="S5OPN2" />
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div class="txaRead" style="">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(S5OPN2))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
      </td>
      <td style="border-right:0;text-align:center">
        <div style="margin-bottom:2px">
          <xsl:choose>
            <xsl:when test="$bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID">
              <xsl:variable name="fkd" select="FILEKIND" />
              <select name="FILEKIND" style="width:100%">
                <option value="">첨부자료명 선택</option>
                <xsl:for-each select="//optioninfo/foption[Item5!='']">
                  <option value="{Item5}">
                    <xsl:if test="Item5=$fkd">
                      <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="Item5"/>
                  </option>
                </xsl:for-each>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(FILEKIND))"/>
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <xsl:if test="//bizinfo/@docstatus != '700'">
          <form id="upForm5{ROWSEQ}" name="upForm5{ROWSEQ}" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
            <xsl:if test="FILEA[.!=''] or not ($bizrole='receive' and $partid!='' and //currentinfo/@deptid=PTDPID)">
              <xsl:attribute name="style">display:none</xsl:attribute>
            </xsl:if>
            <input type="file" name="file1" style="width:100%;height:22px;font-size:12px" />
            <button onclick="return parent.jsFileUpload(0, 'upForm5{ROWSEQ}');" onfocus="this.blur()" class="btn_bg" style="margin-top:2px;width:80px">파일첨부</button>
          </form>
        </xsl:if>
        <div style="padding:2px 4px 0 2px;border:0 solid red">
          <xsl:choose>
            <xsl:when test="FILEA[.!='']">
              <xsl:variable name="fnm" select="substring-before(FILEA,';')" />
              <xsl:variable name="snm" select="substring-after(FILEA,';')" />
              <xsl:apply-templates select="//fileinfo/file[filename=$fnm and savedname=$snm]"/>
              <xsl:if test="$bizrole='receive' and $partid!='' and string(//currentinfo/@deptid)='{PTDPID}'">
                <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                  <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle" src="/{$root}/EA/Images/isdelete.gif" onclick="parent.FU.remove(this, '{$root}', '{//fileinfo/file[filename=$fnm and savedname=$snm]/@attachid}', '', 'upForm5{ROWSEQ}');" />
                </span>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
            </xsl:otherwise>
          </xsl:choose>
        </div>
        <div></div>
        <input type="hidden" data-pos="5;{ROWSEQ}" name="FILEA" value="{FILEA}" />
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
  <xsl:template match="//fileinfo/file[@isfile='N']">
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:down2(string(//config/@web), string($root), string(virtualpath), string(savedname), string(filename))" />
      </xsl:attribute>
      <xsl:value-of select="filename" />
    </a>
  </xsl:template>
</xsl:stylesheet>