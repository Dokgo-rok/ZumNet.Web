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
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:50%} .m .ft .f-lbl2 {width:17%}
          .m .ft .f-option {width:25%} .m .ft .f-option1 {width:20%;}
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
                <td style="width:255px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '제안부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='1차심의' and @partid!='' and @step!='0'], '__si_Normal', '1', '1 차심의자')"/>
                </td>
                <td style="font-size:1px;width:50px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='2차심의' and @partid!='' and @step!='0'], '__si_Normal', '1', '2 차심의자')"/>
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
                <td class="f-lbl2">문서번호</td>
                <td style="width:33%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl2">작성일자</td>
                <td style="border-right:0;width:33%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl2" style="border-bottom:0">작성자</td>
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
              <tr>
                <td class="f-lbl">제안명</td>
                <td style="text-align:center;border-right:0;width:75%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SUGGESTNAME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/SUGGESTNAME" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUGGESTNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:60px">제안사유</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SUGGESTREASON" style="height:55px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SUGGESTREASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="SUGGESTREASON" style="height:55px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUGGESTREASON))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div align="left">
            <font size="2">제안내용 (※ 제안내용은 구체적으로 서술하고, 필요 시는 근거자료를 첨부하시기 바랍니다.)</font>
          </div>
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl2" style="width:50%">개선 전</td>
                <td class="f-lbl2" style="border-right:0;width:50%">개선 후</td>
              </tr>
              <tr>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PROBLEM" style="height:270px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PROBLEM" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="PROBLEM" style="height:270px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PROBLEM))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SUMMARY" style="height:270px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SUMMARY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="SUMMARY" style="height:270px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUMMARY))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div align="left">
            <font size="2">예상효과</font>
          </div>
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:18%"></col>
                <col style="width:20%"></col>
                <col style="width:62%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl" style="" rowspan="3">유형효과</td>
                <td class="f-lbl" style="" >효과금액(년간)</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="GETFFECT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/GETFFECT" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/GETFFECT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">산출기준</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STANDFFECT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STANDFFECT" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/STANDFFECT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="">소요경비</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="USEFFECT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/USEFFECT" />
                          </xsl:attribute>
                        </xsl:if>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/USEFFECT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:70px">무형효과</td>
                <td colspan="2" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="NONFFECT" style="height:65px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/NONFFECT" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="NONFFECT" style="height:65px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NONFFECT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          
          <div align="left">
            <font size="2">1차 심의</font>
          </div>
          

          <div class="fm">
            <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$bizrole='1차심의'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:18%" />
                <col style="width:24%" />
                <col style="width:15%" />
                <col style="width:15%" />
                <col style="width:15%" />                
                <col style="width:15%" />
              </colgroup>
              <tr>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='1차심의' and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td class="f-lbl4" style="width:18%">심의등급</td>                
                <td style="border-right:0;width:82%" colspan="5">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbREGICHECK" value="S1">
                      <xsl:choose>
                        <xsl:when test="$bizrole='1차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK', this, 'REGICHECK')</xsl:attribute>                          
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK),'S1')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK),'S1')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">S</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbREGICHECK" value="A1">
                      <xsl:choose>
                        <xsl:when test="$bizrole='1차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK', this, 'REGICHECK')</xsl:attribute>                          
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK),'A1')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK),'A1')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">A</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbREGICHECK" value="B1">
                      <xsl:choose>
                        <xsl:when test="$bizrole='1차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK', this, 'REGICHECK')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK),'B1')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK),'B1')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>                      
                    </input>
                    <label for="ckb13">B</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb14" name="ckbREGICHECK" value="C1">
                      <xsl:choose>
                        <xsl:when test="$bizrole='1차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK', this, 'REGICHECK')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK),'C1')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK),'C1')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>                      
                    </input>
                    <label for="ckb14">C</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="REGICHECK">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/REGICHECK"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>                   
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">등급부여사유</td>
                <td style="border-bottom:0;border-right:0" colspan="5">
                  <xsl:choose>
                    <xsl:when test="$bizrole='1차심의'  and $partid!=''">
                      <input type="text" id="__mainfield" name="AUDITREASON">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>                        
                        <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/AUDITREASON" />
                        </xsl:attribute>                        
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/AUDITREASON))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>             
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          
          <div class="fm" id="panDisplay">
            <xsl:choose>
              <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK), 'S1') or phxsl:isEqual(string(//forminfo/maintable/REGICHECK), 'A1')">
                <xsl:attribute name="style">display:block</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <table border="0" cellspacing="0" cellpadding="0">              
              <tr>
                <td>
                  <font size="2">개선제안실행계획</font>
                </td>
              </tr>
              <tr>
                <td>
                  <table id="__subtable2" class="ft" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$bizrole='1차심의' ">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:18%" />
                      <col style="width:82%" />
                    </colgroup>
                    <tr>
                      <td class="f-lbl" style="border-top:0;width:18%">구분</td>
                      <td class="f-lbl" style="border-top:0;border-right:0;width:82%">내용</td>
                    </tr>
                    <tr>
                      <td class="f-lbl" style="height:70px">실행일정</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$bizrole='1차심의' and $partid!='' ">
                            <textarea id="__mainfield" name="REALDATE" style="height:65px">
                              <xsl:attribute name="class">txaText</xsl:attribute>
                              <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REALDATE" />
                              </xsl:attribute>
                            </textarea>
                          </xsl:when>
                          <xsl:otherwise>
                            <div name="REALDATE" style="height:65px">
                              <xsl:attribute name="class">txaRead</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALDATE))" />
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl" style="height:70px">실행방법</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$bizrole='1차심의'  and $partid!='' ">
                            <textarea id="__mainfield" name="REALWAY" style="height:65px">
                              <xsl:attribute name="class">txaText</xsl:attribute>
                              <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REALWAY" />
                              </xsl:attribute>
                            </textarea>
                          </xsl:when>
                          <xsl:otherwise>
                            <div  name="REALWAY" style="height:65px">
                              <xsl:attribute name="class">txaRead</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALWAY))" />
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl" style="height:70px">효과측정기준</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$bizrole='1차심의' and $partid!=''   ">
                            <textarea id="__mainfield" name="REALSTAND" style="height:65px">
                              <xsl:attribute name="class">txaText</xsl:attribute>
                              <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REALSTAND" />
                              </xsl:attribute>
                            </textarea>
                          </xsl:when>
                          <xsl:otherwise>
                            <div name="REALSTAND" style="height:65px">
                              <xsl:attribute name="class">txaRead</xsl:attribute>
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REALSTAND))" />
                            </div>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl" style="border-bottom:0">실행담당자</td>
                      <td style="border-bottom:0;border-right:0">
                        <xsl:choose>
                          <xsl:when test="$bizrole='1차심의' and $partid!=''  ">
                            <input type="text" id="__mainfield" name="REALPERSON">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">200</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REALPERSON" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REALPERSON))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>              
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div align="left">
            <font size="2">2차 심의</font>
          </div>

          <div class="fm">
            <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$bizrole='2차심의'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:18%" />
                <col style="width:24%" />
                <col style="width:15%" />
                <col style="width:15%" />
                <col style="width:15%" />
                <col style="width:13%" />
              </colgroup>
              <tr>
                <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='2차심의' and @partid!='']">
                </xsl:apply-templates>
              </tr>
              <tr>
                <td class="f-lbl4" style="18%">심의등급</td>
                <td style="border-right:0;width:82%" colspan="5">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbREGICHECK2" value="S">
                      <xsl:choose>
                        <xsl:when test="$bizrole='2차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK2', this, 'REGICHECK2')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK2),'S')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK2),'S')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>                      
                    </input>
                    <label for="ckb21">S</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbREGICHECK2" value="A">
                      <xsl:choose>
                        <xsl:when test="$bizrole='2차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK2', this, 'REGICHECK2')</xsl:attribute>
                        </xsl:when>                        
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK2),'A')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK2),'A')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>                      
                    </input>
                    <label for="ckb22">A</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb23" name="ckbREGICHECK2" value="B">
                      <xsl:choose>
                        <xsl:when test="$bizrole='2차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK2', this, 'REGICHECK2')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK2),'B')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK2),'B')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>                      
                    </input>
                    <label for="ckb23">B</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb24" name="ckbREGICHECK2" value="C">
                      <xsl:choose>
                        <xsl:when test="$bizrole='2차심의' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbREGICHECK2', this, 'REGICHECK2')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/REGICHECK2),'C')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/REGICHECK2),'C')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">C</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="REGICHECK2">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/REGICHECK2"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">등급부여사유</td>
                <td style="border-bottom:0;border-right:0" colspan="5">
                  <xsl:choose>
                    <xsl:when test="$bizrole='2차심의' and $partid!='' ">
                      <input type="text" id="__mainfield" name="AUDITREASON2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/AUDITREASON2" />
                        </xsl:attribute>                        
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/AUDITREASON2))" />
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

  <xsl:template match="//processinfo/signline/lines/line">
    <xsl:choose>
      <xsl:when test="phxsl:isEqual(string(@bizrole),'1차심의') or phxsl:isEqual(string(@bizrole),'2차심의')">        
          <td class="f-lbl" style="width:18%">부서 / 직책</td>
          <td style="text-align:center;width:24%">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>/<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part5))"/>
          </td>
          <td class="f-lbl" style="width:15%">심의자</td>
          <td style="text-align:center;width:15%">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
          </td>
          <td class="f-lbl" style="width:15%">심의일자</td>
          <td style="text-align:center;border-right:0;width:15%">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))"/>
          </td>         
      </xsl:when>    
    </xsl:choose>
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