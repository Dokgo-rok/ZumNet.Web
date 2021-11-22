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
          .m {width:780px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:13%} .m .ft .f-lbl1 {width:8%} .m .ft .f-lbl2 {width:} .m .ft .f-lbl3 {width:}
          .m .ft .f-option {width:50%} .m .ft .f-option1 {width:} .m .ft .f-option2 {width:}
          .m .ft-sub .f-option {width:}
          .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

          /* 폰트 작게 */
          .si-tbl td,.m .fm-lines .si-list td,.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div,.m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div {font-size:12px}
          .m .fm span,.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:12px}

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
                <td style="width:236px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '요청부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:380px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '5', '처리부서')"/>
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl4" style="width:15%">문서번호</td>
                <td style="width:35%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl4" style="width:15%">작성일자</td>
                <td style="border-right:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl4" style="border-bottom:0">작성자</td>
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
            <span>* 개발중단 요청</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:10%" />
                <col style="width:20%" />
                <col style="width:10%" />
                <col style="width:20%" />
                <col style="width:10%" />
                <col style="width:" />
              </colgroup>
              <tr>
                <td class="f-lbl4">품명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtRead" readonly="readonly"  maxlength="100" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">모델명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" readonly="readonly"  style="width:87%" value="{//forminfo/maintable/MODELNAME}" />
                      <button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" rowspan="2">요청내용</td>
                <td rowspan="2" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTCMNT" style="height:40px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/PARTHISTORY" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REQUESTCMNT" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTCMNT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">고객명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">요청고객담당</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMERMANAGER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMERMANAGER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMERMANAGER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>              
              <tr>
                <td class="f-lbl4" style="border-bottom:0;height:50px">손실처리<br />협의내용</td>
                <td colspan="5" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="LOSSCMNT" style="height:46px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/PARTHISTORY" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="LOSSCMNT" style="height:46px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOSSCMNT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="STEP" value="PMP" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>* 투입개발 인력</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$bizrole='agree' and $partid!=''">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:" />
              </colgroup>
              <tr>
                <td class="f-lbl4">수행업무</td>
                <td class="f-lbl4">PM</td>
                <td class="f-lbl4">기구설계</td>
                <td class="f-lbl4">회로설계</td>
                <td class="f-lbl4">음향설계</td>
                <td class="f-lbl4">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTWORK1"> 
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTWORK1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTWORK1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTWORK2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTWORK2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTWORK2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" style="border-right:0">개발 투입인력비 산출내역 및 금액</td>
              </tr>
              <tr>
                <td class="f-lbl4">부서명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTDEPT1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTDEPT2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTDEPT3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTDEPT4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTDEPT5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTDEPT6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTDEPT6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTDEPT6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td rowspan="3" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <textarea id="__mainfield" name="PARTHISTORY" style="height:68px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTHISTORY))" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="PARTHISTORY" style="height:68px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTHISTORY))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4">직급</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTGRADE1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTGRADE2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTGRADE3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTGRADE4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTGRADE5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTGRADE6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTGRADE6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTGRADE6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">성명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTICIPANT1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTICIPANT2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTICIPANT3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTICIPANT4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTICIPANT5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="PARTICIPANT6">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PARTICIPANT6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTICIPANT6))" />
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
            <span>* 개발진척 현황</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$bizrole='agree' and $partid!=''">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
                <col style="width:10%" />
              </colgroup>
              <tr>
                <td class="f-lbl4">단계</td>
                <td class="f-lbl4">디자인확정</td>
                <td class="f-lbl4">설계</td>
                <td class="f-lbl4">M-UP</td>
                <td class="f-lbl4">금형</td>
                <td class="f-lbl4">EP</td>
                <td class="f-lbl4">PP</td>
                <td class="f-lbl4">PMP</td>
                <td class="f-lbl4">완료보고</td>
                <td class="f-lbl4" style="border-right:0">양산이관</td>
              </tr>
              <tr>
                <td class="f-lbl4">계획일</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE1">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE2">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE3">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE4">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE5">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE6">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE7">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE8">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVPLANDATE9">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVPLANDATE9" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVPLANDATE9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0">완료일</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE1">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE2">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE3">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE4">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE5">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE6">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE7">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE8">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="DEVCOMPDATE9">
                        <xsl:attribute name="class">txtDateSlash</xsl:attribute>
                        <xsl:attribute name="maxlength">8</xsl:attribute>
                        <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCOMPDATE9" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCOMPDATE9))" />
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
            <span class="f-option1">* 제품개발 투자비용</span>
            <span class="f-option2">
              통화&nbsp;:&nbsp;
              <xsl:choose>
                <xsl:when test="$bizrole='agree' and $partid!=''">
                  <input type="text" id="__mainfield" name="CURRENCY1" style="width:60px;height:16px">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/CURRENCY1" />
                    </xsl:attribute>
                  </input>
                  <button onclick="parent.fnOption('iso.currency',160,140,40,110,'etc','CURRENCY1');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY1))" />&nbsp;
                </xsl:otherwise>
              </xsl:choose>
            </span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$bizrole='agree' and $partid!=''">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:6%" />
                <col style="width:6%" />
                <col style="width:7%" />
                <col style="width:6%" />
                <col style="width:7%" />
                <col style="width:7%" />
                <col style="width:7%" />
                <col style="width:7%" />
                <col style="width:6%" />
                <col style="width:7%" />
                <col style="width:6%" />
                <col style="width:7%" />
                <col style="width:7%" />
                <col style="width:7%" />
                <col style="width:7%" />
              </colgroup>
              <tr>
                <td class="f-lbl4" rowspan="2">구분</td>
                <td class="f-lbl4" colspan="2" style="height:36px" >금형투자비</td>
                <td class="f-lbl4" colspan="2">설비/치공구비</td>
                <td class="f-lbl4">인증비</td>
                <td class="f-lbl4">외주<br />설계비</td>
                <td class="f-lbl4" colspan="2">샘플비</td>
                <td class="f-lbl4" colspan="2">Mock UP비</td>
                <td class="f-lbl4">개발<br />용품비</td>
                <td class="f-lbl4">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTHD1">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTHD1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTHD1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTHD2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTHD2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTHD2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl4" rowspan="2" style="border-right:0">TOTAL</td>
              </tr>
              <tr>
                <td class="f-lbl4">수량</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">수량</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">유/무상</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">유/무상</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">금액</td>
                <td class="f-lbl4">금액</td>
              </tr>
              <tr>
                <td class="f-lbl4" style="border-bottom:0;height:42px">집행<br />사항</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOUNT1">
                        <xsl:attribute name="class">txtVolume</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOUNT1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTCOUNT1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST1">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOUNT2">
                        <xsl:attribute name="class">txtVolume</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOUNT2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/INVESTCOUNT2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST2">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST3">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST4">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST5">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbINVESTCHECK1" value="유">
                      <xsl:choose>
                        <xsl:when test="$bizrole='agree' and $partid!=''">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbINVESTCHECK1', this, 'INVESTCHECK1')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INVESTCHECK1),'유')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </input>
                    <label for="ckb11">유</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbINVESTCHECK1" value="무">
                      <xsl:choose>
                        <xsl:when test="$bizrole='agree' and $partid!=''">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbINVESTCHECK1', this, 'INVESTCHECK1')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INVESTCHECK1),'무')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </input>
                    <label for="ckb12">무</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="INVESTCHECK1">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/INVESTCHECK1"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST6">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST6" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST6))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <span class="f-option">
                    <input type="checkbox" id="ckb21" name="ckbINVESTCHECK2" value="유">
                      <xsl:choose>
                        <xsl:when test="$bizrole='agree' and $partid!=''">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbINVESTCHECK2', this, 'INVESTCHECK2')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INVESTCHECK2),'유')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </input>
                    <label for="ckb21">유</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb22" name="ckbINVESTCHECK2" value="무">
                      <xsl:choose>
                        <xsl:when test="$bizrole='agree' and $partid!=''">
                          <xsl:attribute name="onclick">parent.fnCheckYN('ckbINVESTCHECK2', this, 'INVESTCHECK2')</xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INVESTCHECK2),'무')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:otherwise>
                      </xsl:choose>
                    </input>
                    <label for="ckb22">무</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="INVESTCHECK2">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/INVESTCHECK2"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST7">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST7" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST7))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST8">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="INVESTCOST9">
                        <xsl:attribute name="class">txtCurrency</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/INVESTCOST9" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INVESTCOST9))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='agree' and $partid!=''">
                      <input type="text" id="__mainfield" name="TOTALSUM1">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TOTALSUM1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM1))" />
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$bizrole='agree' and $partid!=''">
                  <tr>
                    <td>
                      <span>* 개발중단 손실금액</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY2" style="width:70px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY2" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>* 개발중단 손실금액</span>
                    </td>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY2))" />&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$bizrole='agree' and $partid!=''">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:400px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">항목</td>
                      <td class="f-lbl-sub" style="border-top:0">금액</td>
                      <td class="f-lbl-sub" style="border-top:0">산출기준</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="2">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$bizrole='agree' and $partid!=''">
                            <input type="text" id="__mainfield" name="TOTALSUM2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2"  style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>* 특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 500)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="DESCRIPTION" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
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

  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='agree' and $partid!=''">
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='agree' and $partid!=''">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue2(//optioninfo, string(ROWSEQ), 'Item1', 'LOSSITEM', '50')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(LOSSITEM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='agree' and $partid!=''">
            <input type="text" name="LOSSCOST">
              <xsl:attribute name="class">txtCurrency</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="LOSSCOST" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(LOSSCOST))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td>
        <xsl:choose>
          <xsl:when test="$bizrole='agree' and $partid!=''">
            <input type="text" name="OUTPUTSTD">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">100</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="OUTPUTSTD" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(OUTPUTSTD))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$bizrole='agree' and $partid!=''">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
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
