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
          .m {width:1100px} .m .fm-editor {height:250px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt;}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:80px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:10%} .m .ft .f-lbl1 {width:104px} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}

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
          <div class="ff" />

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:350px">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="f-lbl1">문서번호</td>
                      <td style="border-right:0">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                      </td>
                    </tr>

                    <tr>
                      <td class="f-lbl1">작성일자</td>
                      <td style="border-right:0">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">작성부서</td>
                      <td style="border-right:0">
                        <xsl:value-of select="//creatorinfo/department" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1">작성자</td>
                      <td style="border-right:0">
                        <xsl:value-of select="//creatorinfo/name" />
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl1" style="border-bottom:0;">Rev.</td>
                      <td style="border-right:0;border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="MAINREVISION" class="txtNumberic" maxlength="3" style="width: 50px" value="{//forminfo/maintable/MAINREVISION}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MAINREVISION))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                  </table>
                </td>

                <td style="width:;font-size:1px">&nbsp;</td>

                <td style="width:345px">
                  <table border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
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
              <tr>
                <td class="f-lbl">품명</td>
                <td style="width: ">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtRead" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">고객명</td>
                <td style="width: 21%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER" class="txtRead" value="{//forminfo/maintable/CUSTOMER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">생산예정지</td>
                <td style="width: 21%; border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCECENTER" class="txtRead" value="{//forminfo/maintable/PRODUCECENTER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODUCECENTER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">모델명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" value="{//forminfo/maintable/MODELNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">고객분류</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCLS" class="txtRead" value="{//forminfo/maintable/BUYERCLS}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BUYERCLS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">생산지통화</td>
                <td style="border-bottom:0; border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CORPCURRENCY" class="txtRead" value="{//forminfo/maintable/CORPCURRENCY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CORPCURRENCY))" />
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
              <tr>
                <td>
                  <span>&nbsp;부문구성</span>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable2" class="ft-sub" header="2" progdir="col" data-column-max="5" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:6%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2" colspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">견적표1</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">견적표2</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">견적표3</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">견적표4</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">견적표5</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">비율</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">비율</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">비율</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">비율</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub" style="border-right:0">비율</td>
                    </tr>
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">시트명</td>
                      <td colspan="2" class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="hidden" name="CEID" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/CEID}" />
                            <input type="hidden" name="CURRENCY" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/CURRENCY}" />
                            <input type="text" name="SHEETNAME" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/SHEETNAME}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/SHEETNAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="hidden" name="CEID" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/CEID}" />
                            <input type="hidden" name="CURRENCY" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/CURRENCY}" />
                            <input type="text" name="SHEETNAME" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/SHEETNAME}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/SHEETNAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="hidden" name="CEID" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/CEID}" />
                            <input type="hidden" name="CURRENCY" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/CURRENCY}" />
                            <input type="text" name="SHEETNAME" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/SHEETNAME}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/SHEETNAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="hidden" name="CEID" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/CEID}" />
                            <input type="hidden" name="CURRENCY" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/CURRENCY}" />
                            <input type="text" name="SHEETNAME" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/SHEETNAME}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/SHEETNAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="hidden" name="CEID" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/CEID}" />
                            <input type="hidden" name="CURRENCY" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/CURRENCY}" />
                            <input type="text" name="SHEETNAME" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/SHEETNAME}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/SHEETNAME))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">관련견적표</td>
                      <td colspan="2" class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="//forminfo/subtables/subtable2/row[ROWSEQ='1']/CEID != ''">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:linkCEMain('ekp.cresyn.com', string($root), '바로가기', string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/CEID))" />
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="//forminfo/subtables/subtable2/row[ROWSEQ='2']/CEID != ''">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:linkCEMain('ekp.cresyn.com', string($root), '바로가기', string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/CEID))" />
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="//forminfo/subtables/subtable2/row[ROWSEQ='3']/CEID != ''">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:linkCEMain('ekp.cresyn.com', string($root), '바로가기', string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/CEID))" />
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="//forminfo/subtables/subtable2/row[ROWSEQ='4']/CEID != ''">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:linkCEMain('ekp.cresyn.com', string($root), '바로가기', string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/CEID))" />
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="2" class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="//forminfo/subtables/subtable2/row[ROWSEQ='5']/CEID != ''">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:linkCEMain('ekp.cresyn.com', string($root), '바로가기', string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/CEID))" />
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">총원가</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="TOTALCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/TOTALCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/TOTALCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            100%
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="TOTALCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/TOTALCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/TOTALCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            100%
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="TOTALCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/TOTALCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/TOTALCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            100%
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="TOTALCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/TOTALCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/TOTALCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            100%
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="TOTALCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/TOTALCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/TOTALCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            100%
                          </xsl:when>
                          <xsl:otherwise>
                            &nbsp;
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">판매예정가</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="EXSALEPRICE" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXSALEPRICE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXSALEPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">&nbsp;</td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="EXSALEPRICE" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXSALEPRICE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXSALEPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">&nbsp;</td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="EXSALEPRICE" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXSALEPRICE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXSALEPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">&nbsp;</td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="EXSALEPRICE" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXSALEPRICE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXSALEPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">&nbsp;</td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="EXSALEPRICE" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXSALEPRICE}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXSALEPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">&nbsp;</td>
                    </tr>

                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">예상영업이익</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXOPPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXOPPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXOPPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXOPPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXOPPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXOPPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXOPPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXOPPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXOPPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXOPPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXOPPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXOPPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXOPPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXOPPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXOPPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXOPPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXOPPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXOPPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="EXOPPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXOPPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXOPPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">예상공헌이익</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXCTBPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXCTBPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXCTBPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/EXCTBPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXCTBPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXCTBPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXCTBPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/EXCTBPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXCTBPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXCTBPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXCTBPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/EXCTBPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXCTBPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXCTBPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXCTBPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/EXCTBPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFIT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXCTBPROFIT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXCTBPROFIT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="EXCTBPROFITRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXCTBPROFITRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/EXCTBPROFITRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr>
                      <td colspan="12" style="font-size:1px; height: 2px; border-right: 0">&nbsp;</td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" rowspan="5">재<br />료<br />비</td>
                      <td class="f-lbl-sub">합계</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr class="sub_table_row">
                      <td class="f-lbl-sub">기구</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTA" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTA}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTA))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTART" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTART}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTART))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTA" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTA}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTA))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTART" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTART}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTART))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTA" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTA}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTA))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTART" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTART}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTART))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTA" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTA}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTA))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTART" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTART}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTART))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTA" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTA}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTA))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTART" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTART}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTART))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub">포장</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTB" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTB}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTB))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTBRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTBRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTBRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTB" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTB}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTB))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTBRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTBRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTBRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTB" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTB}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTB))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTBRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTBRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTBRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTB" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTB}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTB))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTBRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTBRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTBRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTB" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTB}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTB))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTBRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTBRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTBRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub">음향</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTC" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTC}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTC))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTCRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTCRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTCRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTC" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTC}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTC))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTCRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTCRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTCRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTC" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTC}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTC))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTCRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTCRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTCRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTC" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTC}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTC))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTCRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTCRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTCRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTC" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTC}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTC))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTCRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTCRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTCRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub">포장</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTD" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTD}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTD))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTDRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTDRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/MTRCOSTDRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTD" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTD}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTD))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTDRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTDRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/MTRCOSTDRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTD" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTD}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTD))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTDRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTDRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/MTRCOSTDRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTD" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTD}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTD))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTDRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTDRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/MTRCOSTDRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTD" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTD}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTD))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="MTRCOSTDRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTDRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/MTRCOSTDRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>

                    <tr>
                      <td colspan="12" style="font-size:1px; height: 2px; border-right: 0">&nbsp;</td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">수입경비</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="IMCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/IMCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/IMCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="IMCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/IMCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/IMCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="IMCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/IMCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/IMCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="IMCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/IMCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/IMCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="IMCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/IMCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/IMCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="IMCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/IMCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/IMCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="IMCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/IMCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/IMCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="IMCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/IMCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/IMCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="IMCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/IMCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/IMCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="IMCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/IMCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/IMCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">가공비</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="PCCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/PCCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/PCCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="PCCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/PCCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/PCCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="PCCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/PCCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/PCCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="PCCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/PCCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/PCCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="PCCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/PCCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/PCCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="PCCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/PCCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/PCCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="PCCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/PCCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/PCCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="PCCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/PCCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/PCCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="PCCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/PCCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/PCCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="PCCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/PCCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/PCCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">소모품비</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="SPLEX" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/SPLEX}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/SPLEX))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="SPLEXRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/SPLEXRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/SPLEXRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="SPLEX" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/SPLEX}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/SPLEX))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="SPLEXRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/SPLEXRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/SPLEXRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="SPLEX" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/SPLEX}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/SPLEX))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="SPLEXRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/SPLEXRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/SPLEXRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="SPLEX" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/SPLEX}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/SPLEX))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="SPLEXRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/SPLEXRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/SPLEXRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="SPLEX" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/SPLEX}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/SPLEX))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="SPLEXRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/SPLEXRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/SPLEXRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">변동원가</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="VARCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/VARCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/VARCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="VARCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/VARCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/VARCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="VARCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/VARCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/VARCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="VARCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/VARCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/VARCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="VARCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/VARCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/VARCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="VARCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/VARCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/VARCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="VARCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/VARCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/VARCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="VARCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/VARCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/VARCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="VARCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/VARCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/VARCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="VARCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/VARCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/VARCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">고정원가</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="FIXCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/FIXCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/FIXCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="FIXCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/FIXCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/FIXCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="FIXCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/FIXCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/FIXCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="FIXCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/FIXCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/FIXCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="FIXCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/FIXCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/FIXCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="FIXCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/FIXCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/FIXCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="FIXCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/FIXCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/FIXCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="FIXCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/FIXCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/FIXCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="FIXCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/FIXCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/FIXCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="FIXCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/FIXCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/FIXCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">제조원가</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="PRODCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/PRODCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/PRODCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="PRODCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/PRODCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/PRODCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="PRODCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/PRODCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/PRODCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="PRODCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/PRODCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/PRODCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="PRODCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/PRODCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/PRODCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="PRODCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/PRODCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/PRODCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="PRODCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/PRODCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/PRODCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="PRODCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/PRODCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/PRODCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="PRODCOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/PRODCOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/PRODCOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="PRODCOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/PRODCOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/PRODCOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                    </tr>
                    
                    <tr class="sub_table_row">
                      <td class="f-lbl-sub" colspan="2">판관비</td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="SGACOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/SGACOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/SGACOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="1">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='1']/ROWSEQ != ''">
                            <input type="text" name="SGACOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='1']/SGACOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='1']/SGACOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="SGACOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/SGACOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/SGACOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="2">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='2']/ROWSEQ != ''">
                            <input type="text" name="SGACOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='2']/SGACOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='2']/SGACOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="SGACOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/SGACOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/SGACOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="3">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='3']/ROWSEQ != ''">
                            <input type="text" name="SGACOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='3']/SGACOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='3']/SGACOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="SGACOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/SGACOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/SGACOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="4">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='4']/ROWSEQ != ''">
                            <input type="text" name="SGACOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='4']/SGACOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='4']/SGACOSTRT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="SGACOST" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/SGACOST}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/SGACOST))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td class="tdRead_Center" style="border-right: 0" data-column="5">
                        <xsl:choose>
                          <xsl:when test="($mode='new' or $mode='edit') and //forminfo/subtables/subtable2/row[ROWSEQ='5']/ROWSEQ != ''">
                            <input type="text" name="SGACOSTRT" class="txtRead_Center" readonly="readonly" value="{//forminfo/subtables/subtable2/row[ROWSEQ='5']/SGACOSTRT}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/subtables/subtable2/row[ROWSEQ='5']/SGACOSTRT))" />
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>&nbsp;특기사항</span>
          </div>

          <div class="ff" />
          <div class="ff" />

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
                <iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx" />
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>&nbsp;개정이력</span>
                    </td>
                    <td class="fm-button">
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>&nbsp;개정이력</span>
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
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:15%"></col>
                      <col style="width:15%"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0;">Rev.</td>
                      <td class="f-lbl-sub" style="border-top:0;">개정일자</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">개정사유</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
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
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">height:18px</xsl:attribute>
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REVISION" class="txtNumberic" maxlength="5" value="{REVISION}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REVISION))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text"  name="REVISIONDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{REVISIONDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REVISIONDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REVISIONCAUSE" class="txtText" maxlength="30" value="{REVISIONCAUSE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REVISIONCAUSE))" />
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
