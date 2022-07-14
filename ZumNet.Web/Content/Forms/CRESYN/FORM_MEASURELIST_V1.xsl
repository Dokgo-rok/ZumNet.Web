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
          .m {width:1100px} .m .fm-editor {height:400px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:13%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:13%}
          .m .ft-sub .f-option {width:100%}

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
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '개발부서')"/>
                </td>
                <td style="width:;font-size:1px">&nbsp;</td>
                <td style="width:170px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '2', '검토부서', 'N')"/>
                </td>
                <td style="width:75px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
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
                <td class="f-lbl">문서번호</td>
                <td style="width:17%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일</td>
                <td style="width:17%">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl">작성부서</td>
                <td style="width:17%">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl">작성자</td>
                <td style="width:17%;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">품명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ITEMNAME" class="txtText" maxlength="100" value="{//forminfo/maintable/ITEMNAME}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ITEMNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">모델명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText" style="width:89%;margin-right:2px" value="{//forminfo/maintable/MODELNAME}" />
                      <!--<button onclick="parent.fnExternal('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME','ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                      </button>-->
					<button type="button" class="btn btn-outline-secondary btn-18" title="모델명" onclick="_zw.formEx.externalWnd('report.SEARCH_NEWDEVREQMODEL',240,40,120,70,'','MODELNAME','ITEMNAME');">
	                    <i class="fas fa-angle-down"></i>
                    </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/MODELNAME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">고객명</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CUSTOMER">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CUSTOMER" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">개발단계</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="STEP" style="width:89%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STEP" />
                        </xsl:attribute>
                      </input>
                      <!--<button onclick="parent.fnOption('external.devstep',140,120,30,75,'etc','STEP');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="개발단계" onclick="_zw.formEx.optionWnd('external.devstep',140,214,-60,0,'etc','STEP');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STEP))" />
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
                      <span></span>
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
                  <table id="__subtable1" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:25px"></col>
                      <col style="width:53px"></col>
                      <col style="width:253px"></col>
                      <col style="width:53px"></col>
                      <col style="width:253px"></col>
                      <col style="width:253px"></col>
                      <col style="width:80px"></col>
                      <col style="width:70px"></col>
                    </colgroup>
                    <tr style="height:38px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0;">발생<br />인자</td>
                      <td class="f-lbl-sub" style="border-top:0;">문제점</td>
                      <td class="f-lbl-sub" style="border-top:0;">중요도</td>
                      <td class="f-lbl-sub" style="border-top:0;">원인분석</td>
                      <td class="f-lbl-sub" style="border-top:0;">개선대책</td>
                      <td class="f-lbl-sub" style="border-top:0;">완료예정일</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">담당자</td>
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
    <tr class="sub_table_row" style="height:150px">
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <xsl:attribute name="style"></xsl:attribute>
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
       <span class="f-option">
          <input type="checkbox" name="ckbFACTOR" value="기구">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.AA</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbFACTOR', this, 'FACTOR')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(FACTOR),'기구')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(FACTOR),'기구')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.AA</xsl:attribute>기구
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbFACTOR" value="회로">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.BB</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbFACTOR', this, 'FACTOR')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(FACTOR),'회로')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(FACTOR),'회로')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.BB</xsl:attribute>회로
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbFACTOR" value="음향">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.CB</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbFACTOR', this, 'FACTOR')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(FACTOR),'음향')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(FACTOR),'음향')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.CB</xsl:attribute>음향
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbFACTOR" value="공정">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.DA</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbFACTOR', this, 'FACTOR')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(FACTOR),'공정')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(FACTOR),'공정')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.DA</xsl:attribute>공정
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbFACTOR" value="환경">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.EA</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbFACTOR', this, 'FACTOR')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(FACTOR),'환경')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(FACTOR),'환경')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.EA</xsl:attribute>환경
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbFACTOR" value="기타">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.FA</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbFACTOR', this, 'FACTOR')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(FACTOR),'기타')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(FACTOR),'기타')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.FA</xsl:attribute>기타
          </label>
        </span>
        <input type="hidden" name="FACTOR">
          <xsl:attribute name="value">
            <xsl:value-of select="FACTOR" />
          </xsl:attribute>
        </input>
      </td>
      <td style="vertical-align:top">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea id="__mainfield" name="PROBLEM"  style="height:100%" class="txaText bootstrap-maxlength" maxlength="500">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="PROBLEM" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="height:">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PROBLEM))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <span class="f-option">
          <input type="checkbox" name="ckbCONSEQ" value="치명">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.1A</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbCONSEQ', this, 'CONSEQ')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(CONSEQ),'치명')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(CONSEQ),'치명')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.1A</xsl:attribute>치명
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbCONSEQ" value="중">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.2A</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbCONSEQ', this, 'CONSEQ')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(CONSEQ),'중')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(CONSEQ),'중')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.2A</xsl:attribute>중
          </label>
        </span>
        <span class="f-option">
          <input type="checkbox" name="ckbCONSEQ" value="경">
            <xsl:attribute name="id">ckb.<xsl:value-of select="ROWSEQ" />.3A</xsl:attribute>
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">_zw.form.checkTableYN('ckbCONSEQ', this, 'CONSEQ')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(CONSEQ),'경')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(CONSEQ),'경')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label class="ml-1">
            <xsl:attribute name="for">ckb.<xsl:value-of select="ROWSEQ" />.3A</xsl:attribute>경
          </label>
        </span>
        <input type="hidden" name="CONSEQ">
          <xsl:attribute name="value">
            <xsl:value-of select="CONSEQ" />
          </xsl:attribute>
        </input>
      </td>
      <td style="vertical-align:top">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea id="__mainfield" name="CAUSE" style="height:100%" class="txaText bootstrap-maxlength" maxlength="500">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="CAUSE" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="height:">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="vertical-align:top">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea id="__mainfield" name="IMPROVEMENT" style="height:100%" class="txaText bootstrap-maxlength" maxlength="500">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="IMPROVEMENT" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="height:">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(IMPROVEMENT))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" id="__mainfield" name="PREDICTIONDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{PREDICTIONDATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PREDICTIONDATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MANAGER">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">30</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MANAGER" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MANAGER))" />
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
            <xsl:when test="phxsl:isEqual(string(@xfalias),'pdm')">
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
