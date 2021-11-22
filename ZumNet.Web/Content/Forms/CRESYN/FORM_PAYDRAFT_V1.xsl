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
  <xsl:variable name="submode" select="//config/@submode" />
  <xsl:variable name="partid" select="//config/@partid" />
  <xsl:variable name="bizrole" select="//config/@bizrole" />
  <xsl:variable name="actrole" select="//config/@actrole" />
  <xsl:variable name="root" select="//config/@root" />
  <xsl:variable name="mlvl" select="phxsl:modLevel(string(//config/@mode), string(//bizinfo/@docstatus), string(//config/@partid), string(//creatorinfo/@uid), string(//currentinfo/@uid), //processinfo/signline/lines)" />
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
          .m {width:800px} .m .fm-editor {height:400px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:5pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:6%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:500px}}
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
                <td style="width:308px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:236px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의부서', 'N')"/>
                </td>
                <td style="width:72px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:92px">
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
            <span>1. 제목</span>
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
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                        </xsl:otherwise>
                      </xsl:choose>
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
            <span>2. 비용지급사유</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="REASON" class="txaText" height="60px" onkeyup="parent.checkTextAreaLength(this, 1000)">
                            <xsl:value-of select="//forminfo/maintable/REASON" />
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="REASON" style="height:60px">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
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
                      <span>3. 비용지급내역</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:60px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>3. 비용지급내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;
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
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:120px"></col>
                      <col style="width:90px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:85px"></col>
                    </colgroup>
                    <tr style="height:40">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">비용내역</td>
                      <td class="f-lbl-sub" style="border-top:0">금액</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        부가세<br />(
                        <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="VATRATE" style="width:40px">
                            <xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="maxlength">10</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/VATRATE" />
                            </xsl:attribute>
                          </input>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="$mlvl='A' or $mlvl='B'">
                            <xsl:attribute name="id">___editable</xsl:attribute>
                          </xsl:if>
                          <xsl:choose>
                            <xsl:when test="$submode='revise'">
                              <input type="text" id="__mainfield" name="VATRATE" class="txtText" maxlengh="10"  value="{forminfo/maintable/VATRATE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VATRATE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>%)
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        관세<br />(
                        <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="TAFIFFRATE" style="width:40px">
                            <xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="maxlength">10</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/TAFIFFRATE" />
                            </xsl:attribute>
                          </input>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="$mlvl='A' or $mlvl='B'">
                            <xsl:attribute name="id">___editable</xsl:attribute>
                          </xsl:if>
                          <xsl:choose>
                            <xsl:when test="$submode='revise'">
                              <input type="text" id="__mainfield" name="TAFIFFRATE" class="txtText" style="width:40px" value="{forminfo/maintable/TAFIFFRATE}" />
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TAFIFFRATE))" />
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:otherwise>
                      </xsl:choose>%)
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">세액<br />합계</td>
                      <td class="f-lbl-sub" style="border-top:0;">지급일</td>
                      <td class="f-lbl-sub" style="border-top:0;">지급처</td>
                      <td class="f-lbl-sub" style="border-top:0;">결제<br />조건</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td colspan="2" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:if test="$mlvl='A' or $mlvl='B'">
                              <xsl:attribute name="id">___editable</xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                              <xsl:when test="$submode='revise'">
                                <input type="text" id="__mainfield" name="TOTALSUM" class="txtText" mexlengh="20" value="{forminfo/maintable/TOTALSUM}" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM))" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALVAT">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALVAT" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:if test="$mlvl='A' or $mlvl='B'">
                              <xsl:attribute name="id">___editable</xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                              <xsl:when test="$submode='revise'">
                                <input type="text" id="__mainfield" name="TOTALVAT" class="txtText" mexlengh="20" value="{forminfo/maintable/TOTALVAT}" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALVAT))" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALTARIFF">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALTARIFF" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:if test="$mlvl='A' or $mlvl='B'">
                              <xsl:attribute name="id">___editable</xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                              <xsl:when test="$submode='revise'">
                                <input type="text" id="__mainfield" name="TOTALTARIFF" class="txtText" mexlengh="20" value="{forminfo/maintable/TOTALTARIFF}" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALTARIFF))" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALTAX">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALTAX" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:if test="$mlvl='A' or $mlvl='B'">
                              <xsl:attribute name="id">___editable</xsl:attribute>
                            </xsl:if>
                            <xsl:choose>
                              <xsl:when test="$submode='revise'">
                                <input type="text" id="__mainfield" name="TOTALTAX" class="txtText" mexlengh="20" value="{forminfo/maintable/TOTALTAX}" />
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALTAX))" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="4" style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>4. 특기사항</span>
          </div>

          <div class="ff" />

          <div class="fm-editor">
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <xsl:if test="$mlvl='A' or $mlvl='B'">
                  <xsl:attribute name="id">___editable</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$submode='revise'">
                    <textarea id="bodytext" style="display:none">
                      <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                    </textarea>
                    <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx"></iframe>
                  </xsl:when>
                  <xsl:otherwise>
                    <div name="WEBEDITOR" id="__mainfield" class="txaRead" style="width:100%;height:100%;padding:4px 4px 4px 4px;position:relative">
                      <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$mode='edit'">
                  <textarea id="bodytext" style="display:none">
                    <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                  </textarea>
                </xsl:if>
                <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx"></iframe>
              </xsl:otherwise>
            </xsl:choose>
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
            <input type="text" name="COMMENT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COMMENT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="COMMENT" class="txtText" maxlength="100" value="{COMMENT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMMENT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="SUM" class="txtText" maxlength="20" value="{SUM}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VAT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="VAT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="VAT" class="txtText" maxlength="20" value="{VAT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VAT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TARIFF">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="TARIFF" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="TARIFF" class="txtText" maxlength="20" value="{TARIFF}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TARIFF))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TAXSUM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="TAXSUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="TAXSUM" class="txtText" maxlength="20" value="{TAXSUM}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TAXSUM))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PAYDATE">
              <xsl:attribute name="class">txtDate</xsl:attribute>
              <xsl:attribute name="maxlength">8</xsl:attribute>
              <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="PAYDATE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="PAYDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{PAYDATE}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PAYDATE))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PAYORGAN">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="PAYORGAN" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="PAYORGAN" class="txtText" maxlength="50" value="{PAYORGAN}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PAYORGAN))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SETTLEMENT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SETTLEMENT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="SETTLEMENT" class="txtText" maxlength="20" value="{SETTLEMENT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SETTLEMENT))" />
              </xsl:otherwise>
            </xsl:choose>
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
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="ETC" class="txtText" maxlength="50" value="{ETC}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
              </xsl:otherwise>
            </xsl:choose>
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
