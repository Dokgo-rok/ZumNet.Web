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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:25%}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:20%;}
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
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:35%"></col>
                <col style="width:15%"></col>
                <col style="width:"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">신청구분</td>
                <td colspan="3" style="text-align:center;border-right:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbREQCLASS" value="제정">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbREQCLASS', this, 'REQCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REQCLASS),'제정')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REQCLASS),'제정')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">제정</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbREQCLASS" value="개정">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbREQCLASS', this, 'REQCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REQCLASS),'개정')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REQCLASS),'개정')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">개정</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbREQCLASS" value="폐지">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbREQCLASS', this, 'REQCLASS')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REQCLASS),'폐지')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/REQCLASS),'폐지')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">폐지</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="REQCLASS">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/REQCLASS"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">표준명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STDNAME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STDNAME" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="STDNAME" class="txtText" maxlength="50" value="{//forminfo/maintable/STDNAME}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDNAME))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">표준번호</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STDNUMBER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STDNUMBER" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="STDNUMBER" class="txtText" maxlength="50" value="{//forminfo/maintable/STDNUMBER}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STDNUMBER))" />
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1">제정 / 개정 / 폐지 사유</td>
                <td class="f-lbl1" style="border-right:0">주요 제정 / 개정 내용 요약</td>
              </tr>
              <tr>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:400px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="REASON" class="txaText" style="height:400px" onclick="parent.checkTextAreaLength(this, 1000)" >
                            <xsl:if test="$submode='revise'">
                              <xsl:value-of select="//forminfo/maintable/REASON" />
                            </xsl:if>
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="REASON" style="height:400px">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SUMMARY" style="height:400px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SUMMARY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="SUMMARY" class="txaText" style="height:400px" onclick="parent.checkTextAreaLength(this, 1000)" >
                            <xsl:if test="$submode='revise'">
                              <xsl:value-of select="//forminfo/maintable/SUMMARY" />
                            </xsl:if>
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="SUMMARY" style="height:400px">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUMMARY))" />
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

          <!--<div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td rowspan="3" class="f-lbl2" style="border-bottom:0">표준주관부서검토</td>
                <td class="f-lbl4" style="border-right:0">신청사항 적합성 검토</td>
              </tr>
              <tr>
                <td style="height:60px;border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//processinfo/signline/lines/line[@bizrole='receive' and @actrole='_redrafter' and @partid!='']/comment))" />
                </td>
              </tr>
              <tr>
                <td style="text-align:center;border-bottom:0;border-right:0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb21" name="ckbREVIEWKIND" value="7" disabled="disabled">
                      <xsl:if test="phxsl:isEqual(string(//processinfo/signline/lines/line[@bizrole='receive' and @actrole='_redrafter' and @partid!='']/@signstatus),'7')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">채택</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb22" name="ckbREVIEWKIND" value="8" disabled="disabled">
                      <xsl:if test="phxsl:isEqual(string(//processinfo/signline/lines/line[@bizrole='receive' and @actrole='_redrafter' and @partid!='']/@signstatus),'8')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">반려</label>
                  </span>
                </td>
              </tr>
            </table>
          </div>-->

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="text-align:left" >
                  <strong style="color:#f00;font-family:맑은고딕;">※심의자는 반려 기능 사용없이 심의의견 기재후 결재 바랍니다.</strong>
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <colgroup>
                <col style="width:7%" />
                <col style="width:18%" />
                <col style="width:10%" />
                <col style="width:13%" />
                <col style="width:" />                
              </colgroup>
              <tr>
                <td colspan="7"  class="f-lbl4" style="border-right:0">심 의 (검토 및 승인)</td>
              </tr>
              <tr>
                <td class="f-lbl4">구분</td>
                <td class="f-lbl4">부서 / 직책</td>
                <td class="f-lbl4">심의일자</td>
                <td class="f-lbl4">심의자 서명</td>
                <td class="f-lbl4"  style="border-right:0">의 견</td>                
              </tr>
              <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='receive' and (@actrole='_reviewer' or @actrole='_approver') and @partid!='']">
                <xsl:sort select="@step" />
              </xsl:apply-templates>
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

  <xsl:template match="//processinfo/signline/lines/line">
    <tr>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(@actrole),'_approver')">심의</xsl:when>
          <xsl:otherwise>검토</xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>/<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part5))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))"/>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(sign),'')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
          </xsl:when>
          <xsl:otherwise>
            <img style="width:44;height:45;border:0;" border="0">
              <xsl:attribute name="src">
                <xsl:value-of select="string(sign)" />
              </xsl:attribute>
            </img>
            <br />
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(comment))"/>
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