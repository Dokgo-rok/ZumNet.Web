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
<title>ECN업무처리계획서</title>
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
      <h1>ECN업무처리계획서</h1>
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
        <td class="f-lbl">법인</td>
        <td style="width:35%">
          <input type="text" name="CORPORATION" class="txtRead" readonly="readonly" value="{//forminfo/maintable/CORPORATION}" />
        </td>
        <td class="f-lbl">작성일</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="CRDT" class="txtRead" readonly="readonly" value="{phxsl:cvtDate(string(//forminfo/maintable/CRDT), '', '',19,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/CRDT[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/CRDT), '', '',19,false)" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
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
                    <xsl:when test="//forminfo/maintable/Creator[.!='']">
                      <xsl:value-of select="//forminfo/maintable/CreatorDept" />.<xsl:value-of select="//forminfo/maintable/Creator" />
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
                <xsl:when test="//forminfo/maintable/Creator[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CreatorDept))" />.<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/Creator))" />
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl" style="border-bottom:0">최종수정일</td>
        <td style="border-bottom:0;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='edit'">
              <input type="text" id="__mainfield" name="MFDT" class="txtRead" readonly="readonly" value="{phxsl:cvtDate(string(//current/@date), '', '',19,false)}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:choose>
                <xsl:when test="//forminfo/maintable/MFDT[.!='']">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:cvtDate(string(//forminfo/maintable/MFDT), '', '',19,false)" />
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
    <span>1. (&#160;<xsl:value-of select="//forminfo/maintable/FMCLS" />&#160;) 변경&#160;&#160;&#160;
      <a target="_blank">
        <xsl:attribute name="href">
          <xsl:value-of disable-output-escaping="yes" select="phxsl:linkForm(string(//config/@web), string($root), string(//forminfo/maintable/MessageID))" />
        </xsl:attribute>
        관련문서
      </a>
    </span>
    <div class="ff" />
    
    <table class="ft" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="f-lbl">MODEL</td>
        <td style="width:35%">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="MODELNAME" class="txtRead" readonly="readonly" value="{//forminfo/maintable/MODELNAME}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">부품번호</td>
        <td style="width:35%;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="PARTNUM" class="txtRead" readonly="readonly" value="{//forminfo/maintable/PARTNUM}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTNUM))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl">CR번호</td>
        <td>
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="ECNNUM" class="txtRead" readonly="readonly" value="{//forminfo/maintable/ECNNUM}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECNNUM))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td class="f-lbl">도면번호번호</td>
        <td style="border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="DRAWNUM" class="txtRead" readonly="readonly" value="{//forminfo/maintable/DRAWNUM}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DRAWNUM))" />
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">주변경내용</td>
        <td colspan="3" style="border-bottom:0;border-right:0">
          <xsl:choose>
            <xsl:when test="$mode='new' or $mode='edit'">
              <input type="text" name="SUMMARY" class="txtRead" readonly="readonly" value="{//forminfo/maintable/SUMMARY}" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SUMMARY))" />
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
    <span>2. (&#160;<xsl:value-of select="//forminfo/maintable/CORPORATION" />&#160;) 업무처리계획</span>
    <div class="ff" />

    <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
      <colgroup>
        <col width="3%" />
        <col width="20%" />
        <col width="62%" />
        <col width="15%" />
      </colgroup>
      <tr>
        <td class="f-lbl-sub">&#160;</td>
        <td class="f-lbl-sub">부서</td>
        <td class="f-lbl-sub">업무계획</td>
        <td class="f-lbl-sub" style="border-right:0">작성/수정일자</td>
      </tr>
      <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
    </table>
  </div>

  <div class="ff" />
  <div class="ff" />
  <div class="ff" />
  <div class="ff" />

  <div class="fm">
    <span>3. 승인내역</span>
    <div class="ff" />
    
    <table class="ft" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td class="f-lbl">승인자</td>
        <td style="width:35%">
          <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/APVRDEPT" />.&#160;<xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/APVRNM" />
        </td>
        <td class="f-lbl">승인일자</td>
        <td style="width:35%;border-right:0">
          <span class="f-option" style="width:70px">
            <input type="checkbox" id="ckb.11" name="ckbSTATUS" disabled="disabled">
              <xsl:if test="//forminfo/maintable/APVRSTATUS='7'">
                <xsl:attribute name="checked">checked</xsl:attribute>
              </xsl:if>
            </input>
            <label for="ckb.11">승인</label>
          </span>
          <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/CODT), '')" />
        </td>
      </tr>
      <tr>
        <td class="f-lbl" style="border-bottom:0">의견</td>
        <td colspan="5" style="border-bottom:0;border-right:0">
          <xsl:choose>
            <xsl:when test="//forminfo/maintable/APVRID=//current/@uid and //forminfo/maintable/APVRSTATUS!='7'">
              <textarea name="NOTE" style="height:60px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000)">
                <xsl:value-of select="//forminfo/maintable/NOTE" />
              </textarea>
            </xsl:when>
            <xsl:otherwise>
              <div style="padding:2px;height:60px">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/NOTE))" />
              </div>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
    </table>
  </div>
