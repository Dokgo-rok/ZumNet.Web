<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">

  <xsl:import href="../../Forms/XFormScript.xsl"/>
  <xsl:variable name="mode" select="//config/@mode" />
  <xsl:variable name="root" select="//config/@root" />
  <xsl:variable name="relid" select="//config/@relid" />
  <xsl:variable name="acl" select="//config/@acl" />
  <xsl:variable name="displaylog">false</xsl:variable>

<xsl:template match="/">
<html>
<head>
<title>금형대장</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<style type="text/css">
  <xsl:value-of select="phxsl:baseStyle()" />
  /* 화면 넓이, 에디터 높이, 양식명크기 */
  .m {width:760px}
  .fh h1 {font-size:22pt;letter-spacing:2pt}

  /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
  .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:} .m .ft .f-lbl2 {width:}
  .m .ft .f-option {width:20px} .m .ft .f-option1 {width:49%} .m .ft .f-option2 {width:49%}
  .m .ft-sub {border:1px solid windowtext;border-top:0}
  .m .ft-sub .ft-sub-sub td {border:0;border-right:windowtext 1pt dotted;border-bottom:windowtext 1pt dotted}
  .m .ft-sub .f-option {width:49%} .m .fm .f-option1 {width:50%} .m .fm .f-option2 {width:50%;text-align:right;padding-right:2px;font-size:12px}

  /* 하위테이블 추가삭제 버튼 */
  .subtbl_div button {height:16px;width:16px}
