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
          .m {width:716px} .m .fm-editor {height:500px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:20px} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%} .m .ft .f-option3 {width:50px}
          .m .ft-sub {border:1px solid windowtext;border-top:0}
          .m .ft-sub .ft-sub-sub td {border:0;border-right:windowtext 1pt dotted;border-bottom:windowtext 1pt dotted}
          .m .ft-sub .f-option {width:49%} .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

          /* 하위테이블 추가삭제 버튼 */
          .subtbl_div button {height:16px;width:16px}

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
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield" name="DOCCLASS" style="font-size:16pt;font-weight:bold">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'개발부품')">
                              <option value="개발부품" selected="selected">개발부품</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="개발부품">개발부품</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'양산부품')">
                              <option value="양산부품" selected="selected">양산부품</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="양산부품">양산부품</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCCLASS))" />
                      </xsl:otherwise>
                    </xsl:choose>                    
                    금형<xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield" name="REPAIRTYPE" style="font-weight:bold;font-size:16pt;letter-spacing:2pt">
                          <xsl:choose>
                            <xsl:when test="//forminfo/maintable/REPAIRTYPE[.='REPAIR']">
                              <option value="REPAIR" selected="selected">수리</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="REPAIR">수리</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="//forminfo/maintable/REPAIRTYPE[.='MODIFY']">
                              <option value="MODIFY" selected="selected">수정</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="MODIFY">수정</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:choose>
                          <xsl:when test="//forminfo/maintable/REPAIRTYPE[.='REPAIR']">수리</xsl:when>
                          <xsl:when test="//forminfo/maintable/REPAIRTYPE[.='MODIFY']">수정</xsl:when>
                          <xsl:otherwise>수리</xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>의뢰서</h1>
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
                <td style="width:325">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '의뢰부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:325px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '접수부서')"/>
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
                <td style="width:36%">
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
         
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">             
              <tr>
                <td class="f-lbl" style="width:150px">적용모델</td>
                <td style="border-right:0" colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" style="width:92%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MODELNAME" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,80,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                
              </tr>
              <tr>
                <td class="f-lbl"  style="width:150px;border-bottom:0">
                    대표품번
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNO" style="width:92%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ITEMNO" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,80,70,'','ITEMNO','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl"  style="width:150px;border-bottom:0">
                  대표품번 외 총 벌 수 
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REQCOUNT">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/REQCOUNT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <!--<div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="width:150px">금형수정 진행판단
                </td>
                <td style="border-right:0">
                  고객4M변경 무관:
                  <span class="f-option3">
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
                    <label for="ckb11">YES</label>
                  </span>
                  <span class="f-option3">
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
                    <label for="ckb12">NO</label>
                  </span>
                  (4M변경 최종승인 여부:
                  <span class="f-option3">
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
                    <label for="ckb11">YES</label>
                  </span>
                  <span class="f-option3">
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
                    <label for="ckb12">NO</label>
                  </span>
                  )
                </td>
              </tr>
              <tr>
                <td style="border-bottom:0;border-right:0;font-size:18;color:red;height:50px" colspan="2">
                  ※본 금형수리/수정 사항을 정확히 확인하였음
                  (
                  <span class="f-option3">
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
                    <label for="ckb11">YES</label>
                  </span>
                  <span class="f-option3">
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
                    <label for="ckb12">NO</label>
                  </span>
                  )
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
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>* 금형상세내역</span>
                    </td>
                    <td class="fm-button">
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
                      <span>* 금형상세내역</span>
                    </td>
                    <td class="fm-button">&nbsp;</td>
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
                  <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:96%"></col>
                    </colgroup>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
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

        <!-- Main Table Hidden Field 01 -->
        <input type="hidden" id="__mainfield" name="ITEMNAME">
          <xsl:attribute name="value">
            <xsl:value-of select="//forminfo/maintable/ITEMNAME" />
          </xsl:attribute>
        </input>        
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
      <td style="border:0;border-top:1px solid windowtext;border-right:1px dotted windowtext">
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
      <td style="border:0;border-top:1px solid windowtext;padding:0;height:232px">
        <table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
          <xsl:if test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">table-layout:</xsl:attribute>
          </xsl:if>
          <colgroup>
            <col style="width:12%"></col>
            <col style="width:8%"></col>
            <col style="width:11%"></col>
            <col style="width:8%"></col>
            <col style="width:11%"></col>
            <col style="width:12%"></col>
            <col style="width:38%"></col>
          </colgroup>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">금형번호</td>
            <td colspan="6" style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="TOOLINGNUMBER" style="width:39%">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="TOOLINGNUMBER" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnOpen('/BizForce/EA/ReportSheet.aspx?M=&amp;ft=REGISTER_TOOLING&amp;Lc=%uAE08%uD615%uB300%uC7A5',840,700,'resize','',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <a target="_blank">
                    <xsl:attribute name="href">
                      /<xsl:value-of select="$root"/>/EA/Forms/XFormMain.aspx?M=read&amp;xf=tooling&amp;fi=REGISTER_TOOLING&amp;mi=<xsl:value-of select="TOOLINGNUMBER"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                      <xsl:value-of select="TOOLINGNUMBER"/>
                    </xsl:attribute>
                    <xsl:value-of select="TOOLINGNUMBER"/>
                  </a>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">적용모델</td>
            <td colspan="4">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNO">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNO" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="MODELOID!=''">
                      <a target="_blank">
                        <xsl:attribute name="href">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(MODELOID))" />
                        </xsl:attribute>
                        <xsl:value-of select="MODELNO" />
                      </a>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="MODELOID">
                <xsl:attribute name="value">
                  <xsl:value-of select="MODELOID" />
                </xsl:attribute>
              </input>
            </td>
            <td class="f-lbl-sub">모델명</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="MODELNM">
                    <xsl:attribute name="class">txtRead</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MODELNM" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNM))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">부품</td>
            <td colspan="6" style="border-right:0">
              <div class="subtbl_div">
                <div>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="PARTNO1" style="width:250px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="PARTNO1" />
                        </xsl:attribute>
                      </input>&nbsp;(
                      <input type="text" name="PARTNM1" style="width:330px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="PARTNM1" />
                        </xsl:attribute>
                      </input>)
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="PARTOID1!=''">
                          <a target="_blank">
                            <xsl:attribute name="href">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PARTOID1))" />
                            </xsl:attribute>
                            <xsl:value-of select="PARTNO1" />
                          </a>&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNO1))" />&nbsp;(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM1))" />)
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" name="PARTOID1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="PARTOID1" />
                    </xsl:attribute>
                  </input>
                </div>              
              </div>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">제작처</td>
            <td colspan="4">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" id="__mainfield" name="MAKESUPPLIER" style="width:92%;border-bottom:0">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="MAKESUPPLIER" />
                    </xsl:attribute>
                  </input>                  
                </xsl:when>
                <xsl:otherwise>                  
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(MAKESUPPLIER))" />
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="MAKESUPPLIERID">
                <xsl:attribute name="value">
                  <xsl:value-of select="MAKESUPPLIERID" />
                </xsl:attribute>
              </input>
              <input type="hidden" name="MAKESUPPLIERSITEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="MAKESUPPLIERSITEID" />
                </xsl:attribute>
              </input>
            </td>
            <td class="f-lbl-sub">제작일자</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" id="__mainfield" name="TODATE" style="width:160px">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="TODATE" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(TODATE),'','')" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
         
          
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">CAVITY</td>
            <td class="f-lbl-sub" style="width:7%">사양</td>
            <td style="width:12%">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="CAVITYA" class="txtRead" style="width:30px" readonly="readonly" value="{CAVITYA}" />
                  *
                  <input type="text" name="CAVITY" class="txtRead" style="width:30px" readonly="readonly" value="{CAVITY}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITYA))" />
                  *
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CAVITY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub" style="width:7%">가용</td>
            <td style="width:12%">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="USABLECAVITYA" class="txtNumberic" style="width:30px" maxlength="3" value="{USABLECAVITYA}" />
                  *
                  <input type="text" name="USABLECAVITY" class="txtNumberic" style="width:30px" maxlength="3" value="{USABLECAVITY}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(USABLECAVITYA))" />
                  *
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(USABLECAVITY))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">양산처</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" id="__mainfield" name="STOREPLACE" style="width:92%;border-bottom:0">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">                      
                      <xsl:value-of select="STOREPLACE" />
                    </xsl:attribute>
                  </input>                  
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(STOREPLACE))" />                  
                </xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="STOREPLACEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="STOREPLACEID" />
                </xsl:attribute>
              </input>
              <input type="hidden" name="STOREPLACESITEID">
                <xsl:attribute name="value">
                  <xsl:value-of select="STOREPLACESITEID" />
                </xsl:attribute>
              </input>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">귀책구분</td>
            <td colspan="4">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <select name="REPAIRSETTLEMENT" style="width:100px">
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(REPAIRSETTLEMENT),'')">
                        <option value="" selected="selected">선택</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="">선택</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(REPAIRSETTLEMENT),'고객')">
                        <option value="고객" selected="selected">고객</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="고객">고객</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(REPAIRSETTLEMENT),'설계')">
                        <option value="설계" selected="selected">설계</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="설계">설계</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(REPAIRSETTLEMENT),'금형')">
                        <option value="금형" selected="selected">금형</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="금형">금형</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(REPAIRSETTLEMENT),'사출')">
                        <option value="사출" selected="selected">사출</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="사출">사출</option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </select>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REPAIRSETTLEMENT))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
            <td class="f-lbl-sub">희망완료일</td>
            <td style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="HOPEDATE">
                    <xsl:attribute name="class">txtDate</xsl:attribute>
                    <xsl:attribute name="style">width:80px</xsl:attribute>
                    <xsl:attribute name="maxlength">8</xsl:attribute>
                    <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="HOPEDATE" />
                    </xsl:attribute>
                  </input>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HOPEDATE))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">height:44px</xsl:attribute>
              </xsl:if>수정(리)사유
            </td>
            <td colspan="6" style="border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <textarea name="REPAIRREASON" style="height:40px">
                    <xsl:attribute name="class">txaText</xsl:attribute>
                    <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                    <xsl:if test="$mode='edit'">
                      <xsl:value-of select="REPAIRREASON" />
                    </xsl:if>
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div name="REPAIRREASON" style="height:40px">
                    <xsl:attribute name="class">txaRead</xsl:attribute>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REPAIRREASON))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:attribute name="style">border-bottom:0;height:44px</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style">border-bottom:0</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>수정(리)내용
            </td>
            <td colspan="6" style="border-bottom:0;border-right:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <textarea name="REPAIRDESCRIPTION" style="height:40px">
                    <xsl:attribute name="class">txaText</xsl:attribute>
                    <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                    <xsl:if test="$mode='edit'">
                      <xsl:value-of select="REPAIRDESCRIPTION" />
                    </xsl:if>
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div name="REPAIRDESCRIPTION" style="height:40px">
                    <xsl:attribute name="class">txaRead</xsl:attribute>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REPAIRDESCRIPTION))" />
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