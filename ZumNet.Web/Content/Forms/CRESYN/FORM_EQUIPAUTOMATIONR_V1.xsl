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
          .m {width:700px} .m .fm-editor {height:350px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:17%}
          .m .ft .f-option {width:18%} .m .ft .f-option1 {width:30%;} .m .ft .f-option2 {width:33%;}
          .m .ft-sub .f-option {width:49%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:350px}}
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
                <td style="width:345px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5', '작성부서')"/>
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0;">제목</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//docinfo/subject" />
                        </xsl:attribute>
                      </input>
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">법인명</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOCATION" style="width:90%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LOCATION" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnView('external.centercode',300,180,80,140,'etc','LOCATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOCATION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">모델명</td>
                <td style="border-right:0;width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNUM" class="txtText" maxlength="50" width="50%" value="{//forminfo/maintable/MODELNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
                  <tr>
                    <td class="f-lbl">부품명</td>
                    <td style="border-right:0" colspan="3" >
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="MODELNUM2">
                            <xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="maxlength">50</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/MODELNUM2" />
                            </xsl:attribute>
                          </input>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNUM2))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </td>
                    <tr>
                      <td class="f-lbl">공정명</td>
                      <td style="width:35%;border-right:0" colspan="3">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="OFFINAME">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">50</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/OFFINAME" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/OFFINAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>                     
                    </tr>
                    <tr>
                      <td class="f-lbl">표준공수</td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="NORMNUM">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="style">width:90%</xsl:attribute>                              
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/NORMNUM" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NORMNUM))" />
                          </xsl:otherwise>
                        </xsl:choose>초
                      </td>
                      <td class="f-lbl">현재 작업인원</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WORKUNIT">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="style">width:90%</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/WORKUNIT" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/WORKUNIT))" />
                          </xsl:otherwise>
                        </xsl:choose>명
                      </td>
                    </tr>      
                  </tr> 
               <tr>
                <td class="f-lbl" style="border-bottom:0">우선순위</td>
                <td style="border-right:0;border-bottom:0" colspan="3">1.
                  <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <select id="__mainfield"  name="RANKCHECK" style="">
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK),'')">
                          <option value="" selected="selected">선택</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="">선택</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK),'생산성')">
                          <option value="생산성" selected="selected">생산성</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="생산성">생산성</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK),'품질')">
                          <option value="품질" selected="selected">품질</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="품질">품질</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK),'인원절감')">
                          <option value="인원절감" selected="selected">인원절감</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="인원절감">인원절감</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK),'기타')">
                          <option value="기타" selected="selected">기타</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="기타">기타</option>
                        </xsl:otherwise>
                      </xsl:choose>
                    </select>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RANKCHECK))" />
                  </xsl:otherwise>
                  </xsl:choose>
                  2.
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="RANKCHECK2" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK2),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK2),'생산성')">
                            <option value="생산성" selected="selected">생산성</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="생산성">생산성</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK2),'품질')">
                            <option value="품질" selected="selected">품질</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="품질">품질</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK2),'인원절감')">
                            <option value="인원절감" selected="selected">인원절감</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="인원절감">인원절감</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK2),'기타')">
                            <option value="기타" selected="selected">기타</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="기타">기타</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RANKCHECK2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  3.
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="RANKCHECK3" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK3),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK3),'생산성')">
                            <option value="생산성" selected="selected">생산성</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="생산성">생산성</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK3),'품질')">
                            <option value="품질" selected="selected">품질</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="품질">품질</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK3),'인원절감')">
                            <option value="인원절감" selected="selected">인원절감</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="인원절감">인원절감</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK3),'기타')">
                            <option value="기타" selected="selected">기타</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="기타">기타</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RANKCHECK3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  4.
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="RANKCHECK4" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK4),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK4),'생산성')">
                            <option value="생산성" selected="selected">생산성</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="생산성">생산성</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK4),'품질')">
                            <option value="품질" selected="selected">품질</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="품질">품질</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK4),'인원절감')">
                            <option value="인원절감" selected="selected">인원절감</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="인원절감">인원절감</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RANKCHECK4),'기타')">
                            <option value="기타" selected="selected">기타</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="기타">기타</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RANKCHECK4))" />
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
            <span>예상 기대 효과</span>
          </div>
          <div class="ff" />
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">             
              <td colspan="4" style="border-right:0;border-bottom:0">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <textarea id="__mainfield" name="EFFECT" style="height:80px">
                      <xsl:attribute name="class">txaText</xsl:attribute>
                      <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                      <xsl:if test="$mode='edit'">
                        <xsl:value-of select="//forminfo/maintable/EFFECT" />
                      </xsl:if>
                    </textarea>
                  </xsl:when>
                  <xsl:otherwise>
                    <div id="__mainfield" name="EFFECT" style="height:80px">
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EFFECT))" />
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
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
                <span>작업지도서 첨부</span>
              </tr>
              <td style="border-bottom:0;border-right:0">
                &nbsp;&nbsp;&nbsp;&nbsp;
                <span class="f-option">
                  <input type="checkbox" id="ckb11" name="ckbENTRYTYPE" value="예">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbENTRYTYPE', this, 'ENTRYTYPE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/ENTRYTYPE),'예')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/ENTRYTYPE),'예')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb11">예</label>
                </span>
                <span class="f-option">
                  <input type="checkbox" id="ckb12" name="ckbENTRYTYPE" value="아니요">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbENTRYTYPE', this, 'ENTRYTYPE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/ENTRYTYPE),'아니요')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/ENTRYTYPE),'아니요')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb12">아니요</label>
                </span>
                <input type="hidden" id="__mainfield" name="ENTRYTYPE">
                  <xsl:attribute name="value">
                    <xsl:value-of select="//forminfo/maintable/ENTRYTYPE"></xsl:value-of>
                  </xsl:attribute>
                </input>
              </td>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>별도 요청 사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <td colspan="4" style="border-right:0;border-bottom:0">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <textarea id="__mainfield" name="EFFECT2" style="height:80px">
                      <xsl:attribute name="class">txaText</xsl:attribute>
                      <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                      <xsl:if test="$mode='edit'">
                        <xsl:value-of select="//forminfo/maintable/EFFECT2" />
                      </xsl:if>
                    </textarea>
                  </xsl:when>
                  <xsl:otherwise>
                    <div id="__mainfield" name="EFFECT2" style="height:80px">
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EFFECT2))" />
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </table>
          </div>



          <div class="ff" />
          <div class="ff" />
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
