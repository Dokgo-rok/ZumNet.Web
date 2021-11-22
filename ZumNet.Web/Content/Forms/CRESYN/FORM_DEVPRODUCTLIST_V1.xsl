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
          .m {width:1392px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:72px}
          .si-tbl .si-bottom,.si-tbl .si-top {height:20px}
          .m .ft td,.m .ft-sub td {height:22px;padding:1px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:5%} .m .ft .f-lbl1 {width:5%} .m .ft .f-lbl2 {width:15%} .m .ft .f-lbl3 {width:9%}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
          .m .ft-sub .f-option {width:49%}
          .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}
          .m .ft input,.m .ft-sub input {height:18px}

          /* 폰트 작게 */
          .si-tbl td,.m .fm-lines .si-list td,.m .ft td, .m .ft input, .m .ft select, .m .ft textarea, .m .ft div {font-size:11px}
          .m .ft-sub td, .m .ft-sub input, .m .ft-sub select, .m .ft-sub textarea, .m .ft-sub div {font-size:11px}
          .m .fm span,.m .fm label, .m .fm .fm-button, .m .fm .fm-button input, .m .fm-file td, .m .fm-file td a {font-size:11px}

          /* 관련 산출물 창 표시 */
          .lkm-popup {display:none;z-index:100;width:450px;height:240px;padding:2px;background-color:#fff;border:3px double #999;font-size:12px}
          .lkm-popup .lkm-btn {padding:2px;text-align:right;background-color:#777;border:1px solid #ccc;border-bottom:1px solid #fff;color:#fff}
          .lkm-popup .lkm-btn span {width:415px;text-align:left}
          .lkm-popup .lkm-btn button {padding:0;text-align:center;width:16px;height:16px;font-size:10px;font-weight:bold;border:1px solid #fff}
          .lkm-popup .lkm-lst {height:220px;padding:2px;background-color:#fff;border:1px solid #ccc;text-align:left;line-height:16px;overflow:auto}

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
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td style="width:452px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '6', '검&lt;br /&gt;&lt;br /&gt;토')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:452px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '6', '결&lt;br /&gt;&lt;br /&gt;재')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:395px">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="f-lbl2" onclick="alert(gg(1));">                      
                      문서번호
                      </td>
                      <td style="width:40%">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                      </td>
                      <td class="f-lbl2">Rev.</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MAINREVISION">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/MAINREVISION" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAINREVISION))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2">작성일자</td>
                      <td>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                      </td>
                      <td class="f-lbl2">개정일자</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="REVISIONDATE">
                              <xsl:attribute name="class">txtDate</xsl:attribute>
                              <xsl:attribute name="style">width:80px</xsl:attribute>
                              <xsl:attribute name="maxlength">8</xsl:attribute>
                              <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REVISIONDATE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2">작성부서</td>
                      <td>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//creatorinfo/department))" />
                      </td>
                      <td class="f-lbl2">개정부서</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" id="__mainfield" name="REVISIONDEPT">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//creatorinfo/department" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" id="__mainfield" name="REVISIONDEPT">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REVISIONDEPT" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REVISIONDEPT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2">작성자</td>
                      <td>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//creatorinfo/name))" />
                      </td>
                      <td class="f-lbl2">개정자</td>
                      <td style="border-right:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="text" id="__mainfield" name="REVISIONUSER">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//creatorinfo/name" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:when test="$mode='edit'">
                            <input type="text" id="__mainfield" name="REVISIONUSER">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REVISIONUSER" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REVISIONUSER))" />
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="$mode='new'">
                            <input type="hidden" id="__mainfield" name="REVISIONUSERID">
                              <xsl:attribute name="value">
                                <xsl:value-of select="//creatorinfo/@uid" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <input type="hidden" id="__mainfield" name="REVISIONUSERID">
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/REVISIONUSERID" />
                              </xsl:attribute>
                            </input>
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl2" style="border-bottom:0">등록율</td>
                      <td colspan="3" style="border-bottom:0;border-right:0;color:red;font-weight:bold">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo)" />
                      </td>
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="border-bottom:0">품명</td>
                <td style="width:13%;border-bottom:0">                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtRead" readonly="readonly"  maxlength="50" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">모델명</td>
                <td style="width:13%;border-bottom:0">
                  <xsl:choose>
                    <!--class="txtText_u" readonly="readonly" txtRead-->
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" readonly="readonly"  style="width:87%" value="{//forminfo/maintable/MODELNAME}" />
                      <button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,100,70,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">고객명</td>
                <td style="width:13%;border-bottom:0">
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
                <td class="f-lbl" style="border-bottom:0">개발등급</td>
                <td style="width:7%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEVCLASS" style="width:72%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEVCLASS" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('external.devclass',80,110,50,105,'','DEVCLASS');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DEVCLASS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1" style="border-bottom:0">
                  PM
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">
                          /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                        </xsl:attribute>
                      </img>
                    </button>
                  </xsl:if>
                </td>
                <td class="f-lbl" style="border-bottom:0">부서명</td>
                <td style="width:11%;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PMDEPT">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PMDEPT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PMDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">성명</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PMNAME">
                        <xsl:attribute name="class">txtRead</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PMNAME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <xsl:if test="$mode='read'">
            <div class="fm" style="text-align:left">
              <table class="ft" border="0" cellspacing="0" cellpadding="0" style="width:50%">
                <tr>
                  <td class="f-lbl" style="width:10%">부서명</td>
                  <td class="f-lbl" style="width:15%">설계</td>
                  <td class="f-lbl" style="width:15%">기술연구소</td>
                  <td class="f-lbl" style="width:15%">기술</td>
                  <td class="f-lbl" style="width:15%">품질</td>
                  <td class="f-lbl" style="width:15%">영업</td>
                  <td class="f-lbl" style="width:15%;border-right:0">설계관리</td>
                </tr>
                <tr>
                  <td class="f-lbl" style="border-bottom:0">등록율</td>
                  <td style="text-align:center;color:red;font-weight:bold;border-bottom:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo, '설계')" />
                  </td>
                  <td style="text-align:center;color:red;font-weight:bold;border-bottom:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo, '기술연구소')" />
                  </td>
                  <td style="text-align:center;color:red;font-weight:bold;border-bottom:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo, '기술')" />
                  </td>
                  <td style="text-align:center;color:red;font-weight:bold;border-bottom:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo, '품질')" />
                  </td>
                  <td style="text-align:center;color:red;font-weight:bold;border-bottom:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo, '영업')" />
                  </td>
                  <td style="text-align:center;color:red;font-weight:bold;border-bottom:0;border-right:0">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue5(//forminfo/subtables/subtable1, //optioninfo, '설계관리')" />
                  </td>
                </tr>
              </table>
            </div>
          </xsl:if>
          
          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <div class="ff" />
                    <div class="ff" />
                  </tr>
                </xsl:when>
                <xsl:otherwise>
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
                  <table id="__subtable1" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:22px"></col>
                      <col style="width:180px"></col>
                      <col style="width:60px"></col>
                      <col style="width:55px"></col>
                      <col style="width:70px"></col>
                      <col style="width:45px"></col>
                      <col style="width:110px"></col>
                      <col style="width:55px"></col>
                      <col style="width:70px"></col>
                      <col style="width:45px"></col>
                      <col style="width:110px"></col>
                      <col style="width:55px"></col>
                      <col style="width:70px"></col>
                      <col style="width:45px"></col>
                      <col style="width:110px"></col>
                      <col style="width:55px"></col>
                      <col style="width:70px"></col>
                      <col style="width:45px"></col>
                      <col style="width:110px"></col>
                    </colgroup>
                    <tr style="height:20px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">산출물명</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작성부서</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="4">개발기획/MU
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                            <input type="text" id="__mainfield" name="DSESTART" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DSESTART}" />&nbsp;~&nbsp;
                            <input type="text" id="__mainfield" name="DSEEND" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/DSEEND}" />
                          </xsl:when>
                          <xsl:otherwise>
                            (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DSESTART))" />&nbsp;~&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DSEEND))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="4">EP
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                            <input type="text" id="__mainfield" name="EPESTART" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/EPESTART}" />&nbsp;~&nbsp;
                            <input type="text" id="__mainfield" name="EPEEND" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/EPEEND}" />
                          </xsl:when>
                          <xsl:otherwise>
                            (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EPESTART))" />&nbsp;~&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EPEEND))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="4">PP
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                            <input type="text" id="__mainfield" name="PPESTART" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/PPESTART}" />&nbsp;~&nbsp;
                            <input type="text" id="__mainfield" name="PPEEND" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/PPEEND}" />
                          </xsl:when>
                          <xsl:otherwise>
                            (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PPESTART))" />&nbsp;~&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PPEEND))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="4">PMP
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                            <input type="text" id="__mainfield" name="PMPESTART" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/PMPESTART}" />&nbsp;~&nbsp;
                            <input type="text" id="__mainfield" name="PMPEEND" class="txtDate" maxlength="8" style="width:70px" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/PMPEEND}" />
                          </xsl:when>
                          <xsl:otherwise>
                            (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PMPESTART))" />&nbsp;~&nbsp;
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PMPEEND))" />)
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub">계획/연결</td>
                      <td class="f-lbl-sub">등록예정</td>
                      <td class="f-lbl-sub">진행</td>
                      <td class="f-lbl-sub">등록일</td>
                      <td class="f-lbl-sub">계획/연결</td>
                      <td class="f-lbl-sub">등록예정</td>
                      <td class="f-lbl-sub">진행</td>
                      <td class="f-lbl-sub">등록일</td>
                      <td class="f-lbl-sub">계획/연결</td>
                      <td class="f-lbl-sub">등록예정</td>
                      <td class="f-lbl-sub">진행</td>
                      <td class="f-lbl-sub">등록일</td>
                      <td class="f-lbl-sub">계획/연결</td>
                      <td class="f-lbl-sub">등록예정</td>
                      <td class="f-lbl-sub">진행</td>
                      <td class="f-lbl-sub" style="border-right:0">등록일</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <span>특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:40px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 200)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="DESCRIPTION" style="height:40px">
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
      <xsl:attribute name="devlvl">
        <xsl:value-of select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', '')" />
      </xsl:attribute>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="Text" name="ROWSEQ" class="txtRead_Center" readonly="readonly" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="text" name="PRODUCTNAME">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item1', string(PRODUCTNAME))" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRODUCTNAME))" />-->
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue4(//optioninfo, string(PRODUCTID), string(PRODUCTNAME))" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="TABLENAME">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
              <xsl:attribute name="value">
                <xsl:value-of select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item2', string(TABLENAME))" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="value">
                <xsl:value-of select="TABLENAME" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </input>
        <input type="hidden" name="PRODUCTID">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
              <xsl:attribute name="value">
                <xsl:value-of select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'FormID', string(PRODUCTID))" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="value">
                <xsl:value-of select="PRODUCTID" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </input>
        <input type="hidden" name="STEPOPTION">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
              <xsl:attribute name="value">
                <xsl:value-of select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', string(STEPOPTION))" />
              </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="value">
                <xsl:value-of select="STEPOPTION" />
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </input>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="text" name="CHARGEDEPT">
              <xsl:attribute name="class">txtRead_Center</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item3', string(CHARGEDEPT))" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CHARGEDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='PLAN' or string(STEPOPTION)='PLAN'">
            <span class="f-option">
              <input type="checkbox" name="ckbDESIGNCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbDESIGNCHECK', this, 'DESIGNCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(DESIGNCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(DESIGNCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
            <span class="f-option">
              <input type="checkbox" name="ckbDESIGNLINKCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbDESIGNLINKCHECK', this, 'DESIGNLINKCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(DESIGNLINKCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="DESIGNCHECK">
          <xsl:attribute name="value"><xsl:value-of select="DESIGNCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="DESIGNLINKCHECK">
          <xsl:attribute name="value"><xsl:value-of select="DESIGNLINKCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="DESIGNLINKMSG">
          <xsl:attribute name="value"><xsl:value-of select="DESIGNLINKMSG" /></xsl:attribute>
        </input>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="text" name="DESIGNDATE">
              <xsl:choose>
                <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='PLAN' or string(STEPOPTION)='PLAN'">
                  <xsl:attribute name="class">txtDate</xsl:attribute>
                  <xsl:attribute name="maxlength">8</xsl:attribute>
                  <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                  <xsl:attribute name="value">
                    <xsl:value-of select="DESIGNDATE" />
                  </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">txtRead</xsl:attribute>
                  <xsl:attribute name="readonly">readonly</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DESIGNDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(DESIGNCHECK),'Y')">
            <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', '', 'read') " />-->
            <xsl:choose>

              <xsl:when test="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', '', 'read')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', '', 'read') " />
              </xsl:when>
              <xsl:when test="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', 'MU', 'read')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', 'MU', 'read') " />
              </xsl:when>
              <xsl:otherwise>             
              
              </xsl:otherwise>
            </xsl:choose>               
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(DESIGNCHECK),'Y') or phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('B', 'O', string(DESIGNLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'D', 'PLAN', 'read')" />               
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(DESIGNCHECK),'Y')">
            <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', '', 'read')" />-->
            <xsl:choose>
              <xsl:when test="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', '', 'read')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', '', 'read') " />
              </xsl:when>
              <xsl:when test="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', 'MU', 'read')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', 'MU', 'read') " />
              </xsl:when>
              <xsl:otherwise>
                &nbsp;
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(DESIGNCHECK),'Y') or phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('A', 'O', string(DESIGNLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'PLAN', 'read')" />-->
                <xsl:choose>
                  <xsl:when test="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'PLAN', 'read')">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'PLAN', 'read') " />
                  </xsl:when>
                  <xsl:when test="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'MU', 'read')">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'MU', 'read') " />
                  </xsl:when>
                  <xsl:otherwise>
                    &nbsp;
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>

        <!--
        아래 같은 걸 위에 처럼 바꿈  MU단계 품평회 회의록이 안나와서 
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(DESIGNCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', '', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(DESIGNCHECK),'Y') or phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(DESIGNLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('A', 'O', string(DESIGNLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'PLAN', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>-->
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='STEP' or string(STEPOPTION)='STEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='EPSTEP' or string(STEPOPTION)='EPSTEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='EPPSTEP' or string(STEPOPTION)='EPPSTEP'">
            <span class="f-option">
              <input type="checkbox" name="ckbEPPLANCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbEPPLANCHECK', this, 'EPPLANCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(EPPLANCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(EPPLANCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
            <span class="f-option">
              <input type="checkbox" name="ckbEPPLANLINKCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbEPPLANLINKCHECK', this, 'EPPLANLINKCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(EPPLANLINKCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(EPPLANLINKCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="EPPLANCHECK">
          <xsl:attribute name="value"><xsl:value-of select="EPPLANCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="EPPLANLINKCHECK">
          <xsl:attribute name="value"><xsl:value-of select="EPPLANLINKCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="EPPLANLINKMSG">
          <xsl:attribute name="value"><xsl:value-of select="EPPLANLINKMSG" /></xsl:attribute>
        </input>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="text" name="EPPLANDATE">
              <xsl:choose>
                <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='STEP' or string(STEPOPTION)='STEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='EPSTEP' or string(STEPOPTION)='EPSTEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='EPPSTEP' or string(STEPOPTION)='EPPSTEP'">
                  <xsl:attribute name="class">txtDate</xsl:attribute>
                  <xsl:attribute name="maxlength">8</xsl:attribute>
                  <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                  <xsl:attribute name="value"><xsl:value-of select="EPPLANDATE" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">txtRead</xsl:attribute>
                  <xsl:attribute name="readonly">readonly</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>-->
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(EPPLANDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(EPPLANCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', 'EP', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(EPPLANCHECK),'Y') or phxsl:isEqual(string(EPPLANLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(EPPLANLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('B', 'O', string(EPPLANLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'D', 'EP', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(EPPLANCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', 'EP', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(EPPLANCHECK),'Y') or phxsl:isEqual(string(EPPLANLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(EPPLANLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('A', 'O', string(EPPLANLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'EP', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='STEP' or string(STEPOPTION)='STEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='PPSTEP' or string(STEPOPTION)='PPSTEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='EPPSTEP' or string(STEPOPTION)='EPPSTEP'">
            <span class="f-option">
              <input type="checkbox" name="ckbPPPLANCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbPPPLANCHECK', this, 'PPPLANCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(PPPLANCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(PPPLANCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
            <span class="f-option">
              <input type="checkbox" name="ckbPPPLANLINKCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbPPPLANLINKCHECK', this, 'PPPLANLINKCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(PPPLANLINKCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(PPPLANLINKCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="PPPLANCHECK">
          <xsl:attribute name="value"><xsl:value-of select="PPPLANCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="PPPLANLINKCHECK">
          <xsl:attribute name="value"><xsl:value-of select="PPPLANLINKCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="PPPLANLINKMSG">
          <xsl:attribute name="value"><xsl:value-of select="PPPLANLINKMSG" /></xsl:attribute>
        </input>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="text" name="PPPLANDATE">
              <xsl:choose>
                <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='STEP' or string(STEPOPTION)='STEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='PPSTEP' or string(STEPOPTION)='PPSTEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='EPPSTEP' or string(STEPOPTION)='EPPSTEP'">
                  <xsl:attribute name="class">txtDate</xsl:attribute>
                  <xsl:attribute name="maxlength">8</xsl:attribute>
                  <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                  <xsl:attribute name="value"><xsl:value-of select="PPPLANDATE" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">txtRead</xsl:attribute>
                  <xsl:attribute name="readonly">readonly</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>-->
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PPPLANDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PPPLANCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', 'PP', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(PPPLANCHECK),'Y') or phxsl:isEqual(string(PPPLANLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PPPLANLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('B', 'O', string(PPPLANLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'D', 'PP', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PPPLANCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', 'PP', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(PPPLANCHECK),'Y') or phxsl:isEqual(string(PPPLANLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PPPLANLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('A', 'O', string(PPPLANLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'PP', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='STEP' or string(STEPOPTION)='STEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='PMPSTEP' or string(STEPOPTION)='PMPSTEP'">
            <span class="f-option">
              <input type="checkbox" name="ckbPMPPLANCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbPMPPLANCHECK', this, 'PMPPLANCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(PMPPLANCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(PMPPLANCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
            <span class="f-option">
              <input type="checkbox" name="ckbPMPPLANLINKCHECK" value="Y" style="height:12px">
                <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbPMPPLANLINKCHECK', this, 'PMPPLANLINKCHECK')</xsl:attribute>
                  <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>-->
                </xsl:if>
                <xsl:if test="phxsl:isEqual(string(PMPPLANLINKCHECK),'Y')">
                  <xsl:attribute name="checked">true</xsl:attribute>
                </xsl:if>
                <xsl:if test="$mode='read' and phxsl:isDiff(string(PMPPLANLINKCHECK),'Y') and not ($bizrole='receive' and $actrole='__r')">
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:if>
              </input>
            </span>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="PMPPLANCHECK">
          <xsl:attribute name="value"><xsl:value-of select="PMPPLANCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="PMPPLANLINKCHECK">
          <xsl:attribute name="value"><xsl:value-of select="PMPPLANLINKCHECK" /></xsl:attribute>
        </input>
        <input type="hidden" name="PMPPLANLINKMSG">
          <xsl:attribute name="value"><xsl:value-of select="PMPPLANLINKMSG" /></xsl:attribute>
        </input>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
            <input type="text" name="PMPPLANDATE">
              <xsl:choose>
                <xsl:when test="phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='ALL' or string(STEPOPTION)='ALL' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='STEP' or string(STEPOPTION)='STEP' or phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item4', '')='PMPSTEP' or string(STEPOPTION)='PMPSTEP'">
                  <xsl:attribute name="class">txtDate</xsl:attribute>
                  <xsl:attribute name="maxlength">8</xsl:attribute>
                  <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                  <xsl:attribute name="value"><xsl:value-of select="PMPPLANDATE" /></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="class">txtRead</xsl:attribute>
                  <xsl:attribute name="readonly">readonly</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <!--<xsl:if test="$mode='new' or not ($mode='edit' and contains(phxsl:fieldValue(//optioninfo, string(ROWSEQ), 'Item5', ''), string(//forminfo/maintable/DEVCLASS)))">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>-->
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PMPPLANDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PMPPLANCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'B', 'PMP', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(PMPPLANCHECK),'Y') or phxsl:isEqual(string(PMPPLANLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PMPPLANLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('B', 'O', string(PMPPLANLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'D', 'PMP', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PMPPLANCHECK),'Y')">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'A', 'PMP', 'read')" />
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
        </xsl:choose>
        <xsl:if test="phxsl:isEqual(string(PMPPLANCHECK),'Y') or phxsl:isEqual(string(PMPPLANLINKCHECK),'Y')">/</xsl:if>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(PMPPLANLINKCHECK),'Y')">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r')">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue3('A', 'O', string(PMPPLANLINKMSG), '')" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:fieldValue1(//optioninfo, string(PRODUCTID), 'C', 'PMP', 'read')" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>&nbsp;</xsl:otherwise>
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
