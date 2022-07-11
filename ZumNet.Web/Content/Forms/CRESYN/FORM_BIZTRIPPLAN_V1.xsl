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
  <xsl:variable name="wid" select="//config/@wid" />
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
          .m {width:720px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:13%} .m .ft .f-lbl1 {width:6%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:24%} .m .ft .f-option1 {width:34%} .m .ft .f-option2 {width:41%} .m .ft .f-option3 {width:80px} .m .ft .f-option4 {width:70px}  .m .ft .f-option5 {width:60px}
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
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='' and @step!='0'], '__si_Form', '1', '작성부서')"/>
                </td>
                <td style="width:;font-size:11px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='동행승인' and @partid!='' and @step!='0'], '__si_Form2', '3', '동행부서')"/>
                </td>
                <td style="width:;font-size:11px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의부서', '')"/>
                </td>
                <td style="width:;font-size:12px">&nbsp;</td>
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
                <td style="width:37%">
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
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" rowspan="2">
                  출장자
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <!--<button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                      </img>
                    </button>-->
				  <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="Contacts" onclick="_zw.fn.org('user','n');">
						  <i class="fas fa-angle-down"></i>
					  </button>
                  </xsl:if>
                </td>
                <td class="f-lbl1">법인</td>
                <td style="width:31%">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="TRIPPERSONCORP">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/belong" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="TRIPPERSONCORP">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TRIPPERSONCORP" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSONCORP))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  </td>
                  <td class="f-lbl">부서</td>
                  <td style="width:37%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="TRIPPERSONORG">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/department" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="TRIPPERSONORG">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TRIPPERSONORG" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSONORG))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="width:6%">직위</td>
                <td style="width:31%">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="TRIPPERSONGRADE">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/grade" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="TRIPPERSONGRADE">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TRIPPERSONGRADE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSONGRADE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">성명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="TRIPPERSON" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" />                        
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="TRIPPERSON" class="txtRead" readonly="readonly" value="{//forminfo/maintable/TRIPPERSON}" />                      
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="TRIPPERSONEMPID">
                      <xsl:choose>
                        <xsl:when test="$mode='new'">
                          <xsl:attribute name="value"><xsl:value-of select="//creatorinfo/empno" /></xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/TRIPPERSONEMPID" /></xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">출장 필요성</td>
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PURPOSE" class="txtText" maxlength="100" value="{//forminfo/maintable/PURPOSE}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PURPOSE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                
              </tr>
              <tr>
                <td class="f-lbl">출장지</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOCATION" style="width:91%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/LOCATION}" />                      
                      <!--<button onclick="parent.fnView('external.centercode',300,180,80,140,'etc','LOCATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
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
                <td class="f-lbl">출장기간</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TRIPFROM" class="datepicker txtDate" maxlength="10" style="width:68px" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TRIPFROM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPFROM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;~&nbsp; 
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TRIPTO" class="datepicker txtDate" maxlength="10" style="width:68px" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/TRIPTO}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TRIPTO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STAY" class="txtVolume" maxlength="3" style="width:22px" data-inputmask="number;3;0" value="{//forminfo/maintable/STAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;박&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DAY" class="txtNumberic" maxlength="3" style="width:22px" data-inputmask="number;3;0" value="{//forminfo/maintable/DAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;일&nbsp;)
                </td>
              </tr>
              <!--<tr>
                <td class="f-lbl" style="">이전출장여부</td>
                <td colspan="4" style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbLASTCHECK" value="전출장무">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbLASTCHECK', this, 'LASTCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LASTCHECK),'전출장무')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/LASTCHECK),'전출장무')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">전출장무</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb32" name="ckbLASTCHECK" value="전출장유">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbLASTCHECK', this, 'LASTCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LASTCHECK),'전출장유')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/LASTCHECK),'전출장유')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">전출장유</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="LASTCHECK">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/LASTCHECK"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LASTTRIPFROM">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="style">display:none;width:100px</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LASTTRIPFROM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LASTTRIPFROM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;~&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LASTTRIPTO">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="style">display:none;width:100px</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LASTTRIPTO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LASTTRIPTO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LASTSTAY">
                        <xsl:attribute name="class">txtNumberic</xsl:attribute>
                        <xsl:attribute name="style">display:none;width:18px</xsl:attribute>
                        <xsl:attribute name="maxlength">3</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LASTSTAY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/LASTSTAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;박&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LASTDAY">
                        <xsl:attribute name="class">txtNumberic</xsl:attribute>
                        <xsl:attribute name="style">display:none;width:18px</xsl:attribute>
                        <xsl:attribute name="maxlength">3</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LASTDAY" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/LASTDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;일&nbsp;)
                </td>                             
              </tr>-->
              <tr>
                <td class="f-lbl">규정외예산</td>
                <td colspan="2">
                  <span class="f-option2">
                    <input type="checkbox" id="ckb11" name="ckbOUTBUDGET" value="불필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbOUTBUDGET', this, 'OUTBUDGET')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/OUTBUDGET),'불필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/OUTBUDGET),'불필요')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">불필요</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbOUTBUDGET" value="필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbOUTBUDGET', this, 'OUTBUDGET')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/OUTBUDGET),'필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/OUTBUDGET),'필요')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">필요</label>
                  </span>(접대비 등)
                  <input type="hidden" id="__mainfield" name="OUTBUDGET">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/OUTBUDGET"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl">비상연락처</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PHNUMBER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PHNUMBER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PHNUMBER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">출장동행자</td>
                <td colspan="2">
                  <span class="f-option">
                    <input type="checkbox" id="ckb41" name="ckbCOMPANIONYN" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOMPANIONYN', this, 'COMPANIONYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COMPANIONYN),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COMPANIONYN),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">없음</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb42" name="ckbCOMPANIONYN" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOMPANIONYN', this, 'COMPANIONYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COMPANIONYN),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COMPANIONYN),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb42">있음(내부)</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb43" name="ckbCOMPANIONYN" value="O">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCOMPANIONYN', this, 'COMPANIONYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/COMPANIONYN),'O')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/COMPANIONYN),'O')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb43">있음(외부)</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="COMPANIONYN" value="{//forminfo/maintable/COMPANIONYN}" />
                </td>
                <td class="f-lbl">동행자</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANION" class="txtText" maxlength="20" value="{//forminfo/maintable/COMPANION}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">출장경비부담</td>
                <td colspan="4" style="border-right:0;border-bottom:0;width:100%">            
                  <span class="f-option5">
                    <input type="checkbox" id="ckb21" name="ckbUSEMONEY" value="회사부담">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEY', this, 'USEMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEY),'회사부담')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEY),'회사부담')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">회사</label>
                  </span>
                  <span class="f-option5">
                    <input type="checkbox" id="ckb22" name="ckbUSEMONEY" value="개인부담">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEY', this, 'USEMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEY),'개인부담')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEY),'개인부담')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">개인</label>
                  </span>
                  <span class="f-option5">
                    <input type="checkbox" id="ckb23" name="ckbUSEMONEY" value="고객부담">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEY', this, 'USEMONEY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEY),'고객부담')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEY),'고객부담')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">고객</label>
                  </span>                  
                  (<span class="f-option4">
                    <input type="checkbox" id="ckb24" name="ckbUSEMONEYDETAIL1" value="항공료">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEYDETAIL1', this, 'USEMONEYDETAIL1')</xsl:attribute>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEYDETAIL1),'항공료')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEYDETAIL1),'항공료')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">항공료</label>
                  </span>
                  <span class="f-option4">
                    <input type="checkbox" id="ckb25" name="ckbUSEMONEYDETAIL2" value="숙박료">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEYDETAIL2', this, 'USEMONEYDETAIL2')</xsl:attribute>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEYDETAIL2),'숙박료')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEYDETAIL2),'숙박료')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb25">숙박료</label>
                  </span>
                  <span class="f-option5">
                    <input type="checkbox" id="ckb26" name="ckbUSEMONEYDETAIL3" value="식비">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEYDETAIL3', this, 'USEMONEYDETAIL3')</xsl:attribute>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEYDETAIL3),'식비')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEYDETAIL3),'식비')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb26">식비</label>
                  </span>
                  <span class="f-option5">
                    <input type="checkbox" id="ckb27" name="ckbUSEMONEYDETAIL4" value="일비">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEYDETAIL4', this, 'USEMONEYDETAIL4')</xsl:attribute>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEYDETAIL4),'일비')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEYDETAIL4),'일비')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb27">일비</label>
                  </span>
                   <span class="f-option6">
                    <input type="checkbox" id="ckb28" name="ckbUSEMONEYDETAIL5" value="기타">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbUSEMONEYDETAIL5', this, 'USEMONEYDETAIL5')</xsl:attribute>
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEMONEYDETAIL5),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/USEMONEYDETAIL5),'기타')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb28">기타</label>
                  </span>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="USEMONEYDETAILETC">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="style">display:none;width:100px</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/USEMONEYDETAILETC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USEMONEYDETAILETC))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm" id="panDisplay">
            <xsl:choose>
              <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/OUTBUDGET), '필요')">
                <xsl:attribute name="style">display:block</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>√규정 외 지출예상 내역</span>
                    </td>
                    <td class="fm-button" >         
                      <!--<button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}//EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}//EA/Images/ico_27.gif" />삭제
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
                      <span>√규정 외 지출예상 내역</span>
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
                  <table id="__subtable2" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:30%"></col>
                      <col style="width:15%"></col>
                      <col style="width:14%"></col>
                      <col style="width:47%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">지출예상 내역</td>
                      <td class="f-lbl-sub" style="border-top:0;">금액</td>
                      <td class="f-lbl-sub" style="border-top:0">통화</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="1">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
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
                      <span>√출장 기안자 출장계획</span>
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
                      <span>
                        √출장 기안자 출장계획 (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSONORG))"/>&nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRIPPERSON))"/>)
                      </span>
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
                      <col style="width:4%"></col>
                      <col style="width:11%"></col>                      
                      <col style="width:19%"></col>
                      <col style="width:24%"></col>
                      <col style="width:42%"></col>
                    </colgroup>
                    <tr style="">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">일자</td>                      
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">방문처</td>                      
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">출장업무 계획</td>
                    </tr>
                    <tr style="">
                      <td class="f-lbl-sub" style="">현안</td>
                      <td class="f-lbl-sub" style="border-right:0">출장 중 처리예정 업무</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <xsl:if test="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6']">
            <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6']">
              <xsl:sort select="@substep" order="ascending"/>
            </xsl:apply-templates>
          </xsl:if>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='동행자' and $actrole='_manager' and $partid!='')">
                  <tr>
                    <td>
                      <span style="width:200px">
                        √출장예상소요비용 <br />(<a href="http://btms.redcap.co.kr/btrs/login.jsp?cust_cd=CRE" target="_blank">항공권예약바로가기</a>)
                      </span>
                    </td>
                    <td style="width:450px">
                      <ol style="margin-top:0;margin-bottom:0;color:#f00;font-family:맑은 고딕;font-size:13px">
                        <li>출장자는 반드시 본인 경비에 한해서만 기입</li>
                        <li>“찾기” 버튼을 통하여 일비 자동계산 가능</li>
                        <li>접대비 규정 외 예산으로 체크必</li>
                      </ol>
                    </td>
                    <td class="fm-button">
                      <xsl:choose>
                        <xsl:when test="$bizrole='동행자' and $actrole='_manager' and $partid!=''">
                          <!--<button onclick="parent.fnFormEvent('_C{//processinfo/signline/lines/line[@wid=$wid]/@substep}');" onfocus="this.blur()" class="btn_bg">
                            <img alt="" class="blt01" src="/{$root}/EA/Images/ico_23.gif" /><xsl:text>찾기</xsl:text>
                          </button>-->
						    <button type="button" class="btn btn-outline-secondary btn-sm" title="일비" onclick="_zw.formEx.event('BIZTRIP_EXPENSERULE','_C{//processinfo/signline/lines/line[@wid=$wid]/@substep}');">
								<i class="fe-search"></i><xsl:text>찾기</xsl:text>
							</button>
                        </xsl:when>
                        <xsl:otherwise>
                          <!--<button onclick="parent.fnFormEvent('');" onfocus="this.blur()" class="btn_bg">
                            <img alt="" class="blt01" src="/{$root}/EA/Images/ico_23.gif" /><xsl:text>찾기</xsl:text>
                          </button>-->
						<button type="button" class="btn btn-outline-secondary btn-sm" title="일비" onclick="_zw.formEx.event('BIZTRIP_EXPENSERULE','');">
								<i class="fe-search"></i><xsl:text>찾기</xsl:text>
							</button>
                        </xsl:otherwise>
                      </xsl:choose>
                      
                      <!--<button onclick="parent.fnAddChkRow('__subtable10');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" /><xsl:text>추가</xsl:text>
                      </button>
                      <button onclick="if (document.getElementById('__subtable10').rows.length > 5) parent.fnDelChkRow('__subtable10');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" /><xsl:text>삭제</xsl:text>
                      </button>-->
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>√출장예상소요비용</span>
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
                <td colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or not(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])">
                      <!--- 기안자 작성/편집 또는 동행자가 없는 경우 -->
                      <table id="__subtable10" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                        <tr style="height:24px">
                          <td class="f-lbl-sub" style="width:4%;border-top:0">&nbsp;</td>
                          <td class="f-lbl-sub" style="width:30%;border-top:0">구분</td>
                          <td class="f-lbl-sub" style="width:24%;border-top:0;">금액(원)</td>
                          <td class="f-lbl-sub" style="width:42%;border-top:0;border-right:0">지출사유</td>
                        </tr>
                        <xsl:apply-templates select="//forminfo/subtables/subtable10/row" mode="tbl1"/>
                        <tr>
                          <td class="f-lbl-sub" colspan="2">TOTAL</td>
                          <td style="border-bottom:0">
                            <xsl:choose>
                              <xsl:when test="$mode='new' or $mode='edit'">
                                <input type="text" id="__mainfield" name="UNITEXPENSE" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/UNITEXPENSE}" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE))" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                          <td style="border-right:0">&nbsp;</td>
                        </tr>
                      </table>
                    </xsl:when>
                    <xsl:when test="$bizrole='동행자' and $actrole='_manager' and $partid!=''">
                      <!--- 동행자 결재 경우 -->
                      <xsl:variable name="unitexpense" select="concat('UNITEXPENSE_C', string(//processinfo/signline/lines/line[@wid=$wid]/@substep))" />
                      <table id="__subtable10" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                        <tr style="height:24px">
                          <td class="f-lbl-sub" style="width:4%;border-top:0" rowspan="2">&nbsp;</td>
                          <td class="f-lbl-sub" style="width:14%;border-top:0" rowspan="2">구분</td>
                          <td class="f-lbl-sub" style="border-top:0" colspan="2">기안자</td>
                          <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">
                            동행자(<xsl:value-of select="//currentinfo/name" />)
                          </td>
                        </tr>
                        <tr style="height:24px">
                          <td class="f-lbl-sub" style="width:14%">금액(원)</td>
                          <td class="f-lbl-sub" style="width:27%">지출사유</td>
                          <td class="f-lbl-sub" style="width:14%">금액(원)</td>
                          <td class="f-lbl-sub" style="width:27%;border-right:0">지출사유</td>
                        </tr>
                        <xsl:apply-templates select="//forminfo/subtables/subtable10/row" mode="tbl1"/>
                        <tr>
                          <td class="f-lbl-sub" colspan="2">TOTAL</td>
                          <td class="tdRead_Right" style="border-bottom:0">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE))" />
                          </td>
                          <td>&nbsp;</td>
                          <td class="tdRead_Right" style="border-bottom:0">
                            <input type="text" id="__mainfield" name="{$unitexpense}" class="txtRead_Right" readonly="readonly" value="{phxsl:nodeText(//forminfo/maintable, string($unitexpense))}" />
                          </td>
                          <td style="border-right:0">&nbsp;</td>
                        </tr>
                      </table>
                    </xsl:when>
                    <xsl:otherwise>
                      <table id="__subtable10" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                        <tr style="height:24px">
                          <td class="f-lbl-sub" style="width:4%;border-top:0" rowspan="2">&nbsp;</td>
                          <td class="f-lbl-sub" style="width:11%;border-top:0" rowspan="2">구분</td>
                          <td class="f-lbl-sub" style="border-top:0" colspan="2">기안자</td>
                          <td class="f-lbl-sub" style="border-top:0" colspan="2">동행자(<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='1' and @viewstate!='6']/partname"/>)</td>
                          <td class="f-lbl-sub" style="border-top:0" colspan="2">동행자
                            <xsl:if test="count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])>=2">
                            (<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='2' and @viewstate!='6']/partname"/>)
                            </xsl:if>
                          </td>
                          <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">동행자
                            <xsl:if test="count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])>=3">
                              (<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='3' and @viewstate!='6']/partname"/>)
                            </xsl:if>
                          </td>
                        </tr>
                        <tr style="height:24px">
                          <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                          <td class="f-lbl-sub" style="width:12%">지출사유</td>
                          <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                          <td class="f-lbl-sub" style="width:11%">지출사유</td>
                          <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                          <td class="f-lbl-sub" style="width:11%">지출사유</td>
                          <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                          <td class="f-lbl-sub" style="width:11%;border-right:0">지출사유</td>
                        </tr>
                        <xsl:apply-templates select="//forminfo/subtables/subtable10/row" mode="tbl1"/>
                        <tr>
                          <td class="f-lbl-sub" colspan="2">TOTAL</td>
                          <td class="tdRead_Right" style="border-bottom:0">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE))" />
                          </td>
                          <td>&nbsp;</td>
                          <td class="tdRead_Right" style="border-bottom:0">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C1))" />
                          </td>
                          <td>&nbsp;</td>
                          <td class="tdRead_Right" style="border-bottom:0">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C2))" />
                          </td>
                          <td>&nbsp;</td>
                          <td class="tdRead_Right" style="border-bottom:0">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C3))" />
                          </td>
                          <td style="border-right:0">&nbsp;</td>
                        </tr>
                      </table>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <xsl:if test="not($mode='new' or $mode='edit' or ($bizrole='동행자' and $actrole='_manager' and $partid!='')) and count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6']) &gt; 3">
                <tr>
                  <td>
                    <div class="ff" />
                    <div class="ff" />
                  </td>
                </tr>
                <tr>
                  <td colspan="3">
                    <table id="__subtable10" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                      <tr style="height:24px">
                        <td class="f-lbl-sub" style="width:4%;border-top:0" rowspan="2">&nbsp;</td>
                        <td class="f-lbl-sub" style="width:11%;border-top:0" rowspan="2">구분</td>
                        <td class="f-lbl-sub" style="border-top:0" colspan="2">동행자
                          <xsl:if test="count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])>=4">
                            (<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='4' and @viewstate!='6']/partname"/>)
                          </xsl:if>
                        </td>
                        <td class="f-lbl-sub" style="border-top:0" colspan="2">동행자
                          <xsl:if test="count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])>=5">
                            (<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='5' and @viewstate!='6']/partname"/>)
                          </xsl:if>
                        </td>
                        <td class="f-lbl-sub" style="border-top:0" colspan="2">동행자
                          <xsl:if test="count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])>=6">
                            (<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='6' and @viewstate!='6']/partname"/>)
                          </xsl:if>
                        </td>
                        <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">동행자
                          <xsl:if test="count(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @viewstate!='6'])>=7">
                            (<xsl:value-of select="//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @partid!='' and @step!='0' and @substep='7' and @viewstate!='6']/partname"/>)
                          </xsl:if>
                        </td>
                      </tr>
                      <tr style="height:24px">
                        <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                        <td class="f-lbl-sub" style="width:12%">지출사유</td>
                        <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                        <td class="f-lbl-sub" style="width:11%">지출사유</td>
                        <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                        <td class="f-lbl-sub" style="width:11%">지출사유</td>
                        <td class="f-lbl-sub" style="width:10%">금액(원)</td>
                        <td class="f-lbl-sub" style="width:11%;border-right:0">지출사유</td>
                      </tr>
                      <xsl:apply-templates select="//forminfo/subtables/subtable10/row" mode="tbl2" />
                      <tr>
                        <td class="f-lbl-sub" colspan="2">TOTAL</td>
                        <td class="tdRead_Right" style="border-bottom:0">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C4))" />
                        </td>
                        <td>&nbsp;</td>
                        <td class="tdRead_Right" style="border-bottom:0">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C5))" />
                        </td>
                        <td>&nbsp;</td>
                        <td class="tdRead_Right" style="border-bottom:0">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C6))" />
                        </td>
                        <td>&nbsp;</td>
                        <td class="tdRead_Right" style="border-bottom:0">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITEXPENSE_C7))" />
                        </td>
                        <td style="border-right:0">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </xsl:if>
            </table>
          </div>          

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>√특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:100px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:80px">
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
          <div class="ff" />
          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:395px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '5', '주관부서')"/>
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

        <!-- 양식 HIDDEN FIELD 정보 -->
        <input type="hidden" id="__mainfield" name="USEMONEY" value="{//forminfo/maintable/USEMONEY}" />
        <input type="hidden" id="__mainfield" name="USEMONEYDETAIL1" value="{//forminfo/maintable/USEMONEYDETAIL1}" />
        <input type="hidden" id="__mainfield" name="USEMONEYDETAIL2" value="{//forminfo/maintable/USEMONEYDETAIL2}" />
        <input type="hidden" id="__mainfield" name="USEMONEYDETAIL3" value="{//forminfo/maintable/USEMONEYDETAIL3}" />
        <input type="hidden" id="__mainfield" name="USEMONEYDETAIL4" value="{//forminfo/maintable/USEMONEYDETAIL4}" />
        <input type="hidden" id="__mainfield" name="USEMONEYDETAIL5" value="{//forminfo/maintable/USEMONEYDETAIL5}" />        
		  
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
                <input type="hidden" id="__mainfield"  name="TRIPPERSONDEPTID" value="{//creatorinfo/@deptid}" />
            </xsl:when>
            <xsl:otherwise>
                <input type="hidden" id="__mainfield"  name="TRIPPERSONDEPTID" value="{//forminfo/maintable/TRIPPERSONDEPTID}" />
            </xsl:otherwise>
        </xsl:choose>
        
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
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TRIPDAY" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{TRIPDAY}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TRIPDAY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>     
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VISITTO">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="VISITTO" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITTO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="BIZNOW">
              <xsl:attribute name="class">txtText</xsl:attribute>              
              <xsl:attribute name="value">
                <xsl:value-of select="BIZNOW" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BIZNOW))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="BIZPLAN">
              <xsl:attribute name="class">txtText</xsl:attribute>              
              <xsl:attribute name="value">
                <xsl:value-of select="BIZPLAN" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BIZPLAN))" />
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
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPECTEXPENSE">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="EXPECTEXPENSE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPECTEXPENSE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="AMOUNT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{AMOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(AMOUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CURRENCY" style="width:68px;height:16px">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="CURRENCY" />
              </xsl:attribute>
            </input>
            <!--<button onclick="parent.fnOption('iso.currency',160,140,60,100,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>-->
		    <button type="button" class="btn btn-outline-secondary btn-18" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',180,274,-100,0,'etc','CURRENCY');">
		        <i class="fas fa-angle-down"></i>
	        </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CURRENCY))" />&nbsp;
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
  <xsl:template match="//forminfo/subtables/subtable10/row" mode="tbl1">
    <tr class="sub_table_row">
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='동행자' and $actrole='_manager' and $partid!='')">
            <!--<input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />-->
            <input type="text" name="ROWSEQ" class="txtRead_Center" readonly="readonly" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='동행자' and $actrole='_manager' and $partid!='')">
            <input type="text" name="EXPENSECLASS" class="txtRead" readonly="readonly" maxlength="100">
              <xsl:attribute name="value">
                <xsl:choose>
                  <xsl:when test="ROWSEQ[.='1']">항공료</xsl:when>
                  <xsl:when test="ROWSEQ[.='2']">숙박료</xsl:when>
                  <xsl:when test="ROWSEQ[.='3']">접대비</xsl:when>
                  <xsl:when test="ROWSEQ[.='4']">교통비</xsl:when>
                  <xsl:when test="ROWSEQ[.='5']">식비</xsl:when>
                  <xsl:when test="ROWSEQ[.='6']">일비</xsl:when>
                  <xsl:when test="ROWSEQ[.='7']">기타</xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="EXPENSECLASS" />
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSECLASS))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <xsl:choose>
        <xsl:when test="$mode='new' or $mode='edit' or not(//processinfo/signline/lines/line[@bizrole='동행자' and @actrole='_manager' and @viewstate!='6'])">
          <td>
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
                <input type="text" name="EXPENSEAMOUNT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{EXPENSEAMOUNT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT))" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td style="border-right:0">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
                <input type="text" name="EXPENSEETC" class="txtText" maxlength="100" value="{EXPENSEETC}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC))" />
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </xsl:when>
        <xsl:when test="$bizrole='동행자' and $actrole='_manager' and $partid!=''">
          <xsl:variable name="expenseamount" select="concat('EXPENSEAMOUNT_C', string(//processinfo/signline/lines/line[@wid=$wid]/@substep))" />
          <xsl:variable name="expenseetc" select="concat('EXPENSEETC_C', string(//processinfo/signline/lines/line[@wid=$wid]/@substep))" />
          <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT))" /></td>
          <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC))" /></td>
          <td><input type="text" name="{$expenseamount}" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{phxsl:nodeText(current(), string($expenseamount))}" /></td>
          <td style="border-right:0"><input type="text" name="{$expenseetc}" class="txtText" maxlength="100" value="{phxsl:nodeText(current(), string($expenseetc))}" /></td>
        </xsl:when>
        <xsl:otherwise>
          <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT))" /></td>
          <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC))" /></td>
          <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C1))" /></td>
          <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C1))" /></td>
          <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C2))" /></td>
          <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C2))" /></td>
          <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C3))" /></td>
          <td style="border-right:0"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C3))" /></td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable10/row" mode="tbl2">
    <tr class="sub_table_row">
      <td class="tdRead_Center"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" /></td>
      <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSECLASS))" /></td>
      <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C4))" /></td>
      <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C4))" /></td>
      <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C5))" /></td>
      <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C5))" /></td>
      <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C6))" /></td>
      <td><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C6))" /></td>
      <td class="tdRead_Right"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEAMOUNT_C7))" /></td>
      <td style="border-right:0"><xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSEETC_C7))" /></td>
    </tr>
  </xsl:template>
  <xsl:template match="row" mode="companion-current">
    <tr class="sub_table_row">
      <td class="tdRead_Center"><input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" /></td>
      <td><input type="text" name="TRIPDAY" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{TRIPDAY}" /></td>
      <td><input type="text" name="VISITTO" class="txtText" maxlength="20" value="{VISITTO}" /></td>
      <td><input type="text" name="BIZNOW" class="txtText" maxlength="100" value="{BIZNOW}" /></td>
      <td style="border-right:0"><input type="text" name="BIZPLAN" class="txtText" maxlength="200" value="{BIZPLAN}" /></td>
    </tr>
  </xsl:template>
  <xsl:template match="row" mode="companion-read">
    <tr class="sub_table_row">
      <td class="tdRead_Center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
      </td>
      <td class="tdRead_Center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TRIPDAY))" />
      </td>
      <td>
        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITTO))" />
      </td>
      <td>
        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BIZNOW))" />
      </td>
      <td style="border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BIZPLAN))" />
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//processinfo/signline/lines/line">
    <div class="ff" />
    <div class="ff" />
    <div class="ff" />
    <div class="ff" />

    <div class="fm">
      <table border="0" cellspacing="0" cellpadding="0">
        <xsl:variable name="location" select="concat('LOCATION_C', string(@substep))" />
        <xsl:variable name="tripfrom" select="concat('TRIPFROM_C', string(@substep))" />
        <xsl:variable name="tripto" select="concat('TRIPTO_C', string(@substep))" />
        <xsl:variable name="purpose" select="concat('PURPOSE_C', string(@substep))" />
        <xsl:variable name="stay" select="concat('STAY_C', string(@substep))" />
        <xsl:variable name="day" select="concat('DAY_C', string(@substep))" />
        <xsl:choose>
          <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
            <tr>
              <td>
                <span>
                  √출장 동행자 출장계획 (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>&nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>)
              </span>
            </td>
            <td class="fm-button">
              <!--<button onclick="parent.fnAddChkRow('__subtable{@substep+2}');" onfocus="this.blur()" class="btn_bg">
                  <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                </button>
                <button onclick="parent.fnDelChkRow('__subtable{@substep+2}');" onfocus="this.blur()" class="btn_bg">
                  <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                </button>-->
			    <button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable{@substep+2}');">
		            <i class="fas fa-plus"></i>
	            </button>
	            <button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable{@substep+2}');">
		            <i class="fas fa-minus"></i>
	            </button>
              </td>
            </tr>
          </xsl:when>
          <xsl:otherwise>
            <tr>
              <td>
                <span>
                  √출장 동행자 출장계획 (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>&nbsp;&nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>)
                </span>
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <tr>
                <td class="f-lbl2" style="width:15%">출장지</td>
                <td style="width:19%">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <input type="text" id="__mainfield" name="{$location}" style="width:84%" class="txtText_u" readonly="readonly">
                        <xsl:attribute name="value">
                          <xsl:value-of select="phxsl:nodeText(//forminfo/maintable, string($location))"/>
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnView('external.centercode',300,180,80,140,'etc','LOCATION_C{@substep}');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                      </button>-->
					    <button type="button" class="btn btn-outline-secondary btn-18" title="출장지" onclick="_zw.formEx.optionWnd('external.centercode',300,180,80,140,'etc','LOCATION_C{@substep}');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nodeText(//forminfo/maintable, string($location), true)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="width:15%">출장기간</td>
                <td style="width:51%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <input type="text" id="__mainfield" name="{$tripfrom}" style="width:90px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd">
                        <xsl:attribute name="value">
                          <xsl:value-of select="phxsl:nodeText(//forminfo/maintable, string($tripfrom))"/>
                        </xsl:attribute>
                      </input>
                      &nbsp;~&nbsp;
                      <input type="text" id="__mainfield" name="{$tripto}" style="width:90px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd">
                        <xsl:attribute name="value">
                          <xsl:value-of select="phxsl:nodeText(//forminfo/maintable, string($tripto))"/>
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nodeText(//forminfo/maintable, string($tripfrom), true)"/>
                      <xsl:if test="phxsl:nodeText(//forminfo/maintable, string($tripfrom))!='' and phxsl:nodeText(//forminfo/maintable, string($tripto))!=''">
                        &nbsp;~&nbsp;
                      </xsl:if>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nodeText(//forminfo/maintable, string($tripto), true)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;(
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <input type="text" id="__mainfield" name="{$stay}" class="txtVolume" maxlength="3" data-inputmask="number;3;0" style="width:30px" value="{phxsl:nodeText(//forminfo/maintable, string($stay))}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nodeText(//forminfo/maintable, string($stay), true)" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;박&nbsp;
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <input type="text" id="__mainfield" name="{$day}" class="txtNumberic" maxlength="3" data-inputmask="number;3;0" style="width:30px" value="{phxsl:nodeText(//forminfo/maintable, string($day))}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nodeText(//forminfo/maintable, string($day), true)" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;일&nbsp;)
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="width:15%;border-bottom:0">출장목적</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <input type="text" id="__mainfield" name="{$purpose}" class="txtText" maxlength="100">
                        <xsl:attribute name="value">
                          <xsl:value-of select="phxsl:nodeText(//forminfo/maintable, string($purpose))"/>
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nodeText(//forminfo/maintable, string($purpose), true)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <table class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
              <xsl:attribute name="id">__subtable<xsl:value-of select="@substep+2"/></xsl:attribute>
              <xsl:if test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                <xsl:attribute name="active">Y</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:4%"></col>
                <col style="width:11%"></col>
                <col style="width:19%"></col>
                <col style="width:24%"></col>
                <col style="width:42%"></col>
              </colgroup>
              <tr style="">
                <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                <td class="f-lbl-sub" style="border-top:0" rowspan="2">일자</td>
                <td class="f-lbl-sub" style="border-top:0" rowspan="2">방문처</td>
                <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">출장업무 계획</td>
              </tr>
              <tr style="">
                <td class="f-lbl-sub" style="">현안</td>
                <td class="f-lbl-sub" style="border-right:0">출장 중 처리예정 업무</td>
              </tr>
              <xsl:choose>
                <xsl:when test="@substep='1'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable3/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable3/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@substep='2'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable4/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable4/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@substep='3'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable5/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable5/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@substep='4'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable6/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable6/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@substep='5'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable7/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable7/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@substep='6'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable8/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable8/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
                <xsl:when test="@substep='7'">
                  <xsl:choose>
                    <xsl:when test="@state='2' and @partid=string(//currentinfo/@uid) and @step!='0'">
                      <xsl:apply-templates select="//forminfo/subtables/subtable9/row" mode="companion-current" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:apply-templates select="//forminfo/subtables/subtable9/row" mode="companion-read" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:when>
              </xsl:choose>
            </table>
          </td>
        </tr>
      </table>
    </div>
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
