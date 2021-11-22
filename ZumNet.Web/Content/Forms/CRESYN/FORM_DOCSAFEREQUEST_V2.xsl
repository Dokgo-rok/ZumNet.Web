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
          .m {width:700px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20.0pt;letter-spacing:2pt}

          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

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
              <xsl:if test="$mode='new' or $mode='edit'">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <colgroup>
                <col style="width:15%"></col>
                <col style="width:20%"></col>
                <col style="width:15%"></col>
                <col style="width:15%"></col>
                <col style="width:15%"></col>
                <col style="width:20%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl">문서번호</td>
                <td style="" colspan="2">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(//docinfo/docnumber))" />
                </td>
                <td class="f-lbl">작성일자</td>
                <td style="border-right:0" colspan="2">
                  <xsl:value-of disable-output-escaping="yes" select="phxsl:convertDate(string(//docinfo/createdate), '')" />
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="border-bottom:0">작성부서</td>
                <td style="border-bottom:0;width:20%">
                  <xsl:value-of select="//creatorinfo/department" />
                </td>
                <td class="f-lbl" style="border-bottom:0">작성자</td>
                <td style="border-bottom:0;width:15%">
                  <xsl:value-of select="//creatorinfo/name" />
                </td>
                <td class="f-lbl" style="border-bottom:0">문서보안ID</td>
                <td style="width:20%;border-bottom:0;border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <input type="text" id="__mainfield" name="DOCID" class="txtText" maxlength="100" value="{//forminfo/maintable/DOCID}" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DOCID))" />
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
              <tr>
                <td class="f-lbl" style="width:30%">요청 권한</td>
                <td class="f-lbl" style="width:8%">
                  사용
                </td>
                <td class="f-lbl" style="width:72%;border-right:0">
                  요청사유(업무관련 내용 상세 기재)
                </td>                
              </tr>
              <tr>
                <td class="" style="height:70px;text-align:center">암호화 해제</td>
                <td style="text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb1" name="ckbCHECK1" value="암호화권한">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK1', this, 'CHECK1')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK1),'암호화권한')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECK1),'암호화권한')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>                    
                  </span>                                        
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CHECKREASON1" style="height:65px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHECKREASON1" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="CHECKREASON1" class="txaText" height="65px" onkeyup="parent.checkTextAreaLength(this, 2000)">
                            <xsl:value-of select="//forminfo/maintable/CHECKREASON1" />
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="CHECKREASON1" style="">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECKREASON1))" />
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="" style="height:70px;text-align:center">
                  USB/이동드라이브 쓰기                  
                </td>
                <td style="text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb2" name="ckbCHECK2" value="USB권한">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK2', this, 'CHECK2')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK2),'USB권한')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECK2),'USB권한')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CHECKREASON2" style="height:65px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHECKREASON2" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="CHECKREASON2" class="txaText" height="65px" onkeyup="parent.checkTextAreaLength(this, 2000)">
                            <xsl:value-of select="//forminfo/maintable/CHECKREASON2" />
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="CHECKREASON2" style="">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECKREASON2))" />
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="" style="height:70px;text-align:center">
                  모바일기기 접속<br />
                  <span style="font-size:11px">
                    (핸드폰, 아이패드 등의 USB 통한 데이터 연결)
                  </span>
                  </td>
                <td style="text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb3" name="ckbCHECK3" value="모바일권한">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK3', this, 'CHECK3')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK3),'모바일권한')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECK3),'모바일권한')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CHECKREASON3" style="height:65px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHECKREASON3" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="CHECKREASON3" class="txaText" height="65px" onkeyup="parent.checkTextAreaLength(this, 2000)">
                            <xsl:value-of select="//forminfo/maintable/CHECKREASON3" />
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="CHECKREASON3" style="">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECKREASON3))" />
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="" style="height:70px;text-align:center">
                  기타 장비 접속<br />
                  <span style="font-size:11px">(각 부서 공용 장비: 현미경, 카메라모듈 등의 테스트장비)</span>
                </td>
                <td style="text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb4" name="ckbCHECK4" value="기타장비권한">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK4', this, 'CHECK4')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK4),'기타장비권한')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECK4),'기타장비권한')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CHECKREASON4" style="height:65px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHECKREASON4" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="CHECKREASON4" class="txaText" height="65px" onkeyup="parent.checkTextAreaLength(this, 2000)">
                            <xsl:value-of select="//forminfo/maintable/CHECKREASON4" />
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="CHECKREASON4" style="">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECKREASON4))" />
                          </div>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="" style="height:70px;text-align:center;border-bottom:0">화면 캡쳐(PrintScreen)</td>
                <td style="border-bottom:0;text-align:center">
                  <span class="f-option">
                    <input type="checkbox" id="ckb5" name="ckbCHECK5" value="화면캡쳐권한">
                      <xsl:if test="$mode='new' or $mode='edit'">
                        <xsl:attribute name="onclick">parent.fnCheckYN('ckbCHECK5', this, 'CHECK5')</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="phxsl:isEqual(string(//forminfo/maintable/CHECK5),'화면캡쳐권한')">
                        <xsl:attribute name="checked">true</xsl:attribute>
                      </xsl:if>
                      <xsl:if test="$mode='read' and phxsl:isDiff(string(//forminfo/maintable/CHECK5),'화면캡쳐권한')">
                        <xsl:attribute name="disabled">disabled</xsl:attribute>
                      </xsl:if>
                    </input>
                  </span>
                </td>
                <td style="border-right:0;border-bottom:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CHECKREASON5" style="height:65px">
                        <xsl:attribute name="class">txaText</xsl:attribute>
                        <xsl:attribute name="onkeyup">parent.checkTextAreaLength(this, 2000)</xsl:attribute>
                        <xsl:if test="$mode='edit'">
                          <xsl:value-of select="//forminfo/maintable/CHECKREASON5" />
                        </xsl:if>
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:attribute name="class">txaRead</xsl:attribute>
                      <xsl:if test="$mlvl='A' or $mlvl='B'">
                        <xsl:attribute name="id">___editable</xsl:attribute>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$submode='revise'">
                          <textarea id="__mainfield" name="CHECKREASON5" class="txaText" height="65px" onkeyup="parent.checkTextAreaLength(this, 2000)">
                            <xsl:value-of select="//forminfo/maintable/CHECKREASON5" />
                          </textarea>
                        </xsl:when>
                        <xsl:otherwise>
                          <div id="__mainfield" name="CHECKREASON5" style="">
                            <xsl:attribute name="class">txaRead</xsl:attribute>
                            <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CHECKREASON5))" />
                          </div>
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
          <div class="ff" />
          <div class="ff" />

          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td colspan="2" style="border-right:0;height:250px;border-bottom:0">
                  <span style="width:100%;text-align:left" >
                    - 본인은 업무수행상 보안에 위반된다고 생각하는 사항을 외부에 누설함으로 당사 및 국가에 대한 불법 행위가<br />
                    됨을 자각하고 보안업무의 제 규정을 시간과 장소에 관계 없이 성실히 이행할 것을 확약함.<br /><br />
                    - 본인은 재직 중 알게 된 모든 직무상의 보안사항을 퇴직 후에도 일체 누설하지 않을 것을 확약함.<br /><br />
                    - 본인은 보안에 대한 기밀사항을 누설 시에는 제반 규정에 따른 처벌을 감수할 것이며, 퇴직 후에도 민·형사상<br />의 처벌을 감수할 것을 확약함.<br /><br />
                    -본인은 문서보안 권한과 관련하여, 업무 용도로만 활용하며, 보안 사항을 준수할 것을 확약함.<br /><br />
                    - 본인은 각종 전자우편시스템 및 모바일 기기를 이용하여 작성, 전송되는 모든 회사관련 정보는 회사의 소유물임을 인식하고,  전체 또는 부분적인 전자우편에 대해 공개 요청을 받은 경우 즉시 제공할 것을 확약함.                                        
                  </span>                 
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

        <!-- 양식 히든필드 -->
        <input type="hidden" id="__mainfield" name="CHECK1" value="{//forminfo/maintable/CHECK1}" />
        <input type="hidden" id="__mainfield" name="CHECK2" value="{//forminfo/maintable/CHECK2}" />
        <input type="hidden" id="__mainfield" name="CHECK3" value="{//forminfo/maintable/CHECK3}" />
        <input type="hidden" id="__mainfield" name="CHECK4" value="{//forminfo/maintable/CHECK4}" />
        <input type="hidden" id="__mainfield" name="CHECK5" value="{//forminfo/maintable/CHECK5}" />
        
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