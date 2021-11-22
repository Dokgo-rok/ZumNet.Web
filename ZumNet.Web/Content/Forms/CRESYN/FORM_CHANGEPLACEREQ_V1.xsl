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
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:12%} .m .ft .f-lbl1 {width:8%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:50%}

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
              <tr>
                <td class="f-lbl" style="border-bottom:0">제목</td>
                <td style="border-right:0;border-bottom:0">
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
          <div class="ff" />

          <div class="fm">
            <span>변경요청</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%" />
                <col style="width:22%" />
                <col style="width:12%" />
                <col style="width:21%" />
                <col style="width:12%" />
                <col style="width:21%" />
                <col />
              </colgroup>              
              <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_approver') and @partid!='']">                
              </xsl:apply-templates>
              <tr>
                <td class="f-lbl">전생산지</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BEFOREPLACE" style="width:85%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BEFOREPLACE" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,120,130,100,'etc','BEFOREPLACE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BEFOREPLACE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">후생산지</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="AFTERPLACE" style="width:85%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/AFTERPLACE" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,120,130,100,'etc','AFTERPLACE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/AFTERPLACE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">완료요청일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REQDATE">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/REQDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:65px;border-bottom:0">요청사유</td>
                <td style="border-right:0;border-bottom:0" colspan="5">
                 <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQREASON" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/REQREASON" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REQREASON" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQREASON))" />
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
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
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>&nbsp;</span>
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
                <td>
                  <table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:30px"></col>
                      <col style="width:240px"></col>
                      <col style="width:230px"></col>                      
                      <col style="width:"></col>
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">품명</td>
                      <td class="f-lbl-sub" style="border-top:0">모델명</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">월별수주예상량</td>
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
            <span>고객사전승인</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
               <xsl:if test="$mode='new' or $mode='edit' or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%" />
                <col style="width:22%" />
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width:9%" />
                <col style="width:12%" />
                <col style="width:21%" />
                <col />
              </colgroup>
              <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='사전승인' and (@actrole='_approver') and @partid!='']">
              </xsl:apply-templates>
              <tr>
                <td class="f-lbl">생산지변경</td>
                <td style="text-align:center" colspan="2">                  
                  <span style="width:100px">
                    <input type="checkbox" id="ckb21" name="ckbPOSSIBLE" value="가능">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='사전승인' and $actrole='__r' and $partid!='') ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbPOSSIBLE', this, 'POSSIBLE')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/POSSIBLE),'가능')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>                          
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/POSSIBLE),'가능')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">가능</label>
                  </span>
                  <span style="width:100px">
                    <input type="checkbox" id="ckb22" name="ckbPOSSIBLE" value="불가능">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='사전승인' and $actrole='__r' and $partid!='')  ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbPOSSIBLE', this, 'POSSIBLE')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>                          
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/POSSIBLE),'불가능')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/POSSIBLE),'불가능')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">불가능</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="POSSIBLE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/POSSIBLE"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl">고객승인</td>
                <td style="text-align:center;border-right:0" colspan="3">
                  <span style="width:100px">
                    <input type="checkbox" id="ckb31" name="ckbCUSTOMEROK" value="필요">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='사전승인' and $actrole='__r' and $partid!='')  ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCUSTOMEROK', this, 'CUSTOMEROK')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CUSTOMEROK),'필요')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUSTOMEROK),'필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">필요</label>
                  </span>
                  <span style="width:100px">
                    <input type="checkbox" id="ckb32" name="ckbCUSTOMEROK" value="불필요">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='사전승인' and $actrole='__r' and $partid!='') ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCUSTOMEROK', this, 'CUSTOMEROK')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CUSTOMEROK),'불필요')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUSTOMEROK),'불필요')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">불필요</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CUSTOMEROK">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CUSTOMEROK"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr >
                <td class="f-lbl" style="border-bottom:0;height:40px">제출물</td>
                <td colspan="6"  style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='사전승인' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="SENDATA">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SENDATA" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SENDATA))" />                     
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>


      <!--    <div class="ff" />    배이사님 요청으로 인하여 변경
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>이수관진행요청</span>
          </div>

         <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width:18%" />
                <col style="width:12%" />
                <col style="width:17%" />
                <col style="width:12%" />
                <col style="width:17%" />
                <col />
              </colgroup>
              <tr>
                <td class="f-lbl" rowspan="2" style="border-bottom:0">
                  진행요청
                </td>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='진행요청' and (@actrole='_approver') and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td colspan="6" style="height:65px;border-right:0;border-bottom:0">
