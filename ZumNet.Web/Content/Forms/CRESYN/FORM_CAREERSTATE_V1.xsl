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
          @media print {.m .fm-editor {height:450px} .fb,.si-tbl,.fh-l img {display:none} .fm-lines {display:none} .m .fh {padding-top:40px}}
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
                  <h1>&nbsp;</h1>
                </td>
                <td class="fh-r">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="height:30px;border:0px solid red">
                    <tr>
                      <td style="width:50%;text-align:right;font-size:15px;border:0">증명 No.</td>
                      <td style="text-align:right;font-size:14px;border:0">
                        <xsl:value-of select="//forminfo/maintable/CERTINO" />
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

          <div class="fb">
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
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:5%"></col>
                <col style="width:15%"></col>
                <col style="width:30%"></col>
                <col style="width:10%"></col>
                <col style="width:30%"></col>
              </colgroup>
              <tr>
                <td colspan="5" style="text-align:center;vertical-align:top;padding-top:50px;border-right:0;font-size:50px;height:150px">
                  경 력 증 명 서
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="text-align:center;font-size:20" rowspan="4">
                  인<br />적<br />사<br />항
                </td>
                <td class="f-lbl" style="height:40px;font-size:17px">사 번</td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/empno" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTEMPNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="APPLICANTID">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/@uid" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="APPLICANTID">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTID" />
                        </xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="APPLICANTDEPTID">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/@deptid" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="APPLICANTDEPTID">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTDEPTID" />
                        </xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:40px;font-size:17px">성 명</td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/name" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px;font-size:17px">주민등록번호(앞 여섯 자리)</td>
                <td colspan="3" style="border-right:0;text-align:left;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="JUMINNO" style="width:150px">
                        <xsl:attribute name="class">txtJuminDash</xsl:attribute>
                        <xsl:attribute name="maxlength">6</xsl:attribute>
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
                <td class="f-lbl" style="height:40px;font-size:17px">
                  주 소
                </td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
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
                <td class="f-lbl2" rowspan="3" style="text-align:center;font-size:20">
                  경<br />력<br />사<br />항
                </td>
                <td class="f-lbl" style="height:40px;font-size:17px">
                  소 속
                </td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/department" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTDEPT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:40px;font-size:17px">
                  직 위
                </td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTGRADE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/grade" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTGRADE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTGRADE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTGRADE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:40px;font-size:17px">
                  근 무 기 간
                </td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <xsl:value-of select="substring(string(//creatorinfo/indate),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//creatorinfo/indate),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//creatorinfo/indate),9,2)" />일&nbsp;&nbsp;&nbsp;부터&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),9,2)" />일&nbsp;&nbsp;&nbsp;현재
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(string(//forminfo/maintable/INDATE),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/INDATE),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/INDATE),9,2)" />일&nbsp;&nbsp;&nbsp;부터&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/REQUESTDATE),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/REQUESTDATE),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/REQUESTDATE),9,2)" />일&nbsp;&nbsp;&nbsp;현재
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
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
              </tr>
              <tr>
                <td colspan="2" class="f-lbl4" style="height:40px;font-size:17px">
                  용도
                </td>
                <td style="width:35%;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORUSE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FORUSE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORUSE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="font-size:17px">
                  제출처
                </td>
                <td style="width:35%;border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORWHERE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FORWHERE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORWHERE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="height:120px;border-right:0;border-bottom:0">
                  &nbsp;
                </td>
                <td colspan="4" style="border-bottom:0;border-right:0;font-size:17">
                  위와 같이 증명합니다.
                </td>
              </tr>
              <tr>
                <td colspan="5" style="border-bottom;0;text-align:center;border-right:0;height:90px;font-size:17px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),9,2)" />일
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="substring(string(//forminfo/maintable/REQUESTDATE),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/REQUESTDATE),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//forminfo/maintable/REQUESTDATE),9,2)" />일
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td colspan="5" style="border-bottom;0;text-align:center;border-right:0;font-size:30;height:100px">
                  크레신 주식회사
                </td>
              </tr>
              <tr>
                <td colspan="5" style="border-bottom;0;text-align:center;border-right:0;font-size:17">
                  서울 서초구 잠원동 8-22
                </td>
              </tr>
              <tr>
                <td colspan="5" style="border-bottom;0;border-right:0;height:170px">
                  <span style="font-size:18px;letter-spacing:3pt;text-align:right;padding-right:20px;width:440px;height:60px;border:0px solid blue">
                    대표이사&nbsp;&nbsp;&nbsp;&nbsp;이&nbsp;&nbsp;종&nbsp;&nbsp;배
                  </span>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:84px;border:0px solid green">
                      <img alt="회사인장" width="84px" style="margin:0;vertical-align:top">
                        <xsl:attribute name="src">
                          /Storage/<xsl:value-of select="//config/@companycode" />/CI/cresyn_stamp.gif
                        </xsl:attribute>
                      </img>
                    </span>
                  </xsl:if>
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
            <!--<div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>-->
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