</div>

  <!-- Main Table Hidden Field -->
  <input type="hidden" name="Creator" value="{//forminfo/maintable/Creator}" />
  <input type="hidden" name="CreatorID" value="{//forminfo/maintable/CreatorID}" />
  <input type="hidden" name="CreatorDept" value="{//forminfo/maintable/CreatorDept}" />
  <input type="hidden" name="CreatorDeptID" value="{//forminfo/maintable/CreatorDeptID}" />

  <input type="hidden" name="APVRID" value="{//forminfo/maintable/APVRID}" />
  <input type="hidden" name="APVRNM" value="{//forminfo/maintable/APVRNM}" />
  <input type="hidden" name="APVRDEPTID" value="{//forminfo/maintable/APVRDEPTID}" />
  <input type="hidden" name="APVRDEPT" value="{//forminfo/maintable/APVRDEPT}" />
  <input type="hidden" name="APVRSTATUS" value="{//forminfo/maintable/APVRSTATUS}" />

  <input type="hidden" id="WriteDate">
    <xsl:choose>
      <xsl:when test="string(//forminfo/maintable/WTDT)=''">
        <xsl:attribute name="value">N</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="value">Y</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </input>

  <xsl:if test="$displaylog='true'"><div><xsl:value-of select="phxsl:getLog()"/></div></xsl:if>
</body>
</html>
</xsl:template>

<xsl:template match="//forminfo/subtables/subtable1/row">
  <tr class="sub_table_row">
    <td>
      <xsl:choose>
        <!--<xsl:when test="PARTID=//current/@uid and PARTDEPTID=//current/@deptid">-->
        <xsl:when test="PARTID=//current/@uid">
          <input type="checkbox" name="SEQ" value="{SEQ}" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="class">tdRead_Center</xsl:attribute>
          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SEQ))" />
        </xsl:otherwise>
      </xsl:choose>

      <input type="hidden" name="PARTID" value="{PARTID}" />
      <input type="hidden" name="PARTNM" value="{PARTNM}" />
      <input type="hidden" name="PARTDEPTID" value="{PARTDEPTID}" />
      <input type="hidden" name="PARTDEPT" value="{PARTDEPT}" />
      <input type="hidden" name="STATUS" value="{STATUS}" />
      <input type="hidden" name="SubWriteDate">
        <xsl:choose>
          <xsl:when test="string(WTDT)=''">
            <xsl:attribute name="value">N</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="value">Y</xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </input>
    </td>
    <td class="tdRead_Center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTDEPT))" />
      <br />
      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PARTNM))" />
    </td>
    <td>
      <xsl:choose>
        <!--<xsl:when test="PARTID=//current/@uid  and PARTDEPTID=//current/@deptid and //forminfo/maintable/APVRSTATUS!='7'">-->
        <xsl:when test="PARTID=//current/@uid and //forminfo/maintable/APVRSTATUS!='7'">
          <textarea name="BIZPLAN" style="height:44px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 2000)">
            <xsl:value-of select="BIZPLAN" />
          </textarea>
        </xsl:when>
        <xsl:otherwise>
          <div style="padding:2px">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(BIZPLAN))" />
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center;border-right:0">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(WTDT), '')" />
      <xsl:if test="phxsl:isDiff(string(WTDT), string(MFDT))!=''">
        <br /><xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(MFDT), '')" />  
      </xsl:if>
    </td>
  </tr>
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
    </xsl:attribute>  
    <xsl:value-of select="filename" />
  </a>
</xsl:template>
</xsl:stylesheet> 

