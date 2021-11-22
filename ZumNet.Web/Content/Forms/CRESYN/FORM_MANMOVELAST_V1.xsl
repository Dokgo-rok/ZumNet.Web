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
          .m {width:720px} .m .fm-editor {height:150px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:3pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:25%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:150px}}
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

          <div class="fm-editor">
            <xsl:choose>
              <xsl:when test="$mode='read'" >
                <div name="WEBEDITOR" id="__mainfield" style="width:100%;height:100%;padding:4px 4px 4px 4px;position:relative">
                  <xsl:attribute name="class">txaRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$mode='edit' ">
                  <textarea id="bodytext" style="display:none">
                    <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                  </textarea>
                </xsl:if>
                <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no">
                  <xsl:attribute name="src">
                    /<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx
                  </xsl:attribute>
                </iframe>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>&nbsp;종합평가</span>
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
                    <td colspan="2">
                      <span>&nbsp;종합평가</span>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td colspan="2">
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:180px"></col>
                      <col style="width:140px"></col>
                      <col style="width:110px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                    </colgroup>
                    <tr style="height:25">
                      <td class="f-lbl-sub" style="width:20px;border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">부서</td>
                      <td class="f-lbl-sub" style="border-top:0">직급</td>
                      <td class="f-lbl-sub" style="border-top:0">성명</td>
                      <td class="f-lbl-sub" style="border-top:0">등급</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">조정등급</td>
                    </tr>
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
      <td style="height:50px">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($actrole='_approver' and $bizrole='normal' and $partid !='')">
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
      <td  style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DEPT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DEPT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <input type="text" name="DEPT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DEPT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td  style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="LOCATION">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="LOCATION" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <input type="text" name="LOCATION">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="LOCATION" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(LOCATION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td  style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="NAME">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="NAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <input type="text" name="NAME">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="NAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(NAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <select name="STANDARD" style="font-size:20px;height:40pxwidth:90px">
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(STANDARD),'')">
                  <option value="" selected="selected">선택</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="">선택</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(STANDARD),'S')">
                  <option value="S" selected="selected">S</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="S">S</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(STANDARD),'A')">
                  <option value="A" selected="selected">A</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="A">A</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(STANDARD),'B')">
                  <option value="B" selected="selected">B</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="B">B</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(STANDARD),'C')">
                  <option value="C" selected="selected">C</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="C">C</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(STANDARD),'D')">
                  <option value="D" selected="selected">D</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="D">D</option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </xsl:when>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <input type="text" name="STANDARD">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px;text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="STANDARD" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(STANDARD))" />
          </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="STANDARD">
              <xsl:attribute name="class">txtVolume</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px;width:90px</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="STANDARD" />
              </xsl:attribute>
            </input>            
          </xsl:when>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <input type="text" name="STANDARD">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px;text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="STANDARD" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(STANDARD))" />
          </xsl:otherwise>
        </xsl:choose>-->
      </td>
      <td style="text-align:center;border-right:0">
        <!--<xsl:choose>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <input type="text" name="CHANGE">
              <xsl:attribute name="class">txtVolume</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="style">font-size:20px;height:40px;width:90px;text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="CHANGE" />
              </xsl:attribute>
            </input>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CHANGE))" />
          </xsl:otherwise>
        </xsl:choose>-->
        <xsl:choose>
          <xsl:when test="$actrole='_approver' and $bizrole='normal' and $partid !=''">
            <select name="CHANGE" style="font-size:20px;height:60px;width:90px;text-align:center">
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(CHANGE),'')">
                  <option value="" selected="selected">선택</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="">선택</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(CHANGE),'S')">
                  <option value="S" selected="selected">S</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="S">S</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(CHANGE),'A')">
                  <option value="A" selected="selected">A</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="A">A</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(CHANGE),'B')">
                  <option value="B" selected="selected">B</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="B">B</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(CHANGE),'C')">
                  <option value="C" selected="selected">C</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="C">C</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(CHANGE),'D')">
                  <option value="D" selected="selected">D</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="D">D</option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CHANGE))" />
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
