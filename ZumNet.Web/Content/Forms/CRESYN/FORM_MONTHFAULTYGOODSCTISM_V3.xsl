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
    <html xmlns:v="urn:schemas-microsoft-com:vml">
      <head>
        <title>전자결재</title>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
        <style type="text/css">
          <xsl:value-of select="phxsl:baseStyle()" />
          /* 화면 넓이, 에디터 높이, 양식명크기 */
          .m {width:1270px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:1pt}
          .m .ft-sub label {font-size:13px}


          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:?} .m .ft .f-lbl2 {width:?}
          .m .ft .f-lbl3 {writing-mode:tb-rl}
          .m .ft .f-option {width:20%} .m .ft .f-option1 {width:38%} .m .ft .f-option2 {width:70px}
          .m .ft-sub .f-option1 {width:35%} .m .ft-sub .f-option2 {width:60%}

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
                      CT(ISM) 불용제품처리기안                      
                  </h1>
                </td>
                <td class="fh-r">&nbsp;</td>
                <input type="hidden" id="__mainfield" name="CORPORATION" value="CT(ISM)">
                </input>
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
                <td style="width:445px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '5', '합의부서', 'N')"/>
                </td>
                <td style="width:85px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
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

          <xsl:choose>
            <xsl:when test="$bizrole='의견' and $partid!=''">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:88px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <textarea id="__mainfield" name="CONTENTS" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CONTENTS" />
                        </xsl:if>
                      </textarea>
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:when test="$bizrole='last' or ($bizrole='의견' and $mode='read')">
              <div class="fm">
                <table class="ft" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td class="f-lbl" style="border-bottom:0;width:88px">
                      기획조정실<br />검토의견
                    </td>
                    <td style="border-right:0;border-bottom:0">
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENTS))" />
                    </td>
                  </tr>
                </table>
              </div>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          

          <div class="fm">
            <span>1. 처리사유</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REASON" style="height:40px" class="txaText" onkeyup="parent.checkTextAreaLength(this, 500);">
                        <xsl:value-of select="//forminfo/maintable/REASON" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="REASON" class="txaRead" style="height:40px">
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

          <div class="fm" style="text-align:left">
            <span style="width:100px">2. 발생기간</span>
            <span style="width:300px;border:0 solid red">
              (&nbsp;<xsl:choose>
              <xsl:when test="$mode='new'">
                <input type="text" id="__mainfield" name="STATSYEAR" style="width:50px" class="txtYear" maxlength="4" value="{substring(string(//docinfo/createdate),1,4)}" />
              </xsl:when>
              <xsl:when test="$mode='edit'">
                <input type="text" id="__mainfield" name="STATSYEAR" style="width:50px" class="txtYear" maxlength="4" value="{//forminfo/maintable/STATSYEAR}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
              </xsl:otherwise>
            </xsl:choose>&nbsp;)&nbsp;년&nbsp;&nbsp;
              (&nbsp;<xsl:choose>
              <xsl:when test="$mode='new'">
                <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px" class="txtMonth" maxlength="2" value="{phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))}" />
              </xsl:when>
              <xsl:when test="$mode='edit'">
                <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px" class="txtMonth" maxlength="2" value="{//forminfo/maintable/STATSMONTH}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
              </xsl:otherwise>
            </xsl:choose>&nbsp;)&nbsp;월
            </span>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm" style="text-align:left">
            <span style="width:30%">3. 생산 자재금액 대비 작불 자재금액 비율</span>
            <span style="width:30%;text-align:center;padding-right:4px">
              통화&nbsp;:&nbsp;
              (&nbsp;<xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <input type="text" id="__mainfield" name="CURRENCY" class="txtRead" readonly="readonly" style="width:40px" value="USD" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="//forminfo/maintable/CURRENCY" />
                </xsl:otherwise>
              </xsl:choose>&nbsp;)
            </span>
            <span style="width:40%">&nbsp;</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table  border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:50%">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td class="f-lbl" style="width:200px">당월 생산 사용 자재금액</td>
                      <td class="f-lbl" style="width:200px">당월 작업불량 자재금액</td>
                      <td class="f-lbl" style="width:300px;border-right:0">생산 자재금액 대비 작불 자재금액 비율</td>
                    </tr>
                    <tr>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="BUYSUM" class="txtDollar" value="{//forminfo/maintable/BUYSUM}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of select="//forminfo/maintable/BUYSUM" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <input type="text" id="__mainfield" name="OCCURSUMQ" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/OCCURSUMQ}" />
                      </td>
                      <td style="border-bottom:0;border-right:0">
                        <input type="text" id="__mainfield" name="RATE1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/RATE1}" />
                      </td>
                    </tr>
                  </table>
                </td>
                <td style="width:50%">&nbsp;</td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>4. 작업불량 및 불용재고 발생내역</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table border="0" cellspacing="0" cellpadding="0">
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td>
                      <span>
                        4-1 작업불량 창고(WRB, DISUSE)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <button onclick="parent.fnAddChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable1');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        4-1 작업불량 창고(WRB, DISUSE)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
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
                      <col width="25px"></col>
                      <col width="150px"></col>
                      <col width="60px"></col>
                      <col width="150px"></col>
                      <col width="50px"></col>
                      <col width="150px"></col>
                      <col width="60px"></col>
                      <col width="60px"></col>                                                             
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="80px"></col>
                      <col width="100px"></col>
                      <col width="100px"></col>
                      <col width="150px"></col>                      
                      <col width="100px"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">NO</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">모델명</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">화소</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품목</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">수율</td>                      
                      <td class="f-lbl-sub" style="border-top:0" colspan="2" >당월발생수량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2" >당월발생금액</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2" >작업불량공수손실</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">당월매출액</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">매출액<br />대비율</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2" >당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" >실제수율</td>
                      <td class="f-lbl-sub" >계약수율</td>
                      <td class="f-lbl-sub" >실제발생수량</td>
                      <td class="f-lbl-sub" >수율감안시수량</td>
                      <td class="f-lbl-sub" >실제발생금액</td>
                      <td class="f-lbl-sub" >수율감안시금액</td>
                      <td class="f-lbl-sub" >공수</td>
                      <td class="f-lbl-sub" >금액</td>
                      <td class="f-lbl-sub" >수량</td>
                      <td class="f-lbl-sub" >금액</td>
                    </tr>                    
                    <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                    <tr>
                      <td colspan="8" class="f-lbl-sub">TOTAL</td>                  
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBCNT2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBCNT4" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBCNT4}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBCNT4))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBSUM0" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBSUM0}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBSUM0))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">                      
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBSUM1" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTLOSSGONGSU" class="txtDollar" value="{//forminfo/maintable/TOTLOSSGONGSU}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTLOSSGONGSU))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTLOSSMONEY" class="txtDollar" value="{//forminfo/maintable/TOTLOSSMONEY}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTLOSSMONEY))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        &nbsp;                        
                      </td>
                      <td style="border-bottom:0">
                        &nbsp;
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>                      
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WRBSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WRBSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WRBSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>                     
                      <td colspan="2" style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
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
                    <td>
                      <span>
                        4-2 자재 불용재고 창고(WAR)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        4-2 자재 불용재고 창고(WAR)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable2" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="2%"></col>
                      <col width="15%"></col>
                      <col width="12%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="6%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="11%"></col>
                      <col width="10%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                    <tr>
                      <td colspan="3" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARCNT1" class="txtDollar" value="{//forminfo/maintable/WARCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARCNT2" class="txtDollar" value="{//forminfo/maintable/WARCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARSUM1" class="txtDollar" value="{//forminfo/maintable/WARSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WARCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WARSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WARSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WARSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
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
                    <td>
                      <span>
                        4-3 반제품 불용재고 창고(WAS)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <button onclick="parent.fnAddChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        4-3 반제품 불용재고 창고(WAS)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable3" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="2%"></col>
                      <col width="15%"></col>
                      <col width="12%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="6%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="11%"></col>
                      <col width="10%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
                    <tr>
                      <td colspan="3" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASCNT1" class="txtDollar" value="{//forminfo/maintable/WASCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASCNT2" class="txtDollar" value="{//forminfo/maintable/WASCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASSUM1" class="txtDollar" value="{//forminfo/maintable/WASSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WASCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WASSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WASSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WASSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
                    </tr>
                  </table>
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
                    <td>
                      <span>
                        4-4 완제품 불용재고 창고(WAF)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                      <button onclick="parent.fnAddChkRow('__subtable4');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_26.gif" />추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable4');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01" src="/{//config/@root}/EA/Images/ico_27.gif" />삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <span>
                        4-4 완제품 불용재고 창고(WAF)
                      </span>
                    </td>
                    <td class="fm-button">
                      통화&nbsp;:&nbsp;(&nbsp;USD&nbsp;)&nbsp;
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td>
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <table id="__subtable4" class="ft-sub" header="2" border="0" cellspacing="0" cellpadding="0">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col width="2%"></col>
                      <col width="15%"></col>
                      <col width="12%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="6%"></col>
                      <col width="9%"></col>
                      <col width="9%"></col>
                      <col width="11%"></col>
                      <col width="10%"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">작업장구분</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">품류</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">기존재고량</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월발생</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">발생원인</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">당월처리계획</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">처리방안</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" rowspan="2">비고</td>
                    </tr>
                    <tr style="height:24px">
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                      <td class="f-lbl-sub">수량</td>
                      <td class="f-lbl-sub">금액</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable4/row"/>
                    <tr>
                      <td colspan="3" class="f-lbl-sub">TOTAL</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFCNT1" class="txtDollar" value="{//forminfo/maintable/WAFCNT1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFCNT1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFCNT2" class="txtDollar" value="{//forminfo/maintable/WAFCNT2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFCNT2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFSUM1" class="txtDollar" value="{//forminfo/maintable/WAFSUM1}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFSUM1))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFCNT3" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WAFCNT3}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFCNT3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-bottom:0">
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="WAFSUM2" class="txtRead_Right" readonly="readonly" value="{//forminfo/maintable/WAFSUM2}" />
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/WAFSUM2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>&nbsp;</td>
                      <td style="border-bottom:0;border-right:0">&nbsp;</td>
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
            <span>5. 특기사항</span>
          </div>

          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 1000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="DESCRIPTION" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <xsl:if test="//linkeddocinfo/linkeddoc or //fileinfo/file">
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

        <!-- Hidden Field -->
        <input type="hidden" id="__mainfield" name="COERPID" value="{//forminfo/maintable/COERPID}" />
        <input type="hidden" id="__mainfield" name="COERPSUBID" value="{//forminfo/maintable/COERPSUBID}" />

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
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS1" class="txtText" maxlength="50" value="{CTCLASS1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <select name="DTCLASS1" style="">
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DTCLASS1),'')">
                  <option value="" selected="selected">선택</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="">선택</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DTCLASS1),'내부')">
                  <option value="내부" selected="selected">내부</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="내부">내부</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DTCLASS1),'외부')">
                  <option value="외부" selected="selected">외부</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="외부">외부</option>
                </xsl:otherwise>
              </xsl:choose>
            </select>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DTCLASS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MODELNM" class="txtText" value="{MODELNM}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MODELNM))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PIXEL" class="txtText" value="{PIXEL}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PIXEL))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS1" class="txtText" maxlength="50" value="{ITEMCLASS1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SURATE11" class="txtText" maxlength="50" value="{SURATE11}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SURATE11))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SURATE21" class="txtText" maxlength="50" value="{SURATE21}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SURATE21))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT12" class="txtDollar" maxlength="50" value="{COUNT12}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COUNT12))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT14" class="txtDollar" maxlength="50" value="{COUNT14}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COUNT14))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM10" class="txtDollar" maxlength="50" value="{SUM10}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUM10))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM11" class="txtDollar" maxlength="50" value="{SUM11}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUM11))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        &nbsp;
      </td>
      <td>
        &nbsp;
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="POSTOS1" class="txtDollar" maxlength="50" value="{POSTOS1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(POSTOS1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="POSTOS2" class="txtText_u" readonly="readonly" style="text-align:center"   maxlength="50" value="{POSTOS2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(POSTOS2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT13" class="txtDollar" maxlength="50" value="{COUNT13}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(COUNT13))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM12" class="txtDollar" maxlength="50" value="{SUM12}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(SUM12))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>           
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD1" id="ckb.{ROWSEQ}.11" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD1', this, 'METHOD1')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD1),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD1),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.11">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD1" id="ckb.{ROWSEQ}.12" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD1', this, 'METHOD1')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD1),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD1),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.12">대금회수</label>
        </span>
        <input type="hidden" name="METHOD1" value="{METHOD1}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC1" class="txtText" maxlength="50" value="{ETC1}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC1))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS2" class="txtText" maxlength="50" value="{CTCLASS2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS2" class="txtText" maxlength="50" value="{ITEMCLASS2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE2" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE2}" />
            <button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT23" class="txtCurrency" maxlength="20" value="{COUNT23}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT23))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM22" class="txtDollar" maxlength="20" value="{SUM22}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM22))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD2" id="ckb.{ROWSEQ}.21" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD2', this, 'METHOD2')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD2),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD2),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.21">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD2" id="ckb.{ROWSEQ}.22" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD2', this, 'METHOD2')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD2),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD2),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.22">대금회수</label>
        </span>
        <input type="hidden" name="METHOD2" value="{METHOD2}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC2" class="txtText" maxlength="50" value="{ETC2}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC2))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable3/row">
    <tr class="sub_table_row">
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS3" class="txtText" maxlength="50" value="{CTCLASS3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS3" class="txtText" maxlength="50" value="{ITEMCLASS3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE3" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE3}" />
            <button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT33" class="txtCurrency" maxlength="20" value="{COUNT33}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT33))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM32" class="txtDollar" maxlength="20" value="{SUM32}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM32))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD3" id="ckb.{ROWSEQ}.31" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD3', this, 'METHOD3')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD3),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD3),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.31">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD3" id="ckb.{ROWSEQ}.32" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD3', this, 'METHOD3')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD3),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD3),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.32">대금회수</label>
        </span>
        <input type="hidden" name="METHOD3" value="{METHOD3}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC3" class="txtText" maxlength="50" value="{ETC3}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC3))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable4/row">
    <tr class="sub_table_row">
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="checkbox" name="ROWSEQ" value="{ROWSEQ}" />
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
            <input type="text" name="CTCLASS4" class="txtText" maxlength="50" value="{CTCLASS4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CTCLASS4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ITEMCLASS4" class="txtText" maxlength="50" value="{ITEMCLASS4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ITEMCLASS4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="CAUSE4" style="width:73%" class="txtText_u" readonly="readonly" value="{CAUSE4}" />
            <button onclick="parent.fnOption('external.wastereason',100,120,50,105,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0" src="/{//config/@root}/EA/Images/ico_28.gif" />
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(CAUSE4))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT43" class="txtCurrency" maxlength="20" value="{COUNT43}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT43))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="SUM42" class="txtDollar" maxlength="20" value="{SUM42}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SUM42))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td class="tdRead_Center">
        <span class="f-option1">
          <input type="checkbox" name="ckbMETHOD4" id="ckb.{ROWSEQ}.41" value="폐기">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD4', this, 'METHOD4')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD4),'폐기')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD4),'폐기')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.41">폐기</label>
        </span>
        <span class="f-option2">
          <input type="checkbox" name="ckbMETHOD4" id="ckb.{ROWSEQ}.42" value="대금회수">
            <xsl:if test="$mode='new' or $mode='edit'">
              <xsl:attribute name="onclick">parent.fnTableCheckYN('ckbMETHOD4', this, 'METHOD4')</xsl:attribute>
            </xsl:if>
            <xsl:if test="phxsl:isEqual(string(METHOD4),'대금회수')">
              <xsl:attribute name="checked">true</xsl:attribute>
            </xsl:if>
            <xsl:if test="$mode='read' and phxsl:isDiff(string(METHOD4),'대금회수')">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckb.{ROWSEQ}.42">대금회수</label>
        </span>
        <input type="hidden" name="METHOD4" value="{METHOD4}" />
      </td>
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="ETC4" class="txtText" maxlength="50" value="{ETC4}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(ETC4))" />
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
