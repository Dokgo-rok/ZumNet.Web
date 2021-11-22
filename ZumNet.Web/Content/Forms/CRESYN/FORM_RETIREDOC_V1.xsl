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
          .fh h1 {font-size:20.0pt;letter-spacing:5pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:18%;height:30px} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

          .m .ft td,.m .ft td span {font-family:굴림}

          /* 인쇄 설정 : 맨하단으로  , 결재권자창 인쇄 시 안보임 */
          @media print {.m .fm-editor {height:450px} .m .fh {padding-top:40px} #panPage {page-break-before:always}}
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
                        <xsl:when test="$mode='read'"><xsl:value-of select="//forminfo/maintable/LOGOPATH" /></xsl:when>
                        <xsl:otherwise>/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </img>
                </td>
                <td class="fh-m">
                  <h1>사직서</h1>
                </td>
                <td class="fh-r">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="height:30px;border:0px solid red">
                    <tr>
                      <td style="width:50%;text-align:right;font-size:15px;border:0">&nbsp;</td>
                      <td style="text-align:right;font-size:14px;border:0">
                        &nbsp;
                      </td>
                    </tr>
                  </table>
                </td>
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
          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:420px">
                  <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'distribution', '__si_Distribution', '5', '총무부서')"/>-->
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '5', '총무부서')"/>
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
                <td class="f-lbl">소 속</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/department" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">사 번</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/empno" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">성 명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANT">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/name" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>                    
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />
                    </xsl:otherwise>  
                  </xsl:choose>
                </td>
                <td class="f-lbl">주민등록번호</td>
                <td style="border-right:0;text-align:left">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="JUMINNO">
                        <xsl:attribute name="class">txtJuminDash</xsl:attribute>
                        <xsl:attribute name="maxlength">14</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/JUMINNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JUMINNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">주 소</td>
                <td colspan="3" style="border-right:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ADDRESS">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ADDRESS" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ADDRESS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>                           
              <tr>
                <td class="f-lbl">근 무 기 간</td>
                <td>                  
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <xsl:value-of select="substring(string(//creatorinfo/indate),1,4)" /> -
                      <xsl:value-of select="substring(string(//creatorinfo/indate),6,2)" /> -
                      <xsl:value-of select="substring(string(//creatorinfo/indate),9,2)" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(string(//forminfo/maintable/INDATE),1,4)" /> -
                      <xsl:value-of select="substring(string(//forminfo/maintable/INDATE),6,2)" /> -
                      <xsl:value-of select="substring(string(//forminfo/maintable/INDATE),9,2)" />
                    </xsl:otherwise>
                  </xsl:choose>
                  ~ 
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TODATE" class="txtDate" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)"  maxlength="8" style="width:80px" value="{//forminfo/maintable/TODATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TODATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="hidden" id="__mainfield" name="INDATE">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/indate" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="INDATE">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INDATE" />
                        </xsl:attribute>  
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                 <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="REQUESTDATE">
                        <xsl:attribute name="value">
                          <xsl:value-of select="substring(string(//docinfo/createdate),1,10)" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="REQUESTDATE">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/REQUESTDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">연락처</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TELLNUM">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TELLNUM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TELLNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td colspan="4" class="f-lbl4" style="font-size:15px;border-right:0">사 유</td>                
              </tr>
              <tr>
                <td colspan="4" style="border-right:0;border-bottom:0">
                  상기 본인은 다음의 사유로 인하여 사직코져 하오니 재가하여 주시기 바립니다.
                </td>
              </tr>
              <tr>
                <td colspan="4" style="height:200px;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CAUSE" style="height:200px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" >
                        <xsl:value-of select="//forminfo/maintable/CAUSE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CAUSE" style="height:200px;padding:2px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CAUSE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>

           <table>
              <tr>
                <td colspan="5" style="border-bottom;0;text-align:center;border-right:0;font-size:20;height:50px">
                  <b>크레신 주식회사 귀하</b>
                </td>
              </tr>               
            </table>
          </div>
          
          
          
          <div class="ff" style="page-break-before:always;display:block;height:0;line-height:0" />

          <div id="" style="">
            <table  border="0" cellspacing="0" cellpadding="0" style="">
              <tr>
                <td style="font-size:25px;height:80px;text-align:center;">
                  <b>
                    영업비밀 보호 준수 서약서<br />
                    ( 퇴사자용 )
                  </b>
                </td>
              </tr>
              <tr>
                <td style="height:30px">
                  &nbsp;
                </td>
              </tr>
              <tr>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANT3">
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="style">border:0;width:80px;text-align:right</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/name" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <font size="3">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    (이하 甲이라 한다)는 크레신주식회사(이하 乙이라한다)를 퇴사하면서<br />
                    아래사항을 이행하기로 하고, 만약 이행하지 않을 때에는 민사▪형사상의 책임을 지기로 하고<br />
                    본 서약서를 乙에게 제출한다.
                  </font>
                </td>
              </tr>
              <tr>
                <td style="height:30px">
                  &nbsp;
                </td>
              </tr>
              <tr>
                <td style="text-align:center;height:40px">
                  -아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래-
                </td>
              </tr>
              <tr>
                <td style="height:300px;text-valign:top">
                  1. 甲은 퇴직일로부터 2년이내 동업종 경쟁업체에 취업하지 아니한다.<br /><br />
                  2. 가. 甲은 乙에게 고용되어 재직한 기간중에 지득한 영업비밀 및 보안사항을 제 3자에게<br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;누설하지 아니한다.<br />
                  &nbsp;&nbsp;&nbsp;&nbsp;나. 甲은 퇴직일로부터 2년간 乙에게 고용되어 재직한 기간 중에 지득한 영업비밀을<br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이용하기 위한 목적으로 창업하거나, 경쟁사에 전직,동업,고문,자문,기타 협력의 지위<br />
                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;를 가질 수 없다.<br /><br />
                  3. 기타 甲은 乙의 영업비밀 유지를 위한 법적▪도덕적 의무를 성실히 이행한다.<br /><br />
                  4. 만약 甲이 본 서약서를 위반하는 등의 행위로 乙에게 손해를 끼쳤을 경우에 甲은 乙이<br />
                  &nbsp;&nbsp;&nbsp;&nbsp;입은 일체의 손해를 배상할 책임을 진다.
                </td>
              </tr>
              <tr>
                <td style="border-bottom;0;text-align:right;border-right:0;height:150px;font-size:17px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),9,2)" />일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),9,2)" />일&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
            <table>
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:65%"></col>
                <col style="width:35%"></col>
              </colgroup>
              <tr>
                <td style="width:65%;text-align:right">소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속:</td>
                <td style="text-align:left;height:35px;width:35%">                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="POSITION">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="style">width:150px</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/POSITION" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/POSITION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="width:65%;text-align:right" valign="bottom" >성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명:</td>
                <td style="text-align:left;height:30px;width:35%" valign="bottom">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THENAME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="style">width:150px</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/THENAME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THENAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                  <span style="width:30px;border:0px solid green">
                    <img alt="" width="30px" style="margin:0;vertical-align:top" src="/Storage/{//config/@companycode}/Sign/{//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_drafter') and @partid!='']/part2}.jpg" />
                  </span>
                  </xsl:if>
                </td>
              </tr>
              <tr>
                <td style="width:65%;text-align:right">주민등록번호:</td>
                <td style="border-right:0;text-align:left;height:55px;width:35%">                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="JUMINNO2" style="width:150px">
                        <xsl:attribute name="class">txtJuminDash</xsl:attribute>
                        <xsl:attribute name="maxlength">14</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/JUMINNO2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JUMINNO2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="width:65%;text-align:right">담&nbsp;&nbsp;당&nbsp;&nbsp;직&nbsp;&nbsp;무:</td>
                <td style="border-right:0;text-align:left;height:40px;width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TAKEWORK" style="width:150px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TAKEWORK" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TAKEWORK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="width:65%;text-align:right">&nbsp;</td>
                <td style="height:50px">
                  &nbsp;
                </td>
              </tr>
              <tr>                
                <td style="border-right:0;text-align:center;padding-left:5px;font-size:20px;" colspan="2">
                  <b>크레신 주식회사 대표이사 귀하</b>
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
