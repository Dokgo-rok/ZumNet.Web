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
          .m {width:1200px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:20%} .m .ft .f-lbl2 {width:50%}
          .m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
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
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
                </td>
                <td style="width:20px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='application' and @partid!='' and @step!='0'], '__si_Application', '1', '접수')"/>
                </td>
                <td style="width:20px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='manage' and @partid!='' and @step!='0'], '__si_Attr', '1', '담당')"/>
                </td>
                <td style="width:650px;font-size:1px">&nbsp;</td>
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:17%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:17%;border-bottom:0">
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
                      <input type="text" id="Subject" name="__commonfield" class="txtRead" readonly="readonly" maxlength="200" value="{//docinfo/subject}" />
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
            <span>1. 사용 프린터 선택</span>
          </div>

          <div class="ff" />
          <div class="ff" />
          
          <div class="fm" style="text-align:left">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="width: 340px">
              <tr>
                <td class="f-lbl2">1순위</td>
                <td class="f-lbl2" style="border-right:0;">2순위</td>
              </tr>
              <tr>
                <td class="tdRead_Center" style="border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="USEPNTA" class="form-control">
                        <option value="Projet MJP 3600">Projet MJP 3600</option>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USEPNTA))"/>
                    </xsl:otherwise>
                  </xsl:choose>

                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="USEPNTA" style="width:100%">
                        <option value="">선택</option>
                        <xsl:for-each select="//optioninfo/foption[@sk='resource.rp']">
                          <option value="{Item1}">
                            <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/USEPNTA), string(Item1))">
                              <xsl:attribute name="selected">selected</xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="Item1"/>
                          </option>
                        </xsl:for-each>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USEPNTA))"/>
                    </xsl:otherwise>
                  </xsl:choose>-->

                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="USEPNTA" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTA),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTA),'Projet MJP 3600')">
                            <option value="Projet MJP 3600" selected="selected">Projet MJP 3600</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Projet MJP 3600">Projet MJP 3600</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTA),'Object 260')">
                            <option value="Object 260" selected="selected">Object 260</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Object 260">Object 260</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTA),'Dimension Elite')">
                            <option value="Dimension Elite" selected="selected">Dimension Elite</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Dimension Elite">Dimension Elite</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USEPNTA))"/>
                    </xsl:otherwise>
                  </xsl:choose>-->
                </td>
                <td class="tdRead_Center" style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="USEPNTB" class="form-control">
                        <option value="Projet MJP 3600">Projet MJP 3600</option>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USEPNTB))"/>
                    </xsl:otherwise>
                  </xsl:choose>

                  <!--<xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="USEPNTB" style="">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTB),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTB),'Projet MJP 3600')">
                            <option value="Projet MJP 3600" selected="selected">Projet MJP 3600</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Projet MJP 3600">Projet MJP 3600</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTB),'Object 260')">
                            <option value="Object 260" selected="selected">Object 260</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Object 260">Object 260</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(USEPNTB),'Dimension Elite')">
                            <option value="Dimension Elite" selected="selected">Dimension Elite</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="Dimension Elite">Dimension Elite</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USEPNTB))"/>
                    </xsl:otherwise>
                  </xsl:choose>-->
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

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>2. 요청 및 사용현황</span>
                    </td>
                    <td class="fm-button">
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
                      <span>2. 요청 및 사용현황</span>
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
                  <table id="__subtable1" class="ft-sub" header="2"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:3%"></col>
                      <col style="width:8%"></col>
                      <col style="width:5%"></col>
                      <col style="width:10%"></col>
                      <col style="width:10%"></col>
                      <col style="width:10%"></col>
                      <col style="width:10%"></col>
                      <col style="width:7%"></col>
                      <col style="width:7%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">요청자 인적사항</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">고객사</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">모델명</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">용도</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">장비명</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">사용일자</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">사용시간</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="4">재료 사용량 (kg)</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">요청부서</td>
                      <td class="f-lbl-sub">성명</td>
                      <td class="f-lbl-sub">시작일</td>
                      <td class="f-lbl-sub">종료일</td>
                      <td class="f-lbl-sub">시작시각</td>
                      <td class="f-lbl-sub">종료시각</td>
                      <td class="f-lbl-sub">Part1</td>
                      <td class="f-lbl-sub">Part2</td>
                      <td class="f-lbl-sub">Part3</td>
                      <td class="f-lbl-sub" style="border-right:0">Support</td>
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
            <span>※ 재료 구분</span>
          </div>
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl1">장비명</td>
                <td class="f-lbl1">PART1</td>
                <td class="f-lbl1">PART2</td>
                <td class="f-lbl1">PART3</td>
                <td class="f-lbl1" style="border-right:0;">SUPPORT</td>
              </tr>
              <tr>
                <td class="tdRead_Center">Projet MJP 3600</td>
                <td class="tdRead_Center">VisiJet M3 Crystal</td>
                <td class="tdRead_Center">&nbsp;</td>
                <td class="tdRead_Center">&nbsp;</td>
                <td class="tdRead_Center" style="border-right:0">VisiJet S300</td>
              </tr>
              <tr>
                <td class="tdRead_Center">Object 260</td>
                <td class="tdRead_Center">RGD835, VERO WHITE PLUS</td>
                <td class="tdRead_Center">OBJET FLX985, AGILUS 30 BLACK</td>
                <td class="tdRead_Center">RIGUR RGD450</td>
                <td class="tdRead_Center" style="border-right:0">SUP706 B</td>
              </tr>
              <tr>
                <td class="tdRead_Center" style="border-bottom:0">Dimension Elite</td>
                <td class="tdRead_Center" style="border-bottom:0">RIGUR, RGD450</td>
                <td class="tdRead_Center" style="border-bottom:0">&nbsp;</td>
                <td class="tdRead_Center" style="border-bottom:0">&nbsp;</td>
                <td class="tdRead_Center" style="border-right:0;border-bottom:0">P400-SR</td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>3. 기타 요청 사항</span>
          </div>
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:100px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
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
            <input type="checkbox" name="ROWSEQ" class="txtRead_Center" value="{ROWSEQ}" />
          </xsl:when>
          <xsl:when test="string(APPLID) != '' and ($bizrole='application' or $bizrole='manage') and $actrole='_approver' and $partid!=''">
            <input type="text" name="ROWSEQ" class="txtRead_Center" readonly="readonly"  value="{ROWSEQ}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLDEPT" class="txtText_u" readonly="readonly" style="width:78%" value="{APPLDEPT}" />
            <!--<button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="요청자" onclick="_zw.fn.org('user','n', this);">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
        <input type="hidden" name="APPLID" value="{APPLID}" />
        <input type="hidden" name="APPLDEPTID" value="{APPLDEPTID}" />
        <input type="hidden" name="APPLCORP" value="{APPLCORP}" />
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLDN" class="txtRead_Center" readonly="readonly" value="{APPLDN}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLDN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CUSTOMER" class="txtText_u"  style="width:83%" value="{CUSTOMER}" />
            <!--<button onclick="parent.fnExternal('erp.customers',240,40,100,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="고객사" onclick="_zw.formEx.externalWnd('erp.customers',240,40,100,70,'','CUSTOMER');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CUSTOMER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MODELNAME" class="txtText_u"  style="width:83%" value="{MODELNAME}" />
            <!--<button onclick="parent.fnExternal('erp.items',240,40,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="모델명" onclick="_zw.formEx.externalWnd('erp.items',240,40,20,70,'','MODELNAME');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USAGE" class="txtText" maxlength="100" value="{USAGE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USAGE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='application' and $actrole='_approver' and $partid!=''">
            <select name="EQUIPID" class="form-control" onclick="_zw.formEx.change(this)">
              <option value="">선택</option>
              <xsl:for-each select="//optioninfo/foption[@sk='resource.rp']">
                <option value="{@sk}.{@cd}">
                  <xsl:value-of select="Item1"/>
                </option>
              </xsl:for-each>
            </select>
            <input type="hidden" name="EQUIPNM" value="{EQUIPNM}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EQUIPNM))"/>
            <input type="hidden" name="EQUIPID" value="{EQUIPID}" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="USESTDT" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{USESTDT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USESTDT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="USEEDDT" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{USEEDDT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USEEDDT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="USESTTM" class="txtHHmm" maxlength="5" data-inputmask="time;HH:MM" value="{USESTTM}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USESTTM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="USEEDTM" class="txtHHmm" maxlength="5" data-inputmask="time;HH:MM" value="{USEEDTM}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USEEDTM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="MTRUSE1" class="txtDollar" maxlength="10" value="{MTRUSE1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MTRUSE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="MTRUSE2" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{MTRUSE2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MTRUSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="MTRUSE3" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{MTRUSE3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MTRUSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="string(APPLID) != '' and $bizrole='manage' and $actrole='_approver' and $partid!=''">
            <input type="text" name="SUPPORT" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{SUPPORT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUPPORT))" />
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
