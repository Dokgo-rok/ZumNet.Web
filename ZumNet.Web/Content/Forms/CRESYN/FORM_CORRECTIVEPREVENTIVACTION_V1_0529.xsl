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
          .m .ft .f-lbl {width:11%} .m .ft .f-lbl1 {width:15%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:12%} .m .ft .f-option1 {width:34%}
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
                    <!--<xsl:value-of select="//docinfo/docname" />-->
                    시정 및 예방조치 요구서
                    <br></br>
                    <span style="font-size:10pt" >(Corrective and Preventive Action Request)</span>
                    <br></br>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        (<select name="ACTIONCODE" id="__mainfield" onchange="parent.fnSelectChange(this);" style="font-size:14pt;font-weight:bold">
                          <option value="">선택</option>
                          <option value="1">시정조치</option>
                          <option value="2">예방조치</option>
                        </select>
                        <input type="text" id="__mainfield" name="ACTIONTYPE"  class="txtText" maxlength="30" style="width:90%;display:none" />)
                      </xsl:when>
                      <xsl:otherwise>
                        <span style="font-size:14pt;font-weight:bold" >
                          (<input type="hidden" id="__mainfield" name="ACTIONCODE" value="{//forminfo/maintable/ACTIONCODE}" />
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ACTIONTYPE))" />)
                        </span>
                      </xsl:otherwise>
                    </xsl:choose>
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
                <td style="width:278px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;&nbsp;</td>
                <td style="width:278px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '3', '수신부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;&nbsp;</td>
                <td style="width:278px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'application', '__si_Application', '3', '주관부서')"/>
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
                <td style="width:23%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성부서</td>
                <td style="width:15%">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl">작성일자</td>
                <td style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">구분타입</td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select name="DIVIDECODE" id="__mainfield" onchange="parent.fnSelectChange(this);" style="width:70%">
                        <option value="">선택</option>
                        <option value="1">개선권고</option>
                        <option value="2">중부적합</option>
                        <option value="3">경부적합</option>
                        <option value="4">관찰사항</option>
                      </select>
                      <input type="text" id="__mainfield" name="DIVIDETYPE"  class="txtText" maxlength="30" style="width:90%;display:none" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="DIVIDECODE" value="{//forminfo/maintable/DIVIDECODE}" />
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DIVIDETYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">수신부서</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="//processinfo/signline/lines/line[@bizrole='receive' and @actrole='__r' and @partid!='']/part1"/>
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
                <td class="f-lbl" style="border-bottom:0;">제&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;목</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
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
            <span>1. 지적 사항</span>
            <span style="padding-left:15px">①문제내용 ②추정원인 ③관련문서 ④조치/권고내용(해당하는 경우) 등의 순으로 기재하시오.</span>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="POINTOUT" style="height:80px;border:1px solid windowtex" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000);" >
                        <xsl:value-of select="//forminfo/maintable/POINTOUT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="POINTOUT" style="height:80px;padding:2px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/POINTOUT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">작성자</td>
                <td style="border-bottom:0;width:37%">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
                <td class="f-lbl1" style="border-bottom:0">회신요청일</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REPLYDATE" style="width:40%" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/REPLYDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REPLYDATE))" />
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

          <div class="fm">
            <span>2. 원인 분석</span>
            <span style="padding-left:15px">①원인분석 ②유사문제 확인결과(해당시) 등의 순으로 기재하시오.</span>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="CAUSEANALYSIS" style="height:80px;" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <textarea id="__mainfield" name="CAUSEANALYSIS" style="height:80px;border:1px solid windowtex" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000);" >
                        <xsl:value-of select="//forminfo/maintable/CAUSEANALYSIS" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CAUSEANALYSIS" style="height:80px;padding:2px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CAUSEANALYSIS))" />
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
            <span>3. 조치 사항</span>
            <span style="padding-left:15px">①조치내용 ②재발 방지대책 ③근거서류(해당시) 등의 순으로 기재하시오.</span>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0" colspan="4">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="ACTIONCONTENT" style="height:100px;" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <textarea id="__mainfield" name="ACTIONCONTENT" style="height:100px;border:1px solid windowtex" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);">
                        <xsl:value-of select="//forminfo/maintable/ACTIONCONTENT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="ACTIONCONTENT" style="height:100px;padding:2px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACTIONCONTENT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">조치자</td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="ACTIONPERSON" style="width:40%" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="ACTIONPERSON" style="width:40%" class="txtText" maxlength="50" value="{//forminfo/maintable/ACTIONPERSON}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACTIONPERSON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">
                  조치완료<br></br>(또는 예정일자)
                </td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="ACTIONDATE" style="width:40%" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="ACTIONDATE" style="width:40%" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/ACTIONDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ACTIONDATE))" />
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
            <span>4. 조치 확인결과</span>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0" colspan="4">
                  <span class="f-option" style="padding-left:10px">
                    <input type="checkbox" id="ckb11" name="ckbRESULTTYPE" value="만족">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/RESULTTYPE),'만족')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbRESULTTYPE', this, 'RESULTTYPE')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/RESULTTYPE),'만족')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </input>
                    <label for="ckb11">만족</label>
                  </span>
                  <span class="f-option" style="width:80%">
                    <input type="checkbox" id="ckb12" name="ckbRESULTTYPE" value="불만족">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/RESULTTYPE),'불만족')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbRESULTTYPE', this, 'RESULTTYPE')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/RESULTTYPE),'불만족')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </input>
                    <label for="ckb12">불만족 ("불만족" 시 불만족 내용을 시정 및 예방조치요구서에 기술하여 재발행한다.)</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="RESULTTYPE">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/RESULTTYPE"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">
                  조치내용검토<BR></BR>(불만족사유등)
                </td>
                <td style="border-right:0" colspan="4">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="ACTIONREVIEW" style="height:100px;" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                      <textarea id="__mainfield" name="ACTIONREVIEW" style="height:100px;border:1px solid windowtex" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);">
                        <xsl:value-of select="//forminfo/maintable/ACTIONREVIEW" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="ACTIONREVIEW" style="height:100px;padding:2px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACTIONREVIEW))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">확인자</td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="ACTIONVERIFY" style="width:40%" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="ACTIONVERIFY" style="width:40%" class="txtText" maxlength="50" value="{//forminfo/maintable/ACTIONVERIFY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACTIONVERIFY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">확인일자</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="VERIFYDATE" style="width:40%" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="VERIFYDATE" style="width:40%" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/VERIFYDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VERIFYDATE))" />
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
            <span>5. 확인검증(유효성 검증)</span>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1">
                  확인내용
                </td>
                <td style="border-right:0" colspan="4">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="VERIFICATIONCONTENT" style="height:100px;" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                      <textarea id="__mainfield" name="VERIFICATIONCONTENT" style="height:100px;border:1px solid windowtex" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);">
                        <xsl:value-of select="//forminfo/maintable/VERIFICATIONCONTENT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="VERIFICATIONCONTENT" style="height:100px;padding:2px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/VERIFICATIONCONTENT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">확인예정일</td>
                <td style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="VERIFICATIONDATE" style="width:40%" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="VERIFICATIONDATE" style="width:40%" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/VERIFICATIONDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VERIFICATIONDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">완료일</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" name="VERIFICATIONEND" style="width:40%;" class="txtRead" readonly="readonly" />
                    </xsl:when>
                    <xsl:when test="$bizrole='application' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="VERIFICATIONEND" style="width:40%" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{//forminfo/maintable/VERIFICATIONEND}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VERIFICATIONEND))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

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
