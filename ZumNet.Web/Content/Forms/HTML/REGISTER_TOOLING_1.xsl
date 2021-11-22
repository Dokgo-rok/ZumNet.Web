<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">

  <xsl:import href="../../Forms/XFormScript.xsl"/>
  <xsl:variable name="mode" select="//config/@mode" />
  <xsl:variable name="root" select="//config/@root" />
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
    <table class="ft" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="f-lbl">금형번호</td>
        <td style="width:35%">
          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TOOLING_NUMBER))" />
        </td>
        <td class="f-lbl">작성일</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <input type="text" id="__mainfield" name="CREATE_DATE">
                <xsl:attribute name="class">txtRead</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//current/@date), '', '',19,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:when test="$mode='edit'">
              <input type="text" id="__mainfield" name="CREATE_DATE">
                <xsl:attribute name="class">txtRead</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:choose>
                    <xsl:when test="//forminfo/maintable/CREATE_DATE!=''">
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
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/CREATE_DATE),'')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">작성자</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="CREATEORINFO">
                <xsl:attribute name="class">txtRead</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//current/depart))" />.<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//current/name))" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable[CREATOR.='']">&#160;</xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CREATORDEPT))" />.<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CREATOR))" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">최종수정일</td>
        <td style="border-bottom:0;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='edit'">
              <input type="text" id="__mainfield" name="MODIFY_DATE">
                <xsl:attribute name="class">txtRead</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//current/@date), '', '',19,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/MODIFY_DATE),'', '')" />
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
        <td class="f-lbl">사업장</td>
        <td style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <input type="text" id="__mainfield" name="ORG_NAME" style="width:60%;border-bottom:1px solid #f00" tabindex="1">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/ORG_NAME" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnOption('external.centercode',200,200,90,148,'orgcode','ORG_NAME', 'ORG_ID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ORG_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">구분</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <select id="__mainfield" name="DIVISION" style="width:100px;border:1px solid #f00" tabindex="2">
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
                    <option value="NEW" selected="selected">금형신작</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="NEW">금형신작</option>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                  <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'ADD')">
                    <option value="ADD" selected="selected">금형증작</option>
                  </xsl:when>
                  <xsl:otherwise>
                    <option value="ADD">금형증작</option>
                  </xsl:otherwise>
                </xsl:choose>
              </select>
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'NEW')">금형신작</xsl:when>
                <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DIVISION),'ADD')">금형증작</xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">적용모델</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <input type="text" id="__subtable1" name="MODELNO" style="width:37%;border-bottom:1px solid #f00" tabindex="3">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
              </input>
              <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdmproduct','MODELNO','MODELNM','MODELOID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
            </xsl:when>
            <xsl:when test="//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']">
              <xsl:apply-templates select="//forminfo/subtables/subtable1/row[CLSNAME='pdmmodel']"/>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">소유구분</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpos'],'POSSESION',string(//forminfo/maintable/POSSESION),'','','120px','4','__mainfield')"/>
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
            <xsl:when test="$mode='new'">
              <input type="text" id="__mainfield" name="BUYER_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="5">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/BUYER_NAME" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'BUYER','BUYER_NAME','BUYER_ID','BUYER_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
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
            <xsl:when test="$mode='new'">
              <input type="text" id="__mainfield" name="MAKE_SUPPLIER_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="6">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/MAKE_SUPPLIER_NAME" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','MAKE_SUPPLIER_NAME','MAKE_SUPPLIER_ID','MAKE_SUPPLIER_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
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
              <input type="text" id="__mainfield" name="MAKE_FROM" tabindex="7" style="width:80px;border:1px solid #f00">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/MAKE_FROM),'','',0,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/MAKE_FROM),'','')" />
            </xsl:otherwise>
          </xsl:choose>
          &#160;~&#160;
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MAKE_TO" tabindex="8" style="width:80px;border:1px solid #f00">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/MAKE_TO),'','',0,false)" />
                </xsl:attribute>
              </input>
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
            <xsl:when test="$mode='new'">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingsettl'],'SETTLEMENT_CODE',string(//forminfo/maintable/SETTLEMENT_CODE),'SETTLEMENT_NAME',string(//forminfo/maintable/SETTLEMENT_NAME),'120px','9','__mainfield')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">tdRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SETTLEMENT_NAME))" />
              <input type="hidden" name="SETTLEMENT_CODE">
                <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/SETTLEMENT_CODE" /></xsl:attribute>
              </input>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">제작비용</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <input type="text" id="__mainfield" name="PRODUCTION_CURRENCY" style="width:45px;height:16px;border:1px solid #f00" tabindex="10">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/PRODUCTION_CURRENCY" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','PRODUCTION_CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
              <input type="text" id="__mainfield" name="PRODUCTION_COST" style="width:200px" tabindex="11">
                <xsl:attribute name="class">txtDollar</xsl:attribute>
                <xsl:attribute name="maxlength">15</xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTION_CURRENCY))" />)&#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTION_COST))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">소유처</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <input type="text" id="__mainfield" name="OWNER_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="12">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/OWNER_NAME" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','OWNER_NAME','OWNER_ID','OWNER_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OWNER_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">보유처</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="STORE_PLACE_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="13">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/STORE_PLACE_NAME" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','STORE_PLACE_NAME','STORE_PLACE_ID','STORE_PLACE_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STORE_PLACE_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">시험사출처</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="TEST_PLACE_NAME" style="width:92%;border-bottom:1px solid #f00" tabindex="14">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/TEST_PLACE_NAME" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnExternal('erp.vendorcustomer',240,40,126,70,'VENDOR','TEST_PLACE_NAME','TEST_PLACE_ID','TEST_PLACE_SITEID');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TEST_PLACE_NAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">시험사출기간</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="TEST_FROM" tabindex="15" style="width:80px;border:1px solid #f00">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/TEST_FROM),'','',0,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/TEST_FROM),'','')" />
            </xsl:otherwise>
          </xsl:choose>
          &#160;~&#160;
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="TEST_TO" tabindex="16" style="width:80px;border:1px solid #f00">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/TEST_TO),'','',0,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/TEST_TO),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">제작완료확인일</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="COMPLETE_DATE" tabindex="15" style="width:80px;border:1px solid #f00">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/COMPLETE_DATE),'','',0,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/COMPLETE_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">승인일</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="APPROVAL_DATE" tabindex="15">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="style">width:80px</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/APPROVAL_DATE),'','',0,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/APPROVAL_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">설치장소</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SETUP_PLACE" style="width:60%;border-bottom:1px solid #f00" tabindex="16">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/SETUP_PLACE" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnOption('external.centercode',200,200,90,148,'','SETUP_PLACE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SETUP_PLACE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">영업부서</td>
        <td style="border-right:0;border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="DEPT_NAME" style="width:92%" tabindex="17">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/DEPT_NAME" />
                </xsl:attribute>
              </input>
              <xsl:if test="$mode='new' or $mode='edit'">
                <button onclick="parent.fnOrgmap('gr','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                  <img alt="" class="blt01" style="margin:0 0 2px 0">
                    <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                  </img>
                </button>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEPT_NAME))" />
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
        <td class="f-lbl">금형분류</td>
        <td style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingcls'],'CLASSIFICATION_ID',string(//forminfo/maintable/CLASSIFICATION_ID),'CLASSIFICATION_NAME',string(//forminfo/maintable/CLASSIFICATION_NAME),'120px','18','__mainfield')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLASSIFICATION_NAME))" />
              <input type="hidden" name="CLASSIFICATION_ID">
                <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CLASSIFICATION_ID" /></xsl:attribute>
              </input>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">사용구분</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new'">
              <select id="__mainfield" name="USAGE_TYPE" style="width:100px" tabindex="19">
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
              </select>
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
        <td class="f-lbl">CAVITY</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CAVITY" style="width:60px;border:1px solid #f00" tabindex="20">
                <xsl:attribute name="class">txtNumberic</xsl:attribute>
                <xsl:attribute name="maxlength">3</xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CAVITY" /></xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CAVITY))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">CAVITY식별명</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CAVITY_DISCRIPTION" tabindex="21">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">50</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/CAVITY_DISCRIPTION" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CAVITY_DISCRIPTION))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">재료명</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MATERIAL_NAME" tabindex="22">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">100</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/MATERIAL_NAME" />
                </xsl:attribute>
              </input>
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
              <input type="text" id="__mainfield" name="MATERIAL_MASS" style="width:120px" tabindex="23">
                <xsl:attribute name="class">txtDollar3</xsl:attribute>
                <xsl:attribute name="maxlength">15</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/MATERIAL_MASS" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MATERIAL_MASS))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">금형중량(kg)</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MASS" style="width:120px" tabindex="24">
                <xsl:attribute name="class">txtDollar3</xsl:attribute>
                <xsl:attribute name="maxlength">15</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/MASS" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MASS))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">사출기용량(os)</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="INJECTION_CAPA" style="width:120px" tabindex="25">
                <xsl:attribute name="class">txtDollar3</xsl:attribute>
                <xsl:attribute name="maxlength">15</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/INJECTION_CAPA" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/INJECTION_CAPA))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">사용실적SHOT</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SHOT" style="width:120px;border:1px solid #f00" tabindex="26">
                <xsl:attribute name="class">txtCurrency</xsl:attribute>
                <xsl:attribute name="maxlength">18</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/SHOT" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SHOT))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">만기SHOT</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="EXPIRATION_SHOT" style="width:120px;border:1px solid #f00" tabindex="27">
                <xsl:attribute name="class">txtCurrency</xsl:attribute>
                <xsl:attribute name="maxlength">18</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/EXPIRATION_SHOT" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EXPIRATION_SHOT))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">CAVITY CORE재질</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="CAVITY_CORE" tabindex="28">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">100</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/CAVITY_CORE" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CAVITY_CORE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">SLIDE CORE재질</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SLIDE_CORE" tabindex="29">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">100</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/SLIDE_CORE" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SLIDE_CORE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">러너/게이트 형식</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="RUNNER_GATE_FORM" tabindex="30">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">50</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/RUNNER_GATE_FORM" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RUNNER_GATE_FORM))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">열처리</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="HEAT_TREAT" tabindex="31">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">50</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/HEAT_TREAT" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/HEAT_TREAT))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">MOLD TYPE</td>
        <td style="border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="MOLD_TYPE" tabindex="32">
                <xsl:attribute name="class">txtText</xsl:attribute>
                <xsl:attribute name="maxlength">50</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/MOLD_TYPE" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MOLD_TYPE))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">공용구분</td>
        <td style="border-right:0;border-bottom:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption[@sk='toolingpub'],'CMN_TYPE',string(//forminfo/maintable/CMN_TYPE),'','','120px','4','__mainfield')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:attribute name="class">tdRead</xsl:attribute>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CMN_TYPE))" />
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
              <select id="__mainfield" name="USAGE_TYPE" style="width:100px" tabindex="33">
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
        <td class="f-lbl">&#160;</td>
        <td style="border-right:0">&#160;</td>
      </tr>
      <tr>
        <td class="f-lbl">금형판매액</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SALES_CURRENCY" style="width:45px;height:16px" tabindex="34">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/SALES_CURRENCY" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','SALES_CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                </img>
              </button>
              <input type="text" id="__mainfield" name="SALES_COST" style="width:200px" tabindex="35">
                <xsl:attribute name="class">txtDollar</xsl:attribute>
                <xsl:attribute name="maxlength">15</xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SALES_CURRENCY))" />)&#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SALES_COST))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">금형판매일</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="SALES_DATE" tabindex="36">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="style">width:80px</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/SALES_DATE),'','',0,false)" />
                </xsl:attribute>
              </input>
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
              <input type="text" id="__mainfield" name="RETRIEVAL_CURRENCY" style="width:45px;height:16px" tabindex="37">
                <xsl:attribute name="class">txtText_u</xsl:attribute>
                <xsl:attribute name="readonly">readonly</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="//forminfo/maintable/RETRIEVAL_CURRENCY" />
                </xsl:attribute>
              </input>
              <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','RETRIEVAL_CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">
                    /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                  </xsl:attribute>
                </img>
              </button>
              <input type="text" id="__mainfield" name="RETRIEVAL_COST" style="width:200px" tabindex="38">
                <xsl:attribute name="class">txtDollar</xsl:attribute>
                <xsl:attribute name="maxlength">15</xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RETRIEVAL_CURRENCY))" />)&#160;<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/RETRIEVAL_COST))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">대금회수일</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" id="__mainfield" name="RETRIEVAL_DATE" tabindex="39">
                <xsl:attribute name="class">txtDate</xsl:attribute>
                <xsl:attribute name="style">width:80px</xsl:attribute>
                <xsl:attribute name="maxlength">8</xsl:attribute>
                <xsl:attribute name="onclick">parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)</xsl:attribute>
                <xsl:attribute name="value">
                  <xsl:value-of select="phxsl:cvtDate(string(//forminfo/maintable/RETRIEVAL_DATE),'','',0,false)" />
                </xsl:attribute>
              </input>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/RETRIEVAL_DATE),'','')" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">최종TRY차수</td>
        <td>
          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LASTTRYNO))" />
        </td>
        <td class="f-lbl">최종TRY일자</td>
        <td style="border-right:0">
          <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/LASTTRYDATE),'','')" />
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">TRY승인</td>
        <td style="border-bottom:0">
          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRYAPPROVALDEPTNM))" />
          <xsl:if test="phxsl:isDiff(string(//forminfo/maintable/TRYAPPROVALNM),'')">
            .<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TRYAPPROVALNM))" />
          </xsl:if>
        </td>
        <td class="f-lbl" style="border-bottom:0">TRY승인일자</td>
        <td style="border-right:0;border-bottom:0">
          <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/TRYAPPROVALDATE),'','')" />
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
        <td class="f-lbl">특기사항1</td>
        <td colspan="3" style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <textarea id="__mainfield" name="REMARK1" style="height:40px" tabindex="40">
                <xsl:attribute name="class">txaText</xsl:attribute>
                <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                <xsl:if test="$mode='edit'">
                  <xsl:value-of select="//forminfo/maintable/REMARK1" />
                </xsl:if>
              </textarea>
            </xsl:when>
            <xsl:otherwise>
              <div id="__mainfield" name="REMARK1" style="height:40px">
                <xsl:attribute name="class">txaRead</xsl:attribute>
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
              <textarea id="__mainfield" name="REMARK2" style="height:40px" tabindex="41">
                <xsl:attribute name="class">txaText</xsl:attribute>
                <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                <xsl:if test="$mode='edit'">
                  <xsl:value-of select="//forminfo/maintable/REMARK2" />
                </xsl:if>
              </textarea>
            </xsl:when>
            <xsl:otherwise>
              <div id="__mainfield" name="REMARK2" style="height:40px">
                <xsl:attribute name="class">txaRead</xsl:attribute>
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
                <xsl:if test="//fileinfo/file[@isfile='N'] or $mode='read'">
                  <xsl:attribute name="style">display:none</xsl:attribute>
                </xsl:if>
                <input type="file" name="file1" style="width:80%"></input>
                <button onclick="return parent.jsFileUpload();" onfocus="this.blur()" class="btn_bg">
                  <img alt="" class="blt01">
                    <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                  </img>파일첨부
                </button>
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
                  <xsl:when test="$mode='read'">
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
        <td class="f-lbl">생산부품</td>
        <td colspan="3" style="border-right:0">
          <div id="__subtable1_div"  class="subtbl_div" max="5" min="1" fld="PARTNO^PARTNM^PARTOID">
            <xsl:choose>
              <xsl:when test="//forminfo/subtables/subtable1/row[CLSNAME='pdmpart']">
                <xsl:apply-templates select="//forminfo/subtables/subtable1/row[CLSNAME='pdmpart']"/>
              </xsl:when>
              <xsl:otherwise>
                <div>
                  <input type="text" id="__subtable1" name="PARTNO1" style="width:245px">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>
                  <button onclick="parent.fnExternal('erp.items',240,40,136,74,'pdm',this);" onfocus="this.blur()" class="btn_bg">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                    </img>
                  </button>&#160;(
                  <input type="text" id="__subtable1" name="PARTNM1" style="width:310px">
                    <xsl:attribute name="class">txtText_u</xsl:attribute>
                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                  </input>)
                  <button onclick="parent.fnAddDiv(this);" onfocus="this.blur()" class="btn_bg">
                    <xsl:if test="phxsl:isGt(string(PARTCNT), 1)">
                      <xsl:attribute name="style">display:none</xsl:attribute>
                    </xsl:if>
                    <img alt="ADD" class="blt01" style="margin:-2px 0 2px -2px">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                    </img>
                  </button>
                  <button onclick="parent.fnDelDiv(this);" onfocus="this.blur()" class="btn_bg" style="display:none">
                    <img alt="DEL" class="blt01" style="margin:-2px 0 2px -2px">
                      <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                    </img>
                  </button>
                  <input type="hidden" id="__subtable1" name="PARTOID1"></input>
                </div>
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
      <xsl:attribute name="value"><xsl:value-of select="//current/name" /></xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATOR" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>  