</style>
</head>
<body>
<div class="m">
  <div class="fh">
    <table border="0" cellspacing="0" cellpadding="0">
    <tr>
    <td class="fh-l">
      <img alt="크레신" src="/Storage/CRESYN/CI/cresyn_logo_large.gif" />
    </td>
    <td class="fh-m">
      <h1>금형대장</h1>
    </td>
    <td class="fh-r">&#160;</td>
    </tr>
    </table>
  </div>

  <div class="ff" />
  <div class="ff" />
  <div class="ff" />
  <div class="ff" />

  <div class="fm">
    <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-top:0;border-right:1px solid #fff">
      <tr>
        <td class="f-lbl" style="border-top:windowtext 1pt solid">고객금형번호</td>
        <td style="border-top:1px solid windowtext">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit' ">
              <input type="text" id="__mainfield" name="TOOLING_TAGNO"  onkeyup="parent.fnAutoText(event, 'tooling', 264, 250, 138, 200, this);" value="{//forminfo/maintable/TOOLING_TAGNO}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOOLING_TAGNO))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td colspan="2" style="border-right:0">&#160;</td>
      </tr>
      <tr>
        <td class="f-lbl">금형번호</td>
        <td style="width:35%">
          <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOOLING_NUMBER))" />-->
          <input type="text" name="TOOLING_NUMBER" class="txtRead" readonly="readonly" value="{//forminfo/maintable/TOOLING_NUMBER}" />
        </td>
        <td class="f-lbl">작성일</td>
        <td style="border-right:windowtext 1pt solid">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CREATE_DATE" class="txtRead" readonly="readonly">
                <xsl:attribute name="value">
                  <xsl:choose>
                    <xsl:when test="//forminfo/maintable/CREATE_DATE[.!='']">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/CREATE_DATE), '', '',19,false)" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//current/@date), '', '',19,false)" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/CREATE_DATE[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/CREATE_DATE), '', '',19,false)" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="$mode='new'">
            <input type="hidden" id="__mainfield" name="ORDER_CREATE_DATE" value="{phxsl:cvtDate(string(//current/@date), '', '',19,false)}" />
          </xsl:if>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">작성자</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit' ">
              <input type="text" name="CREATEORINFO" class="txtRead" readonly="readonly">
                <xsl:attribute name="value">
                  <xsl:choose>
                    <xsl:when test="//forminfo/maintable/CREATOR[.!='']">
                      <xsl:value-of select="//forminfo/maintable/CREATORDEPT" />.<xsl:value-of select="//forminfo/maintable/CREATOR" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="//current/depart" />.<xsl:value-of select="//current/name" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/CREATOR[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CREATORDEPT))" />.<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CREATOR))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">최종수정일</td>
        <td style="border-bottom:0;border-right:windowtext 1pt solid">
          <xsl:choose>
            <xsl:when test="$mode='edit'">
              <input type="text" id="__mainfield" name="MODIFY_DATE" class="txtRead" readonly="readonly" value="{phxsl:cvtDate(string(//current/@date), '', '',19,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/MODIFY_DATE[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/MODIFY_DATE), '', '',19,false)" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
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
      <xsl:if test="$mode='new' or $mode='edit'">
        <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
      </xsl:if>
      <tr>
        <td class="f-lbl">사업장</td>
        <td style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new' or  $mode='edit'">
              <input type="text" id="__mainfield" name="ORG_NAME" style="width:60%;border-bottom:1px solid #f00" tabindex="1" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/ORG_NAME}" />
              <button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','ORG_NAME', 'ORG_ID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ORG_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">제작구분</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <span style="width:80px;border:1px solid #f00">
                <select id="__mainfield" name="DIVISION" style="width:80px" tabindex="2">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'')">
                    <option value="" selected="selected">선택</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'NEW')">
                    <option value="NEW" selected="selected">신작</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="NEW">신작</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'ADD')">
                    <option value="ADD" selected="selected">증작</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="ADD">증작</option>
                  </xsl:otherwise>
                </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'BUYER')">
                      <option value="BUYER" selected="selected">고객</option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="BUYER">고객</option>
                    </xsl:otherwise>
                  </xsl:choose>
              </select>
              </span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'NEW')">신작</xsl:when>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'ADD')">증작</xsl:when>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'BUYER')">고객</xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">적용(Sub)모델</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__subtable1" name="MODELNO" style="width:37%;border-bottom:1px solid #f00" tabindex="3" class="txtText_u" readonly="readonly" value="{//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']/PNUMBER}" />
              <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdmproduct','MODELNO','MODELNM','MODELOID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']">
                  <xsl:apply-templates select="//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']"/>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
              <input type="hidden" name="MODELNO" value="{//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']/PNUMBER}" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">생산부품</td>
        <td colspan="3" style="border-right:0">
          <div id="__subtable1_div"  class="subtbl_div" max="5" min="1" fld="PARTNO^PARTNM^PARTOID">
            <xsl:choose>
              <xsl:when test="//forminfo/subtables/subtable1/row[CLSNAME='pdmpart']">
                <xsl:apply-templates select="//forminfo/subtables/subtable1/row[CLSNAME='pdmpart']"/>
              </xsl:when>
              <xsl:otherwise>
                <div>
                  <input type="text" id="__subtable1" name="PARTNO1" style="width:245px;border:1px solid #f00" class="txtText_u" readonly="readonly" />
                  <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                    <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                  </button>&#160;(<input type="text" id="__subtable1" name="PARTNM1" style="width:310px" class="txtText_u" readonly="readonly" />)
                  <button onclick="parent.fnAddDiv(this);" onfocus="this.blur()" class="btn_bg">
                    <xsl:if test="phxsl:isGt(string(PARTCNT), 1)">
                      <xsl:attribute name="style">display:none</xsl:attribute>
                    </xsl:if>
                    <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px" src="/{//config/@root}/EA/Images/ico_26.gif" />
                  </button>
                  <button onclick="parent.fnDelDiv(this);" onfocus="this.blur()" class="btn_bg" style="display:none">
                    <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px" src="/{//config/@root}/EA/Images/ico_27.gif" />
                  </button>
                  <input type="hidden" id="__subtable1" name="PARTOID1" />
                </div>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">소유구분</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <span style="width:120px;border:1px solid #f00"><xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpos'],'POSSESION',string(//forminfo/maintable/POSSESION),'','','120px','4','__mainfield')"/></span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">tdRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/POSSESION))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">BUYER</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="BUYER_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="5" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/BUYER_NAME}" />
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'BUYER','BUYER_NAME','BUYER_ID','BUYER_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BUYER_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">제작처</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MAKE_SUPPLIER_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="6" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/MAKE_SUPPLIER_NAME}" />
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','MAKE_SUPPLIER_NAME','MAKE_SUPPLIER_ID','MAKE_SUPPLIER_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKE_SUPPLIER_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">제작기간</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MAKE_FROM" tabindex="7" style="width:80px;border:1px solid #f00" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/MAKE_FROM),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/MAKE_FROM),'','')" />
            </xsl:otherwise>
          </xsl:choose>
          &#160;~&#160;
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MAKE_TO" tabindex="8" style="width:80px;border:1px solid #f00" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/MAKE_TO),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/MAKE_TO),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">결제조건</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <span style="width:120px"><xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingsettl'],'SETTLEMENT_CODE',string(//forminfo/maintable/SETTLEMENT_CODE),'SETTLEMENT_NAME',string(//forminfo/maintable/SETTLEMENT_NAME),'120px','9','__mainfield')"/></span>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">tdRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SETTLEMENT_NAME))" />
              <input type="hidden" name="SETTLEMENT_CODE" value="{//forminfo/maintable/SETTLEMENT_CODE}" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">제작비용</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="PRODUCTION_CURRENCY" style="width:45px;height:16px;border:1px solid #f00" tabindex="10" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PRODUCTION_CURRENCY}" />
              <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','PRODUCTION_CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
              <input type="text" id="__mainfield" name="PRODUCTION_COST" style="width:196px;border:1px solid #f00" tabindex="11" class="txtcurrency" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/PRODUCTION_COST), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <!--(<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTION_CURRENCY))" />)&#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTION_COST))" />-->
              (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTION_CURRENCY))" />)&#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/PRODUCTION_COST), 0))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">소유처</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="OWNER_NAME" style="width:92%" tabindex="12" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/OWNER_NAME}" />
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','OWNER_NAME','OWNER_ID','OWNER_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OWNER_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">사용처(양산처)</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="txtText" id="__mainfield" name="STORE_PLACE_NAME" style="width:90%"   value="{//forminfo/maintable/STORE_PLACE_NAME}" />
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','STORE_PLACE_NAME','STORE_PLACE_ID','STORE_PLACE_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STORE_PLACE_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">설치장소</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SETUP_PLACE" style="width:60%;" tabindex="19" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/SETUP_PLACE}" />
              <button onclick="parent.fnOption('external.centercode',200,200,90,148,'','SETUP_PLACE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SETUP_PLACE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">영업담당</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="DEPT_NAME" style="width:48%" tabindex="20" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/DEPT_NAME}" />&#160;
              <input type="text" id="__mainfield" name="CHARGE_USER" style="width:40%" tabindex="21" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CHARGE_USER}" />
              <xsl:if test="$mode='new' or $mode='edit'">
                <button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                  <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                </button>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEPT_NAME))" />
              <xsl:if test="//forminfo/maintable/DEPT_NAME[.!=''] and //forminfo/maintable/CHARGE_USER[.!='']">.</xsl:if>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHARGE_USER))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">제작완료일</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="COMPLETE_DATE" tabindex="17" style="width:80px;" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/COMPLETE_DATE),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/COMPLETE_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">&#160;</td>
        <td style="border-right:0;border-bottom:0">
          &#160;
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
        <td class="f-lbl">금형분류</td>
        <td style="width:35%;">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingcls'],'CLASSIFICATION_ID',string(//forminfo/maintable/CLASSIFICATION_ID),'CLASSIFICATION_NAME',string(//forminfo/maintable/CLASSIFICATION_NAME),'120px','22','__mainfield')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLASSIFICATION_NAME))" />
              <input type="hidden" name="CLASSIFICATION_ID" value="{//forminfo/maintable/CLASSIFICATION_ID}" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">사용구분</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/USAGE_TYPE='폐기'">폐기</xsl:when>
                <xsl:otherwise>
                  <select id="__mainfield" name="USAGE_TYPE" style="width:100px" tabindex="23">
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/USAGE_TYPE),'')">
                        <option value="" selected="selected">선택</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="">선택</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/USAGE_TYPE),'사용')">
                        <option value="사용" selected="selected">사용</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="사용">사용</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/USAGE_TYPE),'미사용')">
                        <option value="미사용" selected="selected">미사용</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="미사용">미사용</option>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/USAGE_TYPE),'분실')">
                        <option value="미사용" selected="selected">분실</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="미사용">분실</option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </select>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/USAGE_TYPE),'')">사용</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/USAGE_TYPE))" />
                </xsl:otherwise>
              </xsl:choose>              
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">RFID등록여부</td>
        <td>
          <span class="f-option1" disabled="disabled">
            <input type="checkbox" name="ckbRFID" id="ckb.51">
              <xsl:if test="//forminfo/maintable/CLASSIFICATION_ID!='C' and //forminfo/maintable/CLASSIFICATION_ID!='ETC' and //forminfo/maintable/CLASSIFICATION_ID!='J' and //forminfo/maintable/CLASSIFICATION_ID!='S' and //forminfo/maintable/CLASSIFICATION_ID!='Q'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
            </input>
            <label for="ckb.51">대상</label>
          </span>
          <span class="f-option1" disabled="disabled">
            <input type="checkbox" name="ckbRFID" id="ckb.52">
              <xsl:if test="//forminfo/maintable/CLASSIFICATION_ID='C' or //forminfo/maintable/CLASSIFICATION_ID='ETC' or //forminfo/maintable/CLASSIFICATION_ID='J' or //forminfo/maintable/CLASSIFICATION_ID='S' or //forminfo/maintable/CLASSIFICATION_ID='Q'">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
            </input>
            <label for="ckb.52">비대상</label>
          </span>
        </td>
        <td class="f-lbl">공용구분</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpub'],'CMN_TYPE',string(//forminfo/maintable/CMN_TYPE),'','','120px','36','__mainfield')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">tdRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CMN_TYPE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="font-size:11px">
          MOLD SIZE<br />(W*D*H,mm)
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MOLDSIZE" class="txtText" maxlength="30" value="{//forminfo/maintable/MOLDSIZE}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MOLDSIZE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">금형중량(kg)</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MASS" style="width:120px" tabindex="27" class="txtDollar3" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/MASS), 4)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/MASS[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/MASS)), 4)" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">CAVITY CORE재질</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CAVITY_CORE" tabindex="31" class="txtText" maxlength="100" value="{//forminfo/maintable/CAVITY_CORE}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CAVITY_CORE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">열처리</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="HEAT_TREAT" tabindex="34" class="txtText" maxlength="50" value="{//forminfo/maintable/HEAT_TREAT}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/HEAT_TREAT))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">CAVITY</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CAVITYA" style="width:60px;border:1px solid #f00" tabindex="24" class="txtNumberic" maxlength="3" value="{//forminfo/maintable/CAVITYA}" />&#160;*&#160;
              <input type="text" id="__mainfield" name="CAVITY" style="width:60px;border:1px solid #f00"  tabindex="24" class="txtNumberic" maxlength="3" value="{//forminfo/maintable/CAVITY}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CAVITYA))" />&#160;*&#160;
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CAVITY))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">가용CAVITY</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="ABLCAVITYA" style="width:60px" class="txtNumberic" maxlength="3" value="{//forminfo/maintable/ABLCAVITYA}" />&#160;*&#160;
              <input type="text" id="__mainfield" name="ABLCAVITY" style="width:60px" class="txtNumberic"  onBlur="parent.gg();" maxlength="3" value="{//forminfo/maintable/ABLCAVITY}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ABLCAVITYA))" />&#160;*&#160;
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ABLCAVITY))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">GATE TYPE</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="GATETYPE" class="txtText" maxlength="30" value="{//forminfo/maintable/GATETYPE}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GATETYPE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">RUNNER 중량(g)</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="RUNNERCNT" style="width:120px" class="txtDollar3" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/RUNNERCNT), 3)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/RUNNERCNT[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/RUNNERCNT)), 3)" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">RUNNER TYPE</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <select id="__mainfield" name="RUNNERTYPE" style="width:80px">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RUNNERTYPE),'')">
                    <option value="" selected="selected">선택</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RUNNERTYPE),'COLD')">
                    <option value="COLD" selected="selected">COLD</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="COLD">COLD</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RUNNERTYPE),'HOT')">
                    <option value="HOT" selected="selected">HOT</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="HOT">HOT</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RUNNERTYPE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="font-size:12px">HOT RUNNER 수량</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="HOTRUNNERCNT" style="width:120px" class="txtDollar3" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/HOTRUNNERCNT), 3)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/HOTRUNNERCNT[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/HOTRUNNERCNT)), 3)" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">RFID 부착 여부</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <select id="__mainfield" name="RFID_TAKE" style="width:100px" tabindex="23">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RFID_TAKE),'')">
                    <option value="" selected="selected">선택</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RFID_TAKE),'부착')">
                    <option value="부착" selected="selected">부착</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="부착">부착</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RFID_TAKE),'미부착')">
                    <option value="미부착" selected="selected">미부착</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="미부착">미부착</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RFID_TAKE),'')">미부착</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RFID_TAKE))" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">명판 부착 여부</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <select id="__mainfield" name="NAME_TAKE" style="width:100px" tabindex="23">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/NAME_TAKE),'')">
                    <option value="" selected="selected">선택</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/NAME_TAKE),'부착')">
                    <option value="부착" selected="selected">부착</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="부착">부착</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/NAME_TAKE),'미부착')">
                    <option value="미부착" selected="selected">미부착</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="미부착">미부착</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/NAME_TAKE),'')">미부착</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/NAME_TAKE))" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">COUNTER <br />부착여부</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <select id="__mainfield" name="COUNTER_TAKE" style="width:100px" tabindex="23">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COUNTER_TAKE),'')">
                    <option value="" selected="selected">선택</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COUNTER_TAKE),'부착')">
                    <option value="부착" selected="selected">부착</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="부착">부착</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COUNTER_TAKE),'미부착')">
                    <option value="미부착" selected="selected">미부착</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="미부착">미부착</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/COUNTER_TAKE),'')">미부착</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/COUNTER_TAKE))" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">제작처 금형번호</td>
        <td style="border-bottom:0;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MAKE_TOOLINGNO" class="txtText" maxlength="30" value="{//forminfo/maintable/MAKE_TOOLINGNO}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKE_TOOLINGNO))" />
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
        <td class="f-lbl">재료명</td>
        <td  style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MATERIAL_NAME" tabindex="25" class="txtText" maxlength="100" value="{//forminfo/maintable/MATERIAL_NAME}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MATERIAL_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">재료중량(g)</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MATERIAL_MASS" style="width:120px" tabindex="26" class="txtDollar3" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/MATERIAL_MASS), 4)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/MATERIAL_MASS[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/MATERIAL_MASS), 4))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">수율(%)</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">             
              <input type="text" id="__mainfield" name="WATERPER" class="txtDollar" onBlur="parent.gg();"  style="width:99%" maxlength="10" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/WATERPER), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/WATERPER), 0))" />              
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">CYCLE TIME</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CYCLETIME" class="txtCurrency"  onBlur="parent.gg();" style="width:120px" maxlength="10" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/CYCLETIME), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/CYCLETIME[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/CYCLETIME), 0))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">생산시간(Hr)</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="PRODHR" class="txtCurrency"  onBlur="parent.gg();" style="width:120px" maxlength="10" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/PRODHR), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/CYCLETIME[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/PRODHR), 0))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">1 DAY CAPA</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="ONEDAY" class="txtRead" readonly="readonly"  style="width:99%;text-align:right" maxlength="10" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/ONEDAY), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/ONEDAY), 0))" />
            </xsl:otherwise>
          </xsl:choose>    
        </td>
      </tr>
      <tr>
        <td class="f-lbl">1 Mth 생산일<br/>
        (Day)
        </td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="ONEMON" class="txtDollar" onBlur="parent.gg();" style="width:99%" maxlength="10" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/ONEMON), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/ONEMON), 0))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">1 Mth CAPA</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="ONEMONCAP" class="txtRead" readonly="readonly" style="width:99%;text-align:right" maxlength="10" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/ONEMONCAP), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/ONEMONCAP), 0))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">누적SHOT</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SHOT" style="width:120px" tabindex="29" class="txtCurrency" maxlength="18" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/SHOT), 0)}" />              
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/SHOT[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/SHOT), 0))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">기준일자</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SHOTSTDDATE" tabindex="29" style="width:80px" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/SHOTSTDDATE),'','',0,false)}" />
              <!--<input type="text" class="txtRead" readonly="readonly" value="{phxsl:cvtDate(string(//forminfo/maintable/SHOTSTDDATE),'','',0,false)}" />-->
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/SHOTSTDDATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">보증 SHOT</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="EXPIRATION_SHOT" style="width:120px" tabindex="30" class="txtCurrency" maxlength="18" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/EXPIRATION_SHOT), 0)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/EXPIRATION_SHOT[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/EXPIRATION_SHOT), 0))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">사출기용량(Ton)</td>
        <td style="border-bottom:0;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="INJECTION_CAPA" style="width:120px" tabindex="28" class="txtDollar3" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/INJECTION_CAPA), 4)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/INJECTION_CAPA[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/INJECTION_CAPA), 4))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
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
        <td class="f-lbl">대금청구구분</td>
        <td style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <select id="__mainfield" name="PRICE_TYPE" style="width:100px" tabindex="37">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/PRICE_TYPE),'')">
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/PRICE_TYPE),'') and phxsl:isEqual(string(//forminfo/maintable/POSSESION),'고객')">
                        <option value="">선택</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="" selected="selected">선택</option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/PRICE_TYPE),'청구')">
                    <option value="청구" selected="selected">청구</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/PRICE_TYPE),'') and phxsl:isEqual(string(//forminfo/maintable/POSSESION),'고객')">
                        <option value="청구" selected="selected">청구</option>
                      </xsl:when>
                      <xsl:otherwise>
                        <option value="청구">청구</option>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/PRICE_TYPE),'미청구')">
                    <option value="미청구" selected="selected">미청구</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="미청구">미청구</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PRICE_TYPE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">금형비부담</td>
        <td colspan="3" style="border-right:0">
          <span class="f-option3" style="width:46px">
            <input type="checkbox" name="ckbWHOMONEY" value="당사" id="ckb.11">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="onclick">parent.fnCheckYN('ckbWHOMONEY', this, 'WHOMONEY')</xsl:attribute>
              </xsl:if>
              <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'당사')">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
              <xsl:if test="not ($mode='new' or $mode='edit')">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>
            </input>
            <label for="ckb.11">당사</label>
          </span>
          <span class="f-option3" style="width:46px">
            <input type="checkbox" name="ckbWHOMONEY" value="고객" id="ckb.12">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="onclick">parent.fnCheckYN('ckbWHOMONEY', this, 'WHOMONEY')</xsl:attribute>
              </xsl:if>
              <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'고객')">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
              <xsl:if test="not ($mode='new' or $mode='edit')">
                <xsl:attribute name="disabled">disabled</xsl:attribute>
              </xsl:if>
            </input>
            <label for="ckb.12">고객</label>
          </span>
          (<span class="f-option3" style="width:76px">
            <input type="checkbox" name="ckbWHOMONEYDETAIL" value="감가상각" id="ckb.13">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="onclick">parent.fnCheckYN('ckbWHOMONEYDETAIL', this, 'WHOMONEYDETAIL')</xsl:attribute>
              </xsl:if>
              <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEYDETAIL),'감가상각')">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'당사')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </input>
            <label for="ckb.13">감가상각</label>
          </span>
          <span class="f-option3" style="width:76px">
            <input type="checkbox" name="ckbWHOMONEYDETAIL" value="고객청구" id="ckb.14">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="onclick">parent.fnCheckYN('ckbWHOMONEYDETAIL', this, 'WHOMONEYDETAIL')</xsl:attribute>
              </xsl:if>
              <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEYDETAIL),'고객청구')">
                <xsl:attribute name="checked">true</xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/WHOMONEY),'당사')">
                    <xsl:attribute name="disabled">disabled</xsl:attribute>
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="disabled">disabled</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
            </input>
            <label for="ckb.14">고객청구</label>
          </span>)
        </td>
      </tr>
      <tr>
        <td class="f-lbl">금형판매액</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SALES_CURRENCY" style="width:45px;height:16px" tabindex="38" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/SALES_CURRENCY}" />
              <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','SALES_CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
              <input type="text" id="__mainfield" name="SALES_COST" style="width:200px" tabindex="39" class="txtDollar" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/SALES_COST), 4)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/SALES_CURRENCY[.!='']">
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SALES_CURRENCY))" />)
                  <xsl:if test="//forminfo/maintable/SALES_COST[.!='']">
                    &#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/SALES_COST), 4))" />
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="//forminfo/maintable/SALES_COST[.!='']">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/SALES_COST), 4))" />
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">금형판매일</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SALES_DATE" tabindex="40" class="txtDate" style="width:80px" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/SALES_DATE),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/SALES_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">대금회수금액</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="RETRIEVAL_CURRENCY" style="width:45px;height:16px" tabindex="41" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/RETRIEVAL_CURRENCY}" />
              <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','RETRIEVAL_CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
              <input type="text" id="__mainfield" name="RETRIEVAL_COST" style="width:200px" tabindex="42" class="txtDollar" maxlength="15" value="{phxsl:addCommaAndDotMinus(string(//forminfo/maintable/RETRIEVAL_COST), 4)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/RETRIEVAL_CURRENCY[.!='']">
                  (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RETRIEVAL_CURRENCY))" />)
                  <xsl:if test="//forminfo/maintable/RETRIEVAL_COST[.!='']">
                    &#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/RETRIEVAL_COST), 4))" />
                  </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="//forminfo/maintable/RETRIEVAL_COST[.!='']">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:nZero(phxsl:addCommaAndDotMinus(string(//forminfo/maintable/RETRIEVAL_COST), 4))" />
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">대금회수일</td>
        <td style="width:12%">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="RETRIEVAL_DATE" tabindex="43" class="txtDate" style="width:80px" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/RETRIEVAL_DATE),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/RETRIEVAL_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="width:11%">회수예정</td>
        <td style="width:12%;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="RETRIEVAL_EXP_DATE" tabindex="43" class="txtDate" style="width:80px" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/RETRIEVAL_EXP_DATE),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/RETRIEVAL_EXP_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">대금회수사업장</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or  $mode='edit'">
              <input type="text" id="__mainfield" name="RETRIEVAL_ORG_NAME" style="width:60%" tabindex="44" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/RETRIEVAL_ORG_NAME}" />
              <button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','RETRIEVAL_ORG_NAME', 'RETRIEVAL_ORG_ID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RETRIEVAL_ORG_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">대금회수완료여부</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <select id="__mainfield" name="RETRIEVAL_TYPE" style="width:80px" tabindex="45">
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RETRIEVAL_TYPE),'')">
                    <option value="" selected="selected">선택</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="">선택</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RETRIEVAL_TYPE),'진행')">
                    <option value="진행" selected="selected">진행</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="진행">진행</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/RETRIEVAL_TYPE),'완료')">
                    <option value="완료" selected="selected">완료</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="완료">완료</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/RETRIEVAL_TYPE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>    
      <tr>
        <td class="f-lbl">PO No.</td>
        <td style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="PONO" class="txtText" maxlength="30" value="{//forminfo/maintable/PONO}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PONO))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">PO발행일</td>
        <td style="border-right:0" colspan="3">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="PODATE" style="width:80px" class="txtDate" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid);" value="{phxsl:cvtDate(string(//forminfo/maintable/PODATE),'','',0,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/PODATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">AP No.</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="APNO" class="txtText" maxlength="30" value="{//forminfo/maintable/APNO}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APNO))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">&#160;</td>
        <td style="border-right:0;border-bottom:0" colspan="3">&#160;</td>
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
        <td class="f-lbl">특기사항1</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <textarea id="__mainfield" name="REMARK1" style="height:40px" tabindex="44" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);">
                <xsl:value-of select="//forminfo/maintable/REMARK1" />
              </textarea>
            </xsl:when>
            <xsl:otherwise>
              <div name="REMARK1" style="height:40px" class="txaRead">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REMARK1))" />
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">특기사항2</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <textarea id="__mainfield" name="REMARK2" style="height:40px" tabindex="45" class="txaText" onkeyup="parent.checkTextAreaLength(this, 1000);">
                <xsl:value-of select="//forminfo/maintable/REMARK2" />
              </textarea>
            </xsl:when>
            <xsl:otherwise>
              <div name="REMARK2" style="height:40px" class="txaRead">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REMARK2))" />
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <xsl:if test="$mode!='new'">
        <tr>
          <td class="f-lbl">금형문서</td>
          <td colspan="3" style="border-right:0">
            <xsl:choose>
              <xsl:when test="//forminfo/subtables/subtable1/row[CLSNAME='ea']">
                <xsl:apply-templates select="//forminfo/subtables/subtable1/row[CLSNAME='ea']"/>
              </xsl:when>
              <xsl:otherwise>&#160;</xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <td class="f-lbl">금형사진</td>
        <td colspan="3" style="border-right:0">
          <div id="lstFile">
            <form id="upForm" name="upForm" action="" method="post" enctype="multipart/form-data" style="margin:0;padding:0">
              <div>
                <xsl:if test="//fileinfo/file[@isfile='N'] or $mode='read' or ($mode='edit' and ($acl='C' or $acl=''))">
                  <xsl:attribute name="style">display:none</xsl:attribute>
                </xsl:if>
                <input type="file" name="file1" style="width:80%"></input>
                <button onclick="return parent.jsFileUpload();" onfocus="this.blur()" class="btn_bg"><img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />파일첨부</button>
              </div>
              <div>
                <xsl:choose>
                  <xsl:when test="//fileinfo/file[@isfile='N']">
                    <xsl:apply-templates select="//fileinfo/file[@isfile='N']"/>
                    <xsl:if test="$mode!='read'">
                      <span style="height:16px;width:16px;margin:0 4px 0 4px;border:1px solid #999999">
                        <img alt="" style="margin:-3px -1px -2px 0;cursor:hand;border:0;vertical-align:middle">
                          <xsl:attribute name="onclick">parent.FU.remove(this,'<xsl:value-of select="$root"/>','<xsl:value-of select="//fileinfo/file[@isfile='N']/@attachid"/>')</xsl:attribute>
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/isdelete.gif</xsl:attribute>
                        </img>
                      </span>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="style">display:none</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </div>
            </form>
          </div>
          <div id="vwFile">
            <xsl:choose>
              <xsl:when test="//fileinfo/file[@isfile='N']">
                <xsl:attribute name="style">padding:4px</xsl:attribute>
                <img onload="if(this.offsetWidth>630)this.style.width='630px'">
                  <xsl:attribute name="alt"><xsl:value-of select="//fileinfo/file[@isfile='N']/filename"/></xsl:attribute>
                  <xsl:attribute name="src"><xsl:value-of select="//fileinfo/file[@isfile='N']/virtualpath"/>/<xsl:value-of select="//fileinfo/file[@isfile='N']/savedname"/></xsl:attribute>
                </img>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$mode='read' or ($mode='edit' and ($acl='C' or $acl=''))">
                    <xsl:attribute name="style">padding:4px</xsl:attribute>&#160;</xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="style">padding:4px;display:none</xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </td>
      </tr>   
      <tr>
        <td class="f-lbl" style="border-bottom:0">첨부파일</td>
        <td colspan="3" style="border-right:0;border-bottom:0">
          <xsl:apply-templates select="//fileinfo/file[@isfile='Y']"/>
        </td>
      </tr>
    </table>
  </div>
