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
  <xsl:variable name="uid" select="//currentinfo/@uid" />
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
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:100px} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}   .m .ft .f-option2 {width:40%} .m .ft .f-option3 {width:100px}
          .m .ft-sub .f-option {width:49%}, .m .l_pos {display:none}

          /* 기타 */
          p, li, li table td  {font-size:14px;font-family:맑은 고딕;letter-spacing:1pt;line-height:22px;vertical-align:top}
          ol, ul {margin-left:30px;text-align:left}
          ul.ft-ul {margin:0;list-style:none}
          ul.ft-ul li {margin-bottom:10px}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:450px} #panStatement, #panHandover, #panCheckout {page-break-before:always}, .m .l_pos {display:block} , .m .l_pos2 {display:none}}
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
          <div class="ff" />

          <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='__r' and $partid!='') or count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0">
            <div class="fb">
              <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td style="width:245px">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                  </td>
                  <td style="width:60px;font-size:1px">&nbsp;</td>
                  <td style="width:395px">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'application', '__si_Application_R', '5', '총무부서')"/>
                  </td>
                </tr>
              </table>
            </div>
          </xsl:if>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">문서번호</td>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일자</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:value-of disable-output-escaping="yes" select="//docinfo/createdate" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="//docinfo/publishdate" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="border-right:0;border-bottom:0">
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
            <span class="f-option" style="font-size:13px">* 퇴직자 정보</span>
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">성명
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button onclick="parent.fnOrgmap('ur','N','RSNNM');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                    </button>
                  </xsl:if>
                </td>
                <td style="width:250px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNGRADE" class="txtText_u" readonly="readonly" value="{//creatorinfo/grade}" style="width:30%" />&nbsp;.&nbsp;
                      <input type="text" id="__mainfield" name="RSNNM" class="txtText_u" readonly="readonly" value="{//creatorinfo/name}" style="width:64%" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNGRADE))" />&nbsp;.&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNNM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">사번</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNEMPNO" class="txtText_u" readonly="readonly" value="{//creatorinfo/empno}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">소속</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNCORP" class="txtText_u" readonly="readonly" value="{//creatorinfo/belong}" style="width:30%" />&nbsp;.&nbsp;
                      <input type="text" id="__mainfield" name="RSNDEPT" class="txtText_u" readonly="readonly" value="{//creatorinfo/department}" style="width:64%" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNCORP))" />&nbsp;.&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">담당직무</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNWORK" class="txtText" maxlength="50" value="{//forminfo/maintable/RSNWORK}" onblur="document.getElementById('txtRSNWORK').value = this.value;" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNWORK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">근무기간</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNINDATE" class="txtDate" style="width:80px" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//creatorinfo/indate}" />&nbsp;~&nbsp;
                      <input type="text" id="__mainfield" name="RSNOUTDATE" class="txtDate" style="width:80px" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/RSNOUTDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNINDATE))" />&nbsp;~&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNOUTDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">주민등록번호<br/>(앞 여섯 자리)</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNJUMINNO" class="txtJuminDash" maxlength="6" value="{//forminfo/maintable/RSNJUMINNO}" onblur="document.getElementById('txtRSNJUMINNO').value = this.value;" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="not(count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0)">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNJUMINNO))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">E-MAIL</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNMAIL" class="txtText" maxlength="50" value="{//forminfo/maintable/RSNMAIL}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNMAIL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">연락처</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNPHONE" class="txtText" maxlength="50" value="{//forminfo/maintable/RSNPHONE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNPHONE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">주소</td>
                <td colspan="3" style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RSNADDR" class="txtText" maxlength="100" value="{//forminfo/maintable/RSNADDR}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNADDR))" />
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

          <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='__r' and $partid!='') or count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0">
            <div class="fm" id="panReason">
              <!--<xsl:if test="not ($mode='new' or $mode='edit' or $bizrole='normal' or $bizrole='application')">-->
              <span class="f-option" style="font-size:13px;text-align:center">상기 본인은 다음의 사유로 인하여 사직코져 하오니 재가하여 주시기 바립니다.</span>
              <table class="ft" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td style="border-right:0;border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="REASON" style="height:100px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000)" >
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="REASON" class="txaRead" style="height:100px;padding:2px">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </table>
              <h3>크레신 주식회사 귀하</h3>
            </div>
          </xsl:if>


          <span class="l_pos" style="text-align:center">
            <h3 style="margin-top:90px">본인이 작성하였음을 확인합니다.</h3>
            <h3 style="">
              성명:<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>(인)
            </h3>
          </span>

          <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='__r' and $partid!='') or count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0">
            <div class="fm" id="panStatement">
              <h2 style="margin-bottom:0">영업비밀 보호 준수 서약서</h2>
              <h3 style="margin-top:0">(퇴사자용)</h3>
              <p style="text-align:left">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" name="txtRSNNM" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:100px" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNNM))" />
                  </xsl:otherwise>
                </xsl:choose>
                (이하 甲이라 한다)는 크레신주식회사(이하 乙이라한다)를 퇴사하면서 아래사항을 이행하기로 하고, 만약 이행하지 않을 때에는 민사▪형사상의 책임을 지기로 하고 본 서약서를 乙에게 제출한다.
              </p>
              <p>- 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 -</p>
              <ol>
                <li>甲은 퇴직일로부터 2년이내 동업종 경쟁업체에 취업하지 아니한다.</li>
                <li>
                  <table style="width:630px" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="width:30px">가.</td>
                      <td>甲은 乙에게 고용되어 재직한 기간중에 지득한 영업비밀 및 보안사항을 제 3자에게 누설하지 아니한다.</td>
                    </tr>
                    <tr>
                      <td>나.</td>
                      <td>甲은 퇴직일로부터 2년간 乙에게 고용되어 재직한 기간 중에 지득한 영업비밀을 이용하기 위한 목적으로 창업하거나, 경쟁사에 전직,동업,고문,자문,기타 협력의 지위를 가질 수 없다.</td>
                    </tr>
                  </table>
                </li>
                <li>기타 甲은 乙의 영업비밀 유지를 위한 법적▪도덕적 의무를 성실히 이행한다.</li>
                <li>만약 甲이 본 서약서를 위반하는 등의 행위로 乙에게 손해를 끼쳤을 경우에 甲은 乙이 입은 일체의 손해를 배상할 책임을 진다.</li>
              </ol>

              <p style="text-align:right;margin:40px">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), 'ko')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/publishdate), 'ko')" />
                  </xsl:otherwise>
                </xsl:choose>
              </p>

              <ul class="ft-ul" style="margin-left:350px">
                <li>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <xsl:attribute name="style">margin-bottom:-2px</xsl:attribute>
                  </xsl:if>
                  소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="txtRSNDEPT" class="txtRead" readonly="readonly" value="{//creatorinfo/department}" style="width:200px" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
                <li>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <xsl:attribute name="style">margin-top:-2px;margin-bottom:-2px</xsl:attribute>
                  </xsl:if>
                  성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="txtRSNNM" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:200px" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNNM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:40px;border:0px solid green">
                      <img alt="" style="width:45px;vertical-align:middle" src="/Storage/{//config/@companycode}/Sign/{//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_drafter') and @partid!='']/part2}.jpg" />
                    </span>
                  </xsl:if>
                </li>
                <li>
                  주민등록번호 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="txtRSNJUMINNO" class="txtRead" readonly="readonly" value="{//forminfo/maintable/RSNJUMINNO}" style="width:200px" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNJUMINNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
                <li>
                  담&nbsp;당&nbsp;&nbsp;&nbsp;직&nbsp;무 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="txtRSNWORK" class="txtRead" readonly="readonly" value="{//forminfo/maintable/RSNWORK}" style="width:200px" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNWORK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </li>
              </ul>
              
              <h3 style="margin-top:30px">크레신 주식회사 대표이사 귀하</h3>              
              
              
              <span class="l_pos" style="text-align:center">
                <h3 style="margin-top:60px">본인이 작성하였음을 확인합니다.</h3>
                <h3 style="">
                  성명:<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>(인)
                </h3>
              </span>              
            </div>
          </xsl:if>

          <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='__r' and $partid!='') or count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0">          
            <div class="fm" id="panStatement">
              <h2 style="margin-bottom:0">퇴직 직원용 - [개인정보의 이용에 관한 동의서]</h2>
              <ol>
                <li>
                  본인은 본인의 퇴직 후에도 다음과 같이 크레신주식회사가 <u>본인 및 본인 가족의</u> 개인 정보·민감<br />
                  정보·고유식별정보를 이용하는 것에 동의합니다.
                  <table  class="ft" style="width:650px"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td  class="f-lbl"  style="width:38%">개인정보항목</td>
                      <td  class="f-lbl" style="width:32%">수집·이용목적</td>
                      <td  class="f-lbl" style="width:30%;border-right:0">보유기간</td>
                    </tr>
                    <tr>
                      <td style="border-bottom:0">가. 성명<br />
                          나. 주소, 이메일, 연락처<br />
                          다. 학력, 근무경력, 자격증<br />
                          라. 가족사항 등 기타 근무와 관련된 개인정보
                      </td>
                      <td style="border-bottom:0">
                        가. 퇴직 후 인사관리<br />
                        나. 세법, 노동관계 법령 등에서 부과하는 의무 이행                        
                      </td>
                      <td style="text-align:center;border-right:0;border-bottom:0">
                        퇴직 후에도 영구보관
                      </td>
                    </tr>                    
                  </table>
                  <table>
                    <tr>
                      <td style="text-align:right;width:650px">                        
                        <span class="l_pos2" style="text-align:right">
                          개인정보의 수집·이용에 동의합니다<input type="checkbox" id="ckb11" name="ckbAGREE1" value="동의함">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">parent.fnCheckYN('ckbAGREE1', this, 'AGREE1')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE1),'동의함')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                        </input>
                        </span>
                        <span class="l_pos" style="text-align:center">
                          개인정보의 수집·이용에(<input type="checkbox" id="ckb11" name="ckbAGREE1" value="동의함">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE1),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE1),'동의함')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb11">동의함</label>
                          <input type="checkbox" id="ckb12" name="ckbAGREE1" value="미동의">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE1),'미동의')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE1),'미동의')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb12">동의하지 않음</label>)
                        </span>
                      </td>
                    </tr>
                  </table>
                  <table  class="ft" style="width:650px"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td  class="f-lbl"  style="width:38%">민감정보의 항목</td>
                      <td  class="f-lbl" style="width:32%">수집·이용목적</td>
                      <td  class="f-lbl" style="width:30%;border-right:0">보유기간</td>
                    </tr>
                    <tr>
                      <td style="border-bottom:0">
                        가. 신체장애<br />
                        나. 병력<br />
                        다. 범죄정보<br />                        
                      </td>
                      <td style="border-bottom:0">
                        가. 퇴직 후 인사관리<br />
                        나. 세법, 노동관계 법령 등에서 부과하는 의무 이행
                      </td>
                      <td style="text-align:center;border-right:0;border-bottom:0">
                        퇴직 후에도 영구보관
                      </td>
                    </tr>
                  </table>
                  <table>
                    <tr>
                      <td style="text-align:right;width:650px">                        
                        <span class="l_pos2" style="text-align:right">
                          민감정보의 수집·이용에 동의합니다<input type="checkbox" id="ckb21" name="ckbAGREE2" value="동의함">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">parent.fnCheckYN('ckbAGREE2', this, 'AGREE2')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE2),'동의함')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                        </input>
                        </span>
                        <span class="l_pos" style="text-align:center">
                          민감정보의 수집·이용에(<input type="checkbox" id="ckb21" name="ckbAGREE2" value="동의함">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE2),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE2),'동의함')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb21">동의함</label>
                          <input type="checkbox" id="ckb22" name="ckbAGREE2" value="미동의">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE2),'미동의')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE2),'미동의')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb22">동의하지 않음</label>)
                        </span>
                      </td>
                    </tr>
                  </table>
                  <table  class="ft" style="width:650px"  border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td  class="f-lbl"  style="width:38%">고유식별항목</td>
                      <td  class="f-lbl" style="width:32%">수집·이용목적</td>
                      <td  class="f-lbl" style="width:30%;border-right:0">보유기간</td>
                    </tr>
                    <tr>
                      <td style="border-bottom:0">
                        본인 및 본인의 가족에 대한<br />
                        가. 주민등록번호<br />
                        나. 운전면허번호<br />
                        다. 여권번호<br />
                      </td>
                      <td style="border-bottom:0">
                        가. 퇴직 후 인사관리<br />
                        나. 세법, 노동관계 법령 등에서 부과하는 의무 이행
                      </td>
                      <td style="text-align:center;border-right:0;border-bottom:0">
                        퇴직 후에도 영구보관
                      </td>
                    </tr>
                  </table>
                  <table>
                    <tr>
                      <td style="text-align:right;width:650px">                        
                        <span class="l_pos2" style="text-align:right">
                          고유식별정보의 수집·이용에 동의합니다<input type="checkbox" id="ckb31" name="ckbAGREE3" value="동의함">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">parent.fnCheckYN('ckbAGREE3', this, 'AGREE3')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE3),'동의함')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                        </input>
                        </span>
                        <span class="l_pos" style="text-align:center">
                          고유식별정보의 수집·이용에(<input type="checkbox" id="ckb31" name="ckbAGREE3" value="동의함">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE3),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE3),'동의함')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb31">동의함</label>
                          <input type="checkbox" id="ckb32" name="ckbAGREE3" value="미동의">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE3),'미동의')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE3),'미동의')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb32">동의하지 않음</label>)
                        </span>
                      </td>
                    </tr>
                  </table>
                </li>
                <li>
                  회사는 취득한 개인정보를 수집한 목적에 필요한 범위에서 적법하게 처리하고 그 목적외의 용<br />
                  도로 사용하지 않으며 <u>개인 정보를 제공한 계약당사자는 언제나 자신이 입력한 개인정보를 열람·
                  수정 및 정보제공에 대해 철회를 할 수 있음에 동의합니다.</u><br />                       
                  <table>
                    <tr>
                      <td style="text-align:right;width:650px">
                        <span class="l_pos2" style="text-align:right">
                          개인정보의 수집·이용에 동의합니다<input type="checkbox" id="ckb41" name="ckbAGREE4" value="동의함">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbAGREE4', this, 'AGREE4')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE4),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>                            
                          </input>                          
                        </span>
                        <span class="l_pos" style="text-align:center">
                          개인정보의 수집·이용에(<input type="checkbox" id="ckb41" name="ckbAGREE4" value="동의함">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE4),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE4),'동의함')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb41">동의함</label>
                          <input type="checkbox" id="ckb42" name="ckbAGREE4" value="미동의">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE4),'미동의')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE4),'미동의')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb42">동의하지 않음</label>)
                        </span>
                      </td>
                    </tr>
                  </table>
                </li>
                <li>
                  <u>본인은 위에 따라 수집되는 개인정보의 항목과 개인정보의 이용에 대한 거부를 할 수<br />
                    있는 권리가 있다는 사실을 충분히 설명받고 숙지하였으며, 미동의시 법령에 따라 발생하는<br />
                    불이익에 대한 책임은 본인에게 있음을 확인합니다.
                  </u><br />
                  <table>
                    <tr>
                      <td style="text-align:right;width:650px">
                        <span class="l_pos2" style="text-align:right">
                          개인정보의 수집·이용에 동의합니다<input type="checkbox" id="ckb51" name="ckbAGREE5" value="동의함">
                            <xsl:if test="$mode='new' or $mode='edit'">
                              <xsl:attribute name="onclick">parent.fnCheckYN('ckbAGREE5', this, 'AGREE5')</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE5),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>                            
                          </input>                                                  
                        </span>
                        <span class="l_pos" style="text-align:center">
                          개인정보의 수집·이용에(<input type="checkbox" id="ckb51" name="ckbAGREE5" value="동의함">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE5),'동의함')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE5),'동의함')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb51">동의함</label>
                          <input type="checkbox" id="ckb52" name="ckbAGREE5" value="미동의">                            
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE5),'미동의')">
                              <xsl:attribute name="checked">true</xsl:attribute>
                            </xsl:if>
                            <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE5),'미동의')">
                              <xsl:attribute name="disabled">disabled</xsl:attribute>
                            </xsl:if>
                          </input>
                          <label for="ckb52">동의하지 않음</label>)
                        </span>
                      </td>
                    </tr>
                  </table>
                </li>                
              </ol>

              <p style="text-align:right;margin:20px">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), 'ko')" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/publishdate), 'ko')" />
                  </xsl:otherwise>
                </xsl:choose>
              </p>

              <ul class="ft-ul" style="margin-left:350px">                
                <li>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <xsl:attribute name="style">margin-top:-2px;margin-bottom:-2px</xsl:attribute>
                  </xsl:if>
                  동의자&nbsp;&nbsp;성명 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="txtRSNNM" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:200px" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNNM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:40px;border:0px solid green">
                      <img alt="" style="width:45px;vertical-align:middle" src="/Storage/{//config/@companycode}/Sign/{//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_drafter') and @partid!='']/part2}.jpg" />
                    </span>
                  </xsl:if>
                </li>
                <li>
                  주민등록번호 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="txtRSNJUMINNO" class="txtRead" readonly="readonly" value="{//forminfo/maintable/RSNJUMINNO}" style="width:200px" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNJUMINNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </li>                
              </ul>

              <h3 style="margin-top:30px">크레신 주식회사 귀중</h3>


              <span class="l_pos" style="text-align:center">
                <h3 style="margin-top:60px">본인이 작성하였음을 확인합니다.</h3>
                <h3 style="">
                  성명:<u>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</u>(인)
                </h3>
              </span>
            </div>
          </xsl:if>         
          
          <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='__r' and $partid!='') or count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0">
            <div class="fm" id="panHandover">
              <h2>업무 인계인수 확인서</h2>
              <table class="ft" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td class="f-lbl">인계자</td>
                  <td class="f-lbl1" style="width:60px">소속</td>
                  <td style="width:220px">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="txtRSNDEPT" class="txtRead" readonly="readonly" value="{//creatorinfo/department}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNDEPT))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class="f-lbl1" style="width:60px">성명</td>
                  <td style="border-right:0;width:260px">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" name="txtRSNGRADE" class="txtRead" readonly="readonly" value="{//creatorinfo/grade}" style="width:30%" />&nbsp;.&nbsp;
                        <input type="text" name="txtRSNNM" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:64%" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNGRADE))" />&nbsp;.&nbsp;
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNNM))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td class="f-lbl">인수자</td>
                  <td colspan="4" style="width:600px;border-right:0;border-bottom:0;padding:0">
                    <table border="0" cellspacing="0" cellpadding="0">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <tr>
                          <td class="fm-button" style="border:0;border-bottom:1px solid windowtext">
                            <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                              <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />추가
                            </button>
                            <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                              <img alt="" class="blt01" src="/{$root}/EA/Images/ico_27.gif" />삭제
                            </button>
                          </td>
                        </tr>
                      </xsl:if>
                      <tr>
                        <td style="border:0;padding:0">
                          <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="border:0;">
                            <colgroup>
                              <col style="width:60px"></col>
                              <col style="width:220px"></col>
                              <col style="width:60px"></col>
                              <col style="width:260px"></col>
                            </colgroup>
                            <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td class="f-lbl">입회자</td>
                  <td class="f-lbl1">
                    소속
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <button onclick="parent.fnOrgmap('ur','N','OSVNM');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:if>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="OSVDEPT" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/OSVDEPT}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OSVDEPT))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td class="f-lbl1">성명</td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="OSVGRADE" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/OSVGRADE}" style="width:30%" />&nbsp;.&nbsp;
                        <input type="text" id="__mainfield" name="OSVNM" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/OSVNM}" style="width:64%" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OSVGRADE))" />&nbsp;.&nbsp;
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OSVNM))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td class="f-lbl">
                    업무 인계<br /><br />내용 개요
                  </td>
                  <td colspan="4" style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="HANDOVERNOTE" style="height:150px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000)" >
                          <xsl:value-of select="//forminfo/maintable/HANDOVERNOTE" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="HANDOVERNOTE" class="txaRead" style="height:150px;padding:2px">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/HANDOVERNOTE))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td colspan="5" style="border-right:0;border-bottom:0;text-align:center;padding:10px">
                    <p>위와 같이 업무 인계 인수 하였음을 확인합니다!</p>
                    <ul class="ft-ul" style="margin-left:250px">
                      <li>
                        전임자 (인계자) :
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" name="txtRSNGRADE" class="txtRead" readonly="readonly" value="{//creatorinfo/grade}" style="width:60px" />&nbsp;&nbsp;
                            <input type="text" name="txtRSNNM" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:120px" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNGRADE))" />&nbsp;&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RSNNM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                      <li>
                        후임자 (인수자) :
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" name="txtACCEPTORGRADE" class="txtRead" readonly="readonly" value="{//forminfo/subtables/subtable1/row/ACCEPTORGRADE}" style="width:60px" />&nbsp;&nbsp;
                            <input type="text" name="txtACCEPTOR" class="txtRead" readonly="readonly" value="{//forminfo/subtables/subtable1/row/ACCEPTOR}" style="width:120px" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable1/row/ACCEPTORGRADE))" />&nbsp;&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable1/row/ACCEPTOR))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                      <li>
                        입&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;회&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;자 :
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" name="txtOSVGRADE" class="txtRead" readonly="readonly" value="{//forminfo/maintable/OSVGRADE}" style="width:60px" />&nbsp;&nbsp;
                            <input type="text" name="txtOSVNM" class="txtRead" readonly="readonly" value="{//forminfo/maintable/OSVNM}" style="width:120px" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OSVGRADE))" />&nbsp;&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OSVNM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </li>
                    </ul>
                  </td>
                </tr>
              </table>
            </div>

            <div class="ff" />
            <div class="ff" />
            <div class="ff" />
            <div class="ff" />
          </xsl:if>

          <div class="fm" id="panCheckout">
            <h2>개인 지급품 및 정산 확인</h2>
            <span class="f-option" style="font-size:13px">* 퇴사시 정리사항</span>
            <table class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl-sub" style="width:130px;border-top:0">담당부서</td>
                <td class="f-lbl-sub" style="width:470px;border-top:0">확인 내용</td>
                <td class="f-lbl-sub" style="width:100px;border-top:0;border-right:0">확인일자</td>
              </tr>
              <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='receive' and @actrole='__r']">
                <xsl:sort select="@step" />
                <xsl:sort select="@substep" />
              </xsl:apply-templates>
            </table>
            <span class="f-option" style="font-size:13px">※ 이 문서는 퇴사시 정산되어야 할 내역이 관련부서로 자동 통지되기위한 목적입니다.</span>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:380px;font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '수신부서')"/>
                </td>
              </tr>
            </table>
          </div>
          
          <xsl:if test="//linkeddocinfo/linkeddoc or //fileinfo/file">
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

          <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='application' and $actrole='__r' and $partid!='') or count(//processinfo/signline/lines/line[(@bizrole='normal' or @bizrole='application') and @partid=$uid])>0">
            <xsl:if test="$mode='read' and count(//processinfo/signline/lines/line)>0">
              <div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>
              <div class="fm-lines">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignTable(//processinfo/signline/lines)"/>
              </div>
            </xsl:if>
          </xsl:if>
        </div>

        <!-- Hidden Field 정보 -->
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="hidden" id="__mainfield" name="RSNID" value="{//currentinfo/@uid}" />
            <input type="hidden" id="__mainfield" name="RSNDEPTID" value="{//currentinfo/@deptid}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield" name="RSNID" value="{//forminfo/maintable/RSNID}" />
            <input type="hidden" id="__mainfield" name="RSNDEPTID" value="{//forminfo/maintable/RSNDEPTID}" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" id="__mainfield" name="OSVID" value="{//forminfo/maintable/OSVID}" />
        <input type="hidden" id="__mainfield" name="OSVDEPTID" value="{//forminfo/maintable/OSVDEPTID}" />
        <input type="hidden" id="__mainfield" name="AGREE1" value="{//forminfo/maintable/AGREE1}" />
        <input type="hidden" id="__mainfield" name="AGREE2" value="{//forminfo/maintable/AGREE2}" />
        <input type="hidden" id="__mainfield" name="AGREE3" value="{//forminfo/maintable/AGREE3}" />
        <input type="hidden" id="__mainfield" name="AGREE4" value="{//forminfo/maintable/AGREE4}" />
        <input type="hidden" id="__mainfield" name="AGREE5" value="{//forminfo/maintable/AGREE5}" />

        <!-- 필수 양식 정보 -->
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
    <xsl:variable name="wid" select="@wid" />
    <tr>
      <td style="padding-left:10px">
        <xsl:value-of disable-output-escaping="yes" select="@substep" />.
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))" />
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="//processinfo/signline/lines/line[@parent=$wid and @step>0]">
            <table border="0" cellspacing="0" cellpadding="0" style="border:0">
              <xsl:for-each select="//processinfo/signline/lines/line[@parent=$wid and @step>0]">
                <xsl:sort select="@step" />
                <tr>
                  <td>
                    <xsl:choose>
                      <xsl:when test="position()=last()">
                        <xsl:attribute name="style">width:15%;border:0</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">width:15%;border:0;border-bottom:1px dotted #666</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))" />
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="position()=last()">
                        <xsl:attribute name="style">width:85%;border:0</xsl:attribute>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="style">width:85%;border:0;border-bottom:1px dotted #666</xsl:attribute>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(comment))" />
                  </td>
                </tr>
              </xsl:for-each>
            </table>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center;border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))" />
      </td>
    </tr>
  </xsl:template>

  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
      <td style="border-bottom:0;display:none">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="ACCEPTORID" value="{ACCEPTORID}" />
        <input type="hidden" name="ACCEPTORDEPTID" value="{ACCEPTORDEPTID}" />
      </td>
      <td class="f-lbl-sub" style="border-top:0">
        소속
        <xsl:if test="$mode='new' or $mode='edit'">
          <button onclick="parent.fnOrgmap('ur','N',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
            <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
          </button>
        </xsl:if>
      </td>
      <td style="border-top:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ACCEPTORDEPT" class="txtText_u" readonly="readonly" value="{ACCEPTORDEPT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACCEPTORDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="f-lbl-sub" style="border-top:0">성명</td>
      <td style="border-top:0;border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ACCEPTORGRADE" class="txtText_u" readonly="readonly" value="{ACCEPTORGRADE}" style="width:32%" />.&nbsp;
            <input type="text" name="ACCEPTOR" class="txtText_u" readonly="readonly" value="{ACCEPTOR}" style="width:64%" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="ACCEPTOR">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACCEPTORGRADE))" />.&nbsp;
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ACCEPTOR))" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty('')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>