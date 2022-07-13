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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:15%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:?}
          .m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
          .m .ft-sub .f-option {width:49%}

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
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '4', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:320px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '4', '수신부서')"/>
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

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" rowspan="3">
                  신청자
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <!--<button onclick="parent.fnOrgmap('ur','N');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">/<xsl:value-of select="$root"/>/EA/Images/ico_28.gif</xsl:attribute>
                      </img>
                    </button>-->
					  <button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="신청자" onclick="_zw.fn.org('user','n');">
						  <i class="fas fa-angle-down"></i>
					  </button>
                  </xsl:if>
                </td>
                <td class="f-lbl1">소속</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTCORP" style="width:45%" class="txtText_u" readonly="readonly" value="{//creatorinfo/belong}" />                        
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTCORP" style="width:45%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/APPLICANTCORP}" />                                              
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTCORP))" />
                    </xsl:otherwise>
                  </xsl:choose>.
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT" style="width:45%" class="txtText_u" readonly="readonly" value="{//creatorinfo/department}" />                        
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTDEPT" style="width:45%" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/APPLICANTDEPT}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">직위</td>
                <td style="width:25%;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTGRADE" class="txtText_u" readonly="readonly" value="{//creatorinfo/grade}" />                      
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTGRADE" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/APPLICANTGRADE}" />                      
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTGRADE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">성명</td>
                <td colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANT" class="txtText_u" readonly="readonly" value="{//creatorinfo/name}" />                      
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANT" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/APPLICANT}" />                                              
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">
                  <a id="gg" onclick="parent.fnOption('report.REGISTER_LEAVE',400,70,20,90,'','gg');">
                    사번
                  </a>
                </td>
                <td style="width:;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO" class="txtText_u" readonly="readonly" value="{//creatorinfo/empno}" />                      
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/APPLICANTEMPNO}" />                                              
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="APPLICANTID" value="{//creatorinfo/@uid}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="hidden" id="__mainfield" name="APPLICANTID" value="{//forminfo/maintable/APPLICANTID}" />                      
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">입사일</td>
                <td colspan="4" style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="ENTERDATE" class="txtText_u" readonly="readonly" value="{//creatorinfo/indate}" />
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="ENTERDATE" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/ENTERDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENTERDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="4" style="border-bottom:0">경&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;조</td>
                <td class="f-lbl1" rowspan="2">경조사<br>발생일</br>
                </td>
                <td rowspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="REQUESTDATE" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/REQUESTDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/REQUESTDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl" rowspan="2">경조금 및 화환</td>
                <td class="f-lbl1">경조금</td>
                <td style="border-right:0">                  
                  <xsl:choose>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="CELMONEYCOM" style="width:70px" class="txtText" value="{//forminfo/maintable/CELMONEYCOM}" />원
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="CELMONEYCOM" style="width:70px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CELMONEYCOM}" />원
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">화환</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$bizrole='receive' and $actrole='__r' and $partid!=''">
                      <input type="text" id="__mainfield" name="CELMONEY" style="width:70px" class="txtText"  value="{//forminfo/maintable/CELMONEY}" />원
                    </xsl:when>
                    <xsl:otherwise>
                      <input type="text" id="__mainfield" name="CELMONEY" style="width:70px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CELMONEY}" />원
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1">경조 구분</td>
                <td >
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="CELTYPE" style="width:30px;font-size:12px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CELTYPE}" />,
                      <input type="text" id="__mainfield" name="CELDETAIL" style="width:110px;font-size:12px" class="txtText_u" readonly="readonly" value="{//forminfo/maintable/CELDETAIL}" />
                      <input type="hidden" id="__mainfield" name="CELCLASS" value="{//forminfo/maintable/CELCLASS}" />
                      <!--<button onclick="parent.fnOption('external.conclassify',600,430,230,300,'','CELDETAIL','CELCLASS','CELTYPE','CELMONEYCOM','CELMONEY');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                        <img alt="" class="blt01" style="margin:0 0 2px 0">
                          <xsl:attribute name="src">
                            /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                          </xsl:attribute>
                        </img>
                      </button>-->
						<button type="button" class="btn btn-outline-secondary btn-18" title="경조 규정" onclick="_zw.formEx.optionWnd('external.conclassify',600,430,230,300,'','CELDETAIL','CELCLASS','CELTYPE','CELMONEYCOM','CELMONEY');">
							<i class="fas fa-angle-down"></i>
						</button>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CELTYPE))" />,
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/CELDETAIL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl1">구체적 관계</td>
                <td style="border-right:0" colspan="2">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DETAILRELATE" class="txtText" value="{//forminfo/maintable/DETAILRELATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DETAILRELATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
              <td class="f-lbl1" style="border-bottom:0">경조<br>휴가기간</br>
            </td>
              <td colspan="4" style="border-right:0;border-bottom:0" >
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="text" id="__mainfield" name="VACATIONDATE" class="txtText" value="{//forminfo/maintable/VACATIONDATE}" />
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/VACATIONDATE))" />
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
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
            <xsl:choose>
              <xsl:when test="$mode='new' or $mode='edit'">
              <tr>
                <td colspan="2" style="border-right:0;height:250px">
                  <span style="width:100%;text-align:left" >
                   - 세부내용 (내부 공지용으로 활용되오니, 정확한 정보를 기입하여 주시기 바랍니다.) <br></br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 예시) 장소 : 정확하고 구체적인 주소 기입<br></br>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;전화 : 휴대전화 / 장소 전화번호 기입<br></br>
                    - 청첩장, 초정장 등 증빙 첨부(단,조사는 사후제출가능)<br></br>
                    <font color="red">
                      - 휴가기간은 경조사 발생일 부터 적용되며, 경조 기간 동안 휴일이 있는 경우 최대 1일이 가산됩니다.<br></br>
                    </font>                 
                    - 경조일은 행사가 있는 경우 행사당일을 표기하시기 바랍니다.<br></br>
                    - 경조장소가 정해지지 않았을 경우 인사총무팀으로 추후 확정된 장소를 전달바랍니다.<br></br><br></br>
                    <font size="3">
                     <b>
                       &nbsp;부모님,본인,배우자,자녀의 결혼 또는 사망시 경조비는 인사총무팀에서 전표 처리하며<br></br>
                       &nbsp;기타 경조비는 본인 또는 해당팀에서 전표처리 바랍니다.                       
                     </b>
                   </font><br></br>
                   
                 </span>
                </td>
              </tr>
              </xsl:when>
            </xsl:choose>
              <tr>
                <td class="f-lbl">경&nbsp;&nbsp;조&nbsp;&nbsp;일</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EVENTDATE" style="width:150px" class="datepicker txtDate" maxlength="10" data-inputmask="date;yyyy-MM-dd" value="{//forminfo/maintable/EVENTDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EVENTDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                
                
                <!--<td style="border-right:0">                  
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="EVENTDATE" style="width:150px"  class="txtText_u" readonly="readonly" value="{//forminfo/maintable/EVENTDATE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/EVENTDATE))" />
                    </xsl:otherwise>
                  </xsl:choose>-->

                  &nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield" name="DAY" class="form-control d-inline-block" style="width: 100px">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'월요일')">
                            <option value="월요일" selected="selected">월요일</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="월요일">월요일</option>
                          </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'화요일')">
                              <option value="화요일" selected="selected">화요일</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="화요일">화요일</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'수요일')">
                              <option value="수요일" selected="selected">수요일</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="수요일">수요일</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'목요일')">
                              <option value="목요일" selected="selected">목요일</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="목요일">목요일</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'금요일')">
                              <option value="금요일" selected="selected">금요일</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="금요일">금요일</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'토요일')">
                              <option value="토요일" selected="selected">토요일</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="토요일">토요일</option>
                            </xsl:otherwise>
                          </xsl:choose>
                          <xsl:choose>
                            <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/DAY),'일요일')">
                              <option value="일요일" selected="selected">일요일</option>
                            </xsl:when>
                            <xsl:otherwise>
                              <option value="일요일">일요일</option>
                            </xsl:otherwise>
                          </xsl:choose>
                        </select>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/DAY))" />
                      </xsl:otherwise>
                    </xsl:choose>
                  &nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <select id="__mainfield"  name="AMPM" class="form-control d-inline-block" style="width: 80px">
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/AMPM),'')">
                            <option value="" selected="selected">선택</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="">선택</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/AMPM),'오전')">
                            <option value="오전" selected="selected">오전</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="오전">오전</option>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                          <xsl:when test="phxsl:isEqual(string(//forminfo/maintable/AMPM),'오후')">
                            <option value="오후" selected="selected">오후</option>
                          </xsl:when>
                          <xsl:otherwise>
                            <option value="오후">오후</option>
                          </xsl:otherwise>
                        </xsl:choose>                        
                      </select>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/AMPM))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  &nbsp;&nbsp;
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TIMEMINUTE" class="txthhmmko" style="width:80px;height:90%" maxlength="10" value="{//forminfo/maintable/TIMEMINUTE}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">tdRead_Center</xsl:attribute>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//forminfo/maintable/TIMEMINUTE))" />
                    </xsl:otherwise>
                  </xsl:choose>                  
                </td>
              </tr>
              <tr>
                <td class="f-lbl">장소(상호)</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLACE" class="txtText" value="{//forminfo/maintable/PLACE}" />                        
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PLACE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="PLACE1" class="txtText" value="{//forminfo/maintable/PLACE1}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/PLACE1))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">전&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;화</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="TEL" class="txtText" value="{//forminfo/maintable/TEL}" />                      
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/TEL))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">축의금 입금계좌<br />(본인 결혼 시)</td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="BANK" class="txtText" value="{//forminfo/maintable/BANK}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/BANK))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">비&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;고</td>
                  <td style="border-right:0;border-bottom:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="REMARK" style="height:60px" class="txaText bootstrap-maxlength" maxlength="2000">
                          <xsl:if test="$mode='edit'">
                            <xsl:value-of select="//forminfo/maintable/REMARK" />
                          </xsl:if>
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div class="txaRead" style="min-height:60px">
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REMARK))" />
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
            <span class="f-option" style="font-size:18px">
              ※ 경조규정 세부내용 <a href=" http://ekp.cresyn.com/storage/cresyn/Files/board/8/경조사비.pdf" target="_blank">바로보기</a>
            </span>
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