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
			.fh h1 {font-size:20.0pt;letter-spacing:5pt}

			/* 결재칸 넓이 */
			.si-tbl .si-title {width:20px} .si-tbl .si-bottom {width:75px}

			/* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
			.m .ft .f-lbl {width:18%} .m .ft .f-lbl1 {width:10%} .m .ft .f-lbl2 {width:}
			.m .ft .f-option {width:15%} .m .ft .f-option1 {width:34%}
			.m .ft-sub .f-option {width:49%}

			.m .ft td,.m .ft td span {font-family:맑은 고딕}

			.etctxt{display:none}/*승인문구*/
			/* 인쇄 설정 : 맨하단으로  , 결재권자창 인쇄 시 안보임 */
			@media print {
			.m .fm-editor {height:450px} .fb,.si-tbl,.fh-l img {display:none} .fm-lines {display:none} .m .fh {padding-top:40px} .etctxt{display:block}
			.m .fm .ft-ttl {height: 15rem !important} .m .fm .ft-content {height: 35rem !important; vertical-align: top; padding-top: 5rem} .m .fm .ft-content2 {height: 18rem !important; padding-left: 4rem !important}
			}
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
                  <h1>&nbsp;</h1>
                </td>
                <td class="fh-r">
                  <table class="ft" border="0" cellspacing="0" cellpadding="0" style="height:30px;border:0px solid red">
                    <tr>
                      <td style="width:50%;text-align:right;font-size:15px;border:0">
                        증명 No.  <xsl:value-of select="//forminfo/maintable/CERTINO" />
                      </td>
                      <!--<td style="text-align:right;font-size:14px;border:0">
                       
                      </td>-->
                    </tr>
                  </table>
                </td>
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

          <div class="fb">
            <table border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignPart($root, //processinfo/signline/lines/line[@bizrole='normal' and @partid!='' and @step!='0'], '__si_Normal', '3', '신청부서')"/>
                </td>
                <td style="font-size:1px">&nbsp;</td>
                <td style="width:245px">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:mappingSignRcvPart($root, //processinfo/signline/lines, 'receive', '__si_Receive', '3', '처리부서')"/>
                </td>
              </tr>
            </table>
          </div>

          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $mode='read'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:18%"></col>
                <col style="width:15%"></col>
                <col style="width:49%"></col>
                <col style="width:18%"></col>
              </colgroup>
              <tr style ="display:none">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </tr>
              <tr>
                <td colspan="4" class="ft-ttl" style="text-align:center;vertical-align:middel;border-right:0;font-size:40px;height:140px">
                  Certificate Of Career<br/>
                  (경 력 증 명 서)
                </td>
              </tr>
              <tr>
                <td class="f-lbl2" style="text-align:center;font-size:16; vertical-align:middle;" rowspan="3"  >
                  Personal <br/>Identification <br/>(인적사항)
                  <xsl:if test="$mode='new' or $mode='edit'">
                    <!--<button onclick="parent.fnExternal('report.DOCCAREER',240,80,320,400,'','');" onfocus="this.blur()" class="btn_bg" style="height:16px;">
                      <img alt="" class="blt01" style="margin:0 0 2px 0">
                        <xsl:attribute name="src">
                          /<xsl:value-of select="$root"/>/EA/Images/ico_28.gif
                        </xsl:attribute>
                      </img>
                    </button>-->
					  <!--<button type="button" class="btn btn-outline-secondary btn-18" data-toggle="tooltip" data-placement="bottom" title="인적사항" onclick="_zw.fn.org('user','n');">
						  <i class="fas fa-angle-down"></i>
					  </button>-->
					  <button type="button" class="btn btn-outline-secondary btn-18" title="대상자" onclick="_zw.formEx.externalWnd('report.DOCCAREER',240,40,20,70,'','MODELNAME','ITEMNAME');">
						  <i class="fas fa-angle-down"></i>
					  </button>
                  </xsl:if>
                </td>
                <td class="f-lbl" style="height:40px;font-size:17px ; display:none">사 번</td>
                <td colspan="2" style="border-right:0;font-size:17px;padding-left:5px; display:none">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO" class="txtText"  style="width:100px" readnoly ="readonly"  value="{//forminfo/maintable/APPLICANTEMPNO}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="APPLICANTEMPNO" class="txtText" style="10px; width:100px" readnoly ="readonly"  value="{//forminfo/maintable/APPLICANTEMPNO}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTEMPNO))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="APPLICANTID" value="{//forminfo/maintable/APPLICANTID}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="hidden" id="__mainfield" name="APPLICANTID" value="{//forminfo/maintable/APPLICANTID}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTID))" />
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="hidden" id="__mainfield" name="APPLICANTDEPTID" value="{//forminfo/maintable/APPLICANTDEPTID}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="hidden" id="__mainfield" name="APPLICANTDEPTID" value="{//forminfo/maintable/APPLICANTDEPTID}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPTID))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px;font-size:15px;text-align:center;vertical-align:middle;">
                  Full Name<br/>(성명)
                </td>
                <td colspan="2" style="border-right:0;font-size:15px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <span>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENGNM))" />
                        (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="ENGNM"   value="{//forminfo/maintable/ENGNM}"/>
                      <input type="hidden" id="__mainfield" name="APPLICANT" value="{//forminfo/maintable/APPLICANT}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <span>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENGNM))" />
                        (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="ENGNM"   value="{//forminfo/maintable/ENGNM}"/>
                      <input type="hidden" id="__mainfield" name="APPLICANT" value="{//forminfo/maintable/APPLICANT}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENGNM))" />
                      (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />)
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px;font-size:15px;text-align:center;vertical-align:middle;">
                  Date of Birth<br/>(생년월일)
                </td>
                <td colspan="3" style="border-right:0;text-align:left;font-size:15px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <span>
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/BIRTHDATE),'en')" />
                        (<xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/BIRTHDATE),'ko')" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="BIRTHDATE" value="{//forminfo/maintable/BIRTHDATE}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <span>
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/BIRTHDATE),'en')" />
                        (<xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/BIRTHDATE),'ko')" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="BIRTHDATE" value="{//forminfo/maintable/BIRTHDATE}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/BIRTHDATE),'en')" />
                      (<xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/BIRTHDATE),'ko')" />)
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <!--<tr>
                <td class="f-lbl" style="height:40px;font-size:17px">
                  주 소
                </td>
                <td colspan="3" style="border-right:0;font-size:17px;padding-left:5px">
                <xsl:choose>
                  <xsl:when test="$mode='new' or $mode='edit'">
                    <input type="hidden" id="__mainfield" name="ADDRESS">
                      <xsl:attribute name="class">txtText</xsl:attribute>
                      <xsl:attribute name="maxlength">100</xsl:attribute>
                      <xsl:attribute name="value">
                        <xsl:value-of select="//forminfo/maintable/ADDRESS" />
                      </xsl:attribute>
                    </input>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ADDRESS))" />
                  </xsl:otherwise>
                </xsl:choose>
                </td>
              </tr>-->
              <tr>
                <td class="f-lbl2" style="text-align:center;font-size:16; vertical-align:middle;"  rowspan="3" >
                  Working <br/>Experience <br/>(경력사항)
                </td>
                <td class="f-lbl" style="height:50px;font-size:15px;text-align:center;vertical-align:middle;">
                  Department <br/> (소속)
                </td>
                <td colspan="2" style="border-right:0;font-size:15px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <span>
                        <xsl:value-of select="string(//forminfo/maintable/ENGDEPTNM)" />
                        (<xsl:value-of select="string(//forminfo/maintable/APPLICANTDEPT)" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="ENGDEPTNM" value="{//forminfo/maintable/ENGDEPTNM}"/>
                      <input type="hidden" id="__mainfield" name="APPLICANTDEPT" value="{//forminfo/maintable/APPLICANTDEPT}"/>

                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <span>
                        <xsl:value-of select="string(//forminfo/maintable/ENGDEPTNM)" />
                        (<xsl:value-of select="string(//forminfo/maintable/APPLICANTDEPT)" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="ENGDEPTNM" value="{//forminfo/maintable/ENGDEPTNM}"/>
                      <input type="hidden" id="__mainfield" name="APPLICANTDEPT" value="{//forminfo/maintable/APPLICANTDEPT}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENGDEPTNM))" />
                      (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTDEPT))" />)
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:50px;font-size:15px;text-align:center;vertical-align:middle;">
                  Position<br/>(직책)
                </td>
                <td colspan="2" style="border-right:0;font-size:15px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <span>
                        <xsl:value-of select="string(//forminfo/maintable/ENGGRADENM)" />
                        (<xsl:value-of select="string(//forminfo/maintable/APPLICANTGRADE)" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="ENGGRADENM" value="{//forminfo/maintable/ENGGRADENM}"/>
                      <input type="hidden" id="__mainfield" name="APPLICANTGRADE" value="{//forminfo/maintable/APPLICANTGRADE}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <span>
                        <xsl:value-of select="string(//forminfo/maintable/ENGGRADENM)" />
                        (<xsl:value-of select="string(//forminfo/maintable/APPLICANTGRADE)" />)
                      </span>
                      <input type="hidden" id="__mainfield" name="ENGGRADENM" value="{//forminfo/maintable/ENGGRADENM}"/>
                      <input type="hidden" id="__mainfield" name="APPLICANTGRADE" value="{//forminfo/maintable/APPLICANTGRADE}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ENGGRADENM))" />
                      (<xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANTGRADE))" />)
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:60px;font-size:14px">
                  Working Period<br/>(근무기간) 
                </td>
                <td colspan="2" style="text-align:left;border-right:0;font-size:15px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <span style="text-align:left">
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/INDATE),'en')" /> ~
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/LEAVEDATE),'en')" /> <br/>
                        (<xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/INDATE),'ko')" />&nbsp;부터 &nbsp;&nbsp;
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/LEAVEDATE),'ko')" />&nbsp;까지 )
                      </span>
                      <input type="hidden" id="__mainfield" name="INDATE" value="{//forminfo/maintable/INDATE}"/>
                      <input type="hidden" id="__mainfield" name="LEAVEDATE" value="{//forminfo/maintable/LEAVEDATE}"/>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <span style="text-align:left">
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/INDATE),'en')" /> ~
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/LEAVEDATE),'en')" /> <br/>
                        (<xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/INDATE),'ko')" />&nbsp;부터 &nbsp;&nbsp;
                        <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/LEAVEDATE),'ko')" />&nbsp;까지)
                    </span>
                      <input type="hidden" id="__mainfield" name="INDATE" value="{//forminfo/maintable/INDATE}"/>
                      <input type="hidden" id="__mainfield" name="LEAVEDATE" value="{//forminfo/maintable/LEAVEDATE}"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/INDATE),'en')" /> ~
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/LEAVEDATE),'en')" /> <br/>
                      (<xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/INDATE),'ko')" /> &nbsp;부터 &nbsp;&nbsp;
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//forminfo/maintable/LEAVEDATE),'ko')" />&nbsp;까지)
                  </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <!--<tr>
                <td colspan="2" class="f-lbl4" style="height:40px;font-size:17px">
                  용도
                </td>
                <td style="width:35%;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORUSE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">50</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FORUSE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORUSE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td class="f-lbl2" style="font-size:17px">
                  제출처
                </td>
                <td style="width:35%;border-right:0;font-size:17px;padding-left:5px">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="FORWHERE">
                        <xsl:attribute name="class">txtText</xsl:attribute>
                        <xsl:attribute name="maxlength">100</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/FORWHERE" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/FORWHERE))" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>                
              </tr>-->
			<tr>
				<td colspan="4" class="ft-content" style="border-bottom:0">
					<p style="font-size: 1.25rem; font-weight: bold; text-align: center;  padding-top: 3rem;">
						This is to certify that above mentioned facts are true and correct.<br />(위와 같이 증명합니다.)
					</p>

					<xsl:if test="//bizinfo/@docstatus!='700'">
						<p class="etctxt" style="font-size: 1.25rem; font-weight: bold; text-align: center; padding-top: 1rem; color: #ec4a3b">
							승인되지 않은 문서입니다.
						</p>
					</xsl:if>

					<p style="font-size:1.05rem;  text-align: center; padding-top: 2rem; height: 8rem">
						<xsl:choose>
							<xsl:when test="$mode='new'">
								Issued Date: <xsl:value-of select="phxsl:convertDate(string(//docinfo/createdate),'en')" /> <br/>
								(발급일&nbsp;:&nbsp;<xsl:value-of select="phxsl:convertDate(string(//docinfo/createdate),'ko')" />)
								<input type="hidden" id="__mainfield" name="REQUESTDATE" value="{//docinfo/createdate}"/>
							</xsl:when>
							<xsl:when test="$mode='edit'">
								Issued Date&nbsp;:&nbsp; <xsl:value-of select="phxsl:convertDate(string(//docinfo/createdate),'en')" /> <br/>
								(발급일&nbsp;:&nbsp;<xsl:value-of select="phxsl:convertDate(string(//docinfo/createdate),'ko')" />)
								<input type="hidden" id="__mainfield" name="REQUESTDATE" value="{//docinfo/createdate}"/>
							</xsl:when>
							<xsl:otherwise>
								Issued Date&nbsp;:&nbsp; <xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/REQUESTDATE),'en')" /><br/>
								(발급일&nbsp;:&nbsp;<xsl:value-of select="phxsl:convertDate(string(//forminfo/maintable/REQUESTDATE),'ko')" />)
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</td>
			</tr>
              <tr>
                <td colspan="3" class="ft-content2" style=" padding-left:10px; border-top: 0; border-bottom;0;text-align:left;border-right:0;font-size:1rem;height:170px; line-height:25px; padding-top:10px">
                  <strong>
                    Jong Bae, Lee  <br/>
                    Representative of CRESYN Co.,Ltd<br/>
                    크레신주식회사 대표이사 이종배
                  </strong><br/>
                  Address : 5 Gangnam-daero 107-gil, Seocho-gu, Seoul, Korea #06524<br/>
                  소재지: 서울특별시 서초구 강남대로 107 길 5
                </td>
                <td style ="border:0; padding-left:25px;padding-top:20px">
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:84px;border:0px solid green">
                      <img alt="회사인장" width="84px" style="margin:0;vertical-align:top" src="/Storage/{//config/@companycode}/CI/cresyn_stamp.gif" />
                    </span>
                  </xsl:if>
                </td>
              </tr>

              <!--<tr>
                <td colspan="5" style="border-bottom;0;border-right:0;height:170px">
                  <span style="font-size:18px;letter-spacing:3pt;text-align:right;padding-right:20px;width:440px;height:60px;border:0px solid blue">
                    대표이사&nbsp;&nbsp;&nbsp;&nbsp;이&nbsp;&nbsp;종&nbsp;&nbsp;배
                  </span>
                  <xsl:if test="//bizinfo/@docstatus='700'">
                    <span style="width:84px;border:0px solid green">
                      <img alt="회사인장" width="84px" style="margin:0;vertical-align:top">
                        <xsl:attribute name="src">
                          /Storage/<xsl:value-of select="//config/@companycode" />/CI/cresyn_stamp.gif
                        </xsl:attribute>
                      </img>
                    </span>
                  </xsl:if>
                </td>
              </tr>-->
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
            <!--<div style="page-break-before:always;font-size:1px;height:1px">&nbsp;</div>-->
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
