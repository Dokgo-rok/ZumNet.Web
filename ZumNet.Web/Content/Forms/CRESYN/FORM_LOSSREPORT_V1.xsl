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
			.m {width:770px} .m .fm-editor {height:300px;min-height:300px;border:windowtext 1pt solid}
			.fh h1 {font-size:20.0pt;letter-spacing:2pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:25%} .m .ft .f-lbl2 {width:?}
			.m .ft .f-option {width:33%} .m .ft .f-option1 {width:34%}
			.m .ft-sub .f-option {width:49%}

			/* 인쇄 설정 : 맨하단으로 */
			@media print {.m .fm-editor {height:300px;min-height:300px}}
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
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0' and @viewstate!='6'], '__si_Normal', '3', '발생부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:170px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='receive' and @partid!='' and @step!='0' and @viewstate!='6' and @actrole!='__r'], '__si_Receive', '2', '수신부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='application' and @partid!='' and @step!='0' and @viewstate!='6' and @actrole!='__r'], '__si_Application_R', '4', '접수부서')"/>
                </td>
              </tr>
            </table>
          </div>
          <div class="ff" />
          <div class="ff" />
          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td>
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='gwichaek' and @partid!='' and @step!='0' and @viewstate!='6' and @actrole!='__r'], '__si_Form', '10', '귀책부서', '', '')"/>
                </td>
              </tr>
            </table>
          </div>

          <!--<div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2" style="width:236px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0' and @viewstate!='6'], '__si_Normal', '3', '발생부서')"/>
                </td>
                <td colspan="4" style="width:;font-size:1px">&nbsp;</td>
              </tr>
              <tr>
                <td style="font-size:1px">
                  <div class="ff" />
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td style="width:165px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='receive' and @partid!='' and @step!='0' and @viewstate!='6' and @actrole!='__r'], '__si_Receive', '2', '결정부서', 'N')"/>
                </td>
                <td style="width:72px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='application' and @actrole='_approver' and @partid!='' and @step!='0' and @viewstate!='6'], '__si_Application', '1', 'BR')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:308px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='gwichaek' and @partid!='' and @step!='0' and @viewstate!='6'], '__si_Form', '4', '귀책부서', '', 'AR')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:164px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='application' and @actrole='_reviewer' and @partid!='' and @step!='0' and @viewstate!='6'], 'gc_si_OnlyOne', '2', '확인부서','','AR')"/>
                </td>
              </tr>
            </table>
          </div>-->

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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <tr>
                <td class="f-lbl">고객명</td>
                <td style="width:35%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">                      
                      <input type="text" id="__mainfield" name="CUSTOMER" class="txtText" maxlength="50" value="{//forminfo/maintable/CUSTOMER}" />                                                                       
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="CUSTOMER" class="txtText" maxlength="50" value="{//forminfo/maintable/CUSTOMER}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CUSTOMER))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">모델명</td>
                <td style="width:35%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MODELNAME" class="txtText" maxlength="50" value="{//forminfo/maintable/MODELNAME}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="MODELNAME" class="txtText" maxlength="50" value="{//forminfo/maintable/MODELNAME}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MODELNAME))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">손실발생일</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOSSDATE" class="txtText" maxlength="200" value="{//forminfo/maintable/LOSSDATE}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="LOSSDATE" class="txtText" maxlength="200" value="{//forminfo/maintable/LOSSDATE}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOSSDATE))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>                  
                </td>
                <td class="f-lbl">손실발생장소</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOSSPLACE" class="txtText" maxlength="50" value="{//forminfo/maintable/LOSSPLACE}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="LOSSPLACE" class="txtText" maxlength="50" value="{//forminfo/maintable/LOSSPLACE}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOSSPLACE))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">부품명</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTSNAME" class="txtText" maxlength="50" value="{//forminfo/maintable/PARTSNAME}" />                                                                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="PARTSNAME" class="txtText" maxlength="50" value="{//forminfo/maintable/PARTSNAME}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTSNAME))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl">부품번호</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PARTSNO" class="txtText" maxlength="50" value="{//forminfo/maintable/PARTSNO}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="PARTSNO" class="txtText" maxlength="50" value="{//forminfo/maintable/PARTSNO}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PARTSNO))" />
                        </xsl:otherwise>
                      </xsl:choose>                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">총 손실비용</td>
                <td style="border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CURRENCY" style="width:70px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CURRENCY}" />                                                                        
                      <!--<button onclick="parent.fnOption('iso.currency',160,140,60,-20,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="CURRENCY" style="width:70px;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CURRENCY}" />
                          <!--<button onclick="parent.fnOption('iso.currency',160,140,60,-20,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                            <img alt="" class="blt01" style="margin:0 0 2px 0">
                              <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                            </img>
                          </button>-->
							<button type="button" class="btn btn-outline-secondary btn-18 mr-1" title="통화" onclick="_zw.formEx.optionWnd('iso.currency',220,274,-130,0,'etc','CURRENCY');">
								<i class="fas fa-angle-down"></i>
							</button>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CURRENCY))" />&nbsp;&nbsp;
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOSSSUM" style="width:154px" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/LOSSSUM}" />                                   
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="LOSSSUM" style="width:154px" class="txtDollar" maxlength="20" data-inputmask="number;16;4" value="{//forminfo/maintable/LOSSSUM}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOSSSUM))" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-bottom:0">MAKER 소재</td>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="MAKER" class="txtText" maxlength="50" value="{//forminfo/maintable/MAKER}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <input type="text" id="__mainfield" name="MAKER" class="txtText" maxlength="50" value="{//forminfo/maintable/MAKER}" />
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/MAKER))" />
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <tr>
                <td class="f-lbl" style="border-bottom:0;border-right:0">손실개요</td>
              </tr>
            </table>
          </div>
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
                    <!--<iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx"></iframe>-->
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
                <!--<iframe id="ifrWebEditor" frameborder="0" width="100%" height="100%" marginheight="0" marginwidth="0" scrolling="no" src="/{$root}/EA/External/Editor_tagfree.aspx"></iframe>-->
				  <div class="h-100" id="__DextEditor"></div>
              </xsl:otherwise>
            </xsl:choose>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-right:0">손실해당금액에 대한 내부 귀책 구분 검토 [경영지원팀 작성]</td>
              </tr>
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $mode='reuse'">
                      <div name="REASON" id="__mainfield" style="min-height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                      </div>
                    </xsl:when>
                    <xsl:when test="$bizrole='receive' and $actrole='__r'">
                      <textarea id="__mainfield" name="REASON" style="min-height:60px" class="txaText bootstrap-maxlength" maxlength="500">
                        <xsl:value-of select="//forminfo/maintable/REASON" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REASON" style="min-height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl">결정 부서 검토</td>
                <td style="border-right:0">
                  &nbsp;&nbsp;※ 손실이 품질문제인 경우는 본사 품질보증팀, 그외 문제는 경영지원팀
                  <!--<span class="f-option">
                    <input type="checkbox" id="ckb11" name="ckbLOSSKIND" value="Y">
                      <xsl:if test="$bizrole='application' and $actrole='_manager'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbLOSSKIND', this, 'LOSSKIND');</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LOSSKIND),'Y')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$bizrole!='application' or $actrole!='_manager'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb11">품질문제 - 총괄QA</label>
                  </span>
                  <span class="f-option">
                    <input type="checkbox" id="ckb12" name="ckbLOSSKIND" value="N">
                      <xsl:if test="$bizrole='application' and $actrole='_manager'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbLOSSKIND', this, 'LOSSKIND');</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/LOSSKIND),'N')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$bizrole!='application' or $actrole!='_manager'">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                    <label for="ckb12">이외 손실 - 경영지원팀</label>
                  </span>
                  <input type="hidden" id="__mainfield" name="LOSSKIND">
                    <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/LOSSKIND"></xsl:value-of></xsl:attribute>
                  </input>-->
                </td>
              </tr>
              <tr>
                <td colspan="2"  style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $mode='reuse'">
                      <div name="OPINION1" id="__mainfield" style="min-height:100px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                      </div>
                    </xsl:when>
                    <xsl:when test="($bizrole='receive' and $actrole='__r') or ($bizrole='application' and $actrole='__r')">
                      <textarea name="OPINION1" id="__mainfield" style="min-height:100px" class="txaText bootstrap-maxlength" maxlength="2000">
                        <xsl:value-of select="//forminfo/maintable/OPINION1" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="OPINION1" id="__mainfield" style="height:min-100px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/OPINION1))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">귀책 부서</td>
                <td style="border-right:0;border-bottom:0">&nbsp;&nbsp;※ 재발방지대책서 첨부</td>
              </tr>
              
              <!--<tr>
                <td colspan="2" style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit' or $mode='reuse'">
                      <div name="OPINION2" id="__mainfield" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                      </div>
                    </xsl:when>
                    <xsl:when test="$bizrole='gwichaek' and $actrole='_confirmor'">
                      <textarea name="OPINION2" id="__mainfield" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:value-of select="//forminfo/maintable/OPINION2" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="OPINION2" id="__mainfield" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:replaceTextArea(string(//forminfo/maintable/OPINION2))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>-->
            </table>
          </div>

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" style="border-bottom:0">
              <tr>
                <td class="f-lbl4" style="width:8%">구분</td>
                <td class="f-lbl4" style="width:30%">소속 / 성 명</td>
                <td class="f-lbl4" style="width:10%">결재일자</td>
                <td class="f-lbl4" style="width:52%;border-right:0">의 견</td>
              </tr>
              <xsl:apply-templates select="//processinfo/signline/lines/line[@bizrole='gwichaek' and @partid!='' and @step!='0' and @viewstate!='6' and @actrole!='__r']">
                <xsl:sort select="@parent" />
                <xsl:sort select="@step" />
              </xsl:apply-templates>
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

  <xsl:template match="//processinfo/signline/lines/line">
    <tr>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(@actrole),'_redrafter')">담당</xsl:when>
          <xsl:when test="phxsl:isEqual(string(@actrole),'_approver')">승인</xsl:when>
          <xsl:otherwise>검토</xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part1))"/>/<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(part5))"/>/<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(partname))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(@completed))"/>
      </td>
      <td style="border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(comment))"/>
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