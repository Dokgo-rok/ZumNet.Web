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
          .m .ft .f-lbl {width:18%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

          .m .ft td,.m .ft td span {font-family:굴림}

          /* 인쇄 설정 : 맨하단으로  , 결재권자창 인쇄 시 안보임 */
          @media print {.m .fm-editor {height:450px} .fb,.si-tbl,.fh-l img {display:none} .m .fh {padding-top:40px}}
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
                    연봉계약서
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

          <!--<div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '3', '처리부서')"/>
                </td>
              </tr>
            </table>
          </div>-->

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm" align="left">
            <table>
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:5%"></col>
                <col style="width:30%"></col>
                <col style="width:15%"></col>
                <col style="width:5%"></col>                
                <col style="width:30%"></col>
                <col style="width:15%"></col>
              </colgroup>
              <tr>
                <td colspan="6">
                  <font size="2">
                    크레신 주식회사 대표이사 이종배(이하  "갑"이라 칭한다)와             
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="THENAME"  class="txtRead" readonly="readonly" maxlength="100" style="width:100px" value="{//forminfo/maintable/THENAME}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THENAME))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    (이하 "을"이라 칭한다) 은(는) <br />
                    다음과 같이 연봉 계약을 체결한다. <br /><br />
                    제  1 조				(계약기간) <br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="FROMYEAR" class="txtRead" readonly="readonly" maxlength="100" style="width:70px" value="{//forminfo/maintable/FROMYEAR}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMYEAR))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    년
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="FROMMONTH"  class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/FROMMONTH}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMMONTH))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    월
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="FROMDAY" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/FROMDAY}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMDAY))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  일부터&nbsp;&nbsp;
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="TOYEAR" class="txtRead" readonly="readonly"  maxlength="100" style="width:70px" value="{//forminfo/maintable/TOYEAR}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOYEAR))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    년
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="TOMONTH" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/TOMONTH}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOMONTH))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    월
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="TODAY" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/TODAY}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TODAY))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    일까지 ( 
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="DURING" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/DURING}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DURING))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    )개월로 한다.<br />
                  제  2 조 (총 연봉 지급액)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  총 연봉 지급액은 
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTMONEY" class="txtRead" readonly="readonly" maxlength="100" style="width:200px" value="{//forminfo/maintable/TOTMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(//forminfo/maintable/TOTMONEY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  원으로 한다.<br />
                  제  3 조 (연봉의 지급방법)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  월급여는 연봉의 12분의1인
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PERMONEY" class="txtRead" readonly="readonly" maxlength="100" style="width:120px" value="{//forminfo/maintable/PERMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(//forminfo/maintable/PERMONEY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  원을 매익월 5일에 지급한다.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    월급여는 기본급
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STDMONEY" class="txtRead" readonly="readonly" maxlength="100" style="width:120px" value="{//forminfo/maintable/STDMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(//forminfo/maintable/STDMONEY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  원 과 연장근로수당 (월
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DLYTIME" class="txtRead" readonly="readonly" maxlength="100" style="width:40px" value="{//forminfo/maintable/DLYTIME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DLYTIME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  시간)	 
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DLYMONEY" class="txtRead" readonly="readonly" maxlength="100" style="width:40px" value="{//forminfo/maintable/DLYMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(//forminfo/maintable/DLYMONEY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  원 으로 구성된다.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  통상시급은 월급여 中 기본급을 209시간으로 나눈것으로 하고, 일급은 시급의 8을 승한것으로 한다.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  단, 수습사원의 경우  회사 급여규정에 의거 수습기간동안  월급여의 80%를  지급한다.<br />
                  제  4 조				(총 연봉 지급액 내역)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  업무의  형태 및 임금산정의  편의를  위하여  기본급,상여금,설계수당(설계직),기타 회사 임의수당,<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  연장근로수당(시간외근무수당,야간근무수당,휴일근무수당)까지 모두 포함된 포괄임금제를 적용한다.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  [단, 퇴직금은 불포함]<br />
                  제  5 조				(계약기간 중의 연봉조정)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  계약기간 중이라도  승진 등의 신분상 변동이나  기타 사유로 인하여  연봉조정이  필요할  경우에는<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  계약을 변경할 수 있다.<br />
                  제  6 조				(퇴직금의 지급)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  퇴직금에 관한 사항은 근로자 퇴직급여보장법에 따른다.<br />
                  제  7 조				(연차 사용 의무 및 연차수당 부지급)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  연차휴가규정  제5조 1항에 의거  "을"'은  당해년도에 사용가능한 모든 휴가일수를 전부 사용하여야<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  하며,  만약  사용하지 못한 휴가에 대해서 회사는 수당지급 등 어떠한 보상도 하지 않는다.  단, 연차<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  사용 희망시 연차계를   필히 회사에 제출하여  승락을  받아 실시하여야 한다.<br />
                  제  8 조				(생차휴가)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  여직원에 대해서는 본인의 청구에 따라 매월 1회 무급 생차휴가를 지급할 수 있다.<br />
                  제  9 조				(연봉 금액의 동의 및 비밀유지)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  상기 연봉 금액에 동의하며, 정당한 이유없이 타인의 연봉을 알려고 하거나 자신의 연봉 및 타인의 연<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  봉을 누설하여서는 안된다.만약 이를 위반할 경우 회사는 연봉삭감 조치나 업무방해로 위법조치한다.<br />
                  제 10조				(중도퇴사)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  중도 퇴사자는  중도 퇴직시  최소한 1개월전에 사전 통보하고 퇴직 승인을 득한 후에 퇴직 처리하며<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  그렇지 아니한 경우에는 무단결근으로 처리한다.<br />
                  제 11조 				(계약의 해지)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  근무중 회사에 막대한 손해를 끼치거나 중대한 과실로 잘못을 야기하였을 경우에는  그에 따른 변상<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  과 본 계약을 해지(해고)할 수 있다.<br />
                  제 12조 				(수습사원)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  1) 신규입사자는 입사일로 부터 3개월간은 시용 수습기간으로 한다.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  2) 시용 수습기간 중 중대한 사고를 유발 하거나 또는  직원으로서 부적격하다고 판단이 될 때는  본<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  채용을 거부할 수 있다.<br />
                  제 13 조				(영업비밀 보호 준수)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  "을"이 근무중이나 사직후 업무와 관련된 기술 및 지식의 유출이나 영업비밀에 대한 유출,회사기밀에<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  대한 각종 자료 유출시에는 민·형사상의 모든 책임에 따른 손해배상 및 법적인 절차등 책임을 감수한다.<br />
                  제 14 조				(기타사항)<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                  기타 본 계약서에 명시되지 않은 사항은 회사의 연봉제 규정 및 취업규칙에 따른다.<br />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     </font>
              </td>
            </tr>
              <tr>
                <td colspan="6" style="text-align:center">
                  위와 같이 연봉계약을 체결하고,이 계약서 2통을 작성하여 각 1통씩을 보관하기로 한다.<br /><br />
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CTRYEAR" class="txtRead" readonly="readonly" maxlength="100" style="width:70px" value="{//forminfo/maintable/CTRYEAR}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTRYEAR))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  년
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CTRMONTH" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/CTRMONTH}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTRMONTH))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  월
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CTRDAY" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/CTRDAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTRDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  일<br /><br />
                </td>
              </tr>
              <tr>
                <td>(갑)</td>
                <td>크 레 신 주 식 회 사</td>
                <td rowspan="3">                  
                    <span style="width:84px;border:0px solid green">
                      <img alt="회사인장" width="84px" style="margin:0;vertical-align:top">
                        <xsl:attribute name="src">/Storage/<xsl:value-of select="//config/@companycode" />/CI/cresyn_stamp.gif
                        </xsl:attribute>
                      </img>
                    </span>                  
                </td>
                <td>(을)</td>
                <td>소  속 :
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="THEDEPT" class="txtRead" readonly="readonly" maxlength="100" style="width:140px" value="{//forminfo/maintable/THEDEPT}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THEDEPT))" />
                  </xsl:otherwise>
                </xsl:choose>
                </td>
                <td rowspan="3">
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:84px;border:0px solid green">
                      <img alt="개인인장" width="84px" style="margin:0;vertical-align:top">
                        <xsl:attribute name="src">/Storage/<xsl:value-of select="//config/@companycode" />/SIGN/<xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_approver') and @partid!='']">
                        </xsl:apply-templates>.jpg
                        </xsl:attribute>
                      </img>
                    </span>                 
                  </xsl:if>                  
                </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>대   표   이   사    이  종  배</td>
                <td>&nbsp;</td>
                <td>직  급 :
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="THEGRADE" class="txtRead" readonly="readonly" maxlength="100" style="width:100px" value="{//forminfo/maintable/THEGRADE}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THEGRADE))" />
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>
                  성  명 : 
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="THENAME" class="txtRead" readonly="readonly" maxlength="100" style="width:100px" value="{//forminfo/maintable/THENAME}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THENAME))" />
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
    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part2))"/>        
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
