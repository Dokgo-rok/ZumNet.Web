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
          .m {width:714px} .m .fm-editor {height:250px;border:windowtext 1pt solid;border-top:0}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:8%} .m .ft .f-lbl2 {width:12%}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:50px;text-align:center}
          .m .ft-sub .f-option {width:50%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:250px}}
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
                <td style="width:236px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:380px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '5', '합의부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:92px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
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
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText" style="width:95%" value="{//forminfo/maintable/MODELNAME}" />
                      <button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
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
                <td class="f-lbl">부품명</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTNAME" class="txtText" maxlength="100" value="{//forminfo/maintable/PARTNAME}" />
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
                      <input type="text" id="__mainfield" name="PARTNUM" class="txtText" maxlength="50" value="{//forminfo/maintable/PARTNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">ECN번호</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ECNNUM" class="txtText" maxlength="100" value="{//forminfo/maintable/ECNNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECNNUM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">도면번호</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DRAWNUM" class="txtText" maxlength="100" value="{//forminfo/maintable/DRAWNUM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DRAWNUM))" />
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
                <td class="f-lbl2">문서명</td>
                <td class="f-lbl">변경대상</td>
                <td class="f-lbl2">변경(예정)일</td>
                <td class="f-lbl1">주관부서</td>
                <td class="f-lbl2">문서명</td>
                <td class="f-lbl">변경대상</td>
                <td class="f-lbl2">변경(예정)일</td>
                <td class="f-lbl1" style="border-right:0;width:3%">주관부서</td>
              </tr>
              <tr>
                <td class="f-lbl2">BOM(P/L)</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb21" name="ckbCHECKYES1" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES1', this, 'CHECKYES1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES1),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES1),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb21">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb22" name="ckbCHECKYES1" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES1', this, 'CHECKYES1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES1),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES1),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb22">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES1" value="{//forminfo/maintable/CHECKYES1}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE1" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">설계</td>
                <td class="f-lbl2">제조공정도</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb23" name="ckbCHECKYES2" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES2', this, 'CHECKYES2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES2),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES2),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb23">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb24" name="ckbCHECKYES2" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES2', this, 'CHECKYES2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES2),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES2),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb24">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES2" value="{//forminfo/maintable/CHECKYES2}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE2" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE2}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-right:0">기술</td>
              </tr>
              <tr>
                <td class="f-lbl2">완제사양서</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb25" name="ckbCHECKYES3" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES3', this, 'CHECKYES3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES3),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES3),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb25">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb26" name="ckbCHECKYES3" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES3', this, 'CHECKYES3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES3),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES3),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb26">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES3" value="{//forminfo/maintable/CHECKYES3}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE3" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE3}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">설계</td>
                <td class="f-lbl2">작업지도서</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb27" name="ckbCHECKYES4" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES4', this, 'CHECKYES4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES4),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES4),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb27">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb28" name="ckbCHECKYES4" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES4', this, 'CHECKYES4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES4),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES4),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb28">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES4" value="{//forminfo/maintable/CHECKYES4}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE4" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE4}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-right:0">기술</td>
              </tr>
              <tr>
                <td class="f-lbl2">납입사양서</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb29" name="ckbCHECKYES5" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES5', this, 'CHECKYES5')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES5),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES5),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb29">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb30" name="ckbCHECKYES5" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES5', this, 'CHECKYES5')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES5),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES5),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb30">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES5" value="{//forminfo/maintable/CHECKYES5}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE5" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE5}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">설계</td>
                <td class="f-lbl2">표준공수</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb31" name="ckbCHECKYES6" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES6', this, 'CHECKYES6')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES6),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES6),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb31">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb32" name="ckbCHECKYES6" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES6', this, 'CHECKYES6')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES6),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES6),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb32">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES6" value="{//forminfo/maintable/CHECKYES6}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE6" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE6}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-right:0">기술</td>
              </tr>
              <tr>
                <td class="f-lbl2">UNIT사양서</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb33" name="ckbCHECKYES7" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES7', this, 'CHECKYES7')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES7),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES7),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb33">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb34" name="ckbCHECKYES7" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES7', this, 'CHECKYES7')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES7),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES7),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb34">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES7" value="{//forminfo/maintable/CHECKYES7}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE7" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE7}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">기술연구</td>
                <td class="f-lbl2">부품검사규격</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb35" name="ckbCHECKYES8" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES8', this, 'CHECKYES8')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES8),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES8),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb35">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb36" name="ckbCHECKYES8" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES8', this, 'CHECKYES8')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES8),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES8),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb36">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES8" value="{//forminfo/maintable/CHECKYES8}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE8" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE8}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-right:0">기술</td>
              </tr>
              <tr>
                <td class="f-lbl2">PCB사양서</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb37" name="ckbCHECKYES9" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES9', this, 'CHECKYES9')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES9),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES9),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb37">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb38" name="ckbCHECKYES9" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES9', this, 'CHECKYES9')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES9),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES9),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb38">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES9" value="{//forminfo/maintable/CHECKYES9}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE9" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE9}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">회로설계</td>
                <td class="f-lbl2">완제검사규격</td>
                <td>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb39" name="ckbCHECKYES10" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES10', this, 'CHECKYES10')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES10),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES10),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb39">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb40" name="ckbCHECKYES10" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES10', this, 'CHECKYES10')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES10),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES10),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb40">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES10" value="{//forminfo/maintable/CHECKYES10}" />
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE10" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE10}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE10))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-right:0">기술</td>
              </tr>
              <tr>
                <td class="f-lbl2" style="border-bottom:0">도면</td>
                <td style="border-bottom:0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb41" name="ckbCHECKYES11" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES11', this, 'CHECKYES11')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES11),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES11),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb41">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb42" name="ckbCHECKYES11" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES11', this, 'CHECKYES11')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES11),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES11),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb42">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES11" value="{//forminfo/maintable/CHECKYES11}" />
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE11" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE11}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE11))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">설계</td>
                <td class="f-lbl2" style="border-bottom:0">신뢰성규격</td>
                <td style="border-bottom:0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb43" name="ckbCHECKYES12" value="Y">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES12', this, 'CHECKYES12')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES12),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES12),'Y')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb43">YES</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb44" name="ckbCHECKYES12" value="N">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECKYES12', this, 'CHECKYES12')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECKYES12),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECKYES12),'N')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb44">NO</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="CHECKYES12" value="{//forminfo/maintable/CHECKYES12}" />
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DATE12" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DATE12}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DATE12))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-right:0;border-bottom:0">기술</td>
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
                <textarea id="__mainfield" name="ETC" style="height:80px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000)" >
                  <xsl:value-of select="//forminfo/maintable/ETC" />
                </textarea>
              </xsl:when>
              <xsl:otherwise>
                <div name="ETC" style="height:80px">
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