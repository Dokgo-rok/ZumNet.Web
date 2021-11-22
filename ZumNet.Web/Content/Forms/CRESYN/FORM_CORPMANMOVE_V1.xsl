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
          .m {width:1100px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:650px}}
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
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>               
                <td style="width:;font-size:1px">&nbsp;</td>
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:15%;border-bottom:0">
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
            <span>1. 법인명</span>
          </div>
          <div class="ff" />


          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">
                  <font size="4">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield" name="FACTORY" style="border:1px solid #f00;width:130px;height:30px;font-size:19px" onchange="parent.fnSelectChange(this);">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'')">
                              <option value="" selected="selected">선택하세요.</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택하세요.</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'CD')">
                              <option value="CD" selected="selected">CD</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="CD">CD</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'CT')">
                              <option value="CT" selected="selected">CT</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="CT">CT</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'CH')">
                              <option value="CH" selected="selected">CH</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="CH">CH</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'CL')">
                              <option value="CL" selected="selected">CL</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="CL">CL</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'IC')">
                              <option value="IC" selected="selected">IC</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="IC">IC</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'IS')">
                              <option value="IS" selected="selected">IS</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="IS">IS</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/FACTORY),'VH')">
                              <option value="VH" selected="selected">VH</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="VH">VH</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'CD')">CD</xsl:when>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'CT')">CT</xsl:when>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'CH')">CH</xsl:when>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'CL')">CL</xsl:when>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'IC')">IC</xsl:when>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'IS')">IS</xsl:when>
                          <xsl:when test="phxsl:isExist(string(//forminfo/maintable/FACTORY),'VH')">VH</xsl:when>
                          <xsl:otherwise>&nbsp;</xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>
                </font>
              </td>
            </tr>
          </table>
        </div>

        <div class="ff" />
        <div class="ff" />
        <div class="ff" />
        <div class="ff" />

        <div class="fm">
          <span>2. 적용일자</span>
        </div>
        <div class="ff" />


        <div class="fm">
          <table border="0" cellspacing="0" cellpadding="0">
            <tr>
              <td class="f-lbl" style="border-bottom:0">
                <font size="4">
                  <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="INPUTDATE" class="txtDate" maxlength="8" style="width:130px;height:30px;font-size:19px" onchange="parent.fnSelectChange(this)" value="{//forminfo/maintable/INPUTDATE}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INPUTDATE))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </font>
                </td>
              </tr>
            <input type="hidden" id="__mainfield" name="INPUTDATE2" class="txtDate" value="{//forminfo/maintable/INPUTDATE2}" />
            </table>
          </div>


          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">              
                  <tr>
                    <td>
                      <span>3. 인원현황</span>
                    </td>
                    <td class="fm-button">                                          
                    </td>
                  </tr>                                  
              <tr>
                <td>
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:80px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:60px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:60px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:60px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">법인명</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="5">현지관리자</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="5">원공</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="5">공장별합계</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="">필요인원(당일)</td>
                      <td class="f-lbl-sub" style="">출근인원(당일)</td>
                      <td class="f-lbl-sub" style="">출근율</td>
                      <td class="f-lbl-sub" style="" >입사인원(전일)</td>
                      <td class="f-lbl-sub" style="" >퇴사인원(전일)</td>
                      <td class="f-lbl-sub" style="">필요인원(당일)</td>
                      <td class="f-lbl-sub" style="">출근인원(당일)</td>
                      <td class="f-lbl-sub" style="">출근율</td>
                      <td class="f-lbl-sub" style="" >입사인원(전일)</td>
                      <td class="f-lbl-sub" style="" >퇴사인원(전일)</td>
                      <td class="f-lbl-sub" style="">필요인원(당일)</td>
                      <td class="f-lbl-sub" style="">출근인원(당일)</td>
                      <td class="f-lbl-sub" style="">출근율</td>
                      <td class="f-lbl-sub" style="" >입사인원(전일)</td>
                      <td class="f-lbl-sub" style="" >퇴사인원(전일)</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>                   
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
            <span>4. 특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="ETC" style="height:100px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/ETC" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="ETC" style="height:100px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETC))" />
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
            <input type="text" name="CORPERATE">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="CORPERATE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CORPERATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="HYUNNEED">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HYUNNEED" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HYUNNEED))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="HYUNWORK">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HYUNWORK" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HYUNWORK))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="HYUNPER">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HYUNPER" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HYUNPER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="HYUNIN">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HYUNIN" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HYUNIN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="HYUNOUT">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HYUNOUT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HYUNOUT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WONNEED">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WONNEED" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WONNEED))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WONWORK">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WONWORK" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WONWORK))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WONPER">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WONPER" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WONPER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WONIN">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WONIN" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WONIN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WONOUT">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WONOUT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WONOUT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GONGNEED">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="GONGNEED" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(GONGNEED))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GONGWORK">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="GONGWORK" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(GONGWORK))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GONGPER">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="GONGPER" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(GONGPER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GONGIN">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="GONGIN" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(GONGIN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GONGOUT">
              <xsl:attribute name="class">txtDollar</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="GONGOUT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(GONGOUT))" />
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
