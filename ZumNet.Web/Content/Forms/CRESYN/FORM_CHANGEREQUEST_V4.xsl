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
          .m {width:720px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:25%}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:24%;} .m .ft .f-option2 {width:9%;} .m .ft .f-option3 {width:20%;}  .m .ft .f-option4 {width:40%;}
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
                <td class="fh-r">
                  &nbsp;
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '요청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:470px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[(@bizrole='설계접수' or @bizrole='샘플제작' or @bizrole='샘플검토' or @bizrole='결과통보' or @bizrole='승인요청') and @partid!='' and @step!='0'], '__si_Receive', '6', '검토부서')"/>
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
                <td class="f-lbl" style="border-bottom:0">작성부서/작성자</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />&nbsp;/&nbsp;<xsl:value-of select="//creatorinfo/name" />
                </td>
                <td class="f-lbl" style="border-bottom:0">요청서 NO.</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:value-of select="//forminfo/maintable/CERTINO" />
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
                <td style="border-right:0;border-bottom:0;">
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
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span class="pl-2">* 요청사항</span>
          </div>
			<div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%" />
                <col style="width:35%" />
                <col style="width:15%" />
                <col style="width:" />
              </colgroup>
              <tr>
                <td class="f-lbl">변경종류</td>
                <td colspan="3" style="">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb11" name="ckbCHANGETYPE" value="제조조건변경">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGETYPE', this, 'CHANGETYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGETYPE),'제조조건변경')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGETYPE),'제조조건변경')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">제조조건 변경</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb12" name="ckbCHANGETYPE" value="설계사양변경">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGETYPE', this, 'CHANGETYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGETYPE),'설계사양변경')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGETYPE),'설계사양변경')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">설계사양 변경</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb13" name="ckbCHANGETYPE" value="기타1">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGETYPE', this, 'CHANGETYPE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGETYPE),'기타1')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGETYPE),'기타1')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">기타</label>
                  </span>
                  (<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ETCCHANGE" style="width:200px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ETCCHANGE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETCCHANGE))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="CHANGETYPE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHANGETYPE"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:30px">고객명</td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER" style="width:91%; margin-right: 2px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.customers',240,40,100,70,'','CUSTOMER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="고객명" onclick="_zw.formEx.externalWnd('erp.customers',240,40,100,70,'','CUSTOMER');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">모델명</td>
                <td style="text-align:center;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" style="width:92%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MODELNAME" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,20,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="고객명" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'','MODELNAME');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:30px">부품명</td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNM1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTNM1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PARTNM1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">부품번호</td>
                <td style="text-align:center;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNO1" style="width:91%; margin-right: 2px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTNO1" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm','PARTNO1','PARTNM1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="고객명" onclick="_zw.formEx.externalWnd('erp.items',240,40,136,74,'pdm','PARTNO1','PARTNM1');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PARTNO1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:30px">샘플제작여부</td>
                <td style="text-align:left;border-right:0" colspan="3">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbLASTCHECK" value="필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbLASTCHECK', this, 'LASTCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LASTCHECK),'필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/LASTCHECK),'필요')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">필요</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb32" name="ckbLASTCHECK" value="불필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbLASTCHECK', this, 'LASTCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LASTCHECK),'불필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/LASTCHECK),'불필요')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">불필요</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="LASTCHECK">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/LASTCHECK"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                  (샘플제작법인 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LASTTRIPFROM">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="style">display:none;width:280px</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LASTTRIPFROM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LASTTRIPFROM))" />
                    </xsl:otherwise>
                  </xsl:choose> )
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:80px">
                  검토 시<br />요구/주의사항<br />(본사품보팀<br />작성)
                </td>
                <td colspan="3" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='선행검토' and $partid!='' and phxsl:isEqual(string(//currentinfo/@deptcode),'A7100')">
                      <textarea id="__mainfield" name="SAMPLEREQUEST" class="txaText bootstrap-maxlength" maxlength="2000" style="min-height:75px">
                        <xsl:value-of select="//forminfo/maintable/SAMPLEREQUEST" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="SAMPLEREQUEST" class="txaRead">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SAMPLEREQUEST))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:40px">
                  변경요청<br></br>적용시점
                </td>
                <td style="text-align:left">
                  <span class="f-option4">
                    <input type="checkbox" id="ckb41" name="ckbCHANGEAPPLY" value="즉시">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEAPPLY', this, 'CHANGEAPPLY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEAPPLY),'즉시')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEAPPLY),'즉시')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">즉시</label>
                  </span>
                  <span class="f-option4">
                    <input type="checkbox" id="ckb42" name="ckbCHANGEAPPLY" value="RC">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEAPPLY', this, 'CHANGEAPPLY')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEAPPLY),'RC')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEAPPLY),'RC')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb42">R/C</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHANGEAPPLY">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHANGEAPPLY"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl">
                  변경통보서<br />
                  작성자
                </td>
                <td style="text-align:center;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="NEXTWORKERDEPT" class="txtRead" style="width:100px"  readonly="readonly" value="{//forminfo/maintable/NEXTWORKERDEPT}" />.
                      <input type="text" id="__mainfield" name="NEXTWORKER" class="txtRead" style="width:60px"  readonly="readonly" value="{//forminfo/maintable/NEXTWORKER}" />
                      <input type="hidden" id="__mainfield" name="NEXTWORKERID" value="{//forminfo/maintable/NEXTWORKERID}"></input>
                      <input type="hidden" id="__mainfield" name="NEXTWORKERDEPTID" value="{//forminfo/maintable/NEXTWORKERDEPTID}"></input>
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <!--<button onclick="parent.fnOrgmap('ur','N','NEXTWORKER');" onfocus="this.blur()" class="btn_bg" style="">
                          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                        </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="변경통보서 작성자" onclick="_zw.fn.org('user','n','NEXTWORKER');">
							  <i class="fas fa-angle-down"></i>
						  </button>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/NEXTWORKER), '')">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NEXTWORKERDEPT))" />.
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NEXTWORKER))" />
                      </xsl:if>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:40px">
                  이전사양변경<br></br>문서처리
                </td>
                <td colspan="3" style="text-align:left;border-right:0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb51" name="ckbCHANGEBEFORE" value="해당없음">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEBEFORE', this, 'CHANGEBEFORE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEBEFORE),'해당없음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEBEFORE),'해당없음')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb51">해당없음</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb52" name="ckbCHANGEBEFORE" value="폐기필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEBEFORE', this, 'CHANGEBEFORE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEBEFORE),'폐기필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEBEFORE),'폐기필요')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb52">폐기필요</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb53" name="ckbCHANGEBEFORE" value="회수필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEBEFORE', this, 'CHANGEBEFORE')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEBEFORE),'회수필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEBEFORE),'회수필요')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb53">회수필요</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHANGEBEFORE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHANGEBEFORE"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px">변경사유</td>
                <td colspan="3" style="text-align:left;border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbCHANGEREASON" value="원가절감">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEREASON),'원가절감')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEREASON),'원가절감')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">원가절감</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb22" name="ckbCHANGEREASON" value="품질향상">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEREASON),'품질향상')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEREASON),'품질향상')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">품질/생산성 향상</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb23" name="ckbCHANGEREASON" value="공정개선">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEREASON),'공정개선')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEREASON),'공정개선')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">공정개선</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb25" name="ckbCHANGEREASON" value="고객요청">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEREASON),'고객요청')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEREASON),'고객요청')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb25">고객요청</label>
                  </span>
                  <br></br>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb26" name="ckbCHANGEREASON" value="설계자체변경">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEREASON),'설계자체변경')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEREASON),'설계자체변경')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb26">설계자체변경</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb24" name="ckbCHANGEREASON" value="기타2">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEREASON),'기타2')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEREASON),'기타2')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">기타</label>
                  </span>
                  (<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ETCREASON" style="width:100px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ETCREASON" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETCREASON))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="CHANGEREASON">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHANGEREASON"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>

              <tr>
                <td class="f-lbl" style="border-bottom:0;height:150px">변경요청사항</td>
                <td colspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CHANGEREQUEST" style="min-height:140px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHANGEREQUEST" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="CHANGEREQUEST" style="min-height:140px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHANGEREQUEST))" />
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
				<span class="pl-2">* 사전회의사항</span>
			</div>
			<div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
                <col style="width:20%" />
              </colgroup>
              <tr>
                <td class="f-lbl" style="" rowspan="6">단계별 소요일수</td>
                <td class="f-lbl" style="">영업(선행검토)</td>
                <td class="f-lbl" style="">
                  본사QA(선행검토)
                </td>
                <td class="f-lbl" style="">
                  공장구매(선행검토)
                </td>
                <td class="f-lbl" style="">
                  본사설계(본설접수)
                </td>
              </tr>
              <tr>                
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW1" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW2" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW3" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW4" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>                
                <td class="f-lbl" style="">
                  해외설계(해설접수)
                </td>
                <td class="f-lbl" style="">
                  개발구매(구매검토)
                </td>
                <td class="f-lbl" style="">
                  공장기술(샘플제작)
                </td>
                <td class="f-lbl" style="">
                  공장QC(해품샘플)
                </td>
              </tr>
              <tr>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW5" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW6" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW7" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW8" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW8}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="">
                  본사QA(본품샘플)
                </td>
                <td class="f-lbl" style="">
                  주관설계(결과통보)
                </td>
                <td class="f-lbl" style="">
                  영업(승인요청)
                </td>
                <td class="f-lbl" style="">
                  총 소요일수
                </td>
              </tr>
              <tr>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW9" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW9}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW10" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW10}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW10))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVIEW11" class="txtVolume" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/REVIEW11}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REVIEW11))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="" style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTALREVIEW">
                        <xsl:attribute name="class">txtVolume</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTALREVIEW" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALREVIEW))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:100px">
                  관련제품/부품<br />재고처리 방법
                </td>
                <td style="text-align:center" colspan="4">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STOCKOUT" style="height:90px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/STOCKOUT" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="STOCKOUT" style="min-height:90px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STOCKOUT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:100px;border-bottom:0">샘플진행수량<br />(고객제출수량, <br />부서별 검토수량, <br />샘플 유무상 여부)
                </td>
                <td style="vertical-align:top;text-align:center;border-bottom:0;" colspan="4">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="NEEDSAMPLE" style="height:90px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/NEEDSAMPLE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="NEEDSAMPLE" style="min-height:9px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NEEDSAMPLE))" />
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
				<span class="pl-2">* 검토결과</span>
			</div>
			<div class="ff" />

          <div class="fm">
            <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <tr>
                <td class="f-lbl4" style="width:11%">구분</td>
                <td class="f-lbl4" style="width:20%">소속 / 성명</td>
                <td class="f-lbl4" style="width:14%">결재일자</td>
                <td class="f-lbl4" style="border-right:0;width:55%">검토의견 / 진행결과 요약</td>
              </tr>

              <xsl:apply-templates select="//processinfo/signline/lines/line[ (@bizrole='영업검토' or @bizrole='품보검토' or @bizrole='본설접수' or @bizrole='해설접수' or @bizrole='구매검토'  or @bizrole='해품샘플' or @bizrole='본품샘플' or @bizrole='결과통보' or @bizrole='승인요청') and (@actrole='_approver' or @actrole='_redrafter' or @actrole='_reviewer') and @partid!='']">
                <xsl:sort select="@completed" />
              </xsl:apply-templates>
            </table>
          </div>


          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

			<div class="fm">
				<span class="pl-2">* 내/외부 4M 진행 검토부서 의견</span>
			</div>
			<div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td >
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <colgroup>
                      <col width="4%" />
                      <col width="18%" />
                      <col width="23%" />
                      <col width="55%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">부서</td>
                      <td class="f-lbl-sub" style="border-top:0">구분</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">의견</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
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


  <xsl:template match="//processinfo/signline/lines/line">
    <tr>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@bizrole))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>/<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))"/>
      </td>
      <td style="border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(comment))"/>
      </td>
    </tr>
  </xsl:template>


  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="($bizrole!='normal') and $partid!='' and //currentinfo/@deptid=PTDPID">
                <input type="text" name="ROWSEQ" class="txtRead_Center"  readonly="readonly" value="{ROWSEQ}" />
              </xsl:when>
              <xsl:otherwise>
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
            <col width="56px" />
            <col width="109px" />
            <col width="" />
          </colgroup>
          <tr>
            <td class="f-lbl-sub" style="border:0;" >담당</td>
            <td style="border-top:0; text-align: center">
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.11"  name="ckbS5DCN1" value="고객4M">
                  <xsl:if test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'고객4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'고객4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label class="ml-2" for="ckb.5{ROWSEQ}.11">고객4M</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.12" name="ckbS5DCN1" value="내부4M">
                  <xsl:if test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'내부4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal') and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'내부4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label class="ml-2" for="ckb.5{ROWSEQ}.12">내부4M</label>
              </span>
              <input type="hidden" name="S5DCN1" value="{S5DCN1}" />
            </td>
            <td style="border:0;">
              <xsl:choose>
                <xsl:when test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                  <textarea name="S5OPN1" class="txaText bootstrap-maxlength" maxlength="500" style="height:96%;width:100%">
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
            <td class="f-lbl-sub" style="border-left:0; border-bottom:0">팀장</td>
            <td style="border-top:0;border-bottom:0; text-align: center">
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.21"  name="ckbS5DCN2" value="고객4M">
                  <xsl:if test="($bizrole!='normal') and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'고객4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'고객4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label class="ml-2" for="ckb.5{ROWSEQ}.21">고객4M</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.22" name="ckbS5DCN2" value="내부4M">
                  <xsl:if test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'내부4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'내부4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label class="ml-2" for="ckb.5{ROWSEQ}.22">내부4M</label>
              </span>
              <input type="hidden" name="S5DCN2" value="{S5DCN2}" />
            </td>
            <td style="vertical-align:top;border-right:0; border-bottom:0;">
              <xsl:choose>
                <xsl:when test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                  <textarea name="S5OPN2" class="txaText bootstrap-maxlength" maxlength="500" style="height:96%;width:100%">
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