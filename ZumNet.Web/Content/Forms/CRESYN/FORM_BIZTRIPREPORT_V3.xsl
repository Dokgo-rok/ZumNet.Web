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
          .m {width:1000px} .m .fm-editor {height:360px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:10pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:10%} .m .ft .f-lbl1 {width:4%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:100%} .m .ft .f-option1 {width:38%} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option1 {width:48%} .m .ft-sub .f-option2 {width:48%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:340px}}
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
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '4', '합의부서', 'N')"/>
                </td>
                <td style="width:75px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:95px">
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
                <td class="f-lbl">문서번호</td>
                <td style="width:40%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/docnumber))" />
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
            <span>1. 출장정보</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl" style="">출장지</td>
                <td style="width: 40%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOCATION">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LOCATION" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOCATION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="">동행자</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="COMPANION">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/COMPANION" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPANION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">출장필요성</td>
                <td style="border-right:0" colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PURPOSE">
                        <xsl:attribute name="class">txtText</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PURPOSE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PURPOSE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">출장일</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDAY" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 120px" value="{//forminfo/maintable/FROMDAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;~&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TODAY" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 120px" value="{//forminfo/maintable/TODAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TODAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">출장기간</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STAY" class="txtVolume" maxlength="3" data-inputmask="number;3;0" style="width: 50px" value="{//forminfo/maintable/STAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STAY))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;박&nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DAY" class="txtVolume" maxlength="3" data-inputmask="number;3;0" style="width: 50px" value="{//forminfo/maintable/DAY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DAY))" />
                    </xsl:otherwise>
                  </xsl:choose>&nbsp;일
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
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>2. 출장결과</span>
                    </td>
					  <td class="fm-button">
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable1');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable1');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>2. 출장결과</span>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
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
                      <col style="width:3%"></col>
                      <col style="width:16%"></col>
                      <col style="width:33%"></col>
                      <col style="width:8%"></col>
                      <col style="width:13%"></col>
                      <col style="width:9%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" >NO</td>
                      <td class="f-lbl-sub" style="border-top:0;" >현안</td>
                      <td class="f-lbl-sub" style="border-top:0;" >처리내용(상세하게 기술)</td>
                      <td class="f-lbl-sub" style="border-top:0;" >완료여부</td>
                      <td class="f-lbl-sub" style="border-top:0;" >결과물</td>
                      <td class="f-lbl-sub" style="border-top:0;" >진행일정</td>
                      <td class="f-lbl-sub" style="border-top:0;" >진행부서</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" >담당자</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>3. 미완료사항</span>
                    </td>
					  <td class="fm-button">
                      <!--<button onclick="parent.fnAddChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable3');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable3');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>3. 미완료사항</span>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable3" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
						<col style="width:3%"></col>
						<col style="width:16%"></col>
						<col style="width:20%"></col>
						<col style="width:23%"></col>
						<col style="width:8%"></col>
						<col style="width:10%"></col>
						<col style="width:8%"></col>
						<col style="width:12%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" >NO</td>
                      <td class="f-lbl-sub" style="border-top:0;" >현안</td>
                      <td class="f-lbl-sub" style="border-top:0;" >미완료원인</td>
                      <td class="f-lbl-sub" style="border-top:0;" >대책</td>
                      <td class="f-lbl-sub" style="border-top:0;" >완료예정일</td>
                      <td class="f-lbl-sub" style="border-top:0;" >조치부서</td>
                      <td class="f-lbl-sub" style="border-top:0;" >담당자</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" >비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
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
            <span>4. 지원요청사항</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">해당법인</td>
                <td style="width:24%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REQFAC" class="txtText" value="{//forminfo/maintable/REQFAC}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REQFAC))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">해당부서</td>
				  <td style="width:24%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REQDEPT" class="txtText" value="{//forminfo/maintable/REQDEPT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REQDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">담당자</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REQMAN" class="txtText" value="{//forminfo/maintable/REQMAN}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REQMAN))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">요청사유</td>
                <td style="border-bottom:0;border-right:0" colspan="5">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQREASON" style="height:70px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REQREASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQREASON))" />
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>5. 규정외 예산 지출내역</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:60px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
							<i class="fas fa-angle-down"></i>
						</button>
                      <!--<button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_26.gif</xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_27.gif</xsl:attribute>
                        </img>삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable2');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="삭제" onclick="_zw.form.removeRow('__subtable2');">
							<i class="fas fa-minus"></i>
						</button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>5. 규정외 예산 지출내역</span>
                    </td>
                    <td class="fm-button">
                      통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;
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
                  <table id="__subtable2" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
						<col style="width:3%"></col>
						<col style="width:12%"></col>
						<col style="width:15%"></col>
						<col style="width:25%"></col>
						<col style="width:15%"></col>
						<col style="width:15%"></col>
						<col style="width:15%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="width:20px;border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">지출일</td>
                      <td class="f-lbl-sub" style="border-top:0">지출장소</td>
                      <td class="f-lbl-sub" style="border-top:0">내역</td>
                      <td class="f-lbl-sub" style="border-top:0">구분</td>
                      <td class="f-lbl-sub" style="border-top:0">지출비용</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="5">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM">
                              <xsl:attribute name="class">txtRead</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="style">text-align:right</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALSUM" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALSUM))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
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
            <span>6. 특기사항 (출장연기 사유/기타사항)</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DETAIL" style="height:70px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DETAIL" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:60px">s
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DETAIL))" />
                      </div>
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
  
  <xsl:template match="//forminfo/subtables/subtable1/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
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
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="MAINISSUE" style="height: 95%" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="MAINISSUE" />
              </xsl:if>
            </textarea>
              </xsl:when>
              <xsl:otherwise>
                <div class="txaRead">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MAINISSUE))" />
                </div>
              </xsl:otherwise>
            </xsl:choose>        
     </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="DETAILSOLVE"  style="height: 95%" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="DETAILSOLVE" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DETAILSOLVE))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <span class="f-option" style="padding-left: 4px">
          <input type="checkbox" name="ckbMETHOD1" id="ckb.{ROWSEQ}.11" value="완료">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD1', this, 'METHOD1')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD1),'완료')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD1),'완료')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.11" style="margin-left: 4px">완료</label>
        </span>
		  <span class="f-option" style="padding-left: 4px">
          <input type="checkbox" name="ckbMETHOD1" id="ckb.{ROWSEQ}.12" value="미완료">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbMETHOD1', this, 'METHOD1')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD1),'미완료')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD1),'미완료')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.12" style="margin-left: 4px">미완료</label>
        </span>
        <input type="hidden" name="METHOD1" value="{METHOD1}" />
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="RESULT" style="height: 95%" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="RESULT" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(RESULT))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FROMDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{FROMDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FROMDATE))" />
          </xsl:otherwise>
        </xsl:choose>
		  <div>~</div>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TODATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{TODATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TODATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DODEPT" class="txtText" value="{DODEPT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DODEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center" style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DOMAN" class="txtText" value="{DOMAN}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DOMAN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{USEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(USEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USEPLACE" class="txtText" value="{USEPLACE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USEPLACE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USEDETAIL" class="txtText" value="{USEDETAIL}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USEDETAIL))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USETYPE" class="txtText" value="{USETYPE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USETYPE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="EXPENSE" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{EXPENSE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EXPENSE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USEETC" class="txtText" value="{USEETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USEETC))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable3/row">
    <tr class="sub_table_row">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ">
              <xsl:attribute name="value">
                <xsl:value-of select="ROWSEQ" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="MAINISSUE2" style="height:45px" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="MAINISSUE2" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="min-height: 45px">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MAINISSUE2))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="UNSOLVEREASON" style="height:45px" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="UNSOLVEREASON" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
			  <div class="txaRead" style="min-height: 45px">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(UNSOLVEREASON))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>     
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="THISWAY" style="height:45px" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="THISWAY" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
			  <div class="txaRead" style="min-height: 45px">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(THISWAY))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SOLVEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{SOLVEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SOLVEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SOLVEDEPT" class="txtText" value="{DODEPT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SOLVEDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SOLVEMAN" class="txtText" value="{SOLVEMAN}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SOLVEMAN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SOLVEETC" class="txtText" value="{//forminfo/maintable/SOLVEETC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SOLVEETC))" />
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
