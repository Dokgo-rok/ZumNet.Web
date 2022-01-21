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
          .m {width:700px} .m .fm-editor {height:400px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:4pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:7%} .m .ft .f-lbl2 {width:8%}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:40%}
          .m .ft-sub .f-option {width:49%}

          /* 기타 */
          p, li, li table td  {font-size:15px;font-family:맑은 고딕;letter-spacing:1pt;line-height:24px;vertical-align:top}
          li {margin-top: 12px}
          ul.ft-ul {margin:0;list-style:none}
          ul.ft-ul li {margin-bottom:10px}

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
                <td style="width:325px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
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
              <tr>
                <td class="f-lbl" style="border-bottom:0;">제목</td>
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
            <table >
              <tr>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <h5 class="text-danger mb-0">※ 첨부파일 확장자명은 반드시 소문자로 작성하여 주시기 바랍니다.</h5>
                    </xsl:when>
                    <xsl:otherwise>
                      &nbsp;
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
            <table class="ft" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td class="f-lbl">제출처</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORWHERE" class="txtText" maxlength="100" value="{//forminfo/maintable/FORWHERE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORWHERE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">해제사유</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);" style="height:80px">
                        <xsl:value-of select="//forminfo/maintable/REASON" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEVLIST" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div style="border:1px solid windowtext;border-top:0;padding:20px;text-align:left">
            <ol>
              <li>
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" name="txtAPPLDN" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:50px" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLDN))" />
                  </xsl:otherwise>
                </xsl:choose>(이하 '본인'이라 한다)는 본 결재문서의 첨부파일에 있는 문서보안해제 요청 파일에 대하여 사용용도 이외의 곳에 사용하지 않을 것을 서약합니다.
              </li>
              <li>
                만약 본 서약을 위반하는 행위로 회사에게 손해를 끼쳤을 경우 본인은 회사가 입은 일체의 손해를 배상할 책임을 지겠습니다.
              </li>
            </ol>

            <p style="text-align:center">
              <span>
                위 사항에 대해 동의합니다 <input type="checkbox" id="ckb11" name="ckbAGREE1" value="동의함">
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <xsl:attribute name="onclick">_zw.form.checkYN('ckbAGREE1', this, 'AGREE1')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/AGREE1),'동의함')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/AGREE1),'동의함')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
              </span>
            </p>

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

            <ul class="ft-ul" style="text-align: right">
              <li>
                <xsl:if test="//bizinfo/@docstatus='700'">
                  <xsl:attribute name="style">margin-bottom:-2px</xsl:attribute>
                </xsl:if>
                소&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속 :
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" name="txtAPPLDEPT" class="txtRead" readonly="readonly" value="{//creatorinfo/department}" style="width:180px" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLDEPT))" />
                  </xsl:otherwise>
                </xsl:choose>
              </li>
              <li>
                <xsl:if test="//bizinfo/@docstatus='700'">
                  <xsl:attribute name="style">margin-top:-2px;margin-bottom:-2px</xsl:attribute>
                </xsl:if>
                성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;명 :
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" name="txtAPPLDN" class="txtRead" readonly="readonly" value="{//creatorinfo/name}" style="width:180px" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLDN))" />
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="//bizinfo/@docstatus='700'">
                  <span style="width:40px;border:0px solid green">
                    <img alt="" style="width:45px;vertical-align:middle" src="/Storage/{//config/@companycode}/Sign/{//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_drafter') and @partid!='']/part2}.jpg" />
                  </span>
                </xsl:if>
              </li>
            </ul>
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

        <!-- 숨은 필드 -->
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="hidden" id="__mainfield" name="APPLID" value="{//creatorinfo/@uid}" />
            <input type="hidden" id="__mainfield" name="APPLDEPTID" value="{//creatorinfo/@deptid}" />
            <input type="hidden" id="__mainfield" name="APPLDN" value="{//creatorinfo/name}" />
            <input type="hidden" id="__mainfield" name="APPLGRADE" value="{//creatorinfo/grade}" />
            <input type="hidden" id="__mainfield" name="APPLDEPT" value="{//creatorinfo/department}" />
            <input type="hidden" id="__mainfield" name="APPLCORP" value="{//creatorinfo/belong}" />
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" id="__mainfield" name="APPLID" value="{//forminfo/maintable/APPLID}" />
            <input type="hidden" id="__mainfield" name="APPLDEPTID" value="{//forminfo/maintable/APPLDEPTID}" />
            <input type="hidden" id="__mainfield" name="APPLDN" value="{//forminfo/maintable/APPLDN}" />
            <input type="hidden" id="__mainfield" name="APPLGRADE" value="{//forminfo/maintable/APPLGRADE}" />
            <input type="hidden" id="__mainfield" name="APPLDEPT" value="{//forminfo/maintable/APPLDEPT}" />
            <input type="hidden" id="__mainfield" name="APPLCORP" value="{//forminfo/maintable/APPLCORP}" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" id="__mainfield" name="AGREE1" value="{//forminfo/maintable/AGREE1}" />

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