<input type="hidden" id="__mainfield" name="CREATORID">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:attribute name="value"><xsl:value-of select="//current[@uid]" /></xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORID" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>
<input type="hidden" id="__mainfield" name="CREATORDEPT">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:attribute name="value"><xsl:value-of select="//current/depart" /></xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORDEPT" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>  
<input type="hidden" id="__mainfield" name="CREATORDEPTID">
  <xsl:choose>
    <xsl:when test="$mode='new' or $mode='edit'">
      <xsl:attribute name="value"><xsl:value-of select="//current[@deptid]" /></xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
      <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/CREATORDEPTID" /></xsl:attribute>
    </xsl:otherwise>
  </xsl:choose>
</input>
<input type="hidden" id="__mainfield" name="ORG_ID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/ORG_ID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="BUYER_ID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/BUYER_ID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="BUYER_SITEID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/BUYER_SITEID" /></xsl:attribute>
</input>
  <input type="hidden" id="__mainfield" name="MAKE_SUPPLIER_ID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/MAKE_SUPPLIER_ID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="MAKE_SUPPLIER_SITEID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/MAKE_SUPPLIER_SITEID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="OWNER_ID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/OWNER_ID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="OWNER_SITEID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/OWNER_SITEID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="STORE_PLACE_ID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/STORE_PLACE_ID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="STORE_PLACE_SITEID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/STORE_PLACE_SITEID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="TEST_PLACE_ID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/TEST_PLACE_ID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="TEST_PLACE_SITEID">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/TEST_PLACE_SITEID" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="EXCHANGE_USD">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/EXCHANGE_USD" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="DEPT_CODE">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/DEPT_CODE" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="STATUS_VALUE">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/STATUS_VALUE" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="DOC_NUMBER">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/DOC_NUMBER" /></xsl:attribute>
</input>
<input type="hidden" id="__mainfield" name="PrevWork">
  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/PrevWork" /></xsl:attribute>
</input>  
  
<!-- LINK Table Hidden Field : DB에 저장되는 값은 아님 -->
<input type="hidden" id="__subtable1" name="MODELNM"></input>
<input type="hidden" id="__subtable1" name="MODELOID"></input>

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