</div>

<!-- Main Table Hidden Field -->
<input type="hidden" id="__mainfield" name="CREATOR">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:choose>
        <xsl:when test="//forminfo/maintable/CREATOR[.!='']">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATOR" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="value"><xsl:value-of select="//current/name" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATOR" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>  
<input type="hidden" id="__mainfield" name="CREATORID">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:choose>
        <xsl:when test="//forminfo/maintable/CREATORID[.!='']">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORID" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="value"><xsl:value-of select="//current/@uid" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORID" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>
<input type="hidden" id="__mainfield" name="CREATORCN">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:choose>
        <xsl:when test="//forminfo/maintable/CREATORCN[.!='']">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORCN" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="value"><xsl:value-of select="//current/@account" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORCN" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>
<input type="hidden" id="__mainfield" name="CREATORDEPT">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:choose>
        <xsl:when test="//forminfo/maintable/CREATORDEPT[.!='']">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORDEPT" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="value"><xsl:value-of select="//current/depart" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORDEPT" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>  
<input type="hidden" id="__mainfield" name="CREATORDEPTID">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:choose>
        <xsl:when test="//forminfo/maintable/CREATORDEPTID[.!='']">
          <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORDEPTID" /></xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="value"><xsl:value-of select="//current/@deptid" /></xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORDEPTID" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>
  <!-- 꽃남-->
