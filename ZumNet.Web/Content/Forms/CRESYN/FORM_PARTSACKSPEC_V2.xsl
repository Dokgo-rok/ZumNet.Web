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
			.m {width:740px}
			.m .fh {text-align:center}
			.m .ff {height:20px}
			.fh h1 {font-size:40pt;letter-spacing:1pt;font-family:궁서}
			.fh h2 {font-size:30pt;letter-spacing:1pt;font-family:돋움}
			.fh h3 {font-size:26pt;letter-spacing:1pt;font-family:돋움}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:25px} .si-tbl .si-bottom {height:25px;width:90px}
			.si-tbl .si-top {height:25px} .si-tbl .si-middle {height:90px}
			.m .fb td {font-size:13pt;font-family:돋움}

			.m .fo {width:100%;border-left:windowtext 1px solid;border-top:windowtext 1px solid}
			.m .fo td {font-size:15pt;font-family:돋움;border:0;border-bottom:windowtext 1px solid;border-right:windowtext 1px solid;padding-left:4px;padding-right:4px}
			.m .fo .f-lbl {height:40px;width:22%;text-align:center;padding-left:0}
			.m .fo input {font-size:15pt;font-family:돋움}

			.m .ff2 {height:40px}
			.m .ft .f-option {width:49%;border:0 solid red} .m .ft .f-option1 {width:34%}
			<!--.m .l_pos {display:inline-block;overflow:hidden;margin:0px;padding:0px;border:1px solid #a3a3a3;height:28px;line-height:28px;background-color:#fff;width:56px}
			.m .l_pos a {color:#666;font-weight:bold;display:block;font-size:12px;letter-spacing:-1px;text-indent:-12px;text-decoration:none;line-height:28px;border:0 solid red}
			.m .l_pos span {background:url('/Bizforce/EA/Images/ico_all_arrows.gif') no-repeat scroll 0px -350px transparent;cursor:pointer;display:block;height:5px;overflow:hidden;position:absolute;right:8px;text-indent:-999em;top:10px;width:8px;}-->

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .ff2, .m .l_pos {display:none}}
		</style>
      </head>
      <body>
        <div class="m" id="_MAINPOS">
          <div class="fh" style="margin-top:70px">
            <h1>部品承認仕樣書</h1>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm" style="margin-left: 70px; margin-right: 70px">
            <table class="fo" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">品名</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText_u" readonly="readonly"  value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">品番</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNO" class="txtText_u" readonly="readonly" style="width:95%" value="{//forminfo/maintable/ITEMNO}" />
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,120,70,'','ITEMNO','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="品番" onclick="_zw.formEx.externalWnd('erp.items',240,40,120,70,'','ITEMNO','ITEMNAME');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">MAKER</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKER" class="txtText" maxlength="50" value="{//forminfo/maintable/MAKER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">使用 MODEL</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText_u" readonly="readonly" style="width:95%" value="{//forminfo/maintable/MODELNAME}" />
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,120,70,'','MODELNAME','ITEMNAME2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="使用 MODEL" onclick="_zw.formEx.externalWnd('erp.items',240,40,120,70,'','MODELNAME','ITEMNAME2');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="ITEMNAME2" maxlength="100" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl">使用 UNIT</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="UNITNAME" class="txtText_u" readonly="readonly" style="width:95%" value="{//forminfo/maintable/UNITNAME}" />
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,120,70,'','UNITNAME','ITEMNAME3');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="使用 UNIT" onclick="_zw.formEx.externalWnd('erp.items',240,40,120,70,'','UNITNAME','ITEMNAME3');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="ITEMNAME3" maxlength="100" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl">承認日子</td>
                <td>                  
                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(concat('20', string(//line[@bizrole='normal' and @actrole='_approve' and @partid!='']/@completed)), 'ko')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                    </xsl:otherwise>
                  </xsl:choose>-->                  
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(concat('20', string(//line[@bizrole='normal' and @actrole='_approver' and @partid!='']/@completed)), 'ko')" />
                  
                </td>
              </tr>              
              <tr>
                <td class="f-lbl">관련문서</td>
                <td>
                  <a href="#_SUBTITLE">부품인정검사서</a>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">문서번호</td>
                <td>
                  <input type="text" id="DocNumber" name="__commonfield">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="//docinfo/docnumber" />
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
            </table>
            <input type="hidden" id="__mainfield" name="STEP" style="" value="PP">              
            </input>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fh">
            <h3>이 書類를 承認 합니다.</h3>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />


          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:88px;font-size:1px">&nbsp;</td>
                <td style="width:295px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '決&lt;br /&gt;&lt;br /&gt;裁', 'N')"/>
                </td>
                <td style="width:90px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '1', 'X', 'N', //currentinfo)"/>
                </td>
                <td style="width:180px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '2')"/>
                </td>
                <td style="width:87px;font-size:1px">&nbsp;</td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fh">
            <h2>CRESYN 株式會社</h2>
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

          <div class="ff2" />
          
          <div class="fh">            
            <xsl:attribute name="style">page-break-before:always</xsl:attribute>            
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="fh-l">
                  <span class="l_pos"><a href="#_MAINPOS" class="btn btn-default">위로&nbsp;<i class="fas fa-angle-up"></i></a></span>
                </td>
                <td class="fh-m">
                  <h2 id="_SUBTITLE">부품인정검사서</h2>
                </td>
                <td class="fh-r">&nbsp;</td>
              </tr>
            </table>
          </div>

          <div class="ff" />

          <div class="fm">          
            <table class="ft" border="0" cellspacing="0" cellpadding="0" text-align="center">
               <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:35%"></col>
                <col style="width:15%"></col>
                <col style="width:35%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">구분</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTTYPE" class="txtText" style="width:91%; margin-right: 2px" value="{//forminfo/maintable/PARTTYPE}" />
                      <!--<button onclick="parent.fnOption('external.partstype',140,180,130,100,'etc','PARTTYPE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="구분" onclick="_zw.formEx.optionWnd('external.partstype',140,180,130,100,'etc','PARTTYPE');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PARTTYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">고객명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER" class="txtText" maxlength="100" value="{//forminfo/maintable/CUSTOMER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">적용모델</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME2" class="txtRead" readonly="readonly" value="{//forminfo/maintable/MODELNAME2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">품명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNAME" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PARTNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PARTNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">적용유니트</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="UNITNAME3" class="txtRead" readonly="readonly" style="width:91%; margin-right: 2px"  value="{//forminfo/maintable/UNITNAME3}" />
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,120,70,'','UNITNAME3','ITEMNAME4');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="적용유니트" onclick="_zw.formEx.externalWnd('erp.items',240,40,120,70,'','UNITNAME3','ITEMNAME4');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITNAME3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">유니트명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME4" class="txtRead" readonly="readonly" value="{//forminfo/maintable/ITEMNAME4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">도면번호</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DRAFTNUM" class="txtText" maxlength="100" value="{//forminfo/maintable/DRAFTNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DRAFTNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">P/NO</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNUM" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PARTNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">의뢰시료수</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTREQ" class="txtNumberic" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/COUNTREQ}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COUNTREQ))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">선행업체명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANY" class="txtText" maxlength="100" value="{//forminfo/maintable/COMPANY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">검사시료수</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNT" class="txtNumberic" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/COUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">후행업체명</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANYBACK" class="txtText" maxlength="100" value="{//forminfo/maintable/COMPANYBACK}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANYBACK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />

          <div class="fm">          
            <table class="ft" border="0" cellspacing="0" cellpadding="0" text-align="center">
               <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:4%"></col>
                <col style="width:11%"></col>
                <col style="width:35%"></col>
                <col style="width:8%"></col>
                <col style="width:30%"></col>
                <col style="width:12%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl2" rowspan="6">외<br /><br />관</td>
                <td class="f-lbl2" colspan="2">SPEC</td>
                <td class="f-lbl2" colspan="2">검사품</td>
                <td class="f-lbl2" style="border-right:0">판정</td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL1" class="txtRead" readonly="readonly" maxlength="50" value="외관" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC1" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM1" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbTESTRESULT1" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT1', this, 'TESTRESULT1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT1),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT1),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbTESTRESULT1" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT1', this, 'TESTRESULT1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT1),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT1),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT1" value="{//forminfo/maintable/TESTRESULT1}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL2" class="txtRead" readonly="readonly" maxlength="50" value="색상" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC2" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM2" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbTESTRESULT2" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT2', this, 'TESTRESULT2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT2),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT2),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbTESTRESULT2" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT2', this, 'TESTRESULT2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT2),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT2),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT2" value="{//forminfo/maintable/TESTRESULT2}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL3" class="txtRead" readonly="readonly" maxlength="50" value="재질" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC3" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM3" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbTESTRESULT3" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT3', this, 'TESTRESULT3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT3),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT3),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb32" name="ckbTESTRESULT3" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT3', this, 'TESTRESULT3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT3),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT3),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT3" value="{//forminfo/maintable/TESTRESULT3}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL4" class="txtRead" readonly="readonly" maxlength="50" value="재료업체" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC4" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM4" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb41" name="ckbTESTRESULT4" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT4', this, 'TESTRESULT4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT4),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT4),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb42" name="ckbTESTRESULT4" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT4', this, 'TESTRESULT4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT4),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT4),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb42">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT4" value="{//forminfo/maintable/TESTRESULT4}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL5" class="txtText" maxlength="50" value="{//forminfo/maintable/SPECLABEL5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC5" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM5" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb51" name="ckbTESTRESULT5" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT5', this, 'TESTRESULT5')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT5),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT5),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb51">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb52" name="ckbTESTRESULT5" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT5', this, 'TESTRESULT5')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT5),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT5),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb52">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT5" value="{//forminfo/maintable/TESTRESULT5}" />
                </td>
              </tr>

              <tr>
                <td class="f-lbl2" rowspan="4">기<br /><br />능</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL6" class="txtText" maxlength="50" value="{//forminfo/maintable/SPECLABEL6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC6" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM6" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb61" name="ckbTESTRESULT6" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT6', this, 'TESTRESULT6')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT6),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT6),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb61">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb62" name="ckbTESTRESULT6" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT6', this, 'TESTRESULT6')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT6),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT6),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb62">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT6" value="{//forminfo/maintable/TESTRESULT6}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL7" class="txtText" maxlength="50" value="{//forminfo/maintable/SPECLABEL7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC7" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM7" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb71" name="ckbTESTRESULT7" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT7', this, 'TESTRESULT7')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT7),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT7),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb71">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb72" name="ckbTESTRESULT7" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT7', this, 'TESTRESULT7')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT7),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT7),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb72">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT7" value="{//forminfo/maintable/TESTRESULT7}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL8" class="txtText" maxlength="50" value="{//forminfo/maintable/SPECLABEL8}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC8" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC8}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM8" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM8}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb81" name="ckbTESTRESULT8" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT8', this, 'TESTRESULT8')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT8),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT8),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb81">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb82" name="ckbTESTRESULT8" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT8', this, 'TESTRESULT8')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT8),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT8),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb82">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT8" value="{//forminfo/maintable/TESTRESULT8}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL9" class="txtText" maxlength="50" value="{//forminfo/maintable/SPECLABEL9}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC9" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC9}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM9" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM9}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb91" name="ckbTESTRESULT9" value="OK">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT9', this, 'TESTRESULT9')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT9),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>                        
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT9),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb91">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb92" name="ckbTESTRESULT9" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT9', this, 'TESTRESULT9')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT9),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT9),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb92">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT9" value="{//forminfo/maintable/TESTRESULT9}" />
                </td>
              </tr>

              <tr>
                <td class="f-lbl2" rowspan="4" style="font-size:11px">중<br />점<br />P<br />O<br />I<br />N<br />T</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL10" class="txtRead" readonly="readonly" maxlength="50" value="POINT 1" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL10))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC10" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC10}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC10))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM10" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM10}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM10))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb101" name="ckbTESTRESULT10" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT10', this, 'TESTRESULT10')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT10),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT10),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb101">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb102" name="ckbTESTRESULT10" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT10', this, 'TESTRESULT10')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT10),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT10),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb102">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT10" value="{//forminfo/maintable/TESTRESULT10}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL11" class="txtRead" readonly="readonly" maxlength="50" value="POINT 2" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL11))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC11" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC11}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC11))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM11" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM11}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM11))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb111" name="ckbTESTRESULT11" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT11', this, 'TESTRESULT11')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT11),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT11),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb111">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb112" name="ckbTESTRESULT11" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT11', this, 'TESTRESULT11')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT11),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT11),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb112">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT11" value="{//forminfo/maintable/TESTRESULT11}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL12" class="txtRead" readonly="readonly" maxlength="50" value="POINT 3" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL12))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC12" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC12}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC12))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM12" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM12}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM12))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb121" name="ckbTESTRESULT12" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT12', this, 'TESTRESULT12')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT12),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT12),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb121">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb122" name="ckbTESTRESULT12" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT12', this, 'TESTRESULT12')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT12),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT12),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb122">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT12" value="{//forminfo/maintable/TESTRESULT12}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL13" class="txtRead" readonly="readonly" maxlength="50" value="POINT 4" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL13))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC13" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC13}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC13))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM13" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM13}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM13))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb131" name="ckbTESTRESULT13" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT13', this, 'TESTRESULT13')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT13),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT13),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb131">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb132" name="ckbTESTRESULT13" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT13', this, 'TESTRESULT13')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT13),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT13),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb132">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT13" value="{//forminfo/maintable/TESTRESULT13}" />
                </td>
              </tr>

              <tr>
                <td class="f-lbl2" rowspan="4">금<br /><br />형</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL14" class="txtRead" readonly="readonly" maxlength="50" value="금형 NO." />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL14))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC14" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC14}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC14))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTLABEL1" class="txtRead" readonly="readonly" maxlength="50" value="시사출 1" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTLABEL1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM14" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM14}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM14))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb141" name="ckbTESTRESULT14" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT14', this, 'TESTRESULT14')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT14),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT14),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb141">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb142" name="ckbTESTRESULT14" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT14', this, 'TESTRESULT14')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT14),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT14),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb142">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT14" value="{//forminfo/maintable/TESTRESULT14}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL15" class="txtRead" readonly="readonly" maxlength="50" value="CAVITY 수" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL15))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC15" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC15}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC15))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTLABEL2" class="txtRead" readonly="readonly" maxlength="50" value="시사출 2" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTLABEL2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM15" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM15}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM15))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb151" name="ckbTESTRESULT15" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT15', this, 'TESTRESULT15')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT15),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT15),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb151">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb152" name="ckbTESTRESULT15" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT15', this, 'TESTRESULT15')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT15),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT15),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb152">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT15" value="{//forminfo/maintable/TESTRESULT15}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL16" class="txtRead" readonly="readonly" maxlength="50" value="적정사출" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL16))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC16" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC16}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC16))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTLABEL3" class="txtRead" readonly="readonly" maxlength="50" value="시사출 3" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTLABEL3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM16" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM16}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM16))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb161" name="ckbTESTRESULT16" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT16', this, 'TESTRESULT16')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT16),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT16),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb161">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb162" name="ckbTESTRESULT16" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT16', this, 'TESTRESULT16')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT16),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT16),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb162">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT16" value="{//forminfo/maintable/TESTRESULT16}" />
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECLABEL17" class="txtRead" readonly="readonly" maxlength="50" value="GATE" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPECLABEL17))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPECDESC17" class="txtText" maxlength="100" value="{//forminfo/maintable/SPECDESC17}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECDESC17))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTLABEL4" class="txtRead" readonly="readonly" maxlength="50" value="시사출 4" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTLABEL4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTITEM17" class="txtText" maxlength="100" value="{//forminfo/maintable/TESTITEM17}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTITEM17))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb171" name="ckbTESTRESULT17" value="OK">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT17', this, 'TESTRESULT17')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT17),'OK')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT17),'OK')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb171">OK</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb172" name="ckbTESTRESULT17" value="NG">
                       <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbTESTRESULT17', this, 'TESTRESULT17')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TESTRESULT17),'NG')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and  phxsl:isDiff(string(//forminfo/maintable/TESTRESULT17),'NG')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb172">NG</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TESTRESULT17" value="{//forminfo/maintable/TESTRESULT17}" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" colspan="2" style="border-bottom:0;height:80px">특기사항</td>
                <td colspan="4" style="border-right:0;border-bottom:0;height:80px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:80px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DESCRIPTION" style="height:80px" class="txaRead">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

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
