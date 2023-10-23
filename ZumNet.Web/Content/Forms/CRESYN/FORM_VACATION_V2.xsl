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
          .fh h1 {font-size:20.0pt;letter-spacing:10pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
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
                    휴가신청서
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
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px">
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
                <td class="f-lbl" rowspan="2">
                  신청자
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <!--<button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">
                          /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                        </xsl:attribute>
                      </img>
                    </button>-->
				  <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="Contacts" onclick="_zw.fn.org('user','n');">
		              <i class="fas fa-angle-down"></i>
	              </button>
                  </xsl:if>
                </td>
                <td class="f-lbl1">소속</td>
                <td style="width:40%">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTCORP" style="width:100px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/belong" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTCORP" style="width:100px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTCORP" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTCORP))" />
                    </xsl:otherwise>
                  </xsl:choose>.
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT" style="width:165px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/department" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT" style="width:165px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTDEPT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">직위</td>
                <td style="width:25%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTGRADE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/grade" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTGRADE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTGRADE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTGRADE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">성명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/name" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANT">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANT" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">
					<!--<xsl:choose>
						<xsl:when test="$mode='new' or $mode='edit'">
							<a href="javascript:void(0)" class="z-lnk-navy" title="연차조회" onclick="_zw.formEx.optionWnd('report.REGISTER_LEAVE',400,70,20,90,'','')">사번</a>
						</xsl:when>
						<xsl:otherwise>사번</xsl:otherwise>
					</xsl:choose>-->
					<a href="javascript:void(0)" class="z-lnk-navy" title="연차조회" onclick="_zw.formEx.optionWnd('report.REGISTER_LEAVE',400,70,20,90,'','')">사번</a>
				</td>
                <td style="width:;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/empno" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTEMPNO" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="APPLICANTID">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//creatorinfo/@uid" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="APPLICANTID">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/APPLICANTID" />
                        </xsl:attribute>
                      </input>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">휴가사유</td>
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:80px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:80px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">휴가기간</td>
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FROMDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/FROMDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/FROMDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;&nbsp;~&nbsp;&nbsp;
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="TODATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 100px" value="{//forminfo/maintable/TODATE}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TODATE))" />
                  </xsl:otherwise>
                </xsl:choose>
                <!--&nbsp;&nbsp;&nbsp;(
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PERIOD" style="width:50px">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">5</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PERIOD" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PERIOD))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;일간)&nbsp;-->
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">비상연락처</td>
                <td colspan="4" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="URGENTPHONE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/URGENTPHONE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/URGENTPHONE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td class="fm-button">
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
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
                  <table id="__subtable1" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:100px"></col>
                      <col style="width:90px"></col>
                      <col style="width:60px"></col>
                      <col style="width:60px"></col>
                      <col style="width:365px"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="width:20px;border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">휴가구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">일자</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">시간</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">시작</td>
                      <td class="f-lbl-sub">종료</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                  </table>
                </td>
              </tr>
            </table>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-top:0">
              <tr>
                <td style="border:0;height:100px">
                  <span style="width:100%;text-align:center">위와 같이 휴가를 신청하오니 허락하여 주시기 바랍니다.</span>
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

        <div id="Guide_Desc" style="display:none"></div>

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
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:value-of disable-output-escaping="yes" select="phxsl:optionValue(//optioninfo/foption,'VACCLASS',string(VACCLASS),'VACCLASSDN',string(VACCLASSDN))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(VACCLASSDN))" />
            <input type="hidden" name="VACCLASS" value="{VACCLASS}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="LEAVEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{LEAVEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(LEAVEDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="FROMTIME" class="txtHHmm" readonly="readonly" maxlength="5" data-inputmask="time;HH:MM" value="{FROMTIME}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FROMTIME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="TOTIME" class="txtHHmm" readonly="readonly" maxlength="5" data-inputmask="time;HH:MM" value="{TOTIME}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTIME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC" class="txtText" maxlength="100" value="{ETC}" />
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
