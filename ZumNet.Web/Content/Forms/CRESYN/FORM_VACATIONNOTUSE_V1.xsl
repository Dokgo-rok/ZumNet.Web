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
          .m {width:710px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:18%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

          <!--.m .ft td,.m .ft td span {font-family:굴림}-->

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

          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @actrole !='_drafter' and @partid!='' and @step!='0'], '__si_Normal', '4', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
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


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="height:60px">
                  성명
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <!--<button onclick="parent.fnOrgmap('ur','N','THENAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                    </button>-->
					  <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="대상자" onclick="_zw.fn.org('user','n', this);">
						  <i class="fas fa-angle-down"></i>
					  </button>
                  </xsl:if>
                </td>
                <td class="tdRead_Center" style="width: 32%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THENAME" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/THENAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THENAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">생년월일</td>
                <td class="tdRead_Center" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THEBIRTH" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/THEBIRTH}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THEBIRTH))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:60px">입사일</td>
				<td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THEIN" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/THEIN}" />
                     </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THEIN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BEFOREYEAR))" />년 발생연차</td>
                <td style="text-align:center;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THEVAC" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/THEVAC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THEVAC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:60px;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BEFOREYEAR))" />년 사용연차</td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THEVACUSE" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/THEVACUSE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THEVACUSE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BEFOREYEAR))" />년 미사용연차</td>
                <td style="border-bottom:0;text-align:center;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THEVACNOTUSE" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/THEVACNOTUSE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/THEVACNOTUSE))" />
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

          <div>
            <table>
              <tr>
                <td>
                  <br/>
                  <font style="color:#000000; font-size:13pt; font-family:맑은 고딕">
                    상기 본인은 
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="BEFOREYEAR" class="txtVolumne" maxlength="4" data-inputmask="date;yyyy" style="width: 80px" value="{//forminfo/maintable/BEFOREYEAR}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BEFOREYEAR))" />
                      </xsl:otherwise>
                    </xsl:choose>년도 미 사용 연차에 대하여  
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="NOWYEAR" class="txtVolumne" maxlength="4" data-inputmask="date;yyyy" style="width: 80px" value="{//forminfo/maintable/NOWYEAR}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NOWYEAR))" />
                      </xsl:otherwise>
                    </xsl:choose>년으로 이월하여 사용하는데 동의합니다.
                  </font>
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


          <div>
            <p style="font-size: 11pt; text-align:right;margin:40px">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), 'ko')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/publishdate), 'ko')" />
                </xsl:otherwise>
              </xsl:choose>
            </p>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:40%"></col>
                <col style="width:15%"></col>
                <col style="width:10%"></col>
                <col style="width:10%"></col>
                <col style="width:25%"></col>
              </colgroup>
              <tr>
                <td>&nbsp;</td>
                <td style="font-size: 11pt; text-align:right">위 서약인</td>
                <td style="font-size: 11pt; text-align:right">성 명 : </td>
                <td style="font-size: 11pt; ">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THENAME))" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="//bizinfo/@docstatus='700'">
                      <img alt="개인인장" width="84px" style="margin:0;vertical-align:top" src="/Storage/{//config/@companycode}/SIGN/{//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_reviewer') and @partid!='']}">
                        <!--<xsl:attribute name="src">
                          /Storage/<xsl:value-of select="//config/@companycode" />/SIGN/<xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_reviewer') and @partid!='']">
                          </xsl:apply-templates>.jpg
                        </xsl:attribute>-->
                      </img>
                    </xsl:when>
                    <xsl:otherwise>&nbsp;</xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>            
              <tr>
                <td colspan="5" style="text-align:center;height:100px">
                  <font style="color:#000000; font-size:15pt; font-family:맑은 고딕">크레신주식회사 대표이사 귀하</font>
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

        <!-- Hidden Field -->
        <input type="hidden" id="__mainfield" name="THEID" value="{//forminfo/maintable/THEID}" />
        <input type="hidden" id="__mainfield" name="THEEMPID" value="{//forminfo/maintable/THEEMPID}" />
        <input type="hidden" id="__mainfield" name="THEGRADE" value="{//forminfo/maintable/THEGRADE}" />
        <input type="hidden" id="__mainfield" name="THEDEPTID" value="{//forminfo/maintable/THEDEPTID}" />

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
