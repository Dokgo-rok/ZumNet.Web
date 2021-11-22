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
          .m {width:720px} .m .fm-editor {height:500px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:15pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:25%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:550px}}
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
                    일반기안
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
                <td style="width:308px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[(@bizrole='normal' or (@bizrole='agree' and @partid='101546')) and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:308px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '4', '합의부서')"/>
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:21%"></col>
                <col style="width:15%"></col>
                <col style="width:17%"></col>
                <col style="width:15%"></col>
                <col style="width:17%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">문서번호</td>
                <td>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">구분</td>
                <td colspan="3" style="border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbDOCCLASS" value="품의">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'품의')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'품의')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">품의</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb12" name="ckbDOCCLASS" value="보고">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'보고')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'보고')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">보고</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbDOCCLASS" value="검토">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbDOCCLASS', this, 'DOCCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'검토')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/DOCCLASS),'검토')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">검토</label>
                  </span>
                </td>
                <input type="hidden" id="__mainfield" name="DOCCLASS">
                  <xsl:attribute name="value">
                    <xsl:value-of select="//forminfo/maintable/DOCCLASS"></xsl:value-of>
                  </xsl:attribute>
                </input>
              </tr>
              <tr>
                <td class="f-lbl" style="">기안부서</td>
                <td style="">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="">기안자</td>
                <td style="">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
                <td class="f-lbl">기안일자</td>
                <td style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">제목</td>
                <td style="border-right:0;border-bottom:0;" colspan="5">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
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

          <xsl:choose>
            <xsl:when test="$bizrole='의견' and $partid!=''">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:88px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <textarea id="__mainfield" name="CONTENTS" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CONTENTS" />
                        </xsl:if>
                      </textarea>
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:when test="$bizrole='last' or ($bizrole='의견' and $mode='read')">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:88px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENTS))" />
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>

          <div class="ff" />
          <div class="ff" />

          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <div class="fm">
                <table border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <div class="ff" />
                      <div class="ff" />
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table id="__subtable1" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                        <colgroup>
                          <col width="4%"></col>
                          <col width="21%"></col>
                          <col width="75%"></col>
                        </colgroup>
                        <tr style="height:24px">
                          <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="3">합의부서 및 합의요청사항</td>
                        </tr>
                        <tr style="height:24px">
                          <td class="f-lbl-sub">&nbsp;</td>
                          <td class="f-lbl-sub">합의부서</td>
                          <td class="f-lbl-sub" style="border-right:0">합의요청사항</td>
                        </tr>
                        <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                      </table>
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="//forminfo/subtables/subtable1/row/AGREEDEPT!='' and //bizinfo/@docstatus!='190' and //bizinfo/@docstatus!='700'">
                <div class="fm">
                  <table id="__subtable1" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <colgroup>
                      <col width="4%"></col>
                      <col width="21%"></col>
                      <col width="75%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="3">합의부서 및 합의요청사항</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">&nbsp;</td>
                      <td class="f-lbl-sub">합의부서</td>
                      <td class="f-lbl-sub" style="border-right:0">합의요청사항</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </div>
              </xsl:if>
            </xsl:otherwise>
          </xsl:choose>

          <div class="ff" />
          <div class="ff" />

          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
            </xsl:when>
            <xsl:otherwise>
              <div class="fm">
                <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
                  <colgroup>
                    <col style="width:10px" />
                    <col style="width:15px" />
                    <col style="width:75%" />
                  </colgroup>
                  <tr>
                    <td colspan="3"  class="f-lbl4" style="border-right:0">합의권자 의견</td>
                  </tr>
                  <xsl:apply-templates select="//processinfo/signline/lines/line[(@bizrole='agree' or @bizrole='confirm') and @partid!='']">
                    <!--<xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='confirm' and @partid!='']">-->
                    <xsl:sort select="@step" order="descending" />
                    <xsl:sort select="@substep" order="descending" />
                  </xsl:apply-templates>
                </table>
              </div>
            </xsl:otherwise>
          </xsl:choose>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
              </xsl:when>
              <xsl:otherwise>
                <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
                  <tr>
                    <td class="f-lbl" style="border-right:0;border-bottom:0">기안내용</td>
                  </tr>
                </table>
              </xsl:otherwise>
            </xsl:choose>
          </div>
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
            <!--<div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>-->
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
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="AGREEDEPT" class="txtText" maxlength="100" value="{AGREEDEPT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(AGREEDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="AGREEREQ" class="txtText" maxlength="100" value="{AGREEREQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(AGREEREQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>


  <!--<xsl:choose>
    <xsl:when test="phxsl:isEqual(string(@bizrole),'normal') or phxsl:isEqual(string(@bizrole),'샘플제작') or phxsl:isEqual(string(@bizrole),'샘플검토')  or phxsl:isEqual(string(@bizrole),'결과통보') ">-->

  <xsl:template match="//processinfo/signline/lines/line">
    <xsl:choose>
      <xsl:when test="phxsl:isEqual(string(comment),'11')">
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td style="text-align:center">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part5))"/>
          </td>
          <td style="text-align:center">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
          </td>
          <td style="border-right:0">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(comment))"/>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
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
