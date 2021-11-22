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
          .m {width:1100px} .m .fm-editor {height:550px;border:windowtext 1pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:-2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:9%} .m .ft .f-lbl1 {width:2%} .m .ft .f-lbl2 {width:13%} .m .ft .f-lbl3 {width:5%}
          .m .ft .f-option {width:20px} .m .ft .f-option1 {width:50%} .m .ft .f-option2 {width:70%}
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
                <td style="width:325">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:325px">
                   <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '주관부서')"/>
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
                <td style="width:37%">
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


          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0">출장지</td>
                <td style="border-bottom:0;width:37.5%">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="LOCATION" style="width:91%">
                        <xsl:attribute name="class">txtText_u</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/LOCATION" />
                        </xsl:attribute>
                      </input>
                      <button onclick="parent.fnView('external.centercode',300,180,80,140,'etc','LOCATION');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/LOCATION))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>               
                  <td class="f-lbl" style="border-bottom:0">출장예정일</td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EVENTDATE" class="txtDate" style="width:100%" maxlength="8" onclick="parent.fnShowPopSelfCalendar(this, parent.fnCalcValid)" value="{//forminfo/maintable/EVENTDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EVENTDATE))" />
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
            <span>＊공통사항</span>

            <div class="ff" />

            <font color="red" style="text-align:lift">
              <span>
                1. 대사관 휴무일 및 공휴일,주말은 비자발급 소요기간이 연장될 수 있음<br></br>           
                2. 오전 11시 이전 서류전달 시 익일비자진행 가능, 11시 이후 전달시 하루연기됨
              </span>
            </font>
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
                <td class="f-lbl1">체크</td>
                <td class="f-lbl3">비자종류</td>
                <td class="f-lbl2">필요서류</td>
                <td class="f-lbl3">소요기간 구분</td>
                <td class="f-lbl3">제출처</td>
                <td class="f-lbl" style="border-right:0">비고</td>
              </tr>
              <tr>
                <td style="text-align:center;height:130px">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbCHCHECK" value="중국체크2">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHCHECK', this, 'CHCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHCHECK),'중국체크2')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHCHECK),'중국체크2')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>                 
                </td>
                <td style="text-align:center">중국상용단수<br></br>
                  3개월 유효 30일 체류
                </td>
                <td style="text-align:center">
                  여권(6개월 이상 유효), 여권용 사진 1매(규격 3.5x4.5 또는 <br></br>
                  3.3x4.8, 흰색 바탕, 흰색 옷X, 안경 착용X, 여권사진과 같은<br></br>
                  사진인 경우 여권 발급일이 6개월 미만必), 명함 1장, 중국비자신청서(수기작성 후 원본제출)<br></br>
                  <a href=" http://ekp.cresyn.com/storage/cresyn/Files/board/8/2059_중국비자신청서%20신규양식.pdf" target="_blank">중국비자신청서다운로드</a>
                </td>
                <td style="text-align:center" rowspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECK0">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0),'5일일반')">
                            <option value="5일일반" selected="selected">5일(일반)</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="5일일반">5일(일반)</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0),'3일급행)')">
                            <option value="3일급행" selected="selected">3일(급행)</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="3일급행">3일(급행)</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECK0),'2일당일)')">
                            <option value="2일당일" selected="selected">2일(당일)</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="2일당일">2일(당일)</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECK0))" />
                        </xsl:otherwise>
                      </xsl:choose>                   
                </td>
                <td style="text-align:center" rowspan="2">
                  인사총무팀                  
                </td>
                <td style="text-align:center;border-right:0" rowspan="2">중국취업비자의 경우 중국 법인에<br></br>
                  초청장 및 취업허가서 요청 必
                </td>
              </tr>
              <tr>
                <td style="text-align:center;height:60px">
                  <span class="f-option">
                    <input type="checkbox" id="ckb31" name="ckbCHCHECK" value="중국체크">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHCHECK', this, 'CHCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHCHECK),'중국체크')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHCHECK),'중국체크')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="text-align:center">
                  중국상용복수<br></br>
                  1년유효 30일 체류
                </td>
                <td style="text-align:center">
                  여권(13개월 이상 유효),여권용 사진 1매(상용단수와 동일), <br></br>
                  명함1장,중국비자신청서(수기작성 후 원본제출)<br></br>
                  <a href=" http://ekp.cresyn.com/storage/cresyn/Files/board/8/2059_중국비자신청서%20신규양식.pdf" target="_blank">중국비자신청서다운로드</a>
                </td>              
              </tr>
              <tr> 
                <td style="text-align:center;height:50px">
                  <span class="f-option">
                    <input type="checkbox" id="ckb41" name="ckbINCHECK" value="인니체크">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbINCHECK', this, 'INCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/INCHECK),'인니체크')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/INCHECK),'인니체크')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>  
                  </span>
                </td>
                <td style="text-align:center">인도네시아 상용단수<br></br>
                  3개월유효 60일체류
                </td>
                  <td style="text-align:center">여권(6개월이상 유효),여권용사진1매(흰색 바탕),<br></br>
                    명함1장,신분증 앞/뒤 사본
                </td>
                  <td style="text-align:center">7일+(1일)</td>
                  <td style="text-align:center">인사총무팀</td>
                  <td style="text-align:center;border-right:0">상용복수비자의 경우<br></br>
                    인니법인에 초정장 요청 必 
                </td>               
              </tr>
              <tr>
                <td style="text-align:center;height:50px">
                 &nbsp;
                </td>
                <td style="text-align:center">
                  인도네시아 무비자<br></br>
                  30일 체류
                </td>
                <td style="text-align:center">
                 무비자로 출장 진행 가능
                </td>
                <td style="text-align:center">X</td>
                <td style="text-align:center">X</td>
                <td style="text-align:center;border-right:0">
                  긴급 출장용,<br></br>
                  입국심사 시 관광목적이라고 대응 必
                </td>
              </tr>
              <tr>
                <td style="text-align:center;height:60px">
                  <span class="f-option">
                    <input type="checkbox" id="ckb51" name="ckbVJCHECK" value="베트남">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbVJCHECK', this, 'VJCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/VJCHECK),'베트남')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/VJCHECK),'베트남')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="text-align:center">
                  베트남
                  <br></br>
                  <font color="red">1개월단수(관광)</font>
                </td>
                <td style="text-align:center" rowspan="2">
                  <font color="red">여권(6개월이상유효), 여권용사진1매(흰색바탕)<br />, 베트남단수비자신청서</font><br></br>
                  <a href=" http://ekp.cresyn.com/storage/cresyn/Files/board/8/베트남단수비자신청서.pdf" target="_blank">베트남단수비자신청서 다운로드</a>
              </td>
                <td style="text-align:center" rowspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECKDAY">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKDAY),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKDAY),'4일(급행)')">
                            <option value="4일(급행)" selected="selected">4일(급행)</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="4일(급행)">4일(급행)</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKDAY),'5일)')">
                            <option value="5일" selected="selected">5일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="5일">5일</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKDAY),'6일)')">
                            <option value="6일" selected="selected">6일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="6일">6일</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKDAY),'8일)')">
                            <option value="8일" selected="selected">8일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="8일">8일</option>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECKDAY))" />
                    </xsl:otherwise>
                  </xsl:choose>
              </td>
                <td style="text-align:center" rowspan="2">인사총무팀</td>
                <td style="text-align:center;border-right:0" rowspan="2">상용비자 진행 시<br></br> 베트남 법인에 초정장 요청 必<br></br>
                  *복수비자 진행 시 인사총무팀에 요청
              </td>
              </tr>
              <tr>
                <td style="text-align:center;height:60px">
                  <span class="f-option">
                    <input type="checkbox" id="ckb81" name="ckbVTCHECK" value="베트남삼개월">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbVTCHECK', this, 'VTCHECK')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/VTCHECK),'베트남삼개월')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/VTCHECK),'베트남삼개월')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="text-align:center">
                 베트남
                  <br></br>
                  <font color="red">3개월단수(관광)</font>
                </td>               
                <!--<td style="text-align:center">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="CHECKME">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKME),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKME),'11일')">
                            <option value="11일" selected="selected">11일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="11일">11일</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKME),'9일)')">
                            <option value="9일" selected="selected">9일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="9일">9일</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/CHECKME),'7일)')">
                            <option value="7일" selected="selected">7일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="7일">7일</option>
                          </xsl:otherwise>
                        </xsl:choose>
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CHECKME))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>-->              
              </tr>
              <tr>
                <td style="text-align:center;height:60px">
                  &nbsp;
                </td>
                <td style="text-align:center">
                  베트남 무비자<br></br>
                  15일 체류
                </td>
                <td style="text-align:center">
                  무비자로 출장 진행 가능<br />
                  (무비자로 재 입국 시 30일 이후 가능)
                </td>
                <td style="text-align:center">X</td>
                <td style="text-align:center">X</td>
                <td style="text-align:center;border-right:0">
                  무비자로 출장을 다녀온 후 <br></br>
                  30일 이내에 재출장 시 관광비자 신청必
                </td>
              </tr>
              <tr>
                <td style="text-align:center;height:50px">
                  &nbsp;
                </td>
                <td style="text-align:center">미국<br></br>
                  2년 유효 90일 체류
              </td>
                <td style="text-align:center">전자여권<br />
                  <a href=" http://ekp.cresyn.com/storage/cresyn/Files/board/8/22_미국ESTA허가승인작성안내.pdf" target="_blank">미국ESTA허가 승인 작성안내 다운로드</a>
                </td>
                <td style="text-align:center">출국시간 기준 48시간 이전 신청</td>
                <td style="text-align:center">신청자 본인 <br></br>인터넷 접수</td>
                <td style="text-align:center;border-right:0"> 
                  <a href="https://esta.cbp.dhs.gov/esta/application.html?execution=e3s1" target="_blank">미국비자신청서사이트바로가기</a>
                </td>
              </tr>
              <tr>
                <td style="text-align:center;height:50px">
                  &nbsp;
                </td>
                <td style="text-align:center">사증추가</td>
                <td style="text-align:center">여권기재사항 변경 등 신청서, 여권<br />
                  여권에 사증 양 옆면 공백必(추가 사증 붙일 자리)
                </td>
                <td style="text-align:center">당일~1일</td>
                <td style="text-align:center">
                  신청자 본인 직접신청<br></br>(구청or시청)
                </td>
                <td style="text-align:center;border-right:0">
                  담당자 제량에 따라<br></br>
                  일정 조율가능
                </td>
              </tr>
              <tr>
                <td style="text-align:center;height:50px;border-bottom:0">
                  &nbsp;
                </td>
                <td style="text-align:center;border-bottom:0">일본 무비자<br />
                  3개월 체류
                </td>
                <td style="text-align:center;border-bottom:0">
                  무비자로 출장진행 가능
                </td>
                <td style="text-align:center;border-bottom:0">X</td>
                <td style="text-align:center;border-bottom:0">X</td>
                <td style="text-align:center;border-right:0;border-bottom:0">X</td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />
          <div class="ff" />
          <div class="ff" />


          <!--<div class="fm">
            <span>특기사항</span>
          </div>
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DESCRIPTION" style="height:100px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/DESCRIPTION" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div id="__mainfield" name="DESCRIPITON" style="height:100px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DESCRIPTION))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </table>
          </div>-->

          <div class="ff" />
          <div class="ff" />
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

        <!-- Main Table Hidden Field 01 -->
        <input type="hidden" id="__mainfield" name="PACHECK" value="{//forminfo/maintable/PACHECK}" />
        <input type="hidden" id="__mainfield" name="INCHECK" value="{//forminfo/maintable/INCHECK}" />
        <input type="hidden" id="__mainfield" name="VJCHECK" value="{//forminfo/maintable/VJCHECK}" />
        <input type="hidden" id="__mainfield" name="AMCHECK" value="{//forminfo/maintable/AMCHECK}" />
        <input type="hidden" id="__mainfield" name="VICHECK" value="{//forminfo/maintable/VICHECK}" />
        <input type="hidden" id="__mainfield" name="CHCHECK" value="{//forminfo/maintable/CHCHECK}" />
        <input type="hidden" id="__mainfield" name="JPCHECK" value="{//forminfo/maintable/JPCHECK}" />
        <input type="hidden" id="__mainfield" name="VTCHECK" value="{//forminfo/maintable/VTCHECK}" />

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