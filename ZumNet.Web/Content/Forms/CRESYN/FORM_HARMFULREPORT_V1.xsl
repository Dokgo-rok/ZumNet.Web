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
          .m {width:700px} .m .fm-editor {height:600px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}


          /* 버튼 스타일 */
          .btn_bg {height:21px;border:1 solid #b1b1b1;background:url('/<xsl:value-of select="$root" />/EA/Images/btn_bg.gif');background-color:#ffffff;
          font-size:11px;letter-spacing:-1px;margin:0 2 0 2;padding:0 0 0 0 ;	vertical-align:middle;cursor:hand;}
          img.blt01	 {margin:0 2 0 2 ; vertical-align:middle;}
          .si-tbl img {margin:0px}


          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?} .m .ft .f-lbl3 {width:30%}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
          .m .ft select{width:100%;margin-bottom:1px;}
          select {
          text-align: center;
          text-align-last: center;
          /* webkit*/
          }
          option {
          text-align: left;
          /* reset to left*/
          }
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
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:250px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Site', '3', '처리부서')"/>
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
                <td style="width:35%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일</td>
                <td style="width:35%;border-right:0">
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
          <div class="ff" />
          <div class="ff" />


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" text-align="center">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:35%"></col>
                <col style="width:15%"></col>
                <col style="width:35%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">품명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText_u" readonly="readonly" maxlength="100" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">모델명</td>
                <td  style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText" style="width:92%" value="{//forminfo/maintable/MODELNAME}" />
                      <button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">업무 단계</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STEP" style="width:92%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STEP" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.devstep',140,120,150,90,'etc','STEP');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STEP))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">작성일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKEDATE">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MAKEDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MAKEDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>           
                <td class="f-lbl1">의뢰자</td>
                <td colspan="3"  style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ANALYSISCOUNT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ANALYSISCOUNT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ANALYSISCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="border-bottom:0">제품 수</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ANALYSISPART">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ANALYSISPART" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ANALYSISPART))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">검토</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ANALYST">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ANALYST" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ANALYST))" />
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="border-bottom:0">시험의뢰 목적</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PURPOSE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PURPOSE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PURPOSE))" />
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
            <span>&nbsp;▶ 검토조건</span>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>&nbsp;&nbsp;1. 검사 기준</span>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1">유해물질</td>
                <td class="f-lbl1">Cd</td>
                <td class="f-lbl1">Pb</td>
                <td class="f-lbl1">Hg</td>
                <td class="f-lbl1">Cr</td>
                <td class="f-lbl1">Br</td>
                <td class="f-lbl1">Cl</td>
                <td class="f-lbl1">BBP</td>
                <td class="f-lbl1">DBP</td>
                <td class="f-lbl1" style="border-right:0">DIBP</td>               
              </tr>
              <tr>
                <td style="text-align:center">유기물</td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CDYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CDYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CDYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PBYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">90</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PBYES" />skdl
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PBYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="HGYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/HGYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/HGYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CRYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CRYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CRYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BRYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BRYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BRYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CLYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CLYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BBPYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BBPYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BBPYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DBPYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DBPYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DBPYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DIBPYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DIBPYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DIBPYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="text-align:center">무기물</td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SBNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SBNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SBNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PBNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PBNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PBNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="HGNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/HGNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/HGNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CRNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CRNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CRNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  -
                </td>
                <td style="text-align:center">
                 -
                </td>
                <td style="text-align:center">
