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
          .m {width:1200px} .m .fm-editor {height:450px;border:windowtext 0pt solid}
          .fh h1 {font-size:20pt;letter-spacing:1pt}
          .m .ft-sub label {font-size:13px}
          .fm1 h2 {font-size:20pt;letter-spacing:1pt;margin:0}
        
          /* 결재칸 넓이 */
          .si-tbl .si-title {width:25px} .si-tbl .si-bottom {width:75px}

          /* 공통,메인 필드 테이블 - f-lbl(n)은 양식별로 틀릴 수 있다. */
          .m .ft .f-lbl {width:8%} .m .ft .f-lbl1 {width:?} .m .ft .f-lbl2 {width:?}
          .m .ft .f-lbl3 {writing-mode:tb-rl}
          .m .ft .f-option {width:} .m .ft .f-option1 {width:150px} .m .ft .f-option2 {width:70px} .m .ft-sub .f-option {width:100%;text-align:center}

          /* 인쇄 설정 : 맨하단으로 */
          @media print {.m .fm-editor {height:450px} .m .fm-chart .fc-lbl1 {background-color:#ffffff}}
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
                <td class="fh-r"></td>
              </tr>
            </table>
            <xsl:choose>
              <xsl:when test="$mode='read'">
                <input type="hidden" id="__mainfield" name="LOGOPATH">
                  <xsl:attribute name="value"><xsl:value-of select="//forminfo/maintable/LOGOPATH" /></xsl:attribute>
                </input>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" id="__mainfield" name="LOGOPATH">
                  <xsl:attribute name="value">/Storage/<xsl:value-of select="//config/@companycode" />/CI/<xsl:value-of select="//creatorinfo/corp/logo" /></xsl:attribute>
                </input>
              </xsl:otherwise>
            </xsl:choose>
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
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td class="f-lbl" style="border-bottom:0;">제목</td>
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
          <div class="fm">
            <table class="ft" border="0" cellspacing="0" cellpadding="0">
              <xsl:if test="$mode='new' or $mode='edit' or $mode='read' ">
                <xsl:attribute name="style">table-layout:fixed</xsl:attribute>
              </xsl:if>
              <!--테이블 넓이나 높이를 고정시켜주는 역활을 하는 놈-->
              <colgroup>
                <col style="width:14%"></col>
                <col style="width:20%"></col>
                <col style="width:30%"></col>
                <col style="width:6%"></col>
                <col style="width:6%"></col>
                <col style="width:6%"></col>
                <col style="width:6%"></col>
                <col style="width:6%"></col>
                <col style="width:%"></col>
              </colgroup>
              <tr>
                <td class="f-lbl" colspan="9" style="border-right:0">
                  금일 주요 작업내역
                </td>
              </tr>
              <tr>
                <td class="f-lbl">구분</td>
                <td class="f-lbl">업무명</td>
                <td class="f-lbl">처리내용</td>
                <td class="f-lbl">요청자</td>
                <td class="f-lbl">요청일</td>
                <td class="f-lbl">예정일</td>
                <td class="f-lbl">처리일</td>
                <td class="f-lbl">완료일</td>
                <td class="f-lbl" style="border-right:0">상태</td>
              </tr>
              <tr style="height:45px">
                <td class="f-lbl">ERP 처리</td>
                <td class="f-lbl">ERP 업무 진행 사항</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr style="height:45px">  
                  <td class="f-lbl" style="">ERP 교육</td>
                  <td class="f-lbl">ERP Part 담당 교육</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="CONTENT1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/CONTENT1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="CONTENT1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="APPLICANT1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/APPLICANT1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="APPLICANT1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="REQUESTDATE1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/REQUESTDATE1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="REQUESTDATE1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DUEDATE1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DUEDATE1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DUEDATE1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DEADLINE1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DEADLINE1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DEADLINE1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="COMPLETE1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/COMPLETE1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="COMPLETE1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="STATE1" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/STATE1" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="STATE1" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE1))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
              </tr>

              <tr>
                  <td class="f-lbl" rowspan="3">기준 정보 검증</td>
                  <td class="f-lbl" style="height:45px">기준정보 검증 회의</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="CONTENT2" maxlenght="20" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/CONTENT2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="CONTENT2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="APPLICANT2" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/APPLICANT2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="APPLICANT2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CPPLICANT2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="REQUESTDATE2" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/REQUESTDATE2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="REQUESTDATE2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DUEDATE2" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DUEDATE2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DUEDATE2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DEADLINE2" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DEADLINE2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DEADLINE2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="COMPLETE2" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/COMPLETE2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="COMPLETE2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="STATE2" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/STATE2" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="STATE2" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE2))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
              </tr>

              <tr>
                  <td class="f-lbl" style="height:45px">기준정보 신규등록 현황</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="CONTENT3" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/CONTENT3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="CONTENT3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="APPLICANT3" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/APPLICANT3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="APPLICANT3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="REQUESTDATE3" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/REQUESTDATE3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="REQUESTDATE3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DUEDATE3" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DUEDATE3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DUEDATE3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DEADLINE3" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DEADLINE3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DEADLINE3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="COMPLETE3" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/COMPLETE3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="COMPLETE3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="STATE3" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/STATE3" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="STATE3" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE3))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
              </tr>

              <tr>
                  <td class="f-lbl" style="height:45px">기준정보 수정/변경등록 현황</td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="CONTENT4" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/CONTENT4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="CONTENT4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="APPLICANT4" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/APPLICANT4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="APPLICANT4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="REQUESTDATE4" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/REQUESTDATE4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="REQUESTDATE4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DUEDATE4" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DUEDATE4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DUEDATE4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="DEADLINE4" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/DEADLINE4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="DEADLINE4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="COMPLETE4" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/COMPLETE4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="COMPLETE4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="border-right:0">
                    <xsl:choose>
                      <xsl:when test="$mode='new' or $mode='edit'">
                        <textarea id="__mainfield" name="STATE4" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                          <xsl:value-of select="//forminfo/maintable/STATE4" />
                        </textarea>
                      </xsl:when>
                      <xsl:otherwise>
                        <div name="STATE4" style="height:40px">
                          <xsl:attribute name="class">txaRead</xsl:attribute>
                          <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE4))" />
                        </div>
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
              </tr>
              

              <tr>
                <td class="f-lbl" rowspan="5">구매/자재관리</td>
                <td class="f-lbl" style="height:45px">실물 납입, 입/출고 관리</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT5" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT5" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE5" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE5" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE5" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE5" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE5" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE5" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE5" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE5))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

              <tr>
                <td class="f-lbl" style="height:45px">ERP 자재수불 일일마감 현황</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT6" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT6" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE6" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE6" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE6" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE6" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE6" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE6" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE6" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE6))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px">비정상 납입, 입/출고 현황</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT7" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT7" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE7" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE7" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE7" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE7" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE7" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE7" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE7" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE7))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px">
                  단종모델(완제/반제/단품)<BR>재고 수량 및 PO 잔량 현황</BR>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT8" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT8" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT8" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE8" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE8" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE8" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE8" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE8" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE8" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE8" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE8" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE8" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE8" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE8" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE8))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr> 
              <tr>
                <td class="f-lbl" style="height:45px">
                  입고품 샘플링 검수 및 결과<BR>(2품목/일)</BR>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT9" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT9" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE9" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE9" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE9" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE9" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE9" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE9" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE9" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE9))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl">CSR 관리</td>
                <td class="f-lbl" style="height:45px">CSR 진행 사항</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE10" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE10" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE10" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE10))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

              <tr>
                <td class="f-lbl" style="height:45px">기타 업무지원</td>
                <td class="f-lbl">과제 외 지원 사항</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DEADLINE11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DEADLINE11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DEADLINE11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DEADLINE11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="COMPLETE11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/COMPLETE11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="COMPLETE11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/COMPLETE11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-right:0">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="STATE11" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/STATE11" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="STATE11" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/STATE11))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>

              <tr>
                <td class="f-lbl" colspan="9" style="border-right:0">
                  명일 주요 작업계획
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="textonly" id="__mainfield" name="STATSYEAR1" style="width:40px;font-size:10pt">
                        <xsl:attribute name="class">txtYear</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="maxlength">4</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="substring(string(//docinfo/createdate),1,4)" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="STATSYEAR1" style="width:40px;font-size:10pt">
                        <xsl:attribute name="class">txtYear</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="maxlength">4</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STATSYEAR1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="//forminfo/maintable/STATSYEAR1" />
                    </xsl:otherwise>
                  </xsl:choose>년
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="STATSMONTH1" style="width:25px;font-size:10pt">
                        <xsl:attribute name="class">txtMonth</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="maxlength">2</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),6,2))" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="STATSMONTH1" style="width:25px;font-size:10pt">
                        <xsl:attribute name="class">txtMonth</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="maxlength">2</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STATSMONTH1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="//forminfo/maintable/STATSMONTH1" />
                    </xsl:otherwise>
                  </xsl:choose>월
                  <xsl:choose>
                    <xsl:when test="$mode='new'">
                      <input type="text" id="__mainfield" name="STATDATE1" style="width:25px;font-size:10pt">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>
                        <xsl:attribute name="maxlength">2</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="phxsl:cvtMonth(substring(string(//docinfo/createdate),9,2))" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:when test="$mode='edit'">
                      <input type="text" id="__mainfield" name="STATSDATE1" style="width:25px;font-size:10pt">
                        <xsl:attribute name="class">txtDate</xsl:attribute>
                        <xsl:attribute name="readonly">readonly</xsl:attribute>                     
                        <xsl:attribute name="maxlength">2</xsl:attribute>
                        <xsl:attribute name="value">
                          <xsl:value-of select="//forminfo/maintable/STATDATE1" />
                        </xsl:attribute>
                      </input>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="//forminfo/maintable/STATSDATE1" />
                    </xsl:otherwise>
                  </xsl:choose>일
                </td>
              </tr>

              <tr>
                <td class="f-lbl">구분</td>
                <td class="f-lbl">업무명</td>
                <td class="f-lbl">처리내용</td>
                <td class="f-lbl">요청자</td>
                <td class="f-lbl">요청일</td>
                <td class="f-lbl">예정일</td>
                <td class="f-lbl" colspan="3" style="border-right:0">공지 및 건의 사항</td>
              </tr>

              <tr>
                <td class="f-lbl" style="height:45px">ERP 처리</td>
                <td class="f-lbl">ERP 업무 진행 사항</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT12" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT12" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT12" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT12))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT12" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT12" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT12" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT12))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE12" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE12" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE12" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE12))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE12" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE12" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE12" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE12))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td style="border-botton:0;border-right:0" colspan="3" rowspan="8">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="announcement" style="height:354px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/announcement" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="announcement" style="height:354px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/announcement))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px">ERP 교육</td>
                <td class="f-lbl">ERP Part 담당 교육</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT13" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT13" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT13" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT13))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT13" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT13" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT13" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT13))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE13" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE13" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE13" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE13))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE13" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE13" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE13" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE13))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" rowspan="5">구매/자재관리</td>
                <td class="f-lbl" style="height:45px">실물 납입, 입/출고 관리</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT14" maxlenght="20" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT14" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT14" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT14))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT14" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT14" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT14" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT14))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE14" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE14" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE14" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE14))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE14" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE14" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE14" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE14))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px">ERP 자재수불 일일마감 현황</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT15" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT15" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT15" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT15))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT15" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT15" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT15" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT15))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE15" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE15" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE15" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE15))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE15" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE15" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE15" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE15))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px">비정상 납입, 입/출고 현황</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT16" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT16" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT16" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT16))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT16" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT16" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT16" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT16))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE16" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE16" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE16" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE16))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE16" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE16" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE16" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE16))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height=45px">
                  단종모델(완제/반제/단품)<BR>재고 수량 및 PO 잔량 현황</BR>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT17" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT17" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT17" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT17))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICATN17" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT17" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT17" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT17))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE17" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE17" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE17" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE17))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE17" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE17" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE17" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE17))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl1" style="height:45px">
                  입고품 샘플링 검수 및 결과<br>(2품목/일)</br>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT18" style="height:40px"  class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT18" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT18" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT18))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT18" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT18" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT18" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT18))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE18" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE18" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE18" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE18))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE18" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE18" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE18" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE18))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl"> CSR 관리 </td>
                <td class="f-lbl" style="height:45px">CSR 진행 사항</td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="CONTENT19" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/CONTENT19" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="CONTENT19" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/CONTENT19))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="APPLICANT19" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/APPLICANT19" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="APPLICANT19" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/APPLICANT19))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="REQUESTDATE19" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/REQUESTDATE19" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="REQUESTDATE19" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/REQUESTDATE19))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
                <td>
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="DUEDATE19" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/DUEDATE19" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="DUEDATE19" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/DUEDATE19))" />
                      </div>
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <tr>
                <td class="f-lbl" style="height:45px;border-bottom:0">ISSUE1</td>
                <td style="border-right:0;border-bottom:0" colspan="8">
                  <xsl:choose>
                    <xsl:when test="$mode='new' or $mode='edit'">
                      <textarea id="__mainfield" name="ISSUE" style="height:40px" class="txatext" onkeyup="parent.checkTextAreaLength(this, 200);">
                        <xsl:value-of select="//forminfo/maintable/ISSUE" />
                      </textarea>
                    </xsl:when>
                    <xsl:otherwise>
                      <div name="ISSUE" style="height:40px">
                        <xsl:attribute name="class">txaRead</xsl:attribute>
                        <xsl:value-of disable-output-escaping="yes" select="phxsl:encodeHtml(string(//forminfo/maintable/ISSUE))" />
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