<input type="hidden" id="__mainfield" name="RUNNER_GATE_FORM" value="{//forminfo/maintable/RUNNER_GATE_FORM}" />
<input type="hidden" id="__mainfield" name="CAVITY_DISCRIPTION" value="{//forminfo/maintable/CAVITY_DISCRIPTION}" />
<input type="hidden" id="__mainfield" name="SLIDE_CORE" value="{//forminfo/maintable/SLIDE_CORE}" />
<input type="hidden" id="__mainfield" name="MOLD_TYPE" value="{//forminfo/maintable/MOLD_TYPE}" />
<input type="hidden" value="{phxsl:cvtDate(string(//forminfo/maintable/TAGDATE),'','',0,false)}" />
<input type="hidden" id="__mainfield" name="APPROVAL_DATE" value="{phxsl:cvtDate(string(//forminfo/maintable/APPROVAL_DATE),'','',0,false)}" />
<input type="hidden" id="__mainfield" name="TEST_TO"  value="{phxsl:cvtDate(string(//forminfo/maintable/TEST_TO),'','',0,false)}" />
<input type="hidden" id="__mainfield" name="TEST_FROM"  value="{phxsl:cvtDate(string(//forminfo/maintable/TEST_FROM),'','',0,false)}" />  
<input type="hidden" id="__mainfield" name="ORG_ID" value="{//forminfo/maintable/ORG_ID}" />
<input type="hidden" id="__mainfield" name="BUYER_ID" value="{//forminfo/maintable/BUYER_ID}" />
<input type="hidden" id="__mainfield" name="BUYER_SITEID" value="{//forminfo/maintable/BUYER_SITEID}" />
<input type="hidden" id="__mainfield" name="MAKE_SUPPLIER_ID" value="{//forminfo/maintable/MAKE_SUPPLIER_ID}" />
<input type="hidden" id="__mainfield" name="MAKE_SUPPLIER_SITEID" value="{//forminfo/maintable/MAKE_SUPPLIER_SITEID}" />
<input type="hidden" id="__mainfield" name="OWNER_ID" value="{//forminfo/maintable/OWNER_ID}" />
<input type="hidden" id="__mainfield" name="OWNER_SITEID" value="{//forminfo/maintable/OWNER_SITEID}" />
<input type="hidden" id="__mainfield" name="STORE_PLACE_ID" value="{//forminfo/maintable/STORE_PLACE_ID}" />
<input type="hidden" id="__mainfield" name="STORE_PLACE_SITEID" value="{//forminfo/maintable/STORE_PLACE_SITEID}" />
<input type="hidden" id="__mainfield" name="TEST_PLACE_ID" value="{//forminfo/maintable/TEST_PLACE_ID}" />
<input type="hidden" id="__mainfield" name="TEST_PLACE_SITEID" value="{//forminfo/maintable/TEST_PLACE_SITEID}" />
<input type="hidden" id="__mainfield" name="EXCHANGE_USD" value="{//forminfo/maintable/EXCHANGE_USD}" />
<input type="hidden" id="__mainfield" name="DEPT_CODE" value="{//forminfo/maintable/DEPT_CODE}" />
<input type="hidden" id="__mainfield" name="CHARGE_USER_ID" value="{//forminfo/maintable/CHARGE_USER_ID}" />
<input type="hidden" id="__mainfield" name="CHARGE_USER_EMPNO" value="{//forminfo/maintable/CHARGE_USER_EMPNO}" />
<input type="hidden" id="__mainfield" name="STATUS_VALUE" value="{//forminfo/maintable/STATUS_VALUE}" />
<input type="hidden" id="__mainfield" name="DOC_NUMBER" value="{//forminfo/maintable/DOC_NUMBER}" />
<input type="hidden" id="__mainfield" name="DOC_IFSTATE" value="{//forminfo/maintable/DOC_IFSTATE}" />
<input type="hidden" id="__mainfield" name="PrevWork" value="{//forminfo/maintable/PrevWork}" />
<input type="hidden" id="__mainfield" name="NextWork" value="{//forminfo/maintable/NextWork}" />
<input type="hidden" id="__mainfield" name="WHOMONEY" value="{//forminfo/maintable/WHOMONEY}" />
<input type="hidden" id="__mainfield" name="WHOMONEYDETAIL" value="{//forminfo/maintable/WHOMONEYDETAIL}" />
<input type="hidden" id="__mainfield" name="RETRIEVAL_ORG_ID" value="{//forminfo/maintable/RETRIEVAL_ORG_ID}" />
  
