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
			.m {width:1100px} .m .fm-editor {height:350px;min-height:350px;border:windowtext 1pt solid}
			.fh h1 {font-size:20.0pt;letter-spacing:2pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
			.m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
			.m .ft-sub .f-option {width:49%}

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:350px;min-height:350px}}
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
                <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의부서', 'N')"/>
                </td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '3', '')"/>
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="width:15%;border-bottom:0;border-right:0">
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
            <span>1. 제목</span>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
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
            <span>2. 제작사유</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:60px" class="txaText bootstrap-maxlength" maxlength="1000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/REASON" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:60px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REASON))" />
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
            <span>3. 용도</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="USAGE" style="height:40px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/USAGE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/USAGE))" />
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
                      <span>4. 샘플제작내역</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:70px;height:16px">
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
                      </button>
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
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
						<button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',160,140,10,115,'etc','CURRENCY');">
							<i class="fas fa-angle-down"></i>
						</button>
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
                      <span>4. 샘플제작내역</span>
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
                  <table id="__subtable1" class="ft-sub" header="1"  border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:130px"></col>
                      <col style="width:110px"></col>
                      <col style="width:50px"></col>
                      <col style="width:50px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:90px"></col>
                      <col style="width:100px"></col>
                      <col style="width:100px"></col>
                      <col style="width:120px"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">품명</td>
                      <td class="f-lbl-sub" style="border-top:0">적용모델</td>
                      <td class="f-lbl-sub" style="border-top:0">수량</td>
                      <td class="f-lbl-sub" style="border-top:0">단위</td>
                      <td class="f-lbl-sub" style="border-top:0">견적단가</td>
                      <td class="f-lbl-sub" style="border-top:0">결정단가</td>
                      <td class="f-lbl-sub" style="border-top:0">금액</td>
                      <td class="f-lbl-sub" style="border-top:0">업체명</td>
                      <td class="f-lbl-sub" style="border-top:0">결제조건</td>
                      <td class="f-lbl-sub" style="border-top:0">비용부담</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="5">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM1">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM1" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="UNITSUM2">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/UNITSUM2" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/UNITSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALSUM">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
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
                      <td colspan="4" style="border-bottom:0;border-right:0">&nbsp;</td>
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
            <span>5. 제작일정</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="SCHEDULE" style="height:40px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/SCHEDULE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="height:40px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/SCHEDULE))" />
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
            <span>6. 특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm-editor">
			  <xsl:if test="$mode!='new' and $mode!='edit'">
				  <xsl:attribute name="class">fm-editor h-auto</xsl:attribute>
			  </xsl:if>
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
				  <div class="h-100" id="__DextEditor"></div>
              </xsl:otherwise>
            </xsl:choose>
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
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="ROWSEQ">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
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
            <input type="text" name="ITEMNAME">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="ITEMNAME">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ITEMNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MODEL">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MODEL" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="MODEL">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MODEL" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODEL))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT" class="txtVolume" data-inputmask="number;10;0" maxlength="10" value="{COUNT}" />
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
			  <input type="text" name="COUNT" class="txtRead" readonly="readonly" value="{COUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNIT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">10</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="UNIT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="UNIT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="UNIT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNIT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST1" class="txtDollar" maxlength="14" data-inputmask="number;10;4" value="{UNITCOST1}" />
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="UNITCOST1" class="txtRead" readonly="readonly" value="{UNITCOST1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="UNITCOST2" class="txtDollar" maxlength="14" data-inputmask="number;10;4" value="{UNITCOST2}" />
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="UNITCOST2" class="txtRead" readonly="readonly" value="{UNITCOST2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(UNITCOST2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM">
              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="SUM">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COMPANY">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COMPANY" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="COMPANY">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COMPANY" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COMPANY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SETTLEMENT">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SETTLEMENT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="SETTLEMENT">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="SETTLEMENT" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SETTLEMENT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option">
          <input type="checkbox" name="ckbCHARGE" value="고객">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.1</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='agree' and $partid!='')" >
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbCHARGE', this, 'CHARGE')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(CHARGE),'고객')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(CHARGE),'고객') and (not ($bizrole='agree' and $partid!=''))">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1"><xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.1</xsl:attribute>고객</label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbCHARGE" value="당사">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.2</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit' or ($bizrole='agree' and $partid!='')">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbCHARGE', this, 'CHARGE')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(CHARGE),'당사')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(CHARGE),'당사') and (not ($bizrole='agree' and $partid!=''))">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
			<label class="ml-1"><xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.2</xsl:attribute>당사</label>
        </span>
        <input type="hidden" name="CHARGE" value="{CHARGE}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:when test="$bizrole='agree' and $partid!='' ">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ETC))" />
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
