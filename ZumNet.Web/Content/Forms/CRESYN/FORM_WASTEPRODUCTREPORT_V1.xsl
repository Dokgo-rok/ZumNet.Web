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
  <xsl:variable name="submode" select="//config/@submode" />
  <xsl:variable name="partid" select="//config/@partid" />
  <xsl:variable name="bizrole" select="//config/@bizrole" />
  <xsl:variable name="actrole" select="//config/@actrole" />
  <xsl:variable name="root" select="//config/@root" />
  <xsl:variable name="mlvl" select="phxsl:modLevel(string(//config/@mode), string(//bizinfo/@docstatus), string(//config/@partid), string(//creatorinfo/@uid), string(//currentinfo/@uid), //processinfo/signline/lines)" />
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
          .m {width:1100px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter -spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}    .m .ft-sub .f-option2 {width:30%}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:650px}}
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
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의부서', 'N')"/>
                </td>
                <td style="width:225px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '3', '')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
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
                      <input type="text" id="Subject" name="__commonfield">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">200</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//docinfo/subject" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//docinfo/subject))" />
                        </xsl:otherwise>
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
            <span style="color:#344fe9">불용제품처리 기안 승인품의 처리가 아래와 같이 진행되었음을 보고 드립니다.</span>
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
                      <span>&nbsp;</span>
                    </td>
                    <td class="fm-button">
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
                      <span>&nbsp;</span>
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
                  <table id="__subtable1" class="ft-sub" header="3"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:3%"></col>
                      <col style="width:8%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:8%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:10%"></col>
                      <col style="width:%"></col>                      
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="3">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="6">처리 기안 승인내역</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="7">처리 결과</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub" style="" rowspan="2">기안번호</td>
                      <td class="f-lbl-sub" style="" rowspan="2">기안일</td>
                      <td class="f-lbl-sub" style="" rowspan="2">품류구분</td>
                      <td class="f-lbl-sub" style="" rowspan="2">수량</td>      
                      <td class="f-lbl-sub" style="" rowspan="2">중량</td>
                      <td class="f-lbl-sub" style="" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="" rowspan="2">처리일자</td>
                      <td class="f-lbl-sub" style="" colspan="2">수량</td>
                      <td class="f-lbl-sub" style="" colspan="2">중량</td>
                      <td class="f-lbl-sub" style="" rowspan="2">차이원인</td>                      
                      <td class="f-lbl-sub" style="border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub" style="">완료</td>
                      <td class="f-lbl-sub" style="">차이</td>
                      <td class="f-lbl-sub" style="">완료</td>
                      <td class="f-lbl-sub" style="">차이</td>
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
                      <span>처리진행 상세내역</span>
                    </td>
                    <td class="fm-button">
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
                      <span>처리진행 상세내역</span>
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
                  <table id="__subtable2" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:3%"></col>                      
                      <col style="width:8%"></col>
                      <col style="width:10%"></col>
                      <col style="width:20%"></col>
                      <col style="width:50%"></col>
                      <col style="width:%"></col>
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0" >NO</td>                      
                      <td class="f-lbl-sub" style="border-top:0" >처리일자</td>
                      <td class="f-lbl-sub" style="border-top:0" >처리장소</td>
                      <td class="f-lbl-sub" style="border-top:0" >처리방법</td>
                      <td class="f-lbl-sub" style="border-top:0" >처리세부내역(폐기 시 폐기사진 첨부)</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">입회자</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                  </table>
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
      <td style="text-align:center">
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
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DOCNUM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DOCNUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DOCNUM" class="txtText" maxlength="20" value="{DOCNUM}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DOCNUM))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DOCDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{DOCDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DOCDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{DOCDATE}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOCDATE))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMTYPE">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMTYPE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="ITEMTYPE" class="txtText" maxlength="200" value="{ITEMTYPE}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Left</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ITEMTYPE))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{COUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="COUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{COUNT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WEIGHT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{WEIGHT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="WEIGHT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{WEIGHT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WEIGHT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WASTEREASON">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WASTEREASON" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="WASTEREASON" class="txtText" maxlength="200" value="{WASTEREASON}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Left</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WASTEREASON))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WASTEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{WASTEDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="WASTEDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{WASTEDATE}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WASTEDATE))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMCOUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{COMCOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="COMCOUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{COMCOUNT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COMCOUNT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DEPCOUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEPCOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DEPCOUNT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEPCOUNT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEPCOUNT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMWEIGHT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{COMWEIGHT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="COMWEIGHT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{COMWEIGHT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COMWEIGHT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DEPWEIGHT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEPWEIGHT}" />
          </xsl:when>
          <xsl:otherwise>         
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DEPWEIGHT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{DEPWEIGHT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEPWEIGHT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DEPREASON">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DEPREASON" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DEPREASON" class="txtText" maxlength="200" value="{DEPREASON}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Left</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DEPREASON))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td style="text-align:center;border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="WASTENUM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="WASTENUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="WASTENUM" class="txtText" maxlength="200" value="{WASTENUM}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WASTENUM))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
      <td style="text-align:center">
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
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DODATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{DODATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DODATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{DODATE}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DODATE))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DOPLACE">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DOPLACE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DOPLACE" class="txtText" maxlength="200" value="{DOPLACE}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Left</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOPLACE))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DOWAY">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DOWAY" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DOWAY" class="txtText" maxlength="200" value="{DOWAY}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Left</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOWAY))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DORESULT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DORESULT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DORESULT" class="txtText" maxlength="200" value="{DORESULT}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Left</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DORESULT))" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </td>          
      <td style="text-align:center;border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="DOPERSON">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="DOPERSON" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:if test="$mlvl='A' or $mlvl='B'">
              <xsl:attribute name="id">___editable</xsl:attribute>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="$submode='revise'">
                <input type="text" name="DOPERSON" class="txtText" maxlength="200" value="{DOPERSON}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOPERSON))" />
              </xsl:otherwise>
            </xsl:choose>
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
