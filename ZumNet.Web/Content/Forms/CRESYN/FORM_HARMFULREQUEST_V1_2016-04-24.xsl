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
          .m {width:710px} .m .fm-editor {height:400px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:10pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:40%}
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:330px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:330px">
                  <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Site', '4', '처리부서')"/>-->
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
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
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%" />
                <col style="width:35%" />
                <col style="width:15%" />
                <col style="width:35%" />
                <col />
              </colgroup>
              <tr>
                <td class="f-lbl" style="">품명</td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="">모델명</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText_u" readonly="readonly"  style="width:92%" value="{//forminfo/maintable/MODELNAME}" />
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
                <td class="f-lbl" style="">단계</td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STEP" style="width:91%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STEP" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.devstep',120,150,140,120,'etc','STEP');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
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
                <td class="f-lbl" style="">의뢰부서</td>
                <td style="border-right:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="">검토완료희망일</td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FINISHDATE">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="style">width:100px</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FINISHDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FINISHDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="">담당자</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REVPERSON" >
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/REVPERSON" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REVPERSON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">시료수</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCOUNT" style="width:100%">
                        <xsl:attribute name="class">txtNumberic</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PRODUCOUNT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCOUNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">생산지</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOCATION" style="width:91%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LOCATION" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.centercode',200,120,130,50,'etc','LOCATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOCATION))" />
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
            <span>1.의뢰목적 및 내용</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:40px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1500)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REASON" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
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
            <span>2.검토조건</span>
          </div>
          <div class="fm">
            <span>1) 고객요청 관리기준(고객 :
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
                <input type="text" id="__mainfield" name="CUSTOMER" style="width:200px">
                  <xsl:attribute name="class">txtText_u</xsl:attribute>
                  <xsl:attribute name="readonly">readonly</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                  </xsl:attribute>
                </input>
                <button onclick="parent.fnOption('external.customecode',140,120,130,50,'etc','CUSTOMER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                  <img alt="" class="blt01" style="margin:0 0 2px 0">
                    <xsl:attribute name="src">
                      /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                    </xsl:attribute>
                  </img>
                </button>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
              </xsl:otherwise>
            </xsl:choose>)
            </span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:12%" />                
                <col />
              </colgroup>
              <tr>
                <td class="f-lbl" style="width:11%;height:60px">RoHS</td>
                <td class="f-lbl" style="width:11%">Halgen<br />(Br/Cl)<br />Free</td>
                <td class="f-lbl" style="width:11%">PVC<br />Free</td>
                <td class="f-lbl" style="width:11%">Be(베릴륨)<br />Free</td>
                <td class="f-lbl" style="width:11%">Phthalate<br />Free</td>
                <td class="f-lbl" style="width:11%">Sb(안티몬)<br />Free</td>
                <td class="f-lbl" style="width:11%">Sb203<br />(삼산화안티몬) Free</td>
                <td class="f-lbl" style="width:11%">Ni<br />Free</td>
                <td class="f-lbl" style="width:12%;border-right:0">기타<br />(미국,캐나다 등)</td>
              </tr>
              <tr>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS0" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS0),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS0),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS0),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS0))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS1" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS1),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS1),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS1),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>                      
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS2" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS2),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS2),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS2),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS3" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS3),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS3),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS3),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS4" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS4),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS4),'7종')">
                            <option value="7종" selected="selected">7종</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="7종">7종</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS4),'10종')">
                            <option value="10종" selected="selected">10종</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="10종">10종</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS5" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS5),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS5),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS5),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS6" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS6),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS6),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS6),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS7" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS7),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS7),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS7),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0;text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="JOBCLASS8" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS8),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS8),'적용')">
                            <option value="적용" selected="selected">적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="적용">적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/JOBCLASS8),'미적용')">
                            <option value="미적용" selected="selected">미적용</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="미적용">미적용</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/JOBCLASS8))" />
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
            <span>2) 유해물질 분석시료에 대한 사전 검사 요구사항</span>
          </div>

          <div class="fm" style="">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="width:70%">1. 외관상에 문제는 없는가?</td>
                <td style="width:30%;border-right:0;text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbTYPE1" value="YES">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE1', this, 'TYPE1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE1),'YES')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE1),'YES')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">YES</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbTYPE1" value="NO">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE1', this, 'TYPE1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE1),'NO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE1),'NO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">NO</label>
                  </span>                
                  <input type="hidden" id="__mainfield" name="TYPE1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/TYPE1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="">2. 구조 / 기능상에 문제는 없는가?</td>
                <td style="border-right:0;text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbTYPE2" value="YES">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE2', this, 'TYPE2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE2),'YES')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE2),'YES')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">YES</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbTYPE2" value="NO">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE2', this, 'TYPE2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE2),'NO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE2),'NO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TYPE2">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/TYPE2"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="">3. 분리배출 마크 및 각인 사양은 확인하였는가?</td>
                <td style="border-right:0;text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbTYPE3" value="YES">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE3', this, 'TYPE3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE3),'YES')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE3),'YES')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">YES</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb32" name="ckbTYPE3" value="NO">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE3', this, 'TYPE3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE3),'NO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE3),'NO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TYPE3">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/TYPE3"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px;border-bottom:0">4. 최종 제품을 의뢰하는가?<br />(각 개발단계 또는 고객제출 최종 승인시료 등)</td>
                <td style="border-right:0;text-align:center;border-bottom:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb41" name="ckbTYPE4" value="YES">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE4', this, 'TYPE4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE3),'YES')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE4),'YES')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">YES</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb42" name="ckbTYPE4" value="NO">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbTYPE4', this, 'TYPE4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/TYPE3),'NO')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/TYPE4),'NO')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb42">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="TYPE4">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/TYPE4"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>3) 분리배출 마크 및 인증 마크 적용(※ 해당되는 항목에"ㅇ"표기)</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:23%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />
                <col style="width:11%" />                                
              </colgroup>
              <tr>
                <td class="f-lbl" style="width:23%" rowspan="2">POLYBAG</td>
                <td class="f-lbl" style="width:11%">국내                  
                </td>
                <td class="f-lbl" style="width:11%">미주
                </td>
                <td class="f-lbl" style="width:11%">캐나다                  
                </td>
                <td class="f-lbl" style="width:11%">일본
                </td>
                <td class="f-lbl" style="width:11%">중국
                </td>
                <td class="f-lbl" style="width:11%">유럽
                </td>
                <td class="f-lbl" style="width:11%;border-right:0">기타
                </td>
              </tr>
              <tr>
                <td style="width:11%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY1">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY1" />
                        </xsl:attribute>
                      </input>                      
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COUNTRY7">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COUNTRY7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COUNTRY7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="width:23%;border-bottom:0" rowspan="2">Blister / Gift Box<br />/ MAIN CARD
                </td>
                <td class="f-lbl" style="width:11%">
                  국내
                </td>
                <td class="f-lbl" style="width:11%">
                  미주
                </td>
                <td class="f-lbl" style="width:11%">
                  캐나다
                </td>
                <td class="f-lbl" style="width:11%">
                  일본
                </td>
                <td class="f-lbl" style="width:11%">
                  중국
                </td>
                <td class="f-lbl" style="width:11%">
                  유럽
                </td>
                <td class="f-lbl" style="width:11%;border-right:0">
                  기타
                </td>
              </tr>
              <tr>
                <td  style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td  style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td  style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td  style="width:11%;border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GROUP7">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/GROUP7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GROUP7))" />
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
            <span>4) 각인 사양(CASE/MOLD 등)</span>
          </div>

          <div class="fm" style="">
            <table  border="0" cellspacing="0" cellpadding="0" style="width:100%">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>                
                <td style="border-right:0;text-align:center;border-bottom:0;width:100%;height:30px">
                  <span class="f-option" style="width:200px;text-align:left">
                    <input type="checkbox" id="ckb91" name="ckbCASE" value="CHINA">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCASE', this, 'CASE1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CASE1),'CHINA')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CASE1),'CHINA')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb91">MADE IN CHINA</label>
                  </span>
                  <span class="f-option" style="width:200px">
                    <input type="checkbox" id="ckb92" name="ckbCASE" value="INDONESIA">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCASE', this, 'CASE1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CASE1),'INDONESIA')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CASE1),'INDONESIA')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb92">MADE IN INDONESIA</label>
                  </span>
                  <span class="f-option" style="width:200px">
                    <input type="checkbox" id="ckb93" name="ckbCASE" value="WEEE">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCASE', this, 'CASE1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CASE1),'WEEE')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CASE1),'WEEE')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb93">WEEE(쓰레기통 마크)</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CASE1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CASE1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
         
          <div class="fm">
            <span>3. 특이사항</span>
          </div>

          <div class="fm-editor">
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <div name="WEBEDITOR" id="__mainfield" style="width:100%;height:100%;padding:4px 4px 4px 4px;position:relative">
                  <xsl:attribute name="class">txaRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="$mode='edit'">
                  <textarea id="bodytext" style="display:none">
                    <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                  </textarea>
                </xsl:if>
                <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no">
                  <xsl:attribute name="src">
                    /<xsl:value-of select="$root" />/EA/External/Editor_tagfree.aspx
                  </xsl:attribute>
                </iframe>
              </xsl:otherwise>
            </xsl:choose>
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
                          <td class="file-title">#첨부자료</td>
                        </tr>
                        <tr>
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
  