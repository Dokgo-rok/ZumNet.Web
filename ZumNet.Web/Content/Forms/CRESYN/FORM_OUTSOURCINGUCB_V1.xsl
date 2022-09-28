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
          .m {width:1200px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:50px} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option {width:49%}

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
                    <!--<xsl:value-of select="//docinfo/docname" />-->
                    외주단가결정품의서(
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <select id="__mainfield" name="DOCCLASS" class="custom-select d-inline-block" style="width: 100px;font-size:16pt;font-weight:bold">
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'')">
                              <option value="" selected="selected">선택</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="">선택</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'인하')">
                              <option value="인하" selected="selected">인하</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="인하">인하</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DOCCLASS),'인상')">
                              <option value="인상" selected="selected">인상</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="인상">인상</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCCLASS))" />
                      </xsl:otherwise>
                    </xsl:choose>
                    )
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
                <td style="width:470px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '6', '의뢰부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:150px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[(@bizrole='confirm' or @bizrole='last') and @partid!='' and @step!='0'], '__si_Agree', '2', '승인부서', '')"/>
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
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit' ">
                  <tr>
                    <td>
                      <span>&nbsp;</span>
                    </td>
                    <td class="fm-button">
                      적용사업장 :                      
                        <input type="text" id="__mainfield" name="PRODUCTCENTER" style="width:100px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/PRODUCTCENTER}" />
                        <!--<button onclick="parent.fnOption('external.centercode',240,140,100,120,'','PRODUCTCENTER');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                          <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
                        </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="적용사업장" onclick="_zw.formEx.optionWnd('external.centercode',220,274,-170,0,'','PRODUCTCENTER');">
							<i class="fas fa-angle-down"></i>
						</button>
						&nbsp;&nbsp;통화 :
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
                      &nbsp;&nbsp;적용환율 :
                      <input type="text" id="__mainfield" name="EXCHANGERATE" style="width:100px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/EXCHANGERATE}" />
                      <!--<button onclick="parent.fnExternal('erp.exchangerate',240,40,80,70,'KRW','EXCHANGERATE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{$root}/EA/Images/ico_28.gif" />
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="적용 환율" onclick="_zw.formEx.externalWnd('erp.exchangerate',240,40,80,70,'KRW','EXCHANGERATE');">
							<i class="fas fa-angle-down"></i>
						</button>
                      <!--<button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnCopyChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />복사
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{$root}/EA/Images/ico_27.gif" />삭제
                      </button>-->
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="추가" onclick="_zw.form.addRow('__subtable1');">
							<i class="fas fa-plus"></i>
						</button>
						<button type="button" class="btn icon-btn btn-outline-secondary btn-sm" data-toggle="tooltip" data-placement="bottom" title="복사" onclick="_zw.form.copyRow('__subtable1');">
							<i class="fas fa-copy"></i>
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
                    적용사업장 : <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PRODUCTCENTER))" />&nbsp;&nbsp;&nbsp;
                    통화 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;&nbsp;&nbsp;
                    적용환율 : <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EXCHANGERATE))" />&nbsp;&nbsp;
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
                    <xsl:if test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:2%"></col>
                      <col style="width:8%"></col>
                      <col style="width:9%"></col>
                      <col style="width:9%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:4%"></col>
                      <col style="width:4%"></col>
                      <col style="width:5%"></col>
                      <col style="width:5%"></col>
                      <col style="width:3%"></col>
                      <col style="width:3%"></col>
                      <col style="width:3%"></col>
                      <col style="width:3%"></col>
                      <col style="width:10%"></col>
                      <col style="width:4%"></col>
                      <col style="width:7%"></col>
                      <col style="width:6%"></col>
                      <col style="width:5%"></col>
                    </colgroup>
                    <tr style="height:40px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">모델명</td>
                      <td class="f-lbl-sub" style="border-top:0">품명</td>
                      <td class="f-lbl-sub" style="border-top:0">품번</td>
                      <td class="f-lbl-sub" style="border-top:0">현행가</td>
                      <td class="f-lbl-sub" style="border-top:0">변경가</td>
                      <td class="f-lbl-sub" style="border-top:0">변동액</td>
                      <td class="f-lbl-sub" style="border-top:0">변동율</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        소요량<br />(월)
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        금액<br />(월)
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        TTL<br />L/T
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        Pre<br />L/T
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">L/T</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        Post<br />L/T
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">업체명</td>
                      <td class="f-lbl-sub" style="border-top:0">
                        업체<br />CODE
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">
                        BPA<br />NUM
                      </td>
                      <td class="f-lbl-sub" style="border-top:0">적용시점</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">비고</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td class="f-lbl-sub" colspan="10">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit' or $actrole='__r' or $actrole='_reviewer'">
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
                      <td colspan="6" style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
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
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
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
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="MODELNAME" style="width:75%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MODELNAME" />
              </xsl:attribute>
            </input>
            <!--<button onclick="parent.fnExternal('erp.items',240,40,80,70,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
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
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="ITEMNAME">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="ITEMNO" style="width:76%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ITEMNO" />
              </xsl:attribute>
            </input>
            <!--<button onclick="parent.fnExternal('erp.items1',240,40,80,70,'',this,'ITEMNAME');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="품번" onclick="_zw.formEx.externalWnd('erp.items3',240,40,20,70,'','ITEMNO','ITEMNAME');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMNO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="PRICEA" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PRICEA}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRICEA))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="PRICEB" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PRICEB}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRICEB))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="PRICEC" class="txtRead_Right" readonly="readonly" value="{PRICEC}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRICEC))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <!--<input type="text" name="RATE" class="txtDollar" maxlength="10" data-inputmask="number;6;4" value="{RATE}" />-->
			  <input type="text" name="RATE" class="txtRead_Right" readonly="readonly" value="{RATE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(RATE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="AMOUNT" class="txtCurrency" maxlength="10" data-inputmask="number;10;0" value="{AMOUNT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(AMOUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="PRICED" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PRICED}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRICED))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="TTLLT" class="txtCurrency" maxlength="20" data-inputmask="number;20;0" value="{TTLLT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TTLLT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="PRELT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PRELT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PRELT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="PROCESSLT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{PROCESSLT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(PROCESSLT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="POSTLT" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{POSTLT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(POSTLT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="COMPANY" style="width:81%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COMPANY" />
              </xsl:attribute>
            </input>
            <!--<button onclick="parent.fnExternal('erp.vendors',240,40,80,70,'',this,'COMPANYCODE');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="업체명" onclick="_zw.formEx.externalWnd('erp.vendors',240,40,100,70,'','COMPANY','COMPANYCODE');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COMPANY))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="COMPANYCODE">
              <xsl:attribute name="class">txtRead</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COMPANYCODE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COMPANYCODE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="BPANUM" style="width:70%" class="txtText_u" readonly="readonly" value="{BPANUM}" />
            <!--<button onclick="parent.fnOption('erp.bpanum',400,160,100,120,'',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>-->
			  <button type="button" class="btn btn-outline-secondary btn-18" title="BPA NUM" onclick="_zw.formEx.optionWnd('erp.bpanum',400,140,-260,120,'','BPANUM');">
				  <i class="fas fa-angle-down"></i>
			  </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(BPANUM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
			  <input type="text" name="APPLYPOINT" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{APPLYPOINT}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(APPLYPOINT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'  or $actrole='__r' or $actrole='_reviewer'">
            <input type="text" name="ETC">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="ETC" />
              </xsl:attribute>
            </input>
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
