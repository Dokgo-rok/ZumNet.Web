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
          .m {width:1365px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:200px} .m .ft .f-option2 {width:70px}
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
                <td style="width:325px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '작성부서')"/>
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
                <td class="f-lbl" style="border-bottom:0">문서번호</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성일자</td>
                <td style="width:15%;border-bottom:0">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="width:15%;border-bottom:0">
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
                      <span>
                        1. <input type="text" id="__mainfield" name="LOCATION" style="width:80px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/LOCATION}" />
                              <!--<button onclick="parent.fnView('external.centercode',300,180,180,140,'etc','LOCATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                                <img alt="" class="blt01" style="margin:0 0 2px 0">
                                  <xsl:attribute name="src">
                                    /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                                  </xsl:attribute>
                                </img>
                              </button>-->
						  <button type="button" class="btn btn-outline-secondary btn-18" title="법인" onclick="_zw.formEx.optionWnd('external.centercode',240,274,-100,0,'','LOCATION');">
							  <i class="fas fa-angle-down"></i>
						  </button>
                          외부출입자 방문사항
                        </span>
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
                        <span>
                          1. <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOCATION))" /> 외부출입자 방문사항</span>
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
                      <col style="width:25px"></col>                      
                      <col style="width:100px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                      <col style="width:100px"></col>
                      <col style="width:185px"></col>
                      <col style="width:125px"></col>
                      <col style="width:120px"></col>
                      <col style="width:250px"></col>                     
                      <col style="width:140px"></col>
                      <col style="width:80px"></col>
                      <col style="width:80px"></col>
                     
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>                      
                      <td class="f-lbl-sub" style="border-top:0" colspan="4">외부출입자 인적사항</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="4">출입예정 계획 및 사유</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0;border-bottom:0" colspan="3">출입자 관리담당</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="">소속</td>
                      <td class="f-lbl-sub" style="">직위</td>
                      <td class="f-lbl-sub" style="">성명</td>
                      <td class="f-lbl-sub" style="">연락처</td>
                      <td class="f-lbl-sub" style="">일자</td>
                      <td class="f-lbl-sub" style="">시간</td>
                      <td class="f-lbl-sub" style="">장소</td>
                      <td class="f-lbl-sub" style="">출입사유</td>                    
                      <td class="f-lbl-sub" style="">부서</td>
                      <td class="f-lbl-sub" style="">직위</td>
                      <td class="f-lbl-sub" style="border-bottom:0;border-right:0">성명</td>                      
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
			<div class="ff" />
			<div class="ff" />

          <div class="fm">
            <span>
              2. 외부 출입자 준수 서약서 접수 여부  <a href="http://ekp.cresyn.com/storage/cresyn/Files/board/8/방문증.doc" target="_blank">(방문증 양식 다운로드)</a>
            </span>
         
           <div class="ff" />
           <div class="ff" />
          </div>
          <div class="ff" />

          
          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">

                  <tr>
                    <td>
                      <input type="checkbox" id="ckb15" name="ckbYESNO" value="YES">
                        <xsl:if test="$mode='new' or $mode='edit'">
                          <xsl:attribute name="onclick">_zw.form.checkYN('ckbYESNO', this, 'YESNO')</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/YESNO),'YES')">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/YESNO),'YES')">
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:if>
                      </input>
                      <label for="ckb15" style="margin-left: 4px">YES</label>&nbsp;&nbsp;&nbsp;&nbsp;
                      <input type="checkbox" id="ckb16" name="ckbYESNO" value="NO">
                        <xsl:if test="$mode='new' or $mode='edit'">
                          <xsl:attribute name="onclick">_zw.form.checkYN('ckbYESNO', this, 'YESNO')</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/YESNO),'NO')">
                          <xsl:attribute name="checked">true</xsl:attribute>
                        </xsl:if>
                        <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/YESNO),'NO')">
                          <xsl:attribute name="disabled">disabled</xsl:attribute>
                        </xsl:if>
                      </input>
                      <label for="ckb16" style="margin-left: 4px">NO</label>
                      <input type="hidden" id="__mainfield" name="YESNO">
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/YESNO"></xsl:value-of>
                        </xsl:attribute>
                      </input>
                    </td>
                  </tr>
            </table>
          </div>
          
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>3. 기타사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="ETC" style="height:100px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/ETC" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div class="txaRead" style="min-height:100px">
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETC))" />
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
            <input type="text" name="OUTWORK">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">200</xsl:attribute>            
               <xsl:attribute name="value">
               <xsl:value-of select="OUTWORK" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(OUTWORK))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="OUTPOSI">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="OUTPOSI" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(OUTPOSI))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="OUTNAME">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="OUTNAME" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(OUTNAME))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="OUTNUM">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="OUTNUM" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(OUTNUM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VISITDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 80px" value="{VISITDATE}" />
          </xsl:when>         
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITDATE))" />
          </xsl:otherwise>
        </xsl:choose>
        &nbsp;~&nbsp;
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VISITDATETO" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" style="width: 80px" value="{VISITDATETO}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITDATETO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VISITTIME" class="txtHHmm" maxlength="10" data-inputmask="time;HH:MM" style="width: 50px" value="{VISITTIME}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITTIME))" />
          </xsl:otherwise>
        </xsl:choose>
        &nbsp;~&nbsp;
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VISITTIMETO" class="txtHHmm" maxlength="10" data-inputmask="time;HH:MM" style="width: 50px" value="{VISITTIMETO}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITTIMETO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="VISITPLACE">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">50</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="VISITPLACE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(VISITPLACE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <textarea name="VISITREASON" style="height:45px" class="txaText bootstrap-maxlength" maxlength="2000">
              <xsl:if test="$mode='edit'">
                <xsl:value-of select="VISITREASON" />
              </xsl:if>
            </textarea>
          </xsl:when>
          <xsl:otherwise>
            <div class="txaRead" style="min-height:45px">
              <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(VISITREASON))" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <!--<td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CORPORATEE">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                <img alt="" class="blt01" style="margin:0 0 2px 0">
                  <xsl:attribute name="src">
                    /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                  </xsl:attribute>
                </img>
              </button>        
              <xsl:attribute name="value">
                <xsl:value-of select="CORPORATEE" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CORPORATEE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>-->
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ATTENDEEDEPT" class="txtText" value="{ATTENDEEDEPT}" style="width:100%" />
            <!--<button onclick="parent.fnOrgmap('ur','N', this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">--><!--
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>-->
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ATTENDEEDEPT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
		<td class="tdRead_Center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ATTENDEEGRADE" class="txtText" value="{ATTENDEEGRADE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ATTENDEEGRADE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center" style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ATTENDEE" class="txtText" value="{ATTENDEE}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ATTENDEE))" />
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
