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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

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
                <td style="width:325">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:325px">
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
                <td style="border-bottom:0;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div align="left">
            <font size="2">제목</font>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0;">
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
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div align="left">
            <font size="2">요청사항</font>
          </div>

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
                <td class="f-lbl" style="height:30px">변경종류</td>
                <td colspan="3" style="text-align:left;border-right:0">
                  제조조건 변경                  
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:30px">샘플제작여부</td>
                <td style="text-align:left;border-right:0" colspan="3">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbLASTCHECK" value="필요">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbLASTCHECK', this, 'LASTCHECK')</xsl:attribute>
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
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbLASTCHECK', this, 'LASTCHECK')</xsl:attribute>
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
                    <xsl:when test="$bizrole='품보검토'">
                      <textarea id="__mainfield" name="SAMPLEREQUEST" style="height:75px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/SAMPLEREQUEST" />
                        <!--<xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SAMPLEREQUEST" />
                        </xsl:if>-->
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="SAMPLEREQUEST" style="height:75px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
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
                <td style="text-align:left;border-right:0" colspan="3">
                  <span class="f-option4">
                    <input type="checkbox" id="ckb41" name="ckbCHANGEAPPLY" value="즉시">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEAPPLY', this, 'CHANGEAPPLY')</xsl:attribute>
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
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEAPPLY'모, this, 'CHANGEAPPLY')</xsl:attribute>
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
              </tr>
              <tr>
                <td class="f-lbl" style="height:40px">
                  이전사양변경<br></br>문서처리
                </td>
                <td colspan="3" style="text-align:left;border-right:0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb51" name="ckbCHANGEBEFORE" value="해당없음">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEBEFORE', this, 'CHANGEBEFORE')</xsl:attribute>
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
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEBEFORE', this, 'CHANGEBEFORE')</xsl:attribute>
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
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEBEFORE', this, 'CHANGEBEFORE')</xsl:attribute>
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
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
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
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
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
                    <input type="checkbox" id="ckb25" name="ckbCHANGEREASON" value="고객요청">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
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
                  <span class="f-option2">
                    <input type="checkbox" id="ckb24" name="ckbCHANGEREASON" value="기타2">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEREASON', this, 'CHANGEREASON')</xsl:attribute>
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
                      <textarea id="__mainfield" name="CHANGEREQUEST" style="height:145px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHANGEREQUEST" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="CHANGEREQUEST" style="height:145px">
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <font size="2">변경항목</font>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.importFile();" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_42.gif" />가져오기
                      </button>
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnCopyChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />복사
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
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
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:130px"></col>
                      <col style="width:130px"></col>
                      <col style="width:130px"></col>
                      <col style="width:100px"></col>                      
                      <col style="width:px"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="width:20px;border-top:0" >NO</td>
                      <td class="f-lbl-sub" style="border-top:0;" >모델명</td>
                      <td class="f-lbl-sub" style="border-top:0;" >품번</td>
                      <td class="f-lbl-sub" style="border-top:0;" >품명</td>
                      <td class="f-lbl-sub" style="border-top:0" >요청서NO</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" >설계담당자</td>                      
                    </tr>                    
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div align="left">
            <font size="2">검토결과</font>
          </div>

          <div class="fm">
            <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <tr>
                <td class="f-lbl4" style="width:11%">구분</td>
                <td class="f-lbl4" style="width:15%">소속 / 성명</td>
                <td class="f-lbl4" style="width:10%">결재일자</td>
                <td class="f-lbl4" style="border-right:0;width:64%">검토의견 / 진행결과 요약</td>
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

          <div align="left">
            <font size="2">내/외부 4M 진행 검토부서 의견</font>
          </div>

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td >
                  <table id="__subtable2" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <colgroup>
                      <col width="4%" />
                      <col width="18%" />
                      <col width="24%" />
                      <col width="54%" />
                    </colgroup>
                    <tr style="height:22px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">부서</td>
                      <td class="f-lbl-sub" style="border-top:0">구분</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">의견</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
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

        <div id="Guide_Desc" style="display:none"></div>

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
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td >
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MODELNAME" class="txtText_u" readonly="readonly"  style="width:85%" value="{MODELNAME}" />
            <button onclick="parent.fnExternal('erp.items',240,40,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td >
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PARTNO" class="txtText_u" readonly="readonly"  style="width:85%" value="{PARTNO}" />
            <button onclick="parent.fnExternal('erp.items',240,40,80,70,'',this,'PARTNM');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td >
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PARTNM" class="txtRead" readonly="readonly" value="{PARTNM}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td >
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CERTINO" class="txtRead" readonly="readonly" value="{CERTINO}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CERTINO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0" >
        <!--<xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="NEXTWORKERINFO" class="txtText_u" readonly="readonly" style="width:89%" />
            <button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(NEXTWORKERINFO))" />
          </xsl:otherwise>
        </xsl:choose>-->
        <input type="text" name="NEXTWORKERINFO" class="txtText_u" readonly="readonly" style="width:89%" />
        <button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
        </button>
        <input type="hidden" name="NEXTWORKER"  value="{NEXTWORKER}"  />
        <input type="hidden" name="NEXTWORKERID"  value="{NEXTWORKERID}"  />
        <input type="hidden" name="NEXTWORKERDEPT"  value="{NEXTWORKERDEPT}"  />
        <input type="hidden" name="NEXTWORKERDEPTID"  value="{NEXTWORKERDEPTID}"  />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
      <td>
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
            <col width="105px" />
            <col width="" />
          </colgroup>
          <tr>
            <td class="f-lbl-sub" style="border-top:0" >담당</td>
            <td style="border-top:0;">
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.11"  name="ckbS5DCN1" value="고객4M">
                  <xsl:if test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'고객4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'고객4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.11">고객4M</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.12" name="ckbS5DCN1" value="내부4M">
                  <xsl:if test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN1', this, 'S5DCN1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN1),'내부4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal') and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN1),'내부4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.12">내부4M</label>
              </span>
              <input type="hidden" name="S5DCN1" value="{S5DCN1}" />
            </td>
            <td style="vertical-align:top;border-top:0;border-right:0">
              <xsl:choose>
                <xsl:when test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
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
                <input type="checkbox" id="ckb.5{ROWSEQ}.21"  name="ckbS5DCN2" value="고객4M">
                  <xsl:if test="($bizrole!='normal') and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'고객4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'고객4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.21">고객4M</label>
              </span>
              <br />
              <span class="f-option1">
                <input type="checkbox" id="ckb.5{ROWSEQ}.22" name="ckbS5DCN2" value="내부4M">
                  <xsl:if test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
                    <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbS5DCN2', this, 'S5DCN2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(S5DCN2),'내부4M')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="not (($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID) and phxsl:isDiff(string(S5DCN2),'내부4M')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb.5{ROWSEQ}.22">내부4M</label>
              </span>
              <input type="hidden" name="S5DCN2" value="{S5DCN2}" />
            </td>
            <td style="vertical-align:top;border-right:0">
              <xsl:choose>
                <xsl:when test="($bizrole!='normal' ) and $partid!='' and //currentinfo/@deptid=PTDPID">
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
