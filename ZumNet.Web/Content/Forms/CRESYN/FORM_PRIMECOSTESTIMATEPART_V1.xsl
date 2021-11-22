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
          .m {width:700px} .m .fm-editor {height:300px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt;}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:80px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:100px} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:300px}}
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
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/XCLS), 'UNIT') or phxsl:isEqual(string(//forminfo/maintable/XCLS), '기구')">
                        (<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/XCLS))" />) 개발원가견적표
                      </xsl:when>
                      <xsl:otherwise>
                        (회로) 개발원가견적표
                        <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/XCLS), '회로')">
                          <div style="font-size: 18px; letter-spacing: 0">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/XCLS))" />
                          </div>
                        </xsl:if>
                      </xsl:otherwise>
                    </xsl:choose>
                    
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
                <td style="width:310px">
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

                <td style="width:38px;font-size:1px">&nbsp;</td>

                <td style="width:">
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
                <td style="width: 35%">
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
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER" class="txtRead" value="{//forminfo/maintable/CUSTOMER}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">품목분류</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMCLS" class="txtRead" value="{//forminfo/maintable/ITEMCLS}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMCLS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">고객분류</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BUYERCLS" class="txtRead" value="{//forminfo/maintable/BUYERCLS}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/BUYERCLS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">모델명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtRead" value="{//forminfo/maintable/MODELNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">기획수량</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLANCNT" class="txtRead" value="{//forminfo/maintable/PLANCNT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PLANCNT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom: 0">생산예정지</td>
                <td style="border-bottom: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODUCECENTER" class="txtRead" style="width:40px" value="{//forminfo/maintable/PRODUCECENTER}" />
                      / <input type="text" id="__mainfield" name="CORPCURRENCY" class="txtRead" style="width:100px" value="{//forminfo/maintable/CORPCURRENCY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODUCECENTER))" />&nbsp;(
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CORPCURRENCY))" />)
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td colspan="2" style="text-align: center; border-right:0; border-bottom: 0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:linkCEMain('ekp.cresyn.com', string($root), '관련 개발원가견적표 열기', string(//forminfo/maintable/CEID))" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span style="width: 50%;">&nbsp;원가구성</span>
            <span style="width: 50%; text-align: right; padding-right: 4px">
              통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />
            </span>
          </div>

          <div class="ff" />
          <div class="ff" />
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl2" style="width: 15%">구분</td>
                <td class="f-lbl2" style="width: 20%">금액</td>
                <td class="f-lbl2" style="width: 15%">비율</td>
                <td class="f-lbl2" style="border-right: 0">비고</td>
              </tr>
              <tr>
                <td class="f-lbl2">총원가</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTALCOST" class="txtRead_Center" value="{//forminfo/maintable/TOTALCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">100%</td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TOTALETC" class="txtText" maxlength="100" value="{//forminfo/maintable/TOTALETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">판매예정가</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXSALEPRICE" class="txtRead_Center" value="{//forminfo/maintable/EXSALEPRICE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXSALEPRICE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">&nbsp;</td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXSALEETC" class="txtText" maxlength="100" value="{//forminfo/maintable/EXSALEETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXSALEETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">예상영업이익</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXOPPROFIT" class="txtRead_Center" value="{//forminfo/maintable/EXOPPROFIT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXOPPROFIT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXOPPROFITRT))" />%
                  <input type="hidden" id="__mainfield" name="EXOPPROFITRT" class="txtRead_Center" value="{//forminfo/maintable/EXOPPROFITRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXOPETC" class="txtText" maxlength="100" value="{//forminfo/maintable/EXOPETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXOPETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">예상공헌이익</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXCTBPROFIT" class="txtRead_Center" value="{//forminfo/maintable/EXCTBPROFIT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCTBPROFIT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCTBPROFITRT))" />%
                  <input type="hidden" id="__mainfield" name="EXCTBPROFITRT" class="txtRead_Center" value="{//forminfo/maintable/EXCTBPROFITRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EXCTBETC" class="txtText" maxlength="100" value="{//forminfo/maintable/EXCTBETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCTBETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

              <tr>
                <td colspan="4" style="font-size:1px; height: 2px">&nbsp;</td>
              </tr>
              
              <tr>
                <td class="f-lbl2">재료비</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MTRCOST" class="txtRead_Center" value="{//forminfo/maintable/MTRCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MTRCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MTRCOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="MTRCOSTRT" class="txtRead_Center" value="{//forminfo/maintable/MTRCOSTRT}" />
              </td>
              <td style="border-right: 0">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="MTRETC" class="txtText" maxlength="100" value="{//forminfo/maintable/MTRETC}" />
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MTRETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">수입경비</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="IMCOST" class="txtRead_Center" value="{//forminfo/maintable/IMCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/IMCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/IMCOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="IMCOSTRT" class="txtRead_Center" value="{//forminfo/maintable/IMCOSTRT}" />
              </td>
              <td style="border-right: 0">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="IMETC" class="txtText" maxlength="100" value="{//forminfo/maintable/IMETC}" />
                  </xsl:when>
                  <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/IMETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">가공비</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PCCOST" class="txtRead_Center" value="{//forminfo/maintable/PCCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PCCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PCCOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="PCCOSTRT" class="txtRead_Center" value="{//forminfo/maintable/PCCOSTRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PCETC" class="txtText" maxlength="100" value="{//forminfo/maintable/PCETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PCETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">소모품비</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPLEX" class="txtRead_Center" value="{//forminfo/maintable/SPLEX}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPLEX))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPLEXRT))" />%
                  <input type="hidden" id="__mainfield" name="SPLEXRT" class="txtRead_Center" value="{//forminfo/maintable/SPLEXRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SPLEXETC" class="txtText" maxlength="100" value="{//forminfo/maintable/SPLEXETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SPLEXETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">변동원가</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="VARCOST" class="txtRead_Center" value="{//forminfo/maintable/VARCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VARCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VARCOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="VARCOSTRT" class="txtRead_Center" value="{//forminfo/maintable/VARCOSTRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="VARETC" class="txtText" maxlength="100" value="{//forminfo/maintable/VARETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/VARETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">고정원가</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FIXCOST" class="txtRead_Center" value="{//forminfo/maintable/FIXCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FIXCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FIXCOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="FIXCOSTRT" class="txtRead_Center" value="{//forminfo/maintable/FIXCOSTRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FIXETC" class="txtText" maxlength="100" value="{//forminfo/maintable/FIXETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FIXETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2">제조원가</td>
                <td class="tdRead_Center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODCOST" class="txtRead_Center" value="{//forminfo/maintable/PRODCOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODCOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODCOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="PRODCOSTRT" class="txtRead_Center" value="{//forminfo/maintable/PRODCOSTRT}" />
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PRODETC" class="txtText" maxlength="100" value="{//forminfo/maintable/PRODETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRODETC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="border-bottom: 0">판관비</td>
                <td class="tdRead_Center" style="border-bottom: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SGACOST" class="txtRead_Center" value="{//forminfo/maintable/SGACOST}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SGACOST))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="tdRead_Center" style="border-bottom: 0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SGACOSTRT))" />%
                  <input type="hidden" id="__mainfield" name="SGACOSTRT" class="txtRead_Center" value="{//forminfo/maintable/SGACOSTRT}" />
                </td>
                <td style="border-right: 0;border-bottom: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="SGAETC" class="txtText" maxlength="100" value="{//forminfo/maintable/SGAETC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SGAETC))" />
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

        <!-- 숨은필드 -->
        <input type="hidden" id="__mainfield" name="CEID" value="{//forminfo/maintable/CEID}" />
        <input type="hidden" id="__mainfield" name="XCLS" value="{//forminfo/maintable/XCLS}" />
        <input type="hidden" id="__mainfield" name="CURRENCY" value="{//forminfo/maintable/CURRENCY}" />

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
      <td  style="border-bottom:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text"  name="REVISIONDATE" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{REVISIONDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REVISIONDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td  style="border-bottom:0;border-right:0">
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