<!-- LINK Table Hidden Field : DB에 저장되는 값은 아님 -->
<input type="hidden" id="__subtable1" name="MODELNM" value="{//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']/SUBJECT}" />
<input type="hidden" id="__subtable1" name="MODELOID" value="{//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']/PDMOID}" />

<xsl:if test="$displaylog='true'"><div><xsl:value-of select="phxsl:getLog()"/></div></xsl:if>
</body>
</html>
</xsl:template>

<xsl:template match="//forminfo/subtables/subtable1/row">
  <xsl:choose>
    <xsl:when test="CLSNAME='ea'">
      <div>
        <a target="_blank">
          <xsl:attribute name="href">/<xsl:value-of select="$root"/>/EA/Forms/XFormMain.aspx?M=read&amp;mi=<xsl:value-of select="PDMOID"/></xsl:attribute>
          <xsl:attribute name="title"><xsl:value-of select="PNUMBER"/></xsl:attribute>
          <xsl:value-of select="SUBJECT"/>&#160;(<xsl:value-of select="PNUMBER"/>)
        </a>
      </div>
    </xsl:when>
    <xsl:when test="CLSNAME='pdmmodel'">
      <div>
        <xsl:choose>
          <xsl:when test="PDMOID!=''">
            <a target="_blank">
              <xsl:attribute name="href">
                <!--/<xsl:value-of select="$root"/>/SSOpdm.aspx?target=prodview&amp;oid=<xsl:value-of select="PDMOID"/>-->
                <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PDMOID))" />
              </xsl:attribute>
              <xsl:attribute name="title"><xsl:value-of select="PNUMBER"/></xsl:attribute>
              <xsl:value-of select="PNUMBER"/>&#160;(<xsl:value-of select="SUBJECT"/>)
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="PNUMBER"/>&#160;(<xsl:value-of select="SUBJECT"/>)
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:when>
    <xsl:when test="CLSNAME='pdmpart'">
      <xsl:choose>
        <xsl:when test="$mode='edit'">
          <div>
            <input type="text" id="__subtable1" name="PARTNO1" style="width:245px">
              <xsl:attribute name="name">PARTNO<xsl:value-of select="position()" /></xsl:attribute>
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value"><xsl:value-of select="PNUMBER" /></xsl:attribute>
            </input>
            <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
              </img>
            </button>&#160;(
            <input type="text" id="__subtable1" style="width:310px">
              <xsl:attribute name="name">PARTNM<xsl:value-of select="position()" /></xsl:attribute>
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value"><xsl:value-of select="SUBJECT" /></xsl:attribute>
            </input>)
            <button onclick="parent.fnAddDiv(this);" onfocus="this.blur()" class="btn_bg">
              <xsl:if test="position()!=last()">
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:if>
              <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
              </img>
            </button>
            <button onclick="parent.fnDelDiv(this);" onfocus="this.blur()" class="btn_bg">
              <xsl:if test="position()!=last()">
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:if>
              <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
              </img>
            </button>
            <input type="hidden" id="__subtable1">
              <xsl:attribute name="name">PARTOID<xsl:value-of select="position()" /></xsl:attribute>
              <xsl:attribute name="value"><xsl:value-of select="PDMOID" /></xsl:attribute>
            </input>
          </div>
        </xsl:when>
        <xsl:otherwise>
          <div>
            <xsl:choose>
              <xsl:when test="PDMOID!=''">
                <a target="_blank">
                  <xsl:attribute name="href">
                    <!--/<xsl:value-of select="$root"/>/SSOpdm.aspx?target=prodview&amp;oid=<xsl:value-of select="PDMOID"/>-->
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:linkDown2(string(//config/@web), string($root), 'pdmpd', string(PDMOID))" />
                  </xsl:attribute>
                  <xsl:attribute name="title">
                    <xsl:value-of select="PNUMBER"/>
                  </xsl:attribute>
                  <xsl:value-of select="PNUMBER"/>&#160;(<xsl:value-of select="SUBJECT"/>)
                </a>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="PNUMBER"/>&#160;(<xsl:value-of select="SUBJECT"/>)
              </xsl:otherwise>
            </xsl:choose>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="//fileinfo/file[@isfile='Y']">
  <div>
    <a target="_blank">
      <xsl:attribute name="href">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:down(string(//config/@web), string($root), 'tooling', string(savedname))" />
      </xsl:attribute>
      <xsl:value-of select="filename" />
    </a>
  </div>
</xsl:template>
<xsl:template match="//fileinfo/file[@isfile='N']">
  <a target="_blank">
    <xsl:attribute name="href">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:down2(string(//config/@web), string($root), string(virtualpath), string(savedname), string(filename))" />
      <!--<xsl:value-of select="//fileinfo/file[@isfile='N']/virtualpath"/>/<xsl:value-of select="//fileinfo/file[@isfile='N']/savedname"/>-->
    </xsl:attribute>  
    <xsl:value-of select="filename" />
  </a>
</xsl:template>
</xsl:stylesheet> 

