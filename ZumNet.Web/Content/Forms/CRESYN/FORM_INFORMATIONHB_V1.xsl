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
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '제안부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='심의자' and @parent='' and @viewstate!='0' and @partid!='' and @step!='0'], '__si_OnlyOne', '1', '심의자')"/>
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
              <colgroup>
                <col style="width:18%"></col>
                <col style="width:41%"></col>
                <col style="width:41%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">제안명</td>
                <td style="text-align:left;border-right:0" colspan="2">
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
                <td class="f-lbl" style="">제안구분</td>
                <td style="border-right:0" colspan="2">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb15" name="ckbNEWPRODUCT" value="신기술삼성무선제품">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbNEWPRODUCT', this, 'NEWPRODUCT')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/NEWPRODUCT),'신기술삼성무선제품')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/NEWPRODUCT),'신기술삼성무선제품')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">신기술(삼성 무선 제품)</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb16" name="ckbNEWPRODUCT" value="신제품삼성무선제품외">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbNEWPRODUCT', this, 'NEWPRODUCT')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/NEWPRODUCT),'신제품삼성무선제품외')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/NEWPRODUCT),'신제품삼성무선제품외')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">신제품(삼성 무선 제품외)</label>
                  </span>&nbsp;&nbsp;&nbsp;
                  <span class="f-option1">
                    <input type="checkbox" id="ckb17" name="ckbNEWPRODUCT" value="GVE">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbNEWPRODUCT', this, 'NEWPRODUCT')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/NEWPRODUCT),'GVE')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/NEWPRODUCT),'GVE')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb14">GVE</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="NEWPRODUCT">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/NEWPRODUCT"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">정보출처<br></br>(세부내용 요약)
              </td>
                <td style="border-right:0" colspan="2">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbGENDER" value="외부고객">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'외부고객')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'외부고객')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">외부고객</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbGENDER" value="내부고객">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'내부고객')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'내부고객')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">내부고객</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb13" name="ckbGENDER" value="인터넷정보">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'인터넷정보')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'인터넷정보')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb13">인터넷정보</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb14" name="ckbGENDER" value="전문서적신문잡지">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'전문서적신문잡지')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'전문서적신문잡지')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb14">전문서적,신문,잡지 등</label>
                  </span>                  
                  <input type="hidden" id="__mainfield" name="GENDER">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/GENDER"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td style="border-right:0;height:100px" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="INFSOURCE" style="height:95px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/INFSOURCE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="INFSOURCE" style="">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INFSOURCE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:200px">정보내용</td>
                <td style="border-right:0" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="INFORMATION" style="height:195px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/INFORMATION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="INFORMATION" style="">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INFORMATION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0" rowspan="2">정보<br />활용방안</td>
                <td class="f-lbl" style="height:30px">유형 효과</td>
                <td class="f-lbl" style="border-right:0">무형 효과</td>
              </tr>
              <tr>
                <td style="border-bottom:0;height:150px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PROBLEM" style="height:145px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PROBLEM" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="PROBLEM" style="">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PROBLEM))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SUMMARY" style="height:145px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SUMMARY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="SUMMARY" style="">
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
          <div class="ff" />
          <div class="ff" />

          <div align="left">
            <font size="2">심의</font>
          </div>


          <div class="fm">
            <table id="__si_Form"  class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$bizrole='심의자'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>                            
              <tr>
                <td class="f-lbl4" style="width:18%;border-bottom:0" rowspan="2">심의결정</td>
                <td style="width:20%">
                  <span class="">
                    <input type="checkbox" id="ckb21" name="ckbCHECK1" value="채택">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK1', this, 'CHECK1')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECK1),'채택')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK1),'채택')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">채택</label>
                  </span>            
                  <input type="hidden" id="__mainfield" name="CHECK1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECK1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td style="border-right:0;width:61%">
                  <span class="f-option2">
                    <input type="checkbox" id="ckb22" name="ckbCHECKCONTENT1" value="신제품개발검토">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKCONTENT1', this, 'CHECKCONTENT1')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECKCONTENT1),'신제품개발검토')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKCONTENT1),'신제품개발검토')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">신제품 개발 검토</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb23" name="ckbCHECKCONTENT2" value="정보공유">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKCONTENT2', this, 'CHECKCONTENT2')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECKCONTENT2),'정보공유')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKCONTENT2),'정보공유')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">정보공유</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb24" name="ckbCHECKCONTENT3" value="개발시정보참조">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKCONTENT3', this, 'CHECKCONTENT3')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECKCONTENT3),'개발시정보참조')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKCONTENT3),'개발시정보참조')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">개발시 정보 참조</label>
                  </span>                 
                  <input type="hidden" id="__mainfield" name="CHECKCONTENT1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKCONTENT1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                  <input type="hidden" id="__mainfield" name="CHECKCONTENT2">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKCONTENT2"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                  <input type="hidden" id="__mainfield" name="CHECKCONTENT3">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKCONTENT3"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td style="width:20%;border-bottom:0">
                  <span class="">
                    <input type="checkbox" id="ckb31" name="ckbCHECK1" value="불채택">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK1', this, 'CHECK1')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECK1),'불채택')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK1),'불채택')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">불채택</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECK1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECK1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td style="border-right:0;width:61%;border-bottom:0">
                  <span class="f-option2">
                    <input type="checkbox" id="ckb32" name="ckbCHECKCONTENT4" value="시장성없음">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKCONTENT4', this, 'CHECKCONTENT4')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECKCONTENT4),'시장성없음')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKCONTENT4),'시장성없음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">시장성 없음</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb33" name="ckbCHECKCONTENT5" value="개발실효성없음">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKCONTENT5', this, 'CHECKCONTENT5')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECKCONTENT5),'개발실효성없음')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKCONTENT5),'개발실효성없음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb33">개발실효성 없음</label>
                  </span>
                  <span class="f-option2">
                    <input type="checkbox" id="ckb34" name="ckbCHECKCONTENT6" value="기타">
                      <xsl:choose>
                        <xsl:when test="$bizrole='심의자' and $partid!='' ">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKCONTENT6', this, 'CHECKCONTENT6')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/CHECKCONTENT6),'기타')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKCONTENT6),'기타')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb34">기타</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKCONTENT4">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKCONTENT4"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                  <input type="hidden" id="__mainfield" name="CHECKCONTENT5">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKCONTENT5"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                  <input type="hidden" id="__mainfield" name="CHECKCONTENT6">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKCONTENT6"></xsl:value-of>
                    </xsl:attribute>
                  </input>
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