--><!--원래 필드명이 requestgo였었는데 알고보니 디비추가를 안시켜놓아서 이전에 만들어놓고 안쓰던 수관체크 땡껴씀 --><!--
                  <xsl:choose>
                    <xsl:when test="$bizrole='진행요청' and $actrole='__r'">
                      <textarea id="__mainfield" name="SUGWANCHECK" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/SUGWANCHECK" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="SUGWANCHECK" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUGWANCHECK))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>-->


          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>이수관협의 일정 및 기타의견</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width:16%" />
                <col style="width:12%" />
                <col style="width:19%" />
                <col style="width:12%" />
                <col style="width:17%" />                
                <col />
              </colgroup>
              <!--<tr>
                <td class="f-lbl" rowspan="2">
                  수관공장<br></br>검토
                </td>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='수관검토' and (@actrole='_approver') and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td colspan="6" style="height:65px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='수관검토' and $actrole='__r'">
                      <textarea id="__mainfield" name="SUGWANCHECK" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/SUGWANCHECK" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="SUGWANCHECK" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUGWANCHECK))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">
                  이관공장<br></br>검토
                </td>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='이관검토' and (@actrole='_approver') and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td colspan="6" style="height:65px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='이관검토' and $actrole='__r'">
                      <textarea id="__mainfield" name="YIGWANCHECK" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/YIGWANCHECK" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="YIGWANCHECK" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/YIGWANCHECK))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>-->
              <tr>
                <td class="f-lbl" rowspan="3"  style="">
                  이수관 일정<br>협의사항</br>
                </td>
                <!--<xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='자료송부' and @actrole='_approver' and @partid!='']">
                </xsl:apply-templates>             필요 없음으로 판단-->
              </tr>              
              <tr>
                <td class="f-lbl">이관</td>
                <td class="f-lbl">수관</td>
                <td class="f-lbl">시제품제작</td>
                <td class="f-lbl">신뢰성/환경검토</td>
                <td class="f-lbl">승인요청</td>
                <td class="f-lbl" style="border-right:0">승인완료</td>
              </tr>
              <tr>
                <td style="height:30px">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="CHECK1">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CHECK1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECK1))" />
                    </xsl:otherwise>
                  </xsl:choose>  
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="CHECK2">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CHECK2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECK2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="CHECK3">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CHECK3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECK3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="CHECK4">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CHECK4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECK4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="CHECK5">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CHECK5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECK5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="CHECK6">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CHECK6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECK6))" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:65px;border-bottom:0">
                  기타의견
                </td>
                <td colspan="5" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='자료송부' and $actrole='__r'">
                      <textarea id="__mainfield" name="MANAGECHECK" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/MANAGECHECK" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="MANAGECHECK" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MANAGECHECK))" />
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
            <span>수관공장 시제품검토결과</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:12%" />
                <col style="width:12%" />
                <col style="width:18%" />
                <col style="width:12%" />
                <col style="width:17%" />
                <col style="width:12%" />
                <col style="width:17%" />
                <col />
              </colgroup>
              <tr>
                <td class="f-lbl" rowspan="2">
                  시제품<br></br>제작검토
                </td>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='샘플제작' and (@actrole='_approver') and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td colspan="6" style="height:65px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='샘플제작' and $actrole='__r'">
                      <textarea id="__mainfield" name="MAKECHECK" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/MAKECHECK" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="MAKECHECK" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKECHECK))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">
                  신뢰성<br></br>환경검토
                </td>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='샘플검토' and (@actrole='_approver') and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td colspan="6" style="height:65px;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='샘플검토' and $actrole='__r'">
                      <textarea id="__mainfield" name="ENVIORCHECK" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/ENVIORCHECK" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="ENVIORCHECK" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENVIORCHECK))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0"  rowspan="2">
                  승인요청
                </td>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='결과통보' and (@actrole='_approver') and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td colspan="6" style="height:65px;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='결과통보' and $actrole='__r'">
                      <textarea id="__mainfield" name="REQUESTALLOW" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/REQUESTALLOW" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REQUESTALLOW" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTALLOW))" />
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
            <span>고객승인</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="width:12%">승인여부</td>
                <td style="text-align:center;border-right:0;width:88%">
                  <span style="width:100px">
                    <input type="checkbox" id="ckb41" name="ckbCUSTOMERCHECK" value="승인">
                      <xsl:choose>
                        <xsl:when test="$bizrole='승인요청' and $actrole='__r' and $partid !='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCUSTOMERCHECK', this, 'CUSTOMERCHECK')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>                          
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CUSTOMERCHECK),'승인')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUSTOMERCHECK),'승인')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">승인</label>
                  </span>
                  <span style="width:100px">
                    <input type="checkbox" id="ckb42" name="ckbCUSTOMERCHECK" value="불승인">
                      <xsl:choose>
                        <xsl:when test="$bizrole='승인요청' and $actrole='__r' and $partid !='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCUSTOMERCHECK', this, 'CUSTOMERCHECK')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CUSTOMERCHECK),'불승인')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUSTOMERCHECK),'불승인')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      </input>
                      <label for="ckb42">불승인</label>
                    </span>
                    <span style="width:100px">
                      <input type="checkbox" id="ckb43" name="ckbCUSTOMERCHECK" value="기타">
                        <xsl:choose>
                          <xsl:when test="$bizrole='승인요청' and $actrole='__r' and $partid !='' ">
                            <xsl:attribute name="onclick">parent.fnCheckYN('ckbCUSTOMERCHECK', this, 'CUSTOMERCHECK')</xsl:attribute>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CUSTOMERCHECK),'기타')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>                          
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CUSTOMERCHECK),'기타')">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                      </input>
                      <label for="ckb43">기타</label>
                    </span>
                  (<xsl:choose>
                    <xsl:when test="$bizrole='승인요청' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="DEVCLASSETC" style="width:200px">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCLASSETC" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEVCLASSETC))" />
                    </xsl:otherwise>
                  </xsl:choose>)
                  <input type="hidden" id="__mainfield" name="CUSTOMERCHECK">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CUSTOMERCHECK"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:65px;border-bottom:0">특기사항</td>
                <td style="text-align:center;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='승인요청' and $actrole='__r'">
                      <textarea id="__mainfield" name="CUSTOMERDETAIL" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/CUSTOMERDETAIL" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="CUSTOMERDETAIL" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMERDETAIL))" />
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
            <table>
              <tr>
                <td style="text-align:left;width:50%">
                  <span>마스터변경등록일</span>
                </td>
                <td style="text-align:left;width:50%">
                  <span>생산지변경통보서발행일</span>
                </td>
              </tr>
            </table>
          </div>
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0"> 
              <tr >
                <td style="border-bottom:0;width:50%">
                  <xsl:choose>
                    <xsl:when test="$bizrole='승인완료' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="MASTERDATE" >
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MASTERDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MASTERDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='승인완료' and $actrole='__r'">
                      <input type="text" id="__mainfield" name="PCNDATE" >
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100%</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PCNDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PCNDATE))" />
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
    <xsl:choose>      
      <xsl:when test="phxsl:isEqual(string(@bizrole),'normal') or phxsl:isEqual(string(@bizrole),'샘플제작') or phxsl:isEqual(string(@bizrole),'샘플검토')  or phxsl:isEqual(string(@bizrole),'결과통보') ">        
          <td class="f-lbl" style="">검토부서</td>
          <td style="text-align:center">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>
          </td>
          <td class="f-lbl" style="">검토자</td>
          <td style="text-align:center">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
          </td>
          <td class="f-lbl" style="">검토일</td>
          <td style="text-align:center;border-right:0">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))"/>
          </td>                  
      </xsl:when>
      <xsl:when test="phxsl:isEqual(string(@bizrole),'사전승인')">
        <tr>
          <td class="f-lbl" style="">검토부서</td>
          <td style="text-align:center">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>
          </td>
          <td class="f-lbl" style="">검토자</td>
          <td style="text-align:center" colspan="2">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
          </td>
          <td class="f-lbl" style="">검토일</td>
          <td style="text-align:center;border-right:0">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))"/>
          </td>
        </tr>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' ">
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
            <input type="text" name="ITEMNAME">
              <!--<xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>-->
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMNO" style="width:90%">
              <!--<xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>-->
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNO" />
              </xsl:attribute>
            </input>
            <button onclick="parent.fnExternal('erp.items',240,40,80,70,'',this,'ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
              </img>
            </button>
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>    
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FORCASTCOUNT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="FORCASTCOUNT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(FORCASTCOUNT))" />
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
