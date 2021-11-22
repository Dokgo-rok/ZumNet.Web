<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">
  <xsl:import href="../../Forms/XFormScript.xsl"/>
  <xsl:variable name="displaylog">false</xsl:variable>
  <xsl:template match="/">
    <div class="ctm" style="width:1190px">
      <div class="fh">
        <h1>
          전법인 (<xsl:value-of select="//maindata/STATSYEAR"></xsl:value-of>)년 (<xsl:value-of select="//maindata/STATSMONTH"></xsl:value-of>)월 불량 및 불용금액 발생현황
        </h1>
      </div>
      <div class="ff"></div>

      <div class="fm">
        <span>1. 법인별 월 불량 및 불용금액 발생현황</span>
      </div>

      <div class="fm">
        <table class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
          <colgroup>
            <col style="width:70px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
          </colgroup>
          <tr style="height:18px">
            <td class="f-lbl-sub" rowspan="3" style="border-top:0">법인명</td>
            <td class="f-lbl-sub" colspan="8" style="border-top:0">월 현황</td>
            <td class="f-lbl-sub" colspan="5" style="border-top:0">연간 누적 현황</td>
            <td class="f-lbl-sub" rowspan="3"  style="border-top:0;border-right:0">비고</td>
          </tr>
          <tr style="height:18px">
            <td class="f-lbl-sub" colspan="4">당월 발생금액</td>
            <td class="f-lbl-sub" colspan="2">매출대비율</td>
            <td class="f-lbl-sub" colspan="2">매입대비율</td>
            <td class="f-lbl-sub" rowspan="2">총 발생<br />금액</td>
            <td class="f-lbl-sub" colspan="2">매출대비율</td>
            <td class="f-lbl-sub" colspan="2">매입대비율</td>
          </tr>
          <tr style="height:18px">
            <td class="f-lbl-sub">자재</td>
            <td class="f-lbl-sub">반제품</td>
            <td class="f-lbl-sub">완제품</td>
            <td class="f-lbl-sub">합계</td>
            <td class="f-lbl-sub">매출액</td>
            <td class="f-lbl-sub">비율</td>
            <td class="f-lbl-sub">매입액</td>
            <td class="f-lbl-sub">비율</td>
            <td class="f-lbl-sub">매출액</td>
            <td class="f-lbl-sub">비율</td>
            <td class="f-lbl-sub">매입액</td>
            <td class="f-lbl-sub">비율</td>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='CT']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='CT']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">CT</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='CD']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='CD']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">CD</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='CH']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='CH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">CH</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='CL']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='CL']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">CL</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='IC']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='IC']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">IC</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='IS']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='IS']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">IS</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:choose>            
              <xsl:when test="//tabledata/row[CORPORATION='VH']">
                <xsl:apply-templates select="//tabledata/row[CORPORATION='VH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td class="f-lbl-sub">VH</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
        </table>
      </div>

      <div class="ff"></div>

      <div class="fm">
        <span>2. 매출액 대비 불량 및 불용금액 추이</span>
      </div>

      <div class="fm-chart">
        <table class="fc" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
          <colgroup>
            <col style="width:70px"></col>
            <col style="width:80px"></col>
            <col style="width:960px"></col>
            <col style="width:80px"></col>
          </colgroup>
          <tr>
            <td class="fc-lbl1">
              매출액<br />대비<br />손실비용<br />추이
            </td>
            <td class="fc-lbl">
              매출액비(%)<br /><br />
              <xsl:value-of select="//tabledata/row/CHATY"/>%
            </td>
            <td style="padding-top:40px">
              <div id="panChart" style="position:relative;width:100%;height:260px;border:0px solid blue">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'CT', 960, 260, string(//tabledata/row/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'CD', 960, 260, string(//tabledata/row/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'CH', 960, 260, string(//tabledata/row/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'CL', 960, 260, string(//tabledata/row/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'IC', 960, 260, string(//tabledata/row/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'IS', 960, 260, string(//tabledata/row/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'VH', 960, 260, string(//tabledata/row/CHATY))"/>
                <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'GROUP', 960, 260, string(//tabledata/row/CHATY))"/>-->
              </div>
            </td>
            <td style="padding-top:40px;border-left:windowtext 1pt solid">
              <div id="panChart2" style="position:relative;width:100%;height:260px;border:0px solid blue">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata1, 'TOTAL', 80, 260, string(//tabledata/row/CHATY))"/>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div class="ff"></div>
      <div class="fm">
        <table class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="table-layout:">
          <colgroup>
            <col style="width:70px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
          </colgroup>
          <tr style="height:24px">
            <td class="f-lbl-sub" style="border-top:0">법인명</td>
            <td class="f-lbl-sub" style="border-top:0">기호</td>
            <td class="f-lbl-sub" style="border-top:0">1월</td>
            <td class="f-lbl-sub" style="border-top:0">2월</td>
            <td class="f-lbl-sub" style="border-top:0">3월</td>
            <td class="f-lbl-sub" style="border-top:0">4월</td>
            <td class="f-lbl-sub" style="border-top:0">5월</td>
            <td class="f-lbl-sub" style="border-top:0">6월</td>
            <td class="f-lbl-sub" style="border-top:0">7월</td>
            <td class="f-lbl-sub" style="border-top:0">8월</td>
            <td class="f-lbl-sub" style="border-top:0">9월</td>
            <td class="f-lbl-sub" style="border-top:0">10월</td>
            <td class="f-lbl-sub" style="border-top:0">11월</td>
            <td class="f-lbl-sub" style="border-top:0">12월</td>
            <td class="f-lbl-sub" style="border-top:0;border-right:0">TOTAL</td>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='CT']/MessageID}">
            <!--<xsl:attribute name="id">_<xsl:value-of select="//chartdata1/row[CORPORATION='CT']/MessageID"/></xsl:attribute>-->
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='CT']">
                  <a href="#" onclick="openXForm(this);">CT</a>
                </xsl:when>
                <xsl:otherwise>CT</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#666666', '', '')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#666666', '', '', '','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='CT']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='CT']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='CD']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='CD']">
                  <a href="#" onclick="openXForm(this);">CD</a>
                </xsl:when>
                <xsl:otherwise>CD</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '#0000ff', '#0000ff', '', '')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#0000ff', '', '', 'shortdashdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='CD']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='CD']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='CH']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='CH']">
                  <a href="#" onclick="openXForm(this);">CH</a>
                </xsl:when>
                <xsl:otherwise>CH</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#a52a2a', 'shortdash', '', 'thinthin', '2px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#a52a2a', '', '', 'shortdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='CH']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='CH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='CL']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='CL']">
                  <a href="#" onclick="openXForm(this);">CL</a>
                </xsl:when>
                <xsl:otherwise>CL</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#191970', 'shortdot', '', '', '2px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#191970', '', '', 'longdashdotdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='CL']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='CL']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='IC']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='IC']">
                  <a href="#" onclick="openXForm(this);">IC</a>
                </xsl:when>
                <xsl:otherwise>IC</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#800080', 'shortdot', '', 'thinthin', '3px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#800080', '', '', 'dot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='IC']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='IC']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='IS']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='IS']">
                  <a href="#" onclick="openXForm(this);">IS</a>
                </xsl:when>
                <xsl:otherwise>IS</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#008000', '', '', 'thinthin', '2px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#008000', '', '', 'longdashdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='IS']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='IS']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata1/row[CORPORATION='VH']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata1/row[CORPORATION='VH']">
                  <a href="#" onclick="openXForm(this);">VH</a>
                </xsl:when>
                <xsl:otherwise>VH</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#999', '', '', '', '1px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#999', '', '', 'solid','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata1/row[CORPORATION='VH']">
                <xsl:apply-templates select="//chartdata1/row[CORPORATION='VH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
        </table>
      </div>
      
      <div class="ff"></div>

      <div class="fm">
        <span>3. 매입액 대비 불량 및 불용금액 추이</span>
      </div>

      <div class="fm-chart">
        <table class="fc" border="0" cellspacing="0" cellpadding="0" style="table-layout:fixed">
          <colgroup>
            <col style="width:70px"></col>
            <col style="width:80px"></col>
            <col style="width:960px"></col>
            <col style="width:80px"></col>
          </colgroup>
          <tr>
            <td class="fc-lbl1">
              매입액<br />대비<br />손실비용<br />추이
            </td>
            <td class="fc-lbl">
              매입액비(%)<br /><br />
              <xsl:value-of select="//tabledata/row/CHATY"/>%
            </td>
            <td style="padding-top:40px">
              <div id="panChart2" style="position:relative;width:100%;height:260px;border:0px solid blue">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'CT', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'CD', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'CH', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'CL', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'IC', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'IS', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'VH', 960, 260, string(//tabledata/row/CHATY), 'BUYSHARE')"/>
                <!--<xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart2(//chartdata2, 'GROUP', 960, 260, string(//tabledata/row/CHATY))"/>-->
              </div>
            </td>
            <td style="padding-top:40px;border-left:windowtext 1pt solid">
              <div id="panChart2" style="position:relative;width:100%;height:260px;border:0px solid blue">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata2, 'TOTALBUY', 80, 260, string(//tabledata/row/CHATY))"/>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div class="ff"></div>
      <div class="fm">
        <table class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0" style="table-layout:">
          <colgroup>
            <col style="width:70px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
            <col style="width:80px"></col>
          </colgroup>
          <tr style="height:24px">
            <td class="f-lbl-sub" style="border-top:0">법인명</td>
            <td class="f-lbl-sub" style="border-top:0">기호</td>
            <td class="f-lbl-sub" style="border-top:0">1월</td>
            <td class="f-lbl-sub" style="border-top:0">2월</td>
            <td class="f-lbl-sub" style="border-top:0">3월</td>
            <td class="f-lbl-sub" style="border-top:0">4월</td>
            <td class="f-lbl-sub" style="border-top:0">5월</td>
            <td class="f-lbl-sub" style="border-top:0">6월</td>
            <td class="f-lbl-sub" style="border-top:0">7월</td>
            <td class="f-lbl-sub" style="border-top:0">8월</td>
            <td class="f-lbl-sub" style="border-top:0">9월</td>
            <td class="f-lbl-sub" style="border-top:0">10월</td>
            <td class="f-lbl-sub" style="border-top:0">11월</td>
            <td class="f-lbl-sub" style="border-top:0">12월</td>
            <td class="f-lbl-sub" style="border-top:0;border-right:0">TOTAL</td>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='CT']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='CT']">
                  <a href="#" onclick="openXForm(this);">CT</a>
                </xsl:when>
                <xsl:otherwise>CT</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#666666', '', '')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#666666', '', '', '','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='CT']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='CT']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='CD']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='CD']">
                  <a href="#" onclick="openXForm(this);">CD</a>
                </xsl:when>
                <xsl:otherwise>CD</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '#0000ff', '#0000ff', '', '')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#0000ff', '', '', 'shortdashdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='CD']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='CD']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='CH']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='CH']">
                  <a href="#" onclick="openXForm(this);">CH</a>
                </xsl:when>
                <xsl:otherwise>CH</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#a52a2a', 'shortdash', '', 'thinthin', '2px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#a52a2a', '', '', 'shortdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='CH']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='CH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='CL']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='CL']">
                  <a href="#" onclick="openXForm(this);">CL</a>
                </xsl:when>
                <xsl:otherwise>CL</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#191970', 'shortdot', '', '', '2px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#191970', '', '', 'longdashdotdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='CL']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='CL']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='IC']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='IC']">
                  <a href="#" onclick="openXForm(this);">IC</a>
                </xsl:when>
                <xsl:otherwise>IC</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#800080', 'shortdot', '', 'thinthin', '3px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#800080', '', '', 'dot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='IC']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='IC']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='IS']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='IS']">
                  <a href="#" onclick="openXForm(this);">IS</a>
                </xsl:when>
                <xsl:otherwise>IS</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#008000', '', '', 'thinthin', '2px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#008000', '', '', 'longdashdot','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='IS']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='IS']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr id="_{//chartdata2/row[CORPORATION='VH']/MessageID}">
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata2/row[CORPORATION='VH']">
                  <a href="#" onclick="openXForm(this);">VH</a>
                </xsl:when>
                <xsl:otherwise>VH</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="vertical-align:middle">
              <div style="position:relative;height:18px;border:0 solid red">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#999', '', '', '', '1px')"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '63,9', 1, '#999', '', '', 'solid','')"/>
              </div>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata2/row[CORPORATION='VH']">
                <xsl:apply-templates select="//chartdata2/row[CORPORATION='VH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
        </table>
      </div>

      <div class="ff"></div>
      <div class="ff"></div>
      <div class="ff"></div>
    </div>
  </xsl:template>
  <xsl:template match="//tabledata/row">
    <td class="f-lbl-sub"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(CORPORATION))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(JAJAE))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BAN))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(WAN))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALSUM))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALESSUM))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALESRATE))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYSUM))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYRATE))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALFAULT))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALSALES))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALSHARE))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALBUY))"/></td>
    <td style="text-align:right"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALBUYSHARE))"/></td>
    <td style="text-align:right;border-right:0">&nbsp;</td>
  </xsl:template>
  <xsl:template match="//chartdata1/row">
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES1))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT1))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE1), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE1"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES2))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT2))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE2), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE2"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES3))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT3))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE3), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE3"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES4))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT4))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE4), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE4"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES5))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT5))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE5), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE5"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES6))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT6))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE6), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE6"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES7))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT7))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE7), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE7"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES8))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT8))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE8), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE8"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES9))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT9))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE9), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE9"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES10))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT10))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE10), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE10"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES11))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT11))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE11), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE11"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(SALES12))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT12))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(SHARE12), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="SHARE12"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center;border-right:0">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALSALES))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALFAULT))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(TOTALSHARE), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="TOTALSHARE"/>)</xsl:otherwise>
        </xsl:choose>
      </div> 
    </td>
  </xsl:template>
  <xsl:template match="//chartdata2/row">
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY1))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT1))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE1), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE1"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY2))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT2))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE2), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE2"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY3))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT3))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE3), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE3"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY4))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT4))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE4), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE4"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY5))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT5))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE5), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE5"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY6))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT6))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE6), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE6"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY7))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT7))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE7), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE7"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY8))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT8))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE8), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE8"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY9))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT9))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE9), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE9"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY10))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT10))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE10), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE10"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY11))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT11))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE11), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE11"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUY12))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(BUYFAULT12))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(BUYSHARE12), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="BUYSHARE12"/>)</xsl:otherwise>
        </xsl:choose>
      </div>    
    </td>
    <td style="text-align:center;border-right:0">
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALBUY))"/></div>
      <div class="f-sub-div"><xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALBUYFAULT))"/></div>
      <div>
        <xsl:choose>
          <xsl:when test="phxsl:isEqual(string(TOTALBUYSHARE), '')">&nbsp;</xsl:when>
          <xsl:otherwise>(<xsl:value-of select="TOTALBUYSHARE"/>)</xsl:otherwise>
        </xsl:choose>
      </div> 
    </td>
  </xsl:template>
</xsl:stylesheet>
