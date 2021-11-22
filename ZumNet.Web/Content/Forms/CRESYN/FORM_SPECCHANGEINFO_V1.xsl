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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 1pt solid;border-top:0}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:8%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:50%}

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
                <td style="width:315px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '통보부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:380px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'distribution', '__si_Distribution', '5', '배포부서')"/>
                </td>
              </tr>
            </table>
          </div>

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

          <div class="fm">
            <span>1. 설계사양변경</span>
          </div>
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:17.5%"></col>
                <col style="width:17.5%"></col>
                <col style="width:15%"></col>
                <col style="width:35%"></col>                
              </colgroup>
              <tr>
                <td class="f-lbl">MODEL</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MODELNAME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">도면번호</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DRAWNUM">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DRAWNUM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DRAWNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">부품명</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNAME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTNAME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">부품번호</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNUM">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTNUM" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">
                  구 부품<br />사용관계
                </td>
                <td style="text-align:center">
                  <input type="checkbox" id="ckb11" name="ckbCHECKUSE" value="사용가능">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKUSE', this, 'CHECKUSE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKUSE),'사용가능')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKUSE),'사용가능')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb11">사용가능</label>
                </td>
                <td colspan="3" rowspan="2" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PARTRELATION" style="height:40px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PARTRELATION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="PARTRELATION" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTRELATION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="text-align:center">
                  <input type="checkbox" id="ckb12" name="ckbCHECKUSE" value="사용불가">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKUSE', this, 'CHECKUSE')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKUSE),'사용불가')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKUSE),'사용불가')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb12">사용불가</label>
                </td>                
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">
                  적용 LOT
                </td>
                <td style="text-align:center">
                  <input type="checkbox" id="ckb13" name="ckbCHECKLOT" value="잠 정">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKLOT', this, 'CHECKLOT')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKLOT),'잠 정')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKLOT),'잠 정')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb13">잠&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;정</label>
                </td>
                <td colspan="3" rowspan="2" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLYLOT" style="height:40px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/APPLYLOT" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="APPLYLOT" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLYLOT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td style="text-align:center">
                  <input type="checkbox" id="ckb14" name="ckbCHECKLOT" value="지 속">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKLOT', this, 'CHECKLOT')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKLOT),'지 속')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKLOT),'지 속')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb14">지&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;속</label>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">
                  변경내용
                </td>
                <td colspan="4" style="text-align:center;border-right:0;border-bottom:0">
                  <input type="checkbox" id="ckb15" name="ckbCHANGEDETAIL1" value="재질">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL1', this, 'CHANGEDETAIL1')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL1),'재질')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL1),'재질')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb15">재질</label>&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" id="ckb16" name="ckbCHANGEDETAIL2" value="표면처리">
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL2', this, 'CHANGEDETAIL2')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL2),'표면처리')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL2),'표면처리')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb16">표면처리</label>&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" id="ckb17" name="ckbCHANGEDETAIL3" value="색상">
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL3', this, 'CHANGEDETAIL3')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL3),'색상')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL3),'색상')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb17">색상</label>&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" id="ckb18" name="ckbCHANGEDETAIL4" value="형상">
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL4', this, 'CHANGEDETAIL4')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL4),'형상')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL4),'형상')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb18">형상</label>&nbsp;&nbsp;&nbsp;&nbsp;
                <input type="checkbox" id="ckb19" name="ckbCHANGEDETAIL5" value="치수">
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL5', this, 'CHANGEDETAIL5')</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL5),'치수')">
                    <xsl:attribute name="checked">true</xsl:attribute>
                  </xsl:if>
                  <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL5),'치수')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </input>
                <label for="ckb19">치수</label>&nbsp;&nbsp;&nbsp;&nbsp;
                  <input type="checkbox" id="ckb20" name="ckbCHANGEDETAIL6" value="기타">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHANGEDETAIL6', this, 'CHANGEDETAIL6')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHANGEDETAIL6),'기타')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHANGEDETAIL6),'기타')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb20">기타</label>                  
                </td>
              </tr>
              <!--<tr>
                <td colspan="5" style="height:400px;border-bottom:0;border-right:0">                  
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
                </td>
              </tr>-->
            </table>
            <input type="hidden" id="__mainfield" name="CHECKUSE">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHECKUSE"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHECKLOT">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHECKLOT"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHANGEDETAIL1">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL1"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHANGEDETAIL2">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL2"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHANGEDETAIL3">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL3"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHANGEDETAIL4">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL4"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHANGEDETAIL5">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL5"></xsl:value-of>
              </xsl:attribute>
            </input>
            <input type="hidden" id="__mainfield" name="CHANGEDETAIL6">
              <xsl:attribute name="value">
                <xsl:value-of select="//forminfo/maintable/CHANGEDETAIL6"></xsl:value-of>
              </xsl:attribute>
            </input>
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

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>2. 설계변경 영향</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl2" style="width:100px">가격변동</td>
                <td>                  
                    <input type="checkbox" id="ckb21" name="ckbCHECKYES1" value="있음">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES1', this, 'CHECKYES1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES1),'있음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES1),'있음')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">있음</label>                  
                    <input type="checkbox" id="ckb22" name="ckbCHECKYES1" value="없음">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES1', this, 'CHECKYES1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES1),'없음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES1),'없음')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">없음</label>                  
                  <input type="hidden" id="__mainfield" name="CHECKYES1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKYES1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl2" style="width:100px">금형변경</td>
                <td>
                    <input type="checkbox" id="ckb23" name="ckbCHECKYES2" value="있음">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES2', this, 'CHECKYES2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES2),'있음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES2),'있음')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">있음</label>                  
                    <input type="checkbox" id="ckb24" name="ckbCHECKYES2" value="없음">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES2', this, 'CHECKYES2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES2),'없음')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES2),'없음')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">없음</label>                  
                  <input type="hidden" id="__mainfield" name="CHECKYES2">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKYES2"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl2" style="width:100px">설계문서수정</td>
                <td style="border-right:0">                  
                    <input type="checkbox" id="ckb25" name="ckbCHECKYES3" value="완료">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES3', this, 'CHECKYES3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES3 ),'완료')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES3),'완료')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb25">완료</label>                                    
                    <input type="checkbox" id="ckb26" name="ckbCHECKYES3" value="미완료">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES3', this, 'CHECKYES3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES3),'미완료')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES3),'미완료')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb26">미완료</label>
                    <input type="hidden" id="__mainfield" name="CHECKYES3">
                      <xsl:attribute name="value">
                        <xsl:value-of select="//forminfo/maintable/CHECKYES3"></xsl:value-of>
                      </xsl:attribute>
                    </input>                  
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" >작업표준수정</td>
                <td >
                  <input type="checkbox" id="ckb27" name="ckbCHECKYES4" value="완료">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES4', this, 'CHECKYES4')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES4),'완료')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES4),'완료')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb27">완료</label>
                  <input type="checkbox" id="ckb28" name="ckbCHECKYES4" value="미완료">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES4', this, 'CHECKYES4')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES4),'미완료')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES4),'미완료')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb28">미완료</label>
                  <input type="hidden" id="__mainfield" name="CHECKYES4">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKYES4"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>              
                <td class="f-lbl2">검사규격수정</td>
                <td >
                  <input type="checkbox" id="ckb29" name="ckbCHECKYES5" value="완료">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES5', this, 'CHECKYES5')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES5),'완료')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES5),'완료')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb29">완료</label>
                  <input type="checkbox" id="ckb30" name="ckbCHECKYES5" value="미완료">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES5', this, 'CHECKYES5')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES5),'미완료')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES5),'미완료')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb30">미완료</label>
                  <input type="hidden" id="__mainfield" name="CHECKYES5">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKYES5"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl2">설변문제점</td>
                <td style="border-right:0">
                  <input type="checkbox" id="ckb31" name="ckbCHECKYES6" value="있음">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES6', this, 'CHECKYES6')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES6),'있음')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES6),'있음')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb31">있음</label>
                  <input type="checkbox" id="ckb32" name="ckbCHECKYES6" value="없음">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES2', this, 'CHECKYES6')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES6),'없음')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES6),'없음')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb32">없음</label>
                  <input type="hidden" id="__mainfield" name="CHECKYES6">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKYES6"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
              <tr>
                <td style="border-bottom:0" class="f-lbl2" >마스터변경</td>
                <td style="border-bottom:0">
                  <input type="checkbox" id="ckb33" name="ckbCHECKYES7" value="있음">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES7', this, 'CHECKYES7')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES7),'있음')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES7),'있음')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb33">있음</label>
                  <input type="checkbox" id="ckb34" name="ckbCHECKYES7" value="없음">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES7', this, 'CHECKYES7')</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES7),'없음')">
                      <xsl:attribute name="checked">true</xsl:attribute>
                    </xsl:if>
                    <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES7),'없음')">
                      <xsl:attribute name="disabled">disabled</xsl:attribute>
                    </xsl:if>
                  </input>
                  <label for="ckb34">없음</label>
                  <input type="hidden" id="__mainfield" name="CHECKYES7">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CHECKYES7"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td class="f-lbl2" style="border-bottom:0">&nbsp;</td>
                <td style="border-bottom:0">
                  &nbsp;
                </td>
                <td class="f-lbl2" style="border-bottom:0">&nbsp;</td>
                <td style="border-bottom:0;border-right:0">
                  &nbsp;
                </td>
              </tr>              
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>3. 특기사항</span>
          </div>

          <div class="ff" />
          <div class="ft">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
                <textarea id="__mainfield" name="ETC" style="height:80px">
                  <xsl:attribute name="class">txaText</xsl:attribute>
                  <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                  <xsl:if test="$mode='edit'">
                    <xsl:value-of select="//forminfo/maintable/ETC" />
                  </xsl:if>
                </textarea>
              </xsl:when>
              <xsl:otherwise>
                <div id="__mainfield" name="ETC" style="height:80px">
                  <xsl:attribute name="class">txaRead</xsl:attribute>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETC))" />
                </div>
              </xsl:otherwise>
            </xsl:choose>
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