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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:19.0pt;letter-spacing:0}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:12%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:25%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

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
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '작성부서')"/>
                </td>
                <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='receive' and @partid!='' and @step!='0'], '__si_Receive', '3', '합의부서')"/>
                </td>               
                <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '승인')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
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
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0;">제목</td>
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//docinfo/subject" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
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
                <td class="f-lbl" style="border-bottom:0">양식 공개 여부</td>
                <td style="border-right:0;border-bottom:0" colspan="2">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb15" name="ckbSECRETOPEN" value="공개">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbSECRETOPEN', this, 'SECRETOPEN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/SECRETOPEN),'공개')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/SECRETOPEN),'공개')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb15">공개</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb16" name="ckbSECRETOPEN" value="비공개">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbSECRETOPEN', this, 'SECRETOPEN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/SECRETOPEN),'비공개')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/SECRETOPEN),'비공개')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb16">비공개</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="SECRETOPEN">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/SECRETOPEN"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <span>
              <font color="red" size="2.5">&nbsp;※ 비공개 양식은 계약서 대장에 노출되지 않습니다.</font>
            </span>
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
                <col style="width:30%"></col>
                <col style="width:70%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl" style="border-right:0" colspan="2">합의부서 및 합의요청사항</td>                
              </tr>
              <tr>
                <td class="f-lbl" style="">합의부서</td>
                <td class="f-lbl" style="border-right:0;">합의요청사항</td>
              </tr>
              <tr>
                <td style="text-align: center; border-bottom:0;">인사총무팀</td>
                <td style="border-bottom:0;border-right:0;">계약전반에 대한 검토</td>
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
                <td class="f-lbl" style="width: 15%;border-bottom: 0">전자계약</td>
                <td style="width: 65%; border-bottom: 0; border-right: 0">
                  <span class="f-option1">
                    <input type="checkbox" id="ckb11" name="ckbECONTYN" value="진행">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbECONTYN', this, 'ECONTYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/ECONTYN),'진행')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/ECONTYN),'진행')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">진행</label>
                  </span>
                  <span class="f-option1">
                    <input type="checkbox" id="ckb12" name="ckbECONTYN" value="미진행">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbECONTYN', this, 'ECONTYN')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/ECONTYN),'미진행')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/ECONTYN),'미진행')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">미진행</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="ECONTYN" value="{//forminfo/maintable/ECONTYN}" />
                </td>
                <td style="border-left: 0; border-right: 0; border-bottom: 0">
                  <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/ECONTYN),'진행') and $bizrole='receive' and $actrole='__r' and $partid!=''">
                    <!--<a href="javascript:" onclick="parent.searchExternal(1, 'api.eformio', '', '', 'ECONTFID^ECONTFNM')" style="text-decoration: none">계약서 선택</a>-->
				    <a onclick="_zw.formEx.optionWnd('api.eformio',550,200,250,-20,'','ECONTFID^ECONTFNM');" style="text-decoration: none" href="javascript:">계약서 선택</a>
                  </xsl:if>
                  <xsl:if test="//bizinfo/@docstatus='700' and phxsl:isEqual(string(//forminfo/maintable/ECONTYN),'진행')">
                    <xsl:choose>
                      <xsl:when  test="phxsl:isEqual(string(//forminfo/maintable/ECONTSENDYN), 'Y')">
                        계약서 발송됨
                      </xsl:when>
                      <xsl:when  test="//processinfo/signline/lines/line[@actrole='_redrafter' or //processinfo/signline/lines/line/@actrole='_reviewer']/@partid = //currentinfo/@uid">
                        <a href="javascript:" onclick="parent.sendExternalAPI('api.eformio', 'sendform')" style="text-decoration: none">계약서 발송</a>
                      </xsl:when>
                      <xsl:otherwise></xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                  <input type="hidden" id="__mainfield" name="ECONTSENDYN" value="{//forminfo/maintable/ECONTSENDYN}" />
                </td>
              </tr>
            </table>
          </div>
          <div class="fm" id="_layer_econtract">
            <xsl:if test="$mode='new' or phxsl:isDiff(string(//forminfo/maintable/ECONTYN),'진행')">
              <xsl:attribute name="style">display: none</xsl:attribute>
            </xsl:if>

			<div class="ff" />
			  
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <xsl:attribute name="style">table-layout:fixed; border-top: 0</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:attribute name="style">border-top: 0</xsl:attribute>
                </xsl:otherwise>
              </xsl:choose>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:15%"></col>
                <col style="width:25%"></col>
                <col style="width:15%"></col>
                <col style="width:30%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">계약서명</td>
                <td colspan="4" style="border-right: 0">
                  <input type="hidden" id="__mainfield" name="ECONTFID" value="{//forminfo/maintable/ECONTFID}" />
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTFNM" class="txtRead" readonly="readonly" value="{//forminfo/maintable/ECONTFNM}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTFNM))" />
                      <input type="hidden" id="__mainfield" name="ECONTFNM" value="{//forminfo/maintable/ECONTFNM}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">발송 제목</td>
                <td colspan="4" style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTMAILSUB" class="txtText" maxlength="100" value="{//forminfo/maintable/ECONTMAILSUB}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTMAILSUB))" />
                      <input type="hidden" id="__mainfield" name="ECONTMAILSUB" value="{//forminfo/maintable/ECONTMAILSUB}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">발송 설명글</td>
                <td colspan="4" style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTMAILBODY" class="txtText" maxlength="100" value="{//forminfo/maintable/ECONTMAILBODY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTMAILBODY))" />
                      <input type="hidden" id="__mainfield" name="ECONTMAILBODY" value="{//forminfo/maintable/ECONTMAILBODY}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom: 0">기타</td>
                <td class="f-lbl2" style="border-bottom: 0">만료일</td>
                <td style="border-bottom: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTEXPIRED" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/ECONTEXPIRED}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTEXPIRED))" />
                      <input type="hidden" id="__mainfield" name="ECONTEXPIRED" value="{//forminfo/maintable/ECONTEXPIRED}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="border-bottom: 0">비밀번호</td>
                <td colspan="" style="border-bottom: 0;border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTPWD" class="txtNumberic" maxlength="10" data-inputmask="number-n;10;0" value="{//forminfo/maintable/ECONTPWD}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTPWD))" />
                      <input type="hidden" id="__mainfield" name="ECONTPWD" value="{//forminfo/maintable/ECONTPWD}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
            
            <!--<div style="height: 2px; font-size: 1px">&nbsp;</div>-->
			  <div class="ff"></div>
            
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="width:15%">수신자</td>
                <td class="f-lbl" style="width:10%">구분</td>
                <td class="f-lbl2" style="width:25%">성명</td>
                <td class="f-lbl2" style="width:25%">메일</td>
                <td class="f-lbl2" style="width:25%; border-right: 0">전화</td>
              </tr>
              <tr>
                <td class="f-lbl">
                  <xsl:choose>
                    <xsl:when  test="//bizinfo/@docstatus='700' and phxsl:isEqual(string(//forminfo/maintable/ECONTYN),'진행')">
                      <xsl:choose>
                        <xsl:when  test="phxsl:isEqual(string(//forminfo/maintable/ECONTSENDYN), 'Y') and phxsl:isDiff(string(//forminfo/maintable/ECONTSENDYN), '')">
                          <a href="javascript:" onclick="if (parent.sendExternalAPI) parent.sendExternalAPI('api.eformio', 'dochistory', this)" title="계약서 작성 내역 조회" style="text-decoration: none">수신자1 (을)</a>
                        </xsl:when>
                        <xsl:otherwise>
                          공급자
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      공급자
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="ECONTRCVIDA" value="{//forminfo/maintable/ECONTRCVIDA}" />
                </td>
                <td style="text-align:center">                  
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbGENDER" value="남" style="position: relative">
                      <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='') ">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'남')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'남')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>                        
                  </span>                    
                  <input type="hidden" id="__mainfield" name="GENDER">
                    <xsl:attribute name="value">
                      <xsl:value-of select="//forminfo/maintable/GENDER"></xsl:value-of>
                    </xsl:attribute>
                  </input>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTRCVNMA" class="txtText" maxlength="50" value="{//forminfo/maintable/ECONTRCVNMA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTRCVNMA))" />
                      <input type="hidden" id="__mainfield" name="ECONTRCVNMA" value="{//forminfo/maintable/ECONTRCVNMA}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTRCVMAILA" class="txtText" maxlength="50" value="{//forminfo/maintable/ECONTRCVMAILA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTRCVMAILA))" />
                      <input type="hidden" id="__mainfield" name="ECONTRCVMAILA" value="{//forminfo/maintable/ECONTRCVMAILA}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTRCVTELA" class="txtText" maxlength="50" value="{//forminfo/maintable/ECONTRCVTELA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTRCVTELA))" />
                      <input type="hidden" id="__mainfield" name="ECONTRCVTELA" value="{//forminfo/maintable/ECONTRCVTELA}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom: 0">
                  <xsl:choose>
                    <xsl:when  test="//bizinfo/@docstatus='700' and phxsl:isEqual(string(//forminfo/maintable/ECONTYN),'진행')">
                      <xsl:choose>
                        <xsl:when  test="phxsl:isEqual(string(//forminfo/maintable/ECONTSENDYN), 'Y') and phxsl:isDiff(string(//forminfo/maintable/ECONTSENDYN), '')">
                          <a href="javascript:" onclick="if (parent.sendExternalAPI) parent.sendExternalAPI('api.eformio', 'dochistory', this)" title="계약서 작성 내역 조회" style="text-decoration: none">수신자2 (갑)</a>
                        </xsl:when>
                        <xsl:otherwise>
                          구매자
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      구매자
                    </xsl:otherwise>
                  </xsl:choose>
                  <input type="hidden" id="__mainfield" name="ECONTRCVIDB" value="{//forminfo/maintable/ECONTRCVIDB}" />
                </td>
                <td style="border-bottom: 0;text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbGENDER" value="여" style="position: relative">
                      <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='') ">
                        <xsl:attribute name="onclick">_zw.form.checkYN('ckbGENDER', this, 'GENDER')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/GENDER),'여')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/GENDER),'여')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="border-bottom: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTRCVNMB" class="txtText" maxlength="50" value="{//forminfo/maintable/ECONTRCVNMB}" />
                      <!--<input type="text" id="__mainfield" name="ECONTRCVNMB" class="txtRead" readonly="readonly" value="크레신" />-->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTRCVNMB))" />
                      <input type="hidden" id="__mainfield" name="ECONTRCVNMB" value="{//forminfo/maintable/ECONTRCVNMB}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTRCVMAILB" class="txtText" maxlength="50" value="{//forminfo/maintable/ECONTRCVMAILB}" />
                      <!--<input type="text" id="__mainfield" name="ECONTRCVMAILB" class="txtRead" readonly="readonly" value="contract@cresyn.com" />-->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTRCVMAILB))" />
                      <input type="hidden" id="__mainfield" name="ECONTRCVMAILB" value="{//forminfo/maintable/ECONTRCVMAILB}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-bottom: 0;border-right: 0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or ($bizrole='receive' and $actrole='__r' and $partid!='')">
                      <input type="text" id="__mainfield" name="ECONTRCVTELB" class="txtText" maxlength="50" value="{//forminfo/maintable/ECONTRCVTELB}" />
                      <!--<input type="text" id="__mainfield" name="ECONTRCVTELB" class="txtRead" readonly="readonly" value="02-2041-2700" />-->
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ECONTRCVTELB))" />
                      <input type="hidden" id="__mainfield" name="ECONTRCVTELB" value="{//forminfo/maintable/ECONTRCVTELB}" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>

            <div style="display: none">
              <span style="color: red">&nbsp;※ 크레신 기입 정보 : 성명 "크레신", 메일 "contract@cresyn.com"</span>
            </div>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>&nbsp;1. 일반정보</span>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="height:50px">목적</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="OBJECT" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/OBJECT" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/OBJECT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
                <tr>
                <td class="f-lbl">계약목적물</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CONTRACTOB">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CONTRACTOB" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTRACTOB))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                </tr>
              <tr>
                <td class="f-lbl" style="height:50px;border-bottom:0">주요내용</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="MAINCON" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/MAINCON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:100px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAINCON))" />
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

          <div class="fm">
            <span>&nbsp;2. 업체 정보</span>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width: 15%" />
                <col style="width: 15%" />
                <col style="width: 70%" />
              </colgroup>
              <tr>
                <td class="f-lbl">업체명</td>
                <td colspan="2" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMERNA" class="txtText" maxlength="100" value="{//forminfo/maintable/CUSTOMERNA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMERNA))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">직전 회계연도</td>
                <td class="f-lbl">매출</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ACCSALES" class="txtText" maxlength="100" value="{//forminfo/maintable/ACCSALES}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCSALES))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">손익</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ACCLOSS" class="txtText" maxlength="100" value="{//forminfo/maintable/ACCLOSS}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ACCLOSS))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>             
              <tr>
                <td class="f-lbl" style="border-bottom:0" >여신 한도</td>
                <td colspan="2" style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CREDITLINE" class="txtText" maxlength="100" value="{//forminfo/maintable/CREDITLINE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CREDITLINE))" />
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
          <div class="ff" />

          <div class="fm">
            <span>&nbsp;3. 계약 기간</span>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">계약 시작일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text"  id="__mainfield" name="STDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 120px" value="{//forminfo/maintable/STDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STDATE))" />                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">계약 만료일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FIDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 120px" value="{//forminfo/maintable/FIDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FIDATE))" />                    
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px;border-bottom:0">자동 연장 조건</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="MAINCON1" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/MAINCON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAINCON1))" />
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
          <div class="ff" />

          <div class="fm">
            <span>&nbsp;4. 계약 금액</span>
          </div>

          <div class="ff" />
          <div class="ff" />


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">계약금</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DEPOSIT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/DEPOSIT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEPOSIT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">중도금</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MIDPAYMENT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MIDPAYMENT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MIDPAYMENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">잔금</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BALANCE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/BALANCE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BALANCE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px">청구 방법 및<br />조건</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEMAND" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DEMAND" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEMAND))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:50px" >지급 방법 및<br />조건</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PAY" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PAY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PAY))" />
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


          <div class="fm">
            <span>&nbsp;5. 인도</span>
          </div>

          <div class="ff" />
          <div class="ff" />


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">납기</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORPAYMENT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FORPAYMENT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORPAYMENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px">인도 장소 및<br />방법</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEPLACE" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DEPLACE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEPLACE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0" >검수 일정</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TESTSCHEDULE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TESTSCHEDULE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TESTSCHEDULE))" />
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
            <span>&nbsp;6. 계약 위반</span>
          </div>

          <div class="ff" />
          <div class="ff" />


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="height:50px">해제 및<br />해지 요건</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CLOSE1" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CLOSE1" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CLOSE1))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px">손해 배상 방법</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="LOSSIND" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/LOSSIND" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOSSIND))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:50px">손해 배상액 산정</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="LOSSMONEY" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/LOSSMONEY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOSSMONEY))" />
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
          
          <div class="fm">          
            <span>7. 재산권</span>
          </div>
          <div class="ff" />
          <div class="ff" />
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>             
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:50px">소유권 및<br />재산권</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PROPERTY" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PROPERTY" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PROPERTY))" />
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

          <div class="fm">
            <span>8. 보증</span>
          </div>
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">보증기간 및 A/S</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ASDATE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ASDATE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ASDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:50px">보증방법</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="GUARANTEE" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/GUARANTEE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/GUARANTEE))" />
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

          <div class="fm">
            <span>9. 기타</span>
          </div>
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">합의 관할</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="AGREEMENT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/AGREEMENT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/AGREEMENT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;height:50px">특이 사항</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SPECIAL" style="height:40px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SPECIAL" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECIAL))" />
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

          <div class="fm">
            <span>10. 체크리스트</span>
          </div>
          <div class="ff" />
          <div class="ff" />       

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $mode='print'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:62%"></col>
                <col style="width:10%"></col>
                <col style="width:13%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">
                  <b>구분</b></td>
                <td class="f-lbl2">
                  <b>체크리스트<font color="red">(붉은색은 중요 항목)</font>                  
                </b>
                </td>
                <td class="f-lbl1">
                  <b>여/부</b>
                </td>
                <td class="f-lbl" style="border-right:0">
                  <b>조항</b>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="3">총칙</td>
                <td class="f-lbl2" style="text-align:left">
                  <font color="red" >
                    "갑""을"관계 및 주소의 정확한 기재
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>               
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="text-align:left">
                  상호 신의성실 의무 기재
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X2" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X2),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X2),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X2),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X2),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X2))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X2))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE2">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE2" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE2))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="text-align:left">
                  계약 관련 용어에 대한 정리
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X3" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X3),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X3),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X3),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X3),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X3))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X3))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE3">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE3" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE3))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="4">목적</td>
                <td class="f-lbl2" style="text-align:left">
                  <font color="red" >
                  계약의 목적물 기재
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X4" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X4),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X4),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X4),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>                            
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>                        
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X4),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X4))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X4))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE4">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE4" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE4))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <tr>
                <td class="f-lbl" style="text-align:left">
                계약 당사자의 권리 의무 기재
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X5" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X5),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X5),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X5),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X5),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X5))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X5))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                   
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE5">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE5" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE5))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                </tr>
              <td class="f-lbl" style="text-align:left">
               계약 위반시 제재 수단(담보,위약금,위약벌,지체상금 등)
              </td>
              <td style="">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <select id="__mainfield"  name="CHECK0X6" class="form-control">
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X6),'')">
                          <option value="" selected="selected">선택</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="">선택</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X6),'○')">
                          <option value="○" selected="selected">○</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="○">○</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X6),'Χ')">
                          <option value="Χ" selected="selected">Χ</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="Χ">Χ</option>
                        </xsl:otherwise>
                      </xsl:choose>
                    </select>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X6),'Χ')">
                        <font color="red">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X6))" />
                        </font>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X6))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>                 
              </td>
              <td style="border-right:0">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="ARTICLE6">
                      <xsl:attribute name="class">txtText</xsl:attribute>
                      <xsl:attribute name="maxlength">100</xsl:attribute>
                      <xsl:attribute name="value">
                        <xsl:value-of select="//forminfo/maintable/ARTICLE6" />
                      </xsl:attribute>
                    </input>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/ARTICLE6),'Χ')">
                        <font color="red">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ARTICLE6))" />
                        </font>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ARTICLE6))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>                   
              </td>
              </tr> 
              <tr>
              <td class="f-lbl" style="text-align:left">
               계약 위반에 대한 의미는 명확한지
               </td>
              <td style="">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <select id="__mainfield"  name="CHECK0X7" class="form-control">
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X7),'')">
                          <option value="" selected="selected">선택</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="">선택</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X7),'○')">
                          <option value="○" selected="selected">○</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="○">○</option>
                        </xsl:otherwise>
                      </xsl:choose>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X7),'Χ')">
                          <option value="Χ" selected="selected">Χ</option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="Χ">Χ</option>
                        </xsl:otherwise>
                      </xsl:choose>
                    </select>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                    <xsl:choose>
                      <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X7),'Χ')">
                        <font color="red">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X7))" />
                        </font>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X7))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>                    
              </td>
              <td style="border-right:0">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="ARTICLE7">
                      <xsl:attribute name="class">txtText</xsl:attribute>
                      <xsl:attribute name="maxlength">100</xsl:attribute>
                      <xsl:attribute name="value">
                        <xsl:value-of select="//forminfo/maintable/ARTICLE7" />
                      </xsl:attribute>
                    </input>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE7))" />
                  </xsl:otherwise>
                </xsl:choose>
              </td>
              </tr>

              <tr>
                <td class="f-lbl" rowspan="4">일반사항</td>
                <td class="f-lbl" style="text-align:left">
                  <font color="red" >
                   계약 금액 명시
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X8" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X8),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X8),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X8),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X8),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X8))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X8))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                    
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE8">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE8" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE8))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <tr>
                  <td class="f-lbl" style="text-align:left">
                    <font color="red">
                   결제 조건, 지급 방법, 결제일 등</font>
                  </td>
                  <td style="">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="CHECK0X9" class="form-control">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X9),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X9),'○')">
                              <option value="○" selected="selected">○</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="○">○</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X9),'Χ')">
                              <option value="Χ" selected="selected">Χ</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="Χ">Χ</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X9),'Χ')">
                            <font color="red">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X9))" />
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X9))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>                       
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="ARTICLE9">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">100</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/ARTICLE9" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE9))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <td class="f-lbl" style="text-align:left">
                  <font color="red">
                 계약 기간 기재
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X10" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X10),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X10),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X10),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X10),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X10))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X10))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE10">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE10" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>                      
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE10))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="text-align:left">
                 계약의 자동 갱신 규정
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X11" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X11),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X11),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X11),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X11),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X11))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X11))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                    
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE11">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE11" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE11))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="4">의무</td>
                <td class="f-lbl" style="text-align:left">
                  <font color="red" >
                    계약 이행 완료 기준, 인도장소, 인도 방법
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X12" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X12),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X12),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X12),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X12),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X12))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X12))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                     
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE12">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE12" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE12))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <tr>
                  <td class="f-lbl" style="text-align:left">
                    당사자 간 권리 의무 양도 금지 조항(서면 합의 예외 규정 가능)
                  </td>
                  <td style="">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="CHECK0X13" class="form-control">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X13),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X13),'○')">
                              <option value="○" selected="selected">○</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="○">○</option>
                            </xsl:otherwise>
                          </xsl:choose>                         
                            <xsl:choose>
                              <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X13),'Χ')">
                                <option value="Χ" selected="selected">Χ</option>
                              </xsl:when>                            
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>                        
                    </xsl:choose>                  
                    </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X13),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X13))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X13))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                      
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="ARTICLE13">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">100</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/ARTICLE13" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE13))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <td class="f-lbl" style="text-align:left">
                  <font color="red">내용 변경 보고 의무 등(불이행시 배상 규정)</font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X14" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X14),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X14),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X14),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X14),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X14))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X14))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                     
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE14">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE14" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE14))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="text-align:left">
                  보증 기간 및 방법에 대한 규정  </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X15" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X15),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X15),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X15),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X15),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X15))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X15))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                    
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE15">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE15" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE15))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

              <tr>
                <td class="f-lbl" rowspan="4">실효</td>
                <td class="f-lbl" style="text-align:left">
                  <font color="red" >
                    계약의 해제(소급적 계약 소멸_원상 회복) 조항
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X16" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X16),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X16),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X16),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X16),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X16))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X16))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                    
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE16">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE16" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE16))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <tr>
                  <td class="f-lbl" style="text-align:left">
                    <font color="red">
                      계약의 해지(장래적 계약 소멸_손해 배상) 조항
                    </font>
                  </td>
                  <td style="">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="CHECK0X17" class="form-control">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X17),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X17),'○')">
                              <option value="○" selected="selected">○</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="○">○</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X17),'Χ')">
                              <option value="Χ" selected="selected">Χ</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="Χ">Χ</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X17),'Χ')">
                            <font color="red">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X17))" />
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X17))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>                     
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="ARTICLE17">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">100</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/ARTICLE17" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE17))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <td class="f-lbl" style="text-align:left">
                  <font color="red">
                    손해 배상에 대한 내용에 대한 구체적 기재
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X18" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X18),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X18),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X18),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X18),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X18))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X18))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                    
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE18">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE18" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE18))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="text-align:left">
               손해 배상에 대한 손해액 산정 기준 명확한지
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X19" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X19),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X19),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X19),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X19),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X19))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X19))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                     
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE19">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE19" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE19))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2">재산권</td>
                <td class="f-lbl" style="text-align:left">
                  <font color="red" >
                    재산권 및 소유권 귀속에 대한 명시
                  </font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X20" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X20),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X20),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X20),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X20),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X20))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X20))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>  
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE20">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE20" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE20))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <tr>
                  <td class="f-lbl" style="text-align:left">
                    제3자의 재산권 침해 금지 규정
                  </td>
                  <td style="">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="CHECK0X21" class="form-control">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X21),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X21),'○')">
                              <option value="○" selected="selected">○</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="○">○</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X21),'Χ')">
                              <option value="Χ" selected="selected">Χ</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="Χ">Χ</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X21),'Χ')">
                            <font color="red">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X21))" />
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X21))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>                        
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="ARTICLE21">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">100</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/ARTICLE21" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE21))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
                <tr>
                  <td class="f-lbl" rowspan="2">분쟁</td>
                  <td class="f-lbl" style="text-align:left">
                    <font color="red">
                      계약서 외의 분쟁 발생의 경우 해결 기준
                    </font>
                  </td>
                  <td style="">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield"  name="CHECK0X22" class="form-control">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X22),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X22),'○')">
                              <option value="○" selected="selected">○</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="○">○</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X22),'Χ')">
                              <option value="Χ" selected="selected">Χ</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="Χ">Χ</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X22),'Χ')">
                            <font color="red">
                              <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X22))" />
                            </font>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X22))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:otherwise>
                    </xsl:choose>                       
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <input type="text" id="__mainfield" name="ARTICLE22">
                          <xsl:attribute name="class">txtText</xsl:attribute>
                          <xsl:attribute name="maxlength">100</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/ARTICLE22" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE22))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                </tr>
              </tr>
              <tr>
                <td class="f-lbl" style="text-align:left">
                  <font color="red">분쟁의 관할(서울 중앙지방법원)</font>
                </td>
                <td style="">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X23" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X23),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X23),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X23),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X23),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X23))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X23))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                      
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE23">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE23" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE23))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="2" style="border-bottom:0">특약</td>
                <td class="f-lbl" style="text-align:left;border-bottom:0">
                 특약의 존재 여부
                </td>              
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0X24" class="form-control">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X24),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X24),'○')">
                            <option value="○" selected="selected">○</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="○">○</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X24),'Χ')">
                            <option value="Χ" selected="selected">Χ</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Χ">Χ</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:choose>
                        <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0X24),'Χ')">
                          <font color="red">
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X24))" />
                          </font>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0X24))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>                     
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ARTICLE24">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/ARTICLE24" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ARTICLE24))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <xsl:if test="//linkeddocinfo/linkeddoc or //fileinfo/file[@isfile='Y']">
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
