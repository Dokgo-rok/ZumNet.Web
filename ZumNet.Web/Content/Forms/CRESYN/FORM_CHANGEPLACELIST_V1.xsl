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
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:12%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
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
                <td style="width:165px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '2', '요청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td> 
                <td style="width:165px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, '이관공장', '__si_Receive', '2', '이관공장')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:165px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, '설계관리', '__si_Receive', '2', '설계관리')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:165px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, '수관공장', '__si_Receive', '2', '수관공장')"/>
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
                <col style="width:14%"></col>
                <col style="width:20%"></col>
                <col style="width:13%"></col>
                <col style="width:20%"></col>
                <col style="width:13%"></col>
                <col style="width:20%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl" style="">제목</td>
                <td style="border-right:0;" colspan="5">
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
              <tr>
                <td class="f-lbl" style="border-bottom:0">품명</td>
                <td  style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ITEMNAME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl"  style="border-bottom:0">모델명</td>
                <td  style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" style="width:84%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MODELNAME" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.items',240,40,40,20,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl"  style="border-bottom:0">고객명</td>
                <td  style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER" style="width:82%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnExternal('erp.customers',240,40,100,20,'','CUSTOMER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
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
                <td class="f-lbl" style="border-bottom:0">수관공장</td>
                <td style="width:35%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SUGWAN" style="width:91%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SUGWAN" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,120,130,100,'etc','SUGWAN');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUGWAN))" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </td>
                <td class="f-lbl" style="border-bottom:0">이관공장</td>
                <td style="border-right:0;width:35%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="YIGWAN" style="width:91%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/YIGWAN" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,120,130,100,'etc','YIGWAN');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/YIGWAN))" />
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
                      <span>&nbsp;</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit' or $mode='read'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:30px"></col>
                      <col style="width:200px"></col>
                      <col style="width:60px"></col>
                      <col style="width:60px"></col>
                      <col style="width:60px"></col>
                      <col style="width:60px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:25">
                      <td class="f-lbl-sub" rowspan="2" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" rowspan="2" style="border-top:0">요청 수관물(수관공장)</td>
                      <td class="f-lbl-sub" colspan="4" style="border-top:0">이관공장</td>
                      <td class="f-lbl-sub" style="border-top:0">설계관리</td>
                      <td class="f-lbl-sub" style="border-top:0">수관공장</td>                      
                      <td class="f-lbl-sub" rowspan="2" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub">이관여부</td>
                      <td class="f-lbl-sub">개정번호</td>                      
                      <td class="f-lbl-sub">개정일자</td>
                      <td class="f-lbl-sub">이관방법</td>
                      <td class="f-lbl-sub">본사확인</td>
                      <td class="f-lbl-sub">수관확인</td>
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
          <xsl:when test="($bizrole='이관공장' or $bizrole='수관공장' or $bizrole='설계관리') and $actrole='__r'">
            <input type="text" name="ROWSEQ">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
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
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item1', 'REQUESTDETAIL', string(REQUESTDETAIL), '100')" />
          </xsl:when>
          <xsl:when test="($bizrole='이관공장' or $bizrole='수관공장' or $bizrole='설계관리') and $actrole='__r'">
            <input type="text" name="REQUESTDETAIL">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REQUESTDETAIL" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REQUESTDETAIL))" />
          </xsl:otherwise>
        </xsl:choose>         
      </td>
      <td>
        <span style="width:55px;text-align:center" >
          <input type="checkbox" name="ckbYICHECK" value="PERIOD">
            <xsl:choose>
              <xsl:when test="$bizrole='이관공장' and $actrole='__r'">
                <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbYICHECK', this, 'YICHECK')</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="phxsl:isEqual(string(YICHECK),'PERIOD')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
          </input>
        </span>               
        <input type="hidden" name="YICHECK">
          <xsl:attribute name="value">
            <xsl:value-of select="YICHECK"></xsl:value-of>
          </xsl:attribute>
        </input>        
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='이관공장' and $actrole='__r'"> 
            <input type="text" name="REVNUM">
              <xsl:attribute name="class">txtText</xsl:attribute>              
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REVNUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="($bizrole='수관공장' or $bizrole='설계관리') and $actrole='__r'">
            <input type="text" name="REVNUM">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REVNUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
             <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REVNUM))" />             
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='이관공장' and $actrole='__r'">
            <input type="text" name="REVDATE">
              <xsl:attribute name="class">txtDate</xsl:attribute>
              <xsl:attribute name="maxlength">8</xsl:attribute>
              <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REVDATE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="($bizrole='수관공장' or $bizrole='설계관리') and $actrole='__r'">
            <input type="text" name="REVDATE">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REVDATE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REVDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='이관공장' and $actrole='__r'">
            <input type="text" name="HOWTO">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HOWTO" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="($bizrole='수관공장' or $bizrole='설계관리') and $actrole='__r'">
            <input type="text" name="HOWTO">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="HOWTO" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(HOWTO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='설계관리' and $actrole='__r'">
            <input type="text" name="CHECKRESULT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="CHECKRESULT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="($bizrole='수관공장' or $bizrole='이관공장') and $actrole='__r'">
            <input type="text" name="CHECKRESULT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="CHECKRESULT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CHECKRESULT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='수관공장' and $actrole='__r'">
            <input type="text" name="SUGWANRESULT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUGWANRESULT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="($bizrole='설계관리' or $bizrole='이관공장') and $actrole='__r'">
            <input type="text" name="SUGWANRESULT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUGWANRESULT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUGWANRESULT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <input type="text" name="ETC" value="ETC">
          <xsl:choose>
            <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item3', '')='필수' or string(ETC)='필수'">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">필수</xsl:attribute>
              <xsl:attribute name="style">color:red;text-align:center;font-weight:bold</xsl:attribute>
            </xsl:when>
            <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item3', '')='해당시' or string(ETC)='해당시'">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">해당시</xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="class">txtText</xsl:attribute>
              </xsl:if>
              <xsl:if test="$mode!='new' and $mode!='edit'">
                <xsl:attribute name="class">txtRead</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
              </xsl:if>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
              <xsl:attribute name="style">text-align:center</xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>                
        </input> 
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
