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
			.m {width:740px} .m .fm-editor {height:450px;min-height:450px;border:windowtext 1pt solid}
			.fh h1 {font-size:20.0pt;letter-spacing:15pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
			.m .ft .f-option {width:20%} .m .ft .f-option1 {width:34%}

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:450px;min-height:450px}}
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
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield" name="DOCCLASS" class="custom-select d-inline-block" style="width: 280px; font-size:16pt;font-weight:bold" onchange="_zw.formEx.change(this);">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'D.R회의록')">
                              <option value="D.R회의록" selected="selected">D.R회의록</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="D.R회의록">D.R회의록</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'타사제품검토보고서')">
                              <option value="타사제품검토보고서" selected="selected">타사제품검토보고서</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="타사제품검토보고서">타사제품검토보고서</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'기술검토보고서')">
                              <option value="기술검토보고서" selected="selected">기술검토보고서</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="기술검토보고서">기술검토보고서</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'IDEA기술보고서')">
                              <option value="IDEA기술보고서" selected="selected">IDEA기술보고서</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="IDEA기술보고서">IDEA기술보고서</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCCLASS))" />
                      </xsl:otherwise>
                    </xsl:choose>
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

          <div class="fm" id="panDisplay1">
            <xsl:choose>
              <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS), 'IDEA기술보고서')">               
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">display:block</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:15%"></col>
                <col style="width:10%"></col>
                <col style="width:20%"></col>
                <col style="width:10%"></col>
                <col style="width:"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">회의명</td>
                <td colspan="5" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TITLE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/TITLE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TITLE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">회의일자</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MEETINGDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/MEETINGDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MEETINGDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">회의시간</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MEETINGTIME">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">20</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/MEETINGTIME" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MEETINGTIME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">회의장소</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLACE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/PLACE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PLACE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">회의목적</td>
                <td colspan="5"  style="border-bottom:0;border-right:0;height:44px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="PURPOSE" style="height:40px" class="txaText bootstrap-maxlength" maxlength="200">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/PURPOSE" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PURPOSE))" />
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

          <div class="fm" id="panDisplay2">
            <xsl:choose>
              <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS), 'IDEA기술보고서')">
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="style">display:block</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>참석자</span>
                    </td>
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
                  <tr>
                    <td>
                      <span>참석자</span>
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
                      <col style="width:18%"></col>
                      <col style="width:15%"></col>
                      <col style="width:15%"></col>
                      <col style="width:18%"></col>
                      <col style="width:15%"></col>
                      <col style="width:"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0">부서명</td>
                      <td class="f-lbl-sub" style="border-top:0">직책</td>
                      <td class="f-lbl-sub" style="border-right:windowtext 1pt solid;border-top:0">성명</td>
                      <td class="f-lbl-sub" style="border-top:0">부서명</td>
                      <td class="f-lbl-sub" style="border-top:0">직책</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">성명</td>
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

          <div class="fm" id="panDisplay3">
            <xsl:choose>
              <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS), 'IDEA기술보고서')">
                <xsl:attribute name="style">display:block</xsl:attribute>
              </xsl:when>
              <xsl:otherwise>              
                <xsl:attribute name="style">display:none</xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <table  class="ft" border="0" cellspacing="0" cellpadding="0">              
                  <tr>
                    <td class="f-lbl">
                     IDEA 기술구분
                    </td>
                    <td style="border-right:0" colspan="5">
                      <span class="f-option">
                        <input type="checkbox" id="ckb11" name="ckbIDEADIVIDE" value="기구">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">_zw.form.checkYN('ckbIDEADIVIDE', this, 'IDEADIVIDE')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/IDEADIVIDE),'기구')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/IDEADIVIDE),'기구')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </input>
                        <label for="ckb11">기구</label>
                      </span>
                      <span class="f-option">
                        <input type="checkbox" id="ckb12" name="ckbIDEADIVIDE" value="회로">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">_zw.form.checkYN('ckbIDEADIVIDE', this, 'IDEADIVIDE')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/IDEADIVIDE),'회로')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/IDEADIVIDE),'회로')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </input>
                        <label for="ckb12">회로</label>
                      </span>
                      <span class="f-option">
                        <input type="checkbox" id="ckb13" name="ckbIDEADIVIDE" value="음향">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">_zw.form.checkYN('ckbIDEADIVIDE', this, 'IDEADIVIDE')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/IDEADIVIDE),'음향')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/IDEADIVIDE),'음향')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </input>
                        <label for="ckb13">음향</label>
                      </span>
                      <span class="f-option1">
                        <input type="checkbox" id="ckb14" name="ckbIDEADIVIDE" value="기타">
                          <xsl:if test="$mode='new' or $mode='edit'">
                            <xsl:attribute name="onclick">_zw.form.checkYN('ckbIDEADIVIDE', this, 'IDEADIVIDE')</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/IDEADIVIDE),'기타')">
                            <xsl:attribute name="checked">true</xsl:attribute>
                          </xsl:if>
                          <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/IDEADIVIDE),'기타')">
                            <xsl:attribute name="disabled">disabled</xsl:attribute>
                          </xsl:if>
                        </input>
                        <label for="ckb14">기타</label>
                      </span>
                      <input type="hidden" id="__mainfield" name="IDEADIVIDE">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/IDEADIVIDE"></xsl:value-of>
                        </xsl:attribute>
                      </input>
                    </td>
                  </tr>
                  <tr>
                    <td class="f-lbl" style="border-bottom:0">IDEA 기술명</td>
                    <td colspan="5" style="border-right:0;border-bottom:0">
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <input type="text" id="__mainfield" name="IDEANAME">
                            <xsl:attribute name="class">txtText</xsl:attribute>
                            <xsl:attribute name="maxlength">100</xsl:attribute>
                            <xsl:attribute name="value">
                              <xsl:value-of select="//forminfo/maintable/IDEANAME" />
                            </xsl:attribute>
                          </input>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/IDEANAME))" />
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
          
          <div class="fm-editor">
			  <xsl:if test="$mode!='new' and $mode!='edit'">
				  <xsl:attribute name="class">fm-editor h-auto</xsl:attribute>
			  </xsl:if>
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <xsl:if test="$mlvl='A' or $mlvl='B'">
                  <xsl:attribute name="id">___editable</xsl:attribute>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$submode='revise'">
                    <textarea id="bodytext" style="display:none">
                      <xsl:value-of select="//forminfo/maintable/WEBEDITOR" />
                    </textarea>
					  <div class="h-100" id="__DextEditor"></div>
                  </xsl:when>
                  <xsl:otherwise>
                    <div name="WEBEDITOR" id="__mainfield" class="txaRead" style="width:100%;height:100%;padding:4px 4px 4px 4px;position:relative">
                      <xsl:value-of disable-output-escaping="yes" select="//forminfo/maintable/WEBEDITOR" />
                    </div>
                  </xsl:otherwise>
                </xsl:choose>
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
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLICANTDEPT1">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="APPLICANTDEPT1" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLICANTDEPT1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLICANTGRADE1">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="APPLICANTGRADE1" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLICANTGRADE1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLICANT1">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="APPLICANT1" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLICANT1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLICANTDEPT2">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="APPLICANTDEPT2" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLICANTDEPT2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLICANTGRADE2">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="APPLICANTGRADE2" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLICANTGRADE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="APPLICANT2">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="APPLICANT2" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(APPLICANT2))" />
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