-
                </td>
                <td style="text-align:center">
                -
                </td>
                <td style="text-align:center;border-right:0">
                 -
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">유해물질</td>
                <td class="f-lbl1">DEHP</td>
                <td class="f-lbl1">Sb</td>
                <td class="f-lbl1">Sn</td>
                <td class="f-lbl1">S</td>
                <td class="f-lbl1">Phth</td>
                <td colspan="4" class="f-lbl1" style="border-right:0">TVOC</td>
              </tr>
              <tr>
                <td style="text-align:center">유기물</td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEHP" class="txtText" maxlength="100" value="{//forminfo/maintable/DEHP}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEHP))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SBYES">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/SBYES" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SBYES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  </td>
                  <td style="text-align:center">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="SNYES" class="txtText" maxlength="100" value="{//forminfo/maintable/SNYES}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SNYES))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="text-align:center">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="SYES" class="txtText" maxlength="100" value="{//forminfo/maintable/SYES}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SYES))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="text-align:center">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="PHTHYES" class="txtText" maxlength="100" value="{//forminfo/maintable/PHTHYES}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PHTHYES))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="text-align:center">Toluene</td>
                  <td style="text-align:center">Benzene</td>
                  <td style="text-align:center;font-size:9">formaldehyde</td>
                  <td style="text-align:center;border-right:0;font-size:9">
                    Phosphine
                  </td>
                </tr>
                <tr>
                  <td style="text-align:center;border-bottom:0">무기물</td>
                  <td style="text-align:center;border-bottom:0">
                    -
                  </td>
                  <td style="text-align:center;border-bottom:0">
                    -
                  </td>
                  <td style="text-align:center;border-bottom:0">
                    -
                  </td>
                  <td style="text-align:center;border-bottom:0">
                    -
                  </td>
                  <td style="text-align:center;border-bottom:0">
                    -
                  </td>
                  <td style="text-align:center;border-bottom:0">
                     <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="TOLUENE" class="txtText" maxlength="100" value="{//forminfo/maintable/TOLUENE}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOLUENE))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>                 
                  <td style="text-align:center;border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="BENZENE" class="txtText" maxlength="100" value="{//forminfo/maintable/BENZENE}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BENZENE))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="text-align:center;border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="FORMALDEHYDE" class="txtText" maxlength="100" value="{//forminfo/maintable/FORMALDEHYDE}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORMALDEHYDE))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="text-align:center;border-bottom:0;border-right:0" >
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="PHOSPHINNO" class="txtText" maxlength="100" value="{//forminfo/maintable/PHOSPHINNO}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PHOSPHINNO))" />
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
            <span>&nbsp;▶ 검토결과</span>
          </div>


          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />


          <div class="fm">
            <span>&nbsp;&nbsp;1. 자료 검토 결과</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td rowspan="2" class="f-lbl1">정밀분석자료<br/>(ICP)</td>
                <td rowspan="2" class="f-lbl1">MSDS</td>
                <td rowspan="2" class="f-lbl">REACH(SVHC)</td>
                <td colspan="3" class="f-lbl1" style="border-right:0">등록자료 확인 결과</td>
              </tr>
              <tr>
                <td class="f-lbl1">e-CIMS</td>
                <td class="f-lbl1">GMQIS</td>
                <td class="f-lbl1" style="border-right:0">HSMS</td>
              </tr>
              <tr>
                <td style="border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="DATETYPEIC" style="">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEIC),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEIC),'OK')">
                              <option value="OK" selected="selected">OK</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="OK">OK</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEIC),'NG')">
                              <option value="NG" selected="selected">NG</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="NG">NG</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEIC),'NA')">
                              <option value="NA" selected="selected">N/A</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="NA">N/A</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DATETYPEIC))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="DATETYPEMS" style="">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEMS),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEMS),'OK')">
                              <option value="OK" selected="selected">OK</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="OK">OK</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEMS),'NG')">
                              <option value="NG" selected="selected">NG</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="NG">NG</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEMS),'NA')">
                              <option value="NA" selected="selected">N/A</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="NA">N/A</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DATETYPEMS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="DATETYPERE" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPERE),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPERE),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPERE),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPERE),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DATETYPERE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="DATETYPECIMS" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPECIMS),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPECIMS),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPECIMS),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPECIMS),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DATETYPECIMS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="DATETYPEGMQIS" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEGMQIS),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEGMQIS),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEGMQIS),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEGMQIS),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DATETYPEGMQIS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="DATETYPEHSMS" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEHSMS),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEHSMS),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/VACATIONTYPE),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DATETYPEHSMS),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DATETYPEHSMS))" />
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
            <span>&nbsp;&nbsp;2. 환경라벨(환경마킹)검토결과</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td rowspan="2" class="f-lbl">
                  POLYBAG<br/>
                  (OR VINYLBAND)
                </td>
                <td class="f-lbl">판정</td>
                <td rowspan="2" class="f-lbl">
                  POLYBAG<br/>(OR VINYLBAND)
                </td>
                <td class="f-lbl" style="border-right:0">판정</td>
              </tr>
              <tr>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="POLYBAGLEFT" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGLEFT),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGLEFT),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGLEFT),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGLEFT),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/POLYBAGLEFT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="POLYBAGRIGHT" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGRIGHT),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGRIGHT),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGRIGHT),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/POLYBAGRIGHT),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/POLYBAGRIGHT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td rowspan="2" class="f-lbl" style="border-bottom:0">원산지</td>
                <td class="f-lbl">판정</td>
                <td rowspan="2" class="f-lbl" style="border-bottom:0">
                  BOX/<br/>
                  MAIN CARE/<br></br>BLISTER
                </td>
                <td class="f-lbl" style="border-right:0">판정</td>
              </tr>
              <tr>
                <td style="border-bottom:0" >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="COORIGIN" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COORIGIN),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COORIGIN),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COORIGIN),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COORIGIN),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COORIGIN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="BOXMAINCARD" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/BOXMAINCARD),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/BOXMAINCARD),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/BOXMAINCARD),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/BOXMAINCARD),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BOXMAINCARD))" />
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
            <span>&nbsp;&nbsp;3. XRF 측정 결과</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">제품수</td>
                <td class="f-lbl">측정포인트</td>
                <td class="f-lbl">양품</td>
                <td class="f-lbl">불량</td>
                <td class="f-lbl">불량 내역</td>
                <td class="f-lbl" style="border-right:0">판정</td>
              </tr>
              <tr>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCTNUM">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PRODUCTNUM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="POINT" class="txtDollar" maxlength="100" value="{//forminfo/maintable/POINT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/POINT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="IMPORTED" class="txtDollar" maxlength="100" value="{//forminfo/maintable/IMPORTED}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/IMPORTED))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEFECTIVE" class="txtDollar" maxlength="100" value="{//forminfo/maintable/DEFECTIVE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEFECTIVE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEFECTIVECON" class="txtDollar" maxlength="100" value="{//forminfo/maintable/DEFECTIVECON}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEFECTIVECON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="JUDGMENT" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/JUDGMENT))" />
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
            <span>&nbsp;&nbsp;4. GC/MS 측정 결과</span>
          </div>


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">제품수</td>
                <td class="f-lbl">측정포인트</td>
                <td class="f-lbl">양품</td>
                <td class="f-lbl">불량</td>
                <td class="f-lbl">불량 내역</td>
                <td class="f-lbl" style="border-right:0">판정</td>
              </tr>
              <tr>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCTNUM2">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PRODUCTNUM2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTNUM2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="POINT2" class="txtDollar" maxlength="100" value="{//forminfo/maintable/POINT2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/POINT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="IMPORTED2" class="txtDollar" maxlength="100" value="{//forminfo/maintable/IMPORTED2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/IMPORTED2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEFECTIVE2" class="txtDollar" maxlength="100" value="{//forminfo/maintable/DEFECTIVE2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEFECTIVE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEFECTIVECON2" class="txtDollar" maxlength="100" value="{//forminfo/maintable/DEFECTIVECON2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEFECTIVECON2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="JUDGMENT2" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT2),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT2),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT2),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JUDGMENT2),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/JUDGMENT2))" />
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
            <span>&nbsp;&nbsp;5. TVOC 측정결과</span>
          </div>


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <colgroup>
                <col style="width:20%"/>
                <col style="width:20%"/>
                <col style="width:20%"/>
                <col style="width:20%"/>
                <col style="width:20%"/>
              </colgroup>
              <tr>
                <td class="f-lbl">Toluene</td>
                <td class="f-lbl">Benzene</td>
                <td class="f-lbl">Formaldehyde</td>
                <td class="f-lbl">Phosphine</td>
                <td class="f-lbl" style="border-right:0">판정</td>
              </tr>
              <tr>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOLUENERES" class="txtDollar" maxlength="100" value="{//forminfo/maintable/TOLUENERES}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOLUENERES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BENZENERES" class="txtDollar" maxlength="100" value="{//forminfo/maintable/BENZENERES}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BENZENERES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORMALDEHYDERES" class="txtDollar" maxlength="100" value="{//forminfo/maintable/FORMALDEHYDERES}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FORMALDEHYDERES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PHOSPHINRES" class="txtDollar" maxlength="100" value="{//forminfo/maintable/PHOSPHINRES}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PHOSPHINRES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="text-align:center;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="TVOCRESULT" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TVOCRESULT),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TVOCRESULT),'OK')">
                            <option value="OK" selected="selected">OK</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="OK">OK</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TVOCRESULT),'NG')">
                            <option value="NG" selected="selected">NG</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NG">NG</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TVOCRESULT),'NA')">
                            <option value="NA" selected="selected">N/A</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="NA">N/A</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TVOCRESULT))" />
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
            <span>&nbsp;&nbsp;6. REMARK</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REMARK" style="height:40px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REMARK" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REMARK" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REMARK))" />
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

          <!--<div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-right:0"> 종합판정</td>
              </tr>
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="TOTALTYPE" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TOTALTYPE),'')">
                            <option value="" selected="Accept">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TOTALTYPE),'Accept')">
                            <option value="Accept" selected="selected">Accept</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Accept">Accept</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/TOTALTYPE),'Reject')">
                            <option value="Reject" selected="selected">Reject</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Reject">Reject</option>
                          </xsl:otherwise>
                        </xsl:choose>                       
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALTYPE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>-->



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
