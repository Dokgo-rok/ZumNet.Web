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
          .fh h1 {font-size:20.0pt;letter-spacing:4pt}

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
                    윤리경영 실천 서약서
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
        

          <div class="fm">
            <table>
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
                     
              <tr>
                <td>
                  <font style="color:#000000; font-size:14pt; font-family:맑은 고딕">                   
                      &nbsp;나는 크레신주식회사 임직원으로서 윤리경영선언과 강령을 숙지함은 물론 회사의 사회적 책임을 다하고 지속적인 성장을 하는데 있어 아래의 사항을
                      솔선수범하여 실천할 것을 약속합니다.                    
                  </font>
                </td>
              </tr>

              <tr>
                <td>
                  <font style="color:#000000; font-size:14pt; font-family:맑은 고딕">
              
                    <br/><br/>
                    1. 나는 항상 법규와 윤리강령을 준수하고 윤리경영 실천에 앞장서겠습니다.<br/><br/>
                    2. 나는 항상 고객만족과 고객의 가치창조를 위해 최선의 노력을 다하겠습니다.<br/><br/>
                    3. 나는 업무를 수행함에 있어 어떠한 불공정 거래 및 부정ㆍ비리 행위도 하지 않겠습니다.<br/><br/>
                    4. 나는 항상 크레신주식회사 인의 긍지와 자부심을 가지며, 맡은 바 직무를 성실히 수행하겠습니다.<br/><br/>
                    5. 나는 회사의 규칙이나 윤리강령에 위반하는 상황에 처하거나 이를 목격하는 경우에는 정해진 절차에 따라 신고하겠습니다.<br/><br/>
                    6. 나는 업무나 행동에 있어 의문이 있거나 윤리규범을 위반할 가능성이 있는 경우에는 상사나 윤리경영 전담부서에 문의하겠습니다.<br/><br/>
                  </font>
                </td>
                
              </tr>
              
              <tr>                
                <td>
                  <br/>
                  <font style="color:#000000; font-size:13pt; font-family:맑은 고딕">
                    상기 각 항의 내용을 충분히 숙지하였으며, 성실히 이행할 것을 서약합니다.
                  </font>
                  </td>                
              </tr>
            
              <tr>                
                <td style="text-align:center;font-family:맑은 고딕">
                  <br/><br/>                
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CTRYEAR" class="txtRead" readonly="readonly" maxlength="100" style="width:70px" value="{//forminfo/maintable/CTRYEAR}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTRYEAR))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <font style="font-family:맑은고딕"> 년 </font>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CTRMONTH" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/CTRMONTH}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTRMONTH))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <font style="font-family:맑은고딕"> 월 </font>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CTRDAY" class="txtRead" readonly="readonly" maxlength="100" style="width:50px" value="{//forminfo/maintable/CTRDAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CTRDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <font style="font-family:맑은고딕"> 일</font><br /><br />
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
              <tr style="font-family:맑은 고딕">
                <td>&nbsp;</td>
                <td style="text-align:right">위 서약인</td>
                <td style="text-align:right">소 속 : </td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THEDEPT" class="txtRead" readonly="readonly" maxlength="100" style="width:140px;font-family:맑은 고딕" value="{//forminfo/maintable/THEDEPT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THEDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <!--<td rowspan="3" style="vertical-align:top">
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:84px;border:1px solid green">
                      <img alt="개인인장" width="84px" style="margin:0;vertical-align:top">
                        <xsl:attribute name="src">
                          /Storage/<xsl:value-of select="//config/@companycode" />/SIGN/<xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_approver') and @partid!='']">
                          </xsl:apply-templates>.jpg
                        </xsl:attribute>
                      </img>
                    </span>
                  </xsl:if>
                </td>-->                
              </tr>
              <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="text-align:right;white-space:nowrap;font-family:맑은 고딕">성  명 : </td>
                <td style="white-space:nowrap;letter-spacing:8pt">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="THENAME" class="txtRead" readonly="readonly" maxlength="100" style="width:100px" value="{//forminfo/maintable/THENAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/THENAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="//bizinfo/@docstatus='700'">
                      <img alt="개인인장" width="84px" style="margin:0;vertical-align:top">
                        <xsl:attribute name="src">
                          /Storage/<xsl:value-of select="//config/@companycode" />/SIGN/<xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='normal' and (@actrole='_approver') and @partid!='']">
                          </xsl:apply-templates>.jpg
                        </xsl:attribute>
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
