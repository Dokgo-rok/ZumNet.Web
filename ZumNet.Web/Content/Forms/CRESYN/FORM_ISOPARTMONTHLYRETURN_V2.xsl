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
			/* 화면 넓이, 에디터 높이, 양식명크기 (tip:_height:500px; IE에만 적용됨) */
			.m {width:700px} .m .fm-editor {min-height:500px;_height:500px;border:windowtext 1pt solid}
			.fh h1 {font-size:20.0pt;letter-spacing:1pt;}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:6%} .m .ft .f-lbl2 {width:?}
			.m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
			.m .ft-sub {border-top-width:0px}

			.fm ul, .fm li {margin:0;text-align:left;list-style:none;font-size:13px;font-family:맑은 고딕}
			.fm ul {margin-left:20px;line-height:20px;letter-spacing:1px}

			.m .ft-sub-sub .subsub_table_row .f-lbl-sub { border-top: 0; border-left: 0}

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:400px}}
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
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:35px;font-size:19pt" class="txtMonth" data-inputmask="month" maxlength="2" value="{phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))}" />
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:19pt" class="txtMonth" data-inputmask="month" maxlength="2" value="{//forminfo/maintable/STATSMONTH}" />
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                      </xsl:otherwise>
                    </xsl:choose>월
                    ISO 파트 월보
                    <!--<xsl:value-of select="//docinfo/docname" />-->
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
                <td style="width:325px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:325px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
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
                <td style="width:35%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일</td>
                <td  style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/publishdate), '')" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">작성부서</td>
                <td>
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl">작성자</td>
                <td style="border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;">법인</td>
                <td style="border-bottom:0;border-right:0" colspan="3">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CORPORATION" style="width:80px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CORPORATION}" />
                      <!--<button onclick="parent.fnOption('external.chartcentercode',200,140,100,120,'','CORPORATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="생산지" onclick="_zw.formEx.optionWnd('external.chartcentercode',240,274,-130,0,'','CORPORATION');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CORPORATION))" />
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
            <div>1. ISO 사무국 당월 업무 진행사항</div>
            <div>1. ISO事务局当月业务进行事项</div>
            <div>1. ISO Secretariat Month's work-in-progress</div>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PROGRESSION" style="height:50px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/PROGRESSION" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PROGRESSION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <div>1. 신입사원 절차서 교육현황</div>
            <div>1. 新员工程序书教育现况</div>
            <div>1. new recruit procedure education status</div>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">
                  교육일자<br></br>教育日子<br></br>education date
                </td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDATEA" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/FROMDATEA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMDATEA))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;&nbsp;~&nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TODATEA" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/TODATEA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TODATEA))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  시간<br></br>时间<br></br>time
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TIMEA" class="txtText" maxlength="50" value="{//forminfo/maintable/TIMEA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TIMEA))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  교육대상자수<br></br>教育对象者数<br></br>Number of training participants
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EDUCATIONNUMBERA" class="txtText" maxlength="50" value="{//forminfo/maintable/EDUCATIONNUMBERA}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EDUCATIONNUMBERA))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;">
                  교육요약내용<br></br>教育要略内容<br></br>Training<br></br>summary
                </td>
                <td style="border-right:0;border-bottom:0" colspan="5">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="EDUCATIONCONTENTSA" style="height:60px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/EDUCATIONCONTENTSA" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EDUCATIONCONTENTSA))" />
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
			<div>2. 기존사원 절차서 교육현황</div>
            <div>2. 现有员工程序教育现况</div>
            <div>2. existing employee procedure education status</div>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">
                  교육일자<br></br>教育日子<br></br>education date
                </td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDATEB" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/FROMDATEB}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMDATEB))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;&nbsp;~&nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TODATEB" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/TODATEB}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TODATEB))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  시간<br></br>时间<br></br>time
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TIMEB" class="txtText" maxlength="50" value="{//forminfo/maintable/TIMEB}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TIMEB))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">
                  교육대상자수<br></br>教育对象者数<br></br>Number of training participants
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EDUCATIONNUMBERB" class="txtText" maxlength="50" value="{//forminfo/maintable/EDUCATIONNUMBERB}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EDUCATIONNUMBERB))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0;">
                  교육요약내용<br></br>教育要略内容<br></br>Training<br></br>summary
                </td>
                <td style="border-bottom:0;border-right:0" colspan="5">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="EDUCATIONCONTENTSB" style="height:60px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/EDUCATIONCONTENTSB" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div  class="txaRead" style="min-height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/EDUCATIONCONTENTSB))" />
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
					    <div>3. 업무절차서/지침서 제/개정 요청현황</div>
					    <div>3. 业务程序书/指南书制/改订请求现况</div>
                        <div>3. Work procedures / instruction enact/revised request status</div>
                    </td>
                    <td class="fm-button" style="vertical-align: bottom">
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_27.gif" />삭제
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
						<div>3. 업무절차서/지침서 제/개정 요청현황</div>
						<div>3. 业务程序书/指南书制/改订请求现况</div>
						<div>3. Work procedures / instruction enact/revised request status</div>
                    </td>
                    <td class="fm-button">
                      &nbsp;
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
                  <table id="__subtable1" class="ft-sub" header="0"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:4%"></col>
                      <col style="width:96%"></col>
                    </colgroup>
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
			  <div>4. 내부/외부감사(고객감사포함)실시현황 및 주요문제점(실시된 월에만 작성)</div>
			  <div>4. 内部/外部审计（包括客户审计）实施现况及主要问题点（只被实施的月编制)</div>
			  <div>4. Internal / external audit (including Customer Appreciation) conduct carried out only in month</div>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="MAINPROBLEM" style="height:50px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/MAINPROBLEM" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAINPROBLEM))" />
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
            <div>5. 기타 ISO 인증관련 특기사항</div>
            <div>5. 关联认证特异事项</div>
            <div>5. Remarks related to other ISO certification</div>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SPECIALTY" style="height:50px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/SPECIALTY" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:50px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SPECIALTY))" />
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
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

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
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0;padding:0;height:220px" colspan="2">
        <table class="ft-sub-sub" header="0" border="0" cellpadding="0" cellspacing="0">
          <xsl:if test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
          </xsl:if>
          <colgroup>
            <col style="width:25%"></col>
            <col style="width:%"></col>
          </colgroup>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="height:50px">
              문서명<br></br>文件名<br></br>document name
            </td>
            <td style="border-right:0; border-top: 0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="DOCUMENTNAME" class="txtText" style="height:50px" maxlength="50" value="{DOCUMENTNAME}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOCUMENTNAME))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="padding-top:10px">제/개정 내용 요약<br></br>制/改订内容要略<br></br>Summary / amendments
            </td>
            <td style="border-right:0;height:60px">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <textarea name="CONTENTSUMMARY" style="height:50px;" class="txaText bootstrap-maxlength" maxlength="2000">
                    <xsl:value-of select="(string(CONTENTSUMMARY))" />                    
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div class="txaRead" style="min-height:50px">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CONTENTSUMMARY))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="padding-top:10px">
              제/개정 사유<br></br>制/改订事由<br></br>Reason for revision/enact
            </td>
            <td style="border-right:0;height:60px">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <textarea name="REASON" style="height:50px" class="txaText bootstrap-maxlength" maxlength="2000">
                    <xsl:value-of select="(string(REASON))" />
                  </textarea>
                </xsl:when>
                <xsl:otherwise>
                  <div class="txaRead" style="min-height:50px">
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(REASON))" />
                  </div>
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
          <tr class="subsub_table_row">
            <td class="f-lbl-sub" style="border-bottom:0;text-align:center;height:50px">비고<br></br>备注<br></br>remarks
            </td>
            <td style="border-right:0;border-bottom:0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" name="ETC" class="txtText" style="height:50px" maxlength="300" value="{ETC}" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ETC))" />
                </xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </table>
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
