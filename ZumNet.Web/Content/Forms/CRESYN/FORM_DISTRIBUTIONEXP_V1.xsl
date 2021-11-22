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
          .m {width:1080px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:4pt}          

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:10%} .m .ft .f-lbl1 {width:12%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:62px}

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
                  <img alt="">
                    <xsl:attribute name="src">
                      <xsl:choose>
                        <xsl:when test="$mode='read'">
                          <xsl:value-of select="//forminfo/maintable/LOGOPATH" />
                        </xsl:when>
                        <xsl:otherwise>
                          /Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" />
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:attribute>
                  </img>
                </td>
                <td class="fh-m">
                  <h1>
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSYEAR" style="width:80px;font-size:19pt">
                          <xsl:attribute name="class">txtYear</xsl:attribute>
                          <xsl:attribute name="maxlength">4</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSYEAR" />
                      </xsl:otherwise>
                    </xsl:choose>년
                    <xsl:choose>
                      <xsl:when test="$mode='new'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:35px;font-size:19pt">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:when test="$mode='edit'">
                        <input type="text" id="__mainfield" name="STATSMONTH" style="width:30px;font-size:19pt">
                          <xsl:attribute name="class">txtMonth</xsl:attribute>
                          <xsl:attribute name="maxlength">2</xsl:attribute>
                          <xsl:attribute name="value">
                            <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                          </xsl:attribute>
                        </input>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="//forminfo/maintable/STATSMONTH" />
                      </xsl:otherwise>
                    </xsl:choose>월 물류비용기안
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
                <td style="width:395px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '5', '작성부서')"/>
                </td>
                <td style="width:50px;font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='agree' and @partid!='' and @step!='0'], '__si_Agree', '3', '합의부서', 'N')"/>
                </td>
                <td style="width:75px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignEdgePart($root, //processinfo/signline/lines/line[@bizrole='confirm' and @partid!='' and @step!='0'], '__si_Confirm', '1', '')"/>
                </td>
                <td style="width:220px;font-size:1px">&nbsp;</td>
                <td style="width:95px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignSerialPart($root, //processinfo/signline/lines/line[@bizrole='last' and @partid!='' and @step!='0'], '__si_Last', '1', '최종승인')"/>
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
                <td style="width:15%;border-bottom:0;border-right:0">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <span>1. 제목</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>                
                <td style="border-right:0;border-bottom:0;">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="Subject" name="__commonfield" class="txtText" maxlength="200" value="{//docinfo/subject}" />
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
            <span>2. 지급사유</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">              
              <tr>                
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PAYREASON" class="txtText" value="{//forminfo/maintable/PAYREASON}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PAYREASON))" />
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
            <span>3. 지급비용</span>
          </div>
          <div class="ff" />
          
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0" >                            
              <tr>
                <td class="f-lbl" style="border-top:0;width:100px;border-bottom:0">통화</td>
                <td style="border-top:0;width:100px;border-bottom:0">
                  <input type="text" id="__mainfield" name="CURRENCY" style="width:80%;height:16px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CURRENCY}" />
                  <xsl:if test="$mode='new' or $mode='edit'">
                  <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                    <img alt="" class="blt01" style="margin:0 0 2px 0">
                      <xsl:attribute name="src">
                        /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                      </xsl:attribute>
                    </img>
                  </button>
                  </xsl:if>
                </td>
                <td class="f-lbl" style="border-top:0;width:100px;border-bottom:0">지급비용</td>
                <td style="border-top:0;width:200px;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PAYMONEY" class="txtDollar" value="{//forminfo/maintable/PAYMONEY}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/PAYMONEY))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" style="border-top:0;border-bottom:0;width:100px">비고</td>
                <td style="border-top:0;border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="ETCTEXT" class="txtText" value="{//forminfo/maintable/ETCTEXT}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/ETCTEXT))" />
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
              <colgroup>
                <col style="width:100px"></col>
                <col style="width:910px"></col>
              </colgroup>
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">                  
                  <tr>
                    <td style="">
                      <span>4. 지급내역</span>
                    </td>
                    <td class="fm-button">
                      통화 :
                      <input type="text" id="__mainfield" name="CURRENCY2" style="width:70px;height:16px">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/CURRENCY2" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnOption('iso.currency',160,140,10,115,'etc','CURRENCY2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                      &nbsp; USD 적용환율 :
                      <input type="text" id="__mainfield" name="EXCHANGERATE" style="width:80px;height:20px">
                        <xsl:attribute name="class">txtDollar</xsl:attribute>                        
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/EXCHANGERATE" />
                        </xsl:attribute>
                      </input>&nbsp;&nbsp;
                      <input type="text" id="__mainfield" name="TYPE1" class="txtText_u" readonly="readonly" style="width:70px"   value="{//forminfo/maintable/TYPE1}" />
                        &nbsp;:&nbsp;
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
                      </button>
                      &nbsp;&nbsp;
                      <input type="text" id="__mainfield" name="TYPE2" class="txtText_u" readonly="readonly" style="width:70px"   value="{//forminfo/maintable/TYPE2}" />&nbsp;:&nbsp;
                      <button onclick="parent.fnAddChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable2');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td style="width:1200px" >
                      <span>4. 지급내역</span>
                    </td>
                    <td style="text-align:right">
                      <span>통화 :
                      <input type="text" id="__mainfield" name="CURRENCY2" class="txtText_u" readonly="readonly" style="width:70px"   value="{//forminfo/maintable/CURRENCY2}" />
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; USD 적용환율 :                      
                      <input type="text" id="__mainfield" name="EXCHANGERATE" class="txtText_u" readonly="readonly" style="width:70px"   value="{//forminfo/maintable/EXCHANGERATE}" />
                      &nbsp;&nbsp;
                      </span>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td colspan="2">
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2"  style="">
                  <table class="ft-sub" border="0" cellspacing="0" cellpadding="0">
                    <colgroup>
                      <col style="width:40px"></col>
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <col style="width:25px"></col>
                          <col style="width:130px"></col>
                        </xsl:when>
                        <xsl:otherwise>
                          <col style="width:155px"></col>
                        </xsl:otherwise>
                      </xsl:choose>
                      <col style="width:55px"></col>
                      <col style="width:90px"></col>
                      <col style="width:90px"></col>
                      <col style="width:90px"></col>
                      <col style="width:70px"></col>
                      <col style="width:90px"></col>
                      <col style="width:90px"></col>
                      <col style="width:140px"></col>
                      <col style="width:px"></col>                     
                    </colgroup>
                    <tr>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">구분</td>
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <td class="f-lbl-sub" style="border-top:0" rowspan="2">&nbsp;</td>
                      </xsl:if>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">비용항목</td>
                      <td class="f-lbl-sub" style="border-top:0" rowspan="2">건수</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">지급비용</td>
                      <td class="f-lbl-sub" style="border-top:0;" rowspan="2">USD환산</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">매출입액 대비 물류비율</td>
                      <td class="f-lbl-sub" style="border-top:0" colspan="2">전월대비 증감율(%)</td>
                      <td class="f-lbl-sub" style="border-top:0;border-right:0" colspan="2">지급조건</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub">매출입액<br />(USD)</td>
                      <td class="f-lbl-sub">물류비율<br />(%)</td>
                      <td class="f-lbl-sub">물류비</td>
                      <td class="f-lbl-sub">매출입액</td>
                      <td class="f-lbl-sub">지급처</td>
                      <td class="f-lbl-sub" style="border-right:0">결재조건</td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub" style="width:50px">                       
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" name="DOCSECURE3" style="width:60%"  id="__mainfield" >
                              <xsl:attribute name="class">txtText_u</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="DOCSECURE3" />
                              </xsl:attribute>
                            </input>
                            <button onclick="parent.fnOption('external.distributionexp2',140,130,100,100,'etc','DOCSECURE3');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0">
                                <xsl:attribute name="src">
                                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                                </xsl:attribute>
                              </img>
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCSECURE3))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="11" style="border-top:0;border-right:0;padding:0;">
                        <table id="__subtable1" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="border:0;table-layout:">
                          <colgroup>                            
                            <xsl:choose>
                              <xsl:when test="$mode='new' or $mode='edit'">
                                <col style="width:25px"></col>
                                <col style="width:130px"></col>
                              </xsl:when>
                              <xsl:otherwise>
                                <col style="width:155px"></col>
                              </xsl:otherwise>
                            </xsl:choose>
                            <col style="width:55px"></col>
                            <col style="width:90px"></col>
                            <col style="width:90px"></col>
                            <col style="width:90px"></col>
                            <col style="width:70px"></col>
                            <col style="width:90px"></col>
                            <col style="width:90px"></col>
                            <col style="width:140px"></col>
                            <col style="width:px"></col>
                          </colgroup>
                          <xsl:apply-templates select="//forminfo/subtables/subtable1/row"/>
                          <tr>
                            <xsl:choose>
                              <xsl:when test="$mode='new' or $mode='edit'">
                                <td class="f-lbl-sub" colspan="2" style="">
                                  SUB-TOTAL
                                </td>
                              </xsl:when>
                              <xsl:otherwise>
                                <td class="f-lbl-sub">
                                  SUB-TOTAL
                                </td>
                              </xsl:otherwise>
                            </xsl:choose>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBONECOUNT">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONECOUNT" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONECOUNT))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBONEPRICE">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONEPRICE" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONEPRICE))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBONEUSDPRICE">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONEUSDPRICE" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONEUSDPRICE))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBONEUSDEARN">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONEUSDEARN" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONEUSDEARN))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBONEUSDDISPER">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONEUSDDISPER" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONEUSDDISPER))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">                                  
                                  <input type="text" id="__mainfield" name="SUBONEDIS" style="">
                                    <xsl:attribute name="class">txtText</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONEDIS" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONEDIS))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">                                  
                                  <input type="text" id="__mainfield" name="SUBONEEARN" style="">
                                    <xsl:attribute name="class">txtText</xsl:attribute>                                    
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBONEEARN" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBONEEARN))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td style="border-right:0" colspan="2">
                              &nbsp;
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                    <tr>
                      <td class="f-lbl-sub" style="width:50px">
                         <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" name="DOCSECURE2" style="width:60%"  id="__mainfield" >
                              <xsl:attribute name="class">txtText_u</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="DOCSECURE2" />
                              </xsl:attribute>
                            </input>
                            <button onclick="parent.fnOption('external.distributionexp2',140,130,100,100,'etc','DOCSECURE2');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                              <img alt="" class="blt01" style="margin:0 0 2px 0">
                                <xsl:attribute name="src">
                                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                                </xsl:attribute>
                              </img>
                            </button>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DOCSECURE2))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td colspan="11" style="border-top:0;border-right:0;padding:0">
                        <table id="__subtable2" class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="border:0">
                          <colgroup>                            
                            <xsl:choose>
                              <xsl:when test="$mode='new' or $mode='edit'">
                                <col style="width:25px"></col>
                                <col style="width:130px"></col>
                              </xsl:when>
                              <xsl:otherwise>
                                <col style="width:155px"></col>
                              </xsl:otherwise>
                            </xsl:choose>
                            <col style="width:55px"></col>
                            <col style="width:90px"></col>
                            <col style="width:90px"></col>
                            <col style="width:90px"></col>
                            <col style="width:70px"></col>
                            <col style="width:90px"></col>
                            <col style="width:90px"></col>
                            <col style="width:140px"></col>
                            <col style="width:px"></col>
                          </colgroup>
                          <xsl:apply-templates select="//forminfo/subtables/subtable2/row"/>
                          <tr>
                            <xsl:choose>
                              <xsl:when test="$mode='new' or $mode='edit'">
                                <td class="f-lbl-sub" colspan="2">
                                  SUB-TOTAL
                                </td>
                              </xsl:when>
                              <xsl:otherwise>
                                <td class="f-lbl-sub" >
                                  SUB-TOTAL
                                </td>
                              </xsl:otherwise>
                            </xsl:choose>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBTWOCOUNT">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWOCOUNT" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWOCOUNT))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBTWOPRICE">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWOPRICE" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWOPRICE))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBTWOUSDPRICE">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWOUSDPRICE" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWOUSDPRICE))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBTWOUSDEARN">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWOUSDEARN" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWOUSDEARN))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">
                                  <input type="text" id="__mainfield" name="SUBTWOUSDDISPER">
                                    <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                                    <xsl:attribute name="readonly">readonly</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWOUSDDISPER" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWOUSDDISPER))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">                                  
                                  <input type="text" id="__mainfield" name="SUBTWODIS" style="">
                                    <xsl:attribute name="class">txtText</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWODIS" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWODIS))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td>                           
                              <xsl:choose>
                                <xsl:when test="$mode='new' or $mode='edit'">                                  
                                  <input type="text" id="__mainfield" name="SUBTWOEARN" style="">
                                    <xsl:attribute name="class">txtText</xsl:attribute>
                                    <xsl:attribute name="value">
                                      <xsl:value-of select="//forminfo/maintable/SUBTWOEARN" />
                                    </xsl:attribute>
                                  </input>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/SUBTWOEARN))" />
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                            <td style="border-right:0" colspan="2">
                              &nbsp;
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>                                        
                    <tr>
                      <xsl:choose>
                        <xsl:when test="$mode='new' or $mode='edit'">
                          <td class="f-lbl-sub" colspan="3">TOTAL</td>
                        </xsl:when>
                        <xsl:otherwise>
                          <td class="f-lbl-sub" colspan="2">
                            TOTAL
                          </td>
                        </xsl:otherwise>
                      </xsl:choose>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALCOUNT">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALCOUNT" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALCOUNT))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALPRICE">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALPRICE" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALUSDPRICE">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALUSDPRICE" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALUSDPRICE))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALUSDEARN">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALUSDEARN" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALUSDEARN))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">
                            <input type="text" id="__mainfield" name="TOTALUSDDISPER">
                              <xsl:attribute name="class">txtRead_Right</xsl:attribute>
                              <xsl:attribute name="readonly">readonly</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALUSDDISPER" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALUSDDISPER))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">                           
                            <input type="text" id="__mainfield" name="TOTALDIS" style="">
                              <xsl:attribute name="class">txtText</xsl:attribute>                              
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALDIS" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALDIS))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td>
                        <xsl:choose>
                          <xsl:when test="$mode='new' or $mode='edit'">                            
                            <input type="text" id="__mainfield"  name="TOTALEARN" style="">
                              <xsl:attribute name="class">txtText</xsl:attribute>
                              <xsl:attribute name="maxlength">20</xsl:attribute>
                              <xsl:attribute name="value">
                                <xsl:value-of select="//forminfo/maintable/TOTALEARN" />
                              </xsl:attribute>
                            </input>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:attribute name="class">tdRead_Right</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TOTALEARN))" />
                          </xsl:otherwise>
                        </xsl:choose>
                      </td>
                      <td style="border-right:0" colspan="2">
                        &nbsp;
                      </td>
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
            <table border="0" cellspacing="0" cellpadding="0" >
              <xsl:choose>
                <xsl:when test="$mode='new' or $mode='edit'">
                  <tr>
                    <td style="">
                      <span>5. 물류비 증감원인</span>
                    </td>
                    <td class="fm-button" style="">
                      <button onclick="parent.fnAddChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_26.gif
                          </xsl:attribute>
                        </img>추가
                      </button>
                      <button onclick="parent.fnDelChkRow('__subtable3');" onfocus="this.blur()" class="btn_bg">
                        <img alt="" class="blt01">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_27.gif
                          </xsl:attribute>
                        </img>삭제
                      </button>
                    </td>
                  </tr>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td colspan="2" style="">
                      <span>5. 물류비 증감원인</span>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
              <tr>
                <td colspan="2">
                  <div class="ff" />
                </td>
              </tr>
              <tr>
                <td colspan="2" style="">
                  <table id="__subtable3" class="ft-sub" header="1" border="0" cellspacing="0" cellpadding="0" style="">
                    <xsl:if test="$mode='new' or $mode='edit'">
                      <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
                    </xsl:if>
                    <colgroup>
                      <col style="width:35px"></col>
                      <col style="width:150px"></col>
                      <col style="width:px"></col>
                    </colgroup>
                    <tr style="height:24px">
                      <td class="f-lbl-sub" style="border-top:0">NO</td>
                      <td class="f-lbl-sub" style="border-top:0">구분</td>                      
                      <td class="f-lbl-sub" style="border-top:0;border-right:0">증감원인</td>
                    </tr>
                    <xsl:apply-templates select="//forminfo/subtables/subtable3/row"/>
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
            <span>6. 특이사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="ETC" style="height:60px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/ETC" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="ETC" style="height:60px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ETC))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

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
      <xsl:if test="$mode='new' or $mode='edit'">
        <td>
          <input type="checkbox" name="ROWSEQ">
            <xsl:attribute name="value">
              <xsl:value-of select="ROWSEQ" />
            </xsl:attribute>
          </input>
        </td>
      </xsl:if>
      <td style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MONEYTYPE" style="width:85%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MONEYTYPE" />
              </xsl:attribute>
            </input>
            <button onclick="parent.fnOption('external.distributionexp',240,120,100,100,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MONEYTYPE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNT" class="txtdollar2" maxlength="20" value="{COUNT}" />                            
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNT))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
            <input type="text" name="PRICE" style="" class="txtdollar2" maxlength="20" value="{PRICE}" />              
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRICE))" />            
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USDPRICE" style="" class="txtdollar2" maxlength="20" value="{USDPRICE}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USDPRICE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
            <input type="text" name="USDEARN" style="" class="txtdollar2" maxlength="20" value="{USDEARN}" />                            
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USDEARN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USDDISPER" style="" class="txtdollar2" readonly="readonly" value="{USDDISPER}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USDDISPER))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">           
            <input type="text" name="DIS" style="text-align:right;width:90px" class="txtDollarMinus" maxlength="20" value="{DIS}" />                            
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DIS))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">           
            <input type="text" name="EARN" style="text-align:right;width:90px" class="txtDollarMinus" maxlength="20" value="{EARN}" />              
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EARN))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GETPLACE" style="" class="txtText" maxlength="200" value="{GETPLACE}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(GETPLACE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:left;border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PAYCOND" style="" class="txtText" maxlength="200" value="{PAYCOND}" />                            
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PAYCOND))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable2/row">
    <tr class="sub_table_row">
      <xsl:if test="$mode='new' or $mode='edit'">
        <td>
          <input type="checkbox" name="ROWSEQ">
            <xsl:attribute name="value">
              <xsl:value-of select="ROWSEQ" />
            </xsl:attribute>
          </input>
        </td>
      </xsl:if>
      <td style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="MONEYTYPETWO" style="width:85%">
              <xsl:attribute name="class">txtText_u</xsl:attribute>
              <xsl:attribute name="readonly">readonly</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="MONEYTYPETWO" />
              </xsl:attribute>
            </input>
            <button onclick="parent.fnOption('external.distributionexp',240,120,100,100,'etc',this);" onfocus="this.blur()" class="btn_bg" style="height:16px;">
              <img alt="" class="blt01" style="margin:0 0 2px 0">
                <xsl:attribute name="src">
                  /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                </xsl:attribute>
              </img>
            </button>            
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(MONEYTYPETWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="COUNTTWO">
              <xsl:attribute name="class">txtDollar2</xsl:attribute>
              <xsl:attribute name="maxlength">20</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="COUNTTWO" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(COUNTTWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PRICETWO" style="" class="txtDollar2" maxlength="20" value="{PRICETWO}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PRICETWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USDPRICETWO" style="" class="txtDollar2" maxlength="20" value="{USDPRICETWO}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USDPRICETWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USDEARNTWO" style="" class="txtDollar2" maxlength="20" value="{USDEARNTWO}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USDEARNTWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="USDDISPERTWO" style="" class="txtDollar2" readonly="readonly" value="{USDDISPERTWO}" />              
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(USDDISPERTWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">           
            <input type="text" name="DISTWO" style="text-align:right;width:90px" class="txtDollarMinus" maxlength="20" value="{DISTWO}" />              
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(DISTWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:right">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">            
            <input type="text" name="EARNTWO" style="text-align:right;width:90px" class="txtDollarMinus" maxlength="20" value="{EARNTWO}" />              
          </xsl:when>
          <xsl:otherwise>            
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(EARNTWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:left">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="GETPLACETWO" style="" class="txtText" maxlength="200" value="{GETPLACETWO}" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(GETPLACETWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:left;border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="PAYCONDTWO" style="" class="txtText" maxlength="200" value="{PAYCONDTWO}" />                            
          </xsl:when> 
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(PAYCONDTWO))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>
  <xsl:template match="//forminfo/subtables/subtable3/row">
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
            <xsl:attribute name="class">tdRead_Center</xsl:attribute>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(ROWSEQ))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td style="text-align:center">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <select name="DOCSECURE" style="width:140px">
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DOCSECURE),'')">
                  <option value="" selected="selected">선택</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="">선택</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DOCSECURE),'공통')">
                  <option value="공통" selected="selected">공통</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="공통">공통</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DOCSECURE),'수출')">
                  <option value="수출" selected="selected">수출</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="수출">수출</option>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:choose>
                <xsl:when test="phxsl:isEqual(string(DOCSECURE),'수입')">
                  <option value="수입" selected="selected">수입</option>
                </xsl:when>
                <xsl:otherwise>
                  <option value="수입">수입</option>
                </xsl:otherwise>
              </xsl:choose>              
            </select>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(DOCSECURE))" />
          </xsl:otherwise>
        </xsl:choose>
      </td>      
      <td style="border-right:0">
        <xsl:choose>
          <xsl:when test="$mode='new' or $mode='edit'">
            <input type="text" name="REASON">
              <xsl:attribute name="class">txtText</xsl:attribute>
              <xsl:attribute name="maxlength">500</xsl:attribute>
              <xsl:attribute name="value">
                <xsl:value-of select="REASON" />
              </xsl:attribute>
            </input>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(REASON))" />
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
