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
          .m {width:1000px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:-2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50%} .m .ft .f-option2 {width:70%}
          .m .ft-sub .f-option {width:49%}

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
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '결재')"/>
                </td>
                <!--<td style="font-size:1px">&nbsp;</td>
                <td style="width:355px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
                </td>-->
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:17%;border-bottom:0">
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
            <table>
              <tr>
                <td style="border-bottom;0;text-align:center;border-right:0;font-size:14px;height:30px">
                  UNIT ASS'Y 월불 발생 현황 통보서 ( 문서번호 :
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DOCUMENTNO" style="width:20%" class="txtText" maxlength="50" value="{//forminfo/maintable/DOCUMENTNO}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="DOCUMENTNO" style="width:20%" class="txtRead" maxlength="50" value="{//forminfo/maintable/DOCUMENTNO}" />
                    </xsl:otherwise>
                  </xsl:choose>
                  )에 의해 통보된 UNIT ASS'Y 원불 품의 확인 결과
                </td>
              </tr>
              <tr>
                <td style="border-bottom;0;border-right:0;font-size:14px;height:30px;padding-left:120px;">
                  아래 사항으로 불량 수량을 최종 합의 합니다.
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
                <td class="f-lbl"> 통보된 원불 총 수량</td>
                <td class="f-lbl" style="border-right:0">상호 확인 최종 수량</td>
              </tr>
              <tr>
                <td style="border-bottom:0;height:100px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="RETURNAMOUNT" class="txtCurrency" style="height:100%;font-size:50pt;text-align:center;" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/RETURNAMOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="RETURNAMOUNT" class="txaRead" style="height:100%;font-size:50pt;text-align:center;" >
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RETURNAMOUNT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CONFIRMAMOUNT" class="txtCurrency" style="height:100%;font-size:50pt;text-align:center;" maxlength="20" data-inputmask="number;20;0" value="{//forminfo/maintable/CONFIRMAMOUNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="RETURNAMOUNT" class="txaRead" style="height:100%;font-size:50pt;text-align:center;" >
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONFIRMAMOUNT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">원불 내역</td>
                <td colspan="5" style="border-right:0;border-bottom:0">
                  ※ 첨부 - UNIT ASS'Y 원불 검사 성적서
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
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table>
              <tr>
                <td style="border-bottom;0;text-align:center;border-right:0;font-size:14px;height:30px;width:50%">
                    <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CORPORATION" style="width:50px;font-size:10pt;">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <!--<xsl:attribute name="readonly">readonly</xsl:attribute>-->
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CORPORATION" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.chartcentercode',180,140,70,122,'','CORPORATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18 mr-2" title="개발단계" onclick="_zw.formEx.optionWnd('external.chartcentercode',220,304,-100,0,'','CORPORATION');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <span class="txaRead" style="width:50px;font-size:10pt" >
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CORPORATION))" />
                      </span>
                    </xsl:otherwise>
                  </xsl:choose>QC 부서장
                </td>
                <td style="border-bottom;0;text-align:center;border-right:0;font-size:14px;height:30px;width:50%">
                  IS QC 부서장
                </td>
              </tr>
              <tr>
                <td style="border-bottom;0;text-align:center;border-right:0;font-size:14px;vertical-align:middle">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),6,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//docinfo/createdate),9,2)" />일&nbsp;&nbsp;&nbsp;
                    </xsl:when>
                    <xsl:otherwise>
                    20<xsl:value-of select="substring(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='']/@completed),1,2)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='']/@completed),4,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='']/@completed),7,2)" />일&nbsp;&nbsp;&nbsp;
                    </xsl:otherwise>
                  </xsl:choose>

                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='']/partname))" />

                  <xsl:if test="//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='']/part2!=''">
                    <span style="width:50px;border:0 solid green">
                      <img alt="" style="margin:0;width:50;vertical-align:middle" src="/Storage/{//config/@companycode}/Sign/{//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_drafter' and @partid!='']/part2}.jpg" />
                    </span>
                  </xsl:if>
                </td>
                <td style="border-bottom;0;text-align:center;border-right:0;font-size:14px;vertical-align:middle">
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    20<xsl:value-of select="substring(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='']/@completed),1,2)" />&nbsp;년&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='']/@completed),4,2)" />&nbsp;월&nbsp;&nbsp;
                      <xsl:value-of select="substring(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='']/@completed),7,2)" />일&nbsp;&nbsp;&nbsp;

                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='']/partname))" />

                    <span style="width:50px;border:0px solid green">
                      <img alt="" style="margin:0;width:50;vertical-align:middle" src="/Storage/{//config/@companycode}/Sign/{//processinfo/signline/lines/line[@bizrole='normal' and @actrole='_approver' and @partid!='']/part2}.jpg" />
                    </span>
                  </xsl:if>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

			<xsl:if test="//linkeddocinfo/linkeddoc or //fileinfo/file[@isfile='Y']">
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
