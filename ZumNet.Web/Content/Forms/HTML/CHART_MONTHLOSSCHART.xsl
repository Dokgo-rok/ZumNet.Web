<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet  version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:phxsl="http://www.phsoft.co.kr/xslt/ea" exclude-result-prefixes="phxsl">
  <xsl:import href="../../Forms/XFormScript.xsl"/>
  <xsl:variable name="displaylog">false</xsl:variable>
  <xsl:template match="/">
    <div class="ctm">
      <div class="fh">
        <h1>
          전법인 (<xsl:value-of select="//chartdata/sum/STATSYEAR"></xsl:value-of>)년 손실비용발생현황
        </h1>
      </div>
      <div class="ff"></div>
      <div class="fm-chart">
        <table class="fc" border="0" cellspacing="0" cellpadding="0">
          <colgroup>
            <col style="width:68px"></col>
            <col style="width:90px"></col>
            <col style="width:720px"></col>
            <col style="width:80px"></col>
          </colgroup>
          <tr>
            <td class="fc-lbl1">
              매출액<br />대비<br />손실비용<br />추이
            </td>
            <td class="fc-lbl">
              매출액비(%)<br /><br />
              <xsl:value-of select="//chartdata/sum/CHATY"/>%
            </td>
            <td style="padding-top:40px">
              <div id="panChart" style="position:relative;width:100%;height:260px;border:0px solid blue">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'CT(HS)', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'CT(ISM)', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'CH', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'CD', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'IC', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'IS', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'CL', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'VH', 720, 260, string(//chartdata/sum/CHATY))"/>
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'GROUP', 720, 260, string(//chartdata/sum/CHATY))"/>
              </div>
            </td>
            <td style="padding-top:40px;border-left:windowtext 1pt solid">
              <div id="panChart2" style="position:relative;width:100%;height:260px;border:0px solid blue">
                <xsl:value-of disable-output-escaping="yes" select="phxsl:reportChart(//chartdata, 'TOTAL', 80, 260, string(//chartdata/sum/CHATY))"/>
              </div>
            </td>
          </tr>
        </table>
      </div>
      <div class="ff"></div>
      <div class="fm">
        <span style="text-align:right">USD (매출액비)&nbsp;</span>
      </div>      
      <div class="fm">
        <table class="ft-sub" header="0" border="0" cellspacing="0" cellpadding="0">
          <colgroup>
            <col style="width:70px"></col>
            <col style="width:100px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:60px"></col>
            <col style="width:82px"></col>
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
          <tr>
            <xsl:attribute name="id">_<xsl:value-of select="//chartdata/row[CORPORATION='CT(HS)']/MessageID"/></xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='CT(HS)']">
                  <a href="#" onclick="openXForm(this);">CT(HS)</a>
                </xsl:when>
                <xsl:otherwise>CT(HS)</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#666666', '', '')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#666666', '', '', '','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='CT(HS)']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='CT(HS)']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">
              _<xsl:value-of select="//chartdata/row[CORPORATION='CT(ISM)']/MessageID"/>
            </xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='CT(ISM)']">
                  <a href="#" onclick="openXForm(this);">CT(ISM)</a>
                </xsl:when>
                <xsl:otherwise>CT(ISM)</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '#daa520', '#8b4513', '', '', '', '2px')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#8b4513', '', '', 'shortdashdotdot','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='CT(ISM)']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='CT(ISM)']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">_<xsl:value-of select="//chartdata/row[CORPORATION='CH']/MessageID"/></xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='CH']">
                  <a href="#" onclick="openXForm(this);">CH</a>
                </xsl:when>
                <xsl:otherwise>CH</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#a52a2a', 'shortdash', '', 'thinthin', '2px')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#a52a2a', '', '', 'shortdot','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='CH']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='CH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">_<xsl:value-of select="//chartdata/row[CORPORATION='CD']/MessageID"/></xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='CD']">
                  <a href="#" onclick="openXForm(this);">CD</a>
                </xsl:when>
                <xsl:otherwise>CD</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '#0000ff', '#0000ff', '', '')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#0000ff', '', '', 'shortdashdot','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='CD']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='CD']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">_<xsl:value-of select="//chartdata/row[CORPORATION='IC']/MessageID"/></xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='IC']">
                  <a href="#" onclick="openXForm(this);">IC</a>
                </xsl:when>
                <xsl:otherwise>IC</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#800080', 'shortdot', '', 'thinthin', '3px')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#800080', '', '', 'dot','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='IC']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='IC']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">_<xsl:value-of select="//chartdata/row[CORPORATION='IS']/MessageID"/></xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='IS']">
                  <a href="#" onclick="openXForm(this);">IS</a>
                </xsl:when>
                <xsl:otherwise>IS</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#008000', '', '', 'thinthin', '2px')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#008000', '', '', 'longdashdot','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='IS']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='IS']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">_<xsl:value-of select="//chartdata/row[CORPORATION='CL']/MessageID"/></xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='CL']">
                  <a href="#" onclick="openXForm(this);">CL</a>
                </xsl:when>
                <xsl:otherwise>CL</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#191970', 'shortdot', '', '', '2px')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#191970', '', '', 'longdashdotdot','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='CL']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='CL']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <tr>
            <xsl:attribute name="id">
              _<xsl:value-of select="//chartdata/row[CORPORATION='VH']/MessageID"/>
            </xsl:attribute>
            <td class="f-lbl-sub">
              <xsl:choose>
                <xsl:when test="//chartdata/row[CORPORATION='VH']">
                  <a href="#" onclick="openXForm(this);">VH</a>
                </xsl:when>
                <xsl:otherwise>VH</xsl:otherwise>
              </xsl:choose>
            </td>
            <td style="position:relative;vertical-align:middle">
              &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '#999', '', '', '', '1px')"/>
              <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 1, '#999', '', '', 'solid','')"/>
            </td>
            <xsl:choose>
              <xsl:when test="//chartdata/row[CORPORATION='VH']">
                <xsl:apply-templates select="//chartdata/row[CORPORATION='VH']"/>
              </xsl:when>
              <xsl:otherwise>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td style="border-right:0">&nbsp;</td>
              </xsl:otherwise>
            </xsl:choose>
          </tr>
          <xsl:apply-templates select="//chartdata/sum"/>
        </table>
      </div>
    </div>
  </xsl:template>
  <xsl:template match="//chartdata/row">
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT1))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE1), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE1"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT2))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE2), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE2"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT3))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE3), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE3"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT4))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE4), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE4"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT5))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE5), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE5"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT6))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE6), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE6"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT7))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE7), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE7"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT8))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE8), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE8"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT9))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE9), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE9"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT10))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE10), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE10"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT11))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE11), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE11"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(FAULT12))"/>
      <xsl:choose>
        <xsl:when test="phxsl:isEqual(string(SHARE12), '')">&nbsp;</xsl:when>
        <xsl:otherwise><br />(<xsl:value-of select="SHARE12"/>)</xsl:otherwise>
      </xsl:choose>
    </td>
    <td style="text-align:center;border-right:0">
      <xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALFAULT))"/>
      <br />(<xsl:value-of disable-output-escaping="yes" select="phxsl:isEmpty(string(TOTALSHARE))"/>)
    </td>
  </xsl:template>
  <xsl:template match="//chartdata/sum">
    <!--<tr>
      <td class="f-lbl-sub">매출액</td>
      <td>&nbsp;</td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM1))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM2))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM3))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM4))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM5))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM6))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM7))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM8))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM9))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM10))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM11))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(SALESSUM12))"/>
      </td>
      <td style="text-align:center;border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(TOTALSALESSUM))"/>
      </td>
    </tr>
    <tr>
      <td class="f-lbl-sub">손실액</td>
      <td style="text-align:center">&nbsp;</td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM1))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM2))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM3))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM4))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM5))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM6))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM7))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM8))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM9))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM10))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM11))"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(FAULTSUM12))"/>
      </td>
      <td style="text-align:center;border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:addComma(string(TOTALFAULTSUM))"/>
      </td>
    </tr>-->
    <tr>
      <td class="f-lbl-sub">TOTAL</td>
      <td style="position:relative;vertical-align:middle">
        &nbsp;<xsl:value-of disable-output-escaping="yes" select="phxsl:setTick(10, 10, 6, 6, '', '', '', '', 'thickthin', '3px')"/>
        <xsl:value-of disable-output-escaping="yes" select="phxsl:setLine('7,9', '81,9', 2, '#ff0000', '', '', 'solid','')"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM1), string(SALESSUM1), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM2), string(SALESSUM2), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM3), string(SALESSUM3), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM4), string(SALESSUM4), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM5), string(SALESSUM5), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM6), string(SALESSUM6), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM7), string(SALESSUM7), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM8), string(SALESSUM8), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM9), string(SALESSUM9), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM10), string(SALESSUM10), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM11), string(SALESSUM11), 2)"/>
      </td>
      <td style="text-align:center">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(FAULTSUM12), string(SALESSUM12), 2)"/>
      </td>
      <td style="text-align:center;border-right:0">
        <xsl:value-of disable-output-escaping="yes" select="phxsl:rate2(string(TOTALFAULTSUM), string(TOTALSALESSUM), 2)"/>
      </td>
    </tr>
  </xsl:template>
</xsl:stylesheet>